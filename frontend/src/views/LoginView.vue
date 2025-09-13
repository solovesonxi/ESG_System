<template>
  <div class="login-container">
    <!-- 左侧面板 - 图片/信息展示区 -->
    <div class="left-panel">
      <div class="logo">
        <div class="logo-icon">🌱</div>
        <div class="logo-text">ESG System</div>
      </div>

      <div class="features">
        <div class="feature">
          <span class="feature-icon">✓</span>
          <span>全面的ESG数据监控与分析</span>
        </div>
        <div class="feature">
          <span class="feature-icon">✓</span>
          <span>资源消耗与碳排放追踪</span>
        </div>
        <div class="feature">
          <span class="feature-icon">✓</span>
          <span>合规性管理与风险预警</span>
        </div>
      </div>

      <div class="tagline">
        企业环境、社会和治理数据综合管理系统<br>
        助力企业实现可持续发展目标
      </div>
    </div>

    <!-- 右侧面板 - 表单区域 -->
    <div class="form-container">
      <!-- 登录表单 -->
      <div v-if="!showRegister" class="register-form">
        <div class="form-row">
          <label class="form-label">用户名</label>
          <input
              v-model="loginForm.username"
              type="text"
              placeholder="请输入用户名"
              required
              :class="{'input-error': loginError}"
          >
        </div>

        <div class="form-row">
          <label class="form-label">密码</label>
          <div class="password-wrapper">
            <input
                v-model="loginForm.password"
                :type="showPassword ? 'text' : 'password'"
                placeholder="请输入密码"
                required
                :class="{'input-error': loginError}"
            >
            <button
                type="button"
                class="password-toggle"
                @click="showPassword = !showPassword"
            >
              <i :class="showPassword ? 'fa-solid fa-eye-slash' : 'fa-solid fa-eye'"></i>
            </button>
          </div>
        </div>
        <div v-if="loginError" class="error-message">
          {{ loginError }}
        </div>
      </div>

      <!-- 注册表单 -->
      <div v-else class="register-form">
        <div class="form-row">
          <label class="form-label">用户名</label>
          <input
              v-model="registerForm.username"
              type="text"
              placeholder="请设置用户名"
              required
              :class="{'input-error': registrationErrors.username}"
          >
        </div>
        <div v-if="registrationErrors.username" class="error-message">
          {{ registrationErrors.username }}
        </div>

        <div class="form-row">
          <label class="form-label">密码</label>
          <div class="password-wrapper">
            <input
                v-model="registerForm.password"
                :type="showPassword ? 'text' : 'password'"
                placeholder="请设置登录密码"
                required
                :class="{'input-error': registrationErrors.password}"
            >
            <button
                type="button"
                class="password-toggle"
                @click="showPassword = !showPassword"
            >
              <i :class="showPassword ? 'fa-solid fa-eye-slash' : 'fa-solid fa-eye'"></i>
            </button>
          </div>
        </div>
        <div v-if="registrationErrors.password" class="error-message">
          {{ registrationErrors.password }}
        </div>

        <div class="form-row">
          <label class="form-label">确认密码</label>
          <div class="password-wrapper">
            <input
                v-model="registerForm.confirmPassword"
                :type="showConfirmPassword ? 'text' : 'password'"
                placeholder="请再次输入密码"
                required
                :class="{'input-error': registrationErrors.confirmPassword}"
            >
            <button
                type="button"
                class="password-toggle"
                @click="showConfirmPassword = !showConfirmPassword"
            >
              <i :class="showConfirmPassword ? 'fa-solid fa-eye-slash' : 'fa-solid fa-eye'"></i>
            </button>
          </div>
        </div>
        <div v-if="registrationErrors.confirmPassword" class="error-message">
          {{ registrationErrors.confirmPassword }}
        </div>

        <div class="form-row">
          <label class="form-label">工厂名称</label>
          <select
              v-model="registerForm.factory"
              required
              :class="{'input-error': registrationErrors.factory}"
          >
            <option value="" disabled selected>请选择工厂</option>
            <option v-for="factory in factories" :key="factory" :value="factory">
              {{ factory }}
            </option>
          </select>
        </div>
        <div v-if="registrationErrors.factory" class="error-message">
          {{ registrationErrors.factory }}
        </div>

        <div class="form-row">
          <label class="form-label">手机号/邮箱</label>
          <input
              v-model="registerForm.contact"
              type="text"
              placeholder="请输入手机号或邮箱"
              required
              :class="{'input-error': registrationErrors.contact}"
          >
        </div>
        <div v-if="registrationErrors.contact" class="error-message">
          {{ registrationErrors.contact }}
        </div>
        <div class="form-row">
          <label class="form-label">验证码</label>
          <div class="verification-wrapper">
            <input
                v-model="registerForm.verificationCode"
                type="text"
                placeholder="请输入验证码"
                required
                :class="{'input-error': registrationErrors.verificationCode}"
            >
            <span class="verification-code" @click="sendVerificationCode">
              {{ registerForm.countdown > 0 ? `重新发送(${registerForm.countdown}s)` : '发送验证码' }}
                </span>
          </div>
        </div>
        <div v-if="registrationErrors.verificationCode" class="error-message">
          {{ registrationErrors.verificationCode }}
        </div>
      </div>
      <button class="btn" @click="showRegister ? handleRegister() : handleLogin()">
        {{ showRegister ? '注册' : '登录' }}
      </button>
      <div class="links">
        <a href="#" @click="showRegister = !showRegister">
          {{ showRegister ? '已有账号？立即登录' : '没有账号？立即注册' }}
        </a>
        <a href="#" @click="showRegister ? (showRegister=false) : forgetPassword()">{{
            showRegister ? "了解更多关于 ESG" : "忘记密码"
          }}</a>
      </div>
    </div>

    <div class="footer">
      &copy; 2025 ESG System | 企业可持续发展管理平台
    </div>
  </div>
