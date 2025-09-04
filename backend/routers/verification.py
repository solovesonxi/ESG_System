import os
import random
import smtplib
import uuid
from email.header import Header
from email.mime.text import MIMEText
from email.utils import formataddr, formatdate
from typing import Optional

import redis
from aliyunsdkcore.client import AcsClient
from aliyunsdkcore.request import CommonRequest
from fastapi import APIRouter, HTTPException, Depends, Body

from core.dependencies import get_redis, logger

router = APIRouter(prefix="/verification", tags=["验证"])


def send_sms(phone: str, code: str):
    client = AcsClient(os.getenv("ALIBABA_CLOUD_ACCESS_KEY_ID"), os.getenv("ALIBABA_CLOUD_ACCESS_KEY_SECRET"),
                       "cn-hangzhou")
    request = CommonRequest()
    request.set_method("POST")
    request.set_domain("dysmsapi.aliyuncs.com")
    request.set_version("2017-05-25")
    request.set_action_name("SendSms")

    request.add_query_param("PhoneNumbers", phone)
    request.add_query_param("SignName", "你的签名名称")  # 替换为你的短信签名
    request.add_query_param("TemplateCode", "你的模板CODE")  # 替换为你的短信模板CODE
    request.add_query_param("TemplateParam", f'{{"code":"{code}"}}')

    response = client.do_action_with_exception(request)
    return response.decode("utf-8")


def send_email(to_email: str, code: str):
    smtp_server = "smtp.qq.com"  # QQ 邮箱 SMTP 服务器
    smtp_port = 465
    sender = "2172449563@qq.com"  # 你的 QQ 邮箱
    email_password = "ghukttjbejahdhfi"  # 替换为 QQ 邮箱生成的授权码

    subject = "验证码通知"
    content = f"您的ESG账号验证码是：{code}，有效期5分钟。"
    message = MIMEText(content, "plain", "utf-8")

    # 修正头部格式 - 使用标准格式
    message["From"] = formataddr(("ESG系统", sender))
    message["To"] = to_email
    message["Subject"] = Header(subject, "utf-8")
    message["Message-ID"] = f"<{uuid.uuid4()}@{smtp_server.split('.')[0]}>"
    message["Date"] = formatdate(localtime=True)
    try:
        server = smtplib.SMTP_SSL(smtp_server, smtp_port)
        server.login(sender, email_password)
        server.sendmail(sender, [to_email], message.as_string())
        server.quit()
        logger.info(f"邮件已发送至 {to_email}")
        return True
    except smtplib.SMTPAuthenticationError as e:
        logger.error(f"邮件发送失败: SMTP 认证失败 - {e}")
        raise HTTPException(status_code=500, detail="SMTP 认证失败，请检查邮箱授权码")
    except Exception as e:
        logger.error(f"邮件发送失败: {e}")
        raise HTTPException(status_code=500, detail="邮件发送失败")


@router.post("")
def send_verification_code(phone: Optional[str] = Body(None, description="电话号码"),
                           email: Optional[str] = Body(None, description="电子邮箱"),
                           redis_client: redis.Redis = Depends(get_redis)):
    if not phone and not email:
        raise HTTPException(status_code=400, detail="请提供电话号码或邮箱")
    if phone and email:
        raise HTTPException(status_code=400, detail="只能提供电话号码或邮箱中的一种")
    verification_code = str(random.randint(100000, 999999))
    target = phone or email
    redis_client.setex(f"verification_code:{target}", 300, verification_code)
    if phone:
        send_sms(phone, verification_code)
        channel = "手机"
    else:
        send_email(email, verification_code)
        channel = "邮箱"

    return {"success": True, "message": f"验证码已发送至您的{channel}", "channel": channel, "target": target}