</template>

<script>
import router from "@/router/index.js";
import {useAuthStore} from '@/stores/authStore';
import apiClient from "@/utils/axios.js";

export default {
  name: 'LoginView',
  data() {
    return {
      showRegister: false,
      showPassword: false,
      showConfirmPassword: false,
      loginError: '',
      factories: [
        "安徽光大美科", "安徽光大同创", "昆山一", "昆山二", "成都厂", "惠阳厂",
        "厦门奔方", "武汉厂", "南昌厂", "越南", "墨西哥", "深圳光大", "沃普智选",
        "青岛音诺", "天津茂创", "合肥山秀", "苏州领新", "东莞美科同创",
        "重庆致贯", "苏州致贯"
      ],
      loginForm: {
        username: '',
        password: '',
      },
      registerForm: {
        username: '',
        password: '',
        confirmPassword: '',
        factory: '',
        contact: '', // 输入的手机号或邮箱
        phone: '', // 手机号
        email: '', // 邮箱
        verificationCode: '',
        countdown: 0 // 倒计时秒数
      },
      registrationErrors: {
        username: '',
        password: '',
        confirmPassword: '',
        factory: '',
        contact: '',
        verificationCode: ''
      }
    }
  },
  methods: {
    async handleLogin() {
      this.loginError = '';
      if (!this.loginForm.username || !this.loginForm.password) {
        this.loginError = '请输入用户名和密码';
        return;
      }
      const payload = {
        username: this.loginForm.username,
        password: this.loginForm.password
      }
      try {
        const response = await apiClient.post('/login', payload);
        const {token, user} = response.data;
        useAuthStore().initAuth(token, user);
        await router.push('/home');
      } catch (error) {
        this.loginError = '用户名或密码错误';
        console.error('登录失败:', error);
      }
    },

    async handleRegister() {
      Object.keys(this.registrationErrors).forEach(key => {
        this.registrationErrors[key] = '';
      });
      let isValid = true;
      if (!this.registerForm.username) {
        this.registrationErrors.username = '用户名不能为空';
        isValid = false;
      }
      if (!this.registerForm.password) {
        this.registrationErrors.password = '密码不能为空';
        isValid = false;
      } else if (this.registerForm.password.length < 6) {
        this.registrationErrors.password = '密码至少需要6个字符';
        isValid = false;
      }
      if (this.registerForm.password !== this.registerForm.confirmPassword) {
        this.registrationErrors.confirmPassword = '两次输入的密码不一致';
        isValid = false;
      }
      if (!this.registerForm.factory) {
        this.registrationErrors.factory = '请选择工厂';
        isValid = false;
      }
      if (!this.registerForm.contact) {
        this.registrationErrors.contact = '请输入手机号或邮箱';
        isValid = false;
      } else {
        const input = this.registerForm.contact;
        const isPhone = /^1[3-9]\d{9}$/.test(input);
        const isEmail = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(input);
        if (!isPhone && !isEmail) {
          this.registrationErrors.contact = '请输入正确的手机号或邮箱';
          isValid = false;
        } else {
          if (isPhone) {
            this.registerForm.phone = input;
            this.registerForm.email = '';
            alert('抱歉，目前暂不支持手机号注册，请使用邮箱注册。');
            return;
          } else {
            this.registerForm.email = input;
            this.registerForm.phone = '';
          }
        }
      }
      if (!this.registerForm.verificationCode) {
        this.registrationErrors.verificationCode = '请输入验证码';
        isValid = false;
      }
      if (!isValid) {
        return;
      }
      console.log('注册信息:', this.registerForm);
      const payload = {
        username: this.registerForm.username,
        password: this.registerForm.password,
        factory: this.registerForm.factory,
        phone: this.registerForm.phone,
        email: this.registerForm.email,
        verificationCode: this.registerForm.verificationCode
      }
      const response = await apiClient.post('/register', payload)
      if (response.data.status === 'success') {
        alert('注册成功!', response.data.username)
        this.showRegister = false;
      } else {
        alert(response.data.message || '注册失败，请稍后重试。')
      }
    },

    forgetPassword() {
      alert('请联系管理员重置密码。');
    },

    async sendVerificationCode() {
      const input = this.registerForm.contact;
      if (!input) {
        this.registrationErrors.contact = '请输入手机号或邮箱';
        return;
      }
      const isPhone = /^1[3-9]\d{9}$/.test(input);
      const isEmail = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(input);
      if (!isPhone && !isEmail) {
        this.registrationErrors.contact = '请输入正确的手机号或邮箱';
        return;
      }
      this.registrationErrors.contact = '';
      if (isPhone) {
        this.registerForm.phone = input;
        this.registerForm.email = '';
        alert('抱歉，目前暂不支持手机号注册，请使用邮箱注册。');
        return;
      } else {
        this.registerForm.email = input;
        this.registerForm.phone = '';
      }
      try {
        const response = await apiClient.post('/verification', {
          phone: this.registerForm.phone,
          email: this.registerForm.email
        });

        if (response.data.success) {
          alert(`验证码已发送至您的${isPhone ? '手机' : '邮箱'}，请注意查收！`);
          // 开始60秒倒计时
          this.registerForm.countdown = 60;
          const timer = setInterval(() => {
            this.registerForm.countdown--;
            if (this.registerForm.countdown <= 0) {
              clearInterval(timer);
            }
          }, 1000);
        } else {
          alert(response.data.message || '发送验证码失败，请稍后重试。');
        }
      } catch (error) {
        console.error('发送验证码失败:', error);
        alert('发送验证码失败，请稍后重试。');
      }
    }
  }
}
</script>

<style scoped>
.login-container {
  width: 100%;
  min-height: 80vh;
  display: flex;
  justify-content: center;
  align-items: center;
  flex-direction: row;
  background: radial-gradient(
      circle at top left,
      rgba(26, 42, 108, 0.9),
      rgba(145, 25, 25, 0.6),
      rgba(26, 42, 108, 0.9),
      rgba(164, 90, 6, 0.6),
      rgba(26, 42, 108, 0.9)
  );
  background-size: 500% 500%;
  animation: gradientBG 30s ease infinite;
  color: #fff;
  position: relative;
  padding: 20px;
  border-radius: 20px;
  backdrop-filter: blur(10px);
  overflow: hidden;
}

@keyframes gradientBG {
  0% {
    background-position: 0 0;
  }
  50% {
    background-position: 100% 100%;
  }
  100% {
    background-position: 0 0;
  }
}

.left-panel {
  flex: 1;
  padding: 40px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  max-width: 45%;
}

.logo {
  display: flex;
  align-items: center;
  margin-bottom: 30px;
}

.logo-icon {
  font-size: 42px;
  margin-right: 15px;
  color: #4CAF50;
}

.logo-text {
  font-size: 28px;
  font-weight: 700;
  letter-spacing: 1px;
}

.tagline {
  font-size: 18px;
  margin-top: auto;
  line-height: 1.6;
  opacity: 0.9;
}

.features {
  margin-bottom: 40px;
}

.feature {
  display: flex;
  align-items: center;
  margin-bottom: 15px;
  font-size: 16px;
}

.feature-icon {
  margin-right: 10px;
  color: #4CAF50;
}

.form-container {
  background: rgba(255, 255, 255, 0.1);
  padding: 40px;
  border-radius: 15px;
  width: 100%;
  max-width: 500px;
  min-height: 280px;
  position: relative;
}

.register-form {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  height: 100%;
}

.form-row {
  display: flex;
  align-items: center;
  flex-grow: 1;
  margin-bottom: 15px;
  width: 100%;
}

.form-label {
  width: 80px;
  color: #fff;
  font-weight: 500;
  margin-right: 15px;
  flex-shrink: 0;
}

input, select {
  flex: 1;
  padding: 12px;
  border: none;
  border-radius: 8px;
  background: rgba(255, 255, 255, 0.9);
  font-size: 16px;
  transition: all 0.3s ease;
}

input:focus, select:focus {
  outline: none;
  box-shadow: 0 0 0 3px rgba(76, 175, 80, 0.3);
}

.password-wrapper, .verification-wrapper {
  position: relative;
  flex: 1;
  display: flex;
}

.password-toggle {
  position: absolute;
  right: 10px;
  top: 50%;
  transform: translateY(-50%);
  background: none;
  border: none;
  color: #666;
  cursor: pointer;
  font-size: 18px;
  width: 30px;
  height: 30px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  transition: all 0.3s ease;
}

.password-toggle:hover {
  background: rgba(0, 0, 0, 0.1);
}

.verification-code {
  position: absolute;
  right: 10px;
  top: 50%;
  transform: translateY(-50%);
  padding: 4px 8px;
  border-radius: 4px;
  font-weight: 500;
  font-size: 14px;
  cursor: pointer;
  color: #fff;
  background: #4CAF50;
  transition: all 0.3s ease;
}

.verification-code:hover {
  background: #388E3C;
}

.verification-code span {
  display: inline-block;
}

.btn {
  width: 80%;
  background: linear-gradient(135deg, #6a11cb 0%, #2575fc 100%);
  color: white;
  border: none;
  border-radius: 8px;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  display: block;
  margin: 0 auto;
  padding: 12px 24px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  position: relative;
  overflow: hidden;
  z-index: 1;
}

.btn::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: linear-gradient(45deg, transparent, rgba(255, 255, 255, 0.3), transparent);
  animation: electricFlow 4s linear infinite;
  z-index: -1;
}

@keyframes electricFlow {
  0% {
    transform: translateX(-100%);
    opacity: 0;
  }
  20% {
    opacity: 1;
  }
  100% {
    transform: translateX(100%);
    opacity: 0;
  }
}

.btn::after {
  content: '';
  position: absolute;
  top: -2px;
  left: -2px;
  right: -2px;
  bottom: -2px;
  border-radius: 10px;
  background: linear-gradient(45deg, #6a11cb, #2575fc, #6a11cb);
  background-size: 500% 500%;
  z-index: -2;
  opacity: 0;
  animation: electricGlow 5s infinite alternate;
}

@keyframes electricGlow {
  0% {
    box-shadow: 0 0 5px #6a11cb, 0 0 10px #2575fc;
  }
  100% {
    box-shadow: 0 0 15px #6a11cb, 0 0 20px #2575fc;
  }
}

.btn:hover {
  background: linear-gradient(45deg, #4a00e0, #8e2de2, #4a00e0);
  animation: enhancedElectricGlow 0.5s infinite alternate;
}

@keyframes enhancedElectricGlow {
  0% {
    box-shadow: 0 0 10px #4a00e0, 0 0 20px #8e2de2;
  }
  100% {
    box-shadow: 0 0 20px #4a00e0, 0 0 30px #8e2de2;
  }
}

.btn:active {
  background: linear-gradient(135deg, #f10f11 0%, #dc7b1a 100%);
  transform: scale(0.98);
}

.btn:hover::before {
  left: 100%;
}

.btn::after {
  content: '';
  position: absolute;
  top: -2px;
  left: -2px;
  right: -2px;
  bottom: -2px;
  background: linear-gradient(45deg, #4CAF50, #388E3C, #4CAF50);
  border-radius: 10px;
  z-index: -2;
  opacity: 0;
  transition: all 0.3s ease;
}

.btn:hover::after {
  opacity: 1;
  animation: borderGlow 1.5s infinite;
}

@keyframes borderGlow {
  0% {
    box-shadow: 0 0 5px #4CAF50, 0 0 10px #4CAF50;
  }
  50% {
    box-shadow: 0 0 15px #4CAF50, 0 0 20px #4CAF50;
  }
  100% {
    box-shadow: 0 0 5px #4CAF50, 0 0 10px #4CAF50;
  }
}

.btn:hover {
  transform: translateY(-2px) scale(1.02);
  box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15);
  text-shadow: 0 0 5px rgba(255, 255, 255, 0.8);
}

.btn:active {
  transform: translateY(0) scale(0.98);
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
}

.btn::after {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(255, 255, 255, 0.2);
  transform: translateX(-100%);
  transition: transform 0.5s ease;
}

.btn:hover::after {
  transform: translateX(0);
}

.links {
  display: flex;
  justify-content: space-between;
  position: absolute;
  bottom: 8px;
  left: 20px;
  right: 20px;
}

.links a {
  color: #4CAF50;
  text-decoration: none;
  font-weight: 500;
  transition: all 0.3s ease;
  cursor: pointer;
  font-size: 14px;
}

.links a:hover {
  text-decoration: underline;
}

.error-message {
  color: #ff5252;
  font-size: 14px;
  margin-top: 5px;
  margin-left: 95px;
}

.input-error {
  border: 1px solid #ff5252;
  box-shadow: 0 0 0 2px rgba(255, 82, 82, 0.2);
}

.footer {
  position: absolute;
  bottom: 20px;
  left: 0;
  width: 100%;
  text-align: center;
  font-size: 14px;
  opacity: 0.7;
}

/* 响应式设计 */
@media (max-width: 900px) {
  .container {
    flex-direction: column;
    height: auto;
  }

  .left-panel, .right-panel {
    padding: 30px 20px;
  }

  .form-container {
    padding: 20px;
  }

  .form-label {
    width: 100%;
    margin-bottom: 8px;
    margin-right: 0;
  }

  .error-message {
    margin-left: 0;
  }
}

@media (max-width: 600px) {
  .login-container {
    padding: 10px;
  }

  .container {
    border-radius: 15px;
  }

  .logo-text {
    font-size: 24px;
  }

  .tagline {
    font-size: 16px;
  }

  .form-container {
    padding: 15px;
  }

  .feature {
    font-size: 14px;
  }

  .links {
    flex-direction: column;
    gap: 10px;
  }

  .links a {
    text-align: center;
  }
}
</style>