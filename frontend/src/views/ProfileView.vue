<template>
  <div class="profile-container">
    <div class="profile-header">
      <h1>个人中心</h1>
      <div class="profile-avatar">
        <span>👤</span>
      </div>
    </div>

    <div class="profile-content">
      <div class="profile-info">
        <div class="info-item">
          <div class="info-label">
            <i class="fas fa-user"></i>
            <span>用户名</span>
          </div>
          <div class="info-value">
            <span>{{ user.username }}</span>
          </div>
          <button class="edit-btn" @click="openEditModal('username')">
            <i class="fas fa-edit"></i>
            <span>编辑</span>
          </button>
        </div>

        <div class="info-item">
          <div class="info-label">
            <i class="fas fa-industry"></i>
            <span>工厂名</span>
          </div>
          <div class="info-value">
            <span>{{ user.factory }}</span>
          </div>
        </div>

        <div class="info-item">
          <div class="info-label">
            <i class="fas fa-user-tag"></i>
            <span>账号类型</span>
          </div>
          <div class="info-value">
            <span>{{ user.type }}</span>
          </div>
        </div>

        <div class="info-item">
          <div class="info-label">
            <i class="fas fa-phone"></i>
            <span>电话</span>
          </div>
          <div class="info-value">
            <span>{{ user.phone }}</span>
          </div>
          <button class="edit-btn" @click="openEditModal('phone')">
            <i class="fas fa-edit"></i>
            <span>编辑</span>
          </button>
        </div>

        <div class="info-item">
          <div class="info-label">
            <i class="fas fa-envelope"></i>
            <span>邮箱</span>
          </div>
          <div class="info-value">
            <span>{{ user.email }}</span>
          </div>
          <button class="edit-btn" @click="openEditModal('email')">
            <i class="fas fa-edit"></i>
            <span>编辑</span>
          </button>
        </div>
      </div>

      <button class="change-password-btn" @click="openPasswordModal">
        <i class="fas fa-key"></i>
        <span>更改密码</span>
      </button>
    </div>

    <!-- 编辑信息模态框 -->
    <div class="modal-overlay" v-if="showEditModal">
      <div class="edit-modal">
        <div class="modal-header">
          <h2>{{ modalTitle }}</h2>
          <button class="close-modal-btn" @click="closeEditModal">
            <i class="fas fa-times"></i>
          </button>
        </div>

        <div class="input-group">
          <label>{{ fieldLabel }}</label>
          <input
              type="text"
              class="input-field"
              v-model="editValue"
              :placeholder="`请输入${fieldLabel}`"
          >
          <div class="verification-code-group" v-if="currentField === 'phone' || currentField === 'email'">
            <input
                type="text"
                class="input-field"
                v-model="verificationCode"
                placeholder="请输入验证码"
            >
            <button
                class="send-code-btn"
                @click="sendVerificationCode"
                :disabled="isSendingCode"
            >
              {{ isSendingCode ? `${countdown}秒后重试` : '发送验证码' }}
            </button>
          </div>
        </div>

        <div class="modal-actions">
          <button class="submit-btn" @click="submitEdit">
            <i class="fas fa-check"></i>
            <span>提交</span>
          </button>
        </div>
      </div>
    </div>

    <!-- 更改密码模态框 -->
    <div class="modal-overlay" v-if="showPasswordModal">
      <div class="edit-modal">
        <div class="modal-header">
          <h2>更改密码</h2>
        </div>

        <div class="input-group">
          <label>当前密码</label>
          <input
              type="password"
              class="input-field"
              v-model="currentPassword"
              placeholder="请输入当前密码"
          >
        </div>

        <div class="input-group">
          <label>新密码</label>
          <input
              type="password"
              class="input-field"
              v-model="newPassword"
              placeholder="请输入新密码"
          >
        </div>

        <div class="input-group">
          <label>确认新密码</label>
          <input
              type="password"
              class="input-field"
              v-model="confirmPassword"
              placeholder="请再次输入新密码"
          >
        </div>

        <div class="modal-actions">
          <button class="cancel-btn" @click="closePasswordModal">
            <i class="fas fa-times"></i>
            <span>取消</span>
          </button>
          <button class="submit-btn" @click="submitPassword">
            <i class="fas fa-check"></i>
            <span>提交</span>
          </button>
        </div>
      </div>
    </div>

    <!-- 通知消息 -->
    <div class="notification" :class="{ show: showNotification, error: notificationError }">
      <i class="fas" :class="notificationError ? 'fa-exclamation-circle' : 'fa-check-circle'"></i>
      <span>{{ notificationMessage }}</span>
    </div>
  </div>
</template>

<script setup>
import {computed, ref} from 'vue';
import {useAuthStore} from '@/stores/authStore';
import apiClient from '@/utils/axios';

const authStore = useAuthStore();

// 用户信息
const user = ref({
  username: authStore.user?.username || '未设置',
  factory: authStore.user?.factory || '未设置',
  type: authStore.user?.account_type === "factory" ? '工厂账号' : '总部账号',
  phone: authStore.user?.phone || '未设置',
  email: authStore.user?.email || '未设置'
});

// 编辑模态框状态
const showEditModal = ref(false);
const currentField = ref('');
const editValue = ref('');
const verificationCode = ref('');
const isSendingCode = ref(false);
const countdown = ref(0);
const modalTitle = computed(() => {
  switch (currentField.value) {
    case 'username':
      return '编辑用户名';
    case 'phone':
      return '编辑电话';
    case 'email':
      return '编辑邮箱';
    default:
      return '编辑信息';
  }
});
const fieldLabel = computed(() => {
  switch (currentField.value) {
    case 'username':
      return '新用户名';
    case 'phone':
      return '新电话';
    case 'email':
      return '新邮箱';
    default:
      return '新内容';
  }
});

// 密码模态框状态
const showPasswordModal = ref(false);
const currentPassword = ref('');
const newPassword = ref('');
const confirmPassword = ref('');

// 通知状态
const showNotification = ref(false);
const notificationMessage = ref('');
const notificationError = ref(false);

// 打开编辑模态框
const openEditModal = (field) => {
  currentField.value = field;
  editValue.value = '';
  showEditModal.value = true;
};

// 关闭编辑模态框
const closeEditModal = () => {
  showEditModal.value = false;
  editValue.value = '';
};

const sendVerificationCode = async () => {
  if (!editValue.value.trim()) {
    showNotificationMessage('输入内容不能为空', true);
    return;
  }
  showNotificationMessage('已发送验证码...有效期5分钟');
  try {
    const data = currentField.value === 'phone' ? {phone: editValue.value.trim()} : {email: editValue.value.trim()}
    await apiClient.post('/verification', data);
  } catch (error) {
    console.error('验证码发送失败：', error);
    showNotificationMessage('验证码发送失败：' + error.response.data.detail, true);
  }
}

// 提交编辑
const submitEdit = async () => {
  showNotificationMessage('正在更新信息...');
  if (!editValue.value.trim()) {
    showNotificationMessage('输入内容不能为空', true);
    return;
  }
  if (currentField.value === 'phone' && !/^\d{10,15}$/.test(editValue.value.trim())) {
    showNotificationMessage('请输入有效的电话号码', true);
    return;
  }
  if (currentField.value === 'email' && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(editValue.value.trim())) {
    showNotificationMessage('请输入有效的邮箱地址', true);
    return;
  }
  showNotificationMessage('正在更改' + currentField.value + '...请稍等', false, 20000);
  try {
    let response;
    if (currentField.value === 'username') {
      response = await apiClient.patch('/update/username', editValue.value.trim());
    } else {
      if (!verificationCode.value.trim()) {
        showNotificationMessage('请输入验证码', true);
        return;
      }
      if (currentField.value === 'phone') {
        response = await apiClient.patch('/update/phone', {
          new_phone: editValue.value.trim(),
          code: verificationCode.value.trim()
        });
      } else if (currentField.value === 'email') {
        response = await apiClient.patch('/update/email', {
          new_email: editValue.value.trim(),
          code: verificationCode.value.trim()
        });
      }
    }
    console.log('更新结果：', response.data);
    if (response.data.status === 'success') {
      user.value[currentField.value] = editValue.value;
      authStore.user[currentField.value] = editValue.value;
      const token = response.data.new_token;
      if (token) {
        authStore.setAuth(token, response.data.user)
      }
      closeEditModal();
      showNotificationMessage(`${fieldLabel.value}更新成功！`);
    } else {
      showNotificationMessage(response.data.message || '更新失败，请稍后重试', true);
    }
  } catch (error) {
    console.error('更新失败：', error);
    showNotificationMessage('更新失败：' + error.response.data.detail, true);
  }
};

// 打开密码模态框
const openPasswordModal = () => {
  showPasswordModal.value = true;
};

// 关闭密码模态框
const closePasswordModal = () => {
  showPasswordModal.value = false;
  currentPassword.value = '';
  newPassword.value = '';
  confirmPassword.value = '';
};

// 提交密码更改
const submitPassword = async () => {
  if (!currentPassword.value || !newPassword.value || !confirmPassword.value) {
    showNotificationMessage('所有字段都必须填写', true);
    return;
  }
  if (newPassword.value !== confirmPassword.value) {
    showNotificationMessage('两次输入的密码不一致', true);
    return;
  }
  if (newPassword.value.length < 6) {
    showNotificationMessage('密码长度至少为6位', true);
    return;
  }
  showNotificationMessage('正在更新密码...');
  try {
    const response = await apiClient.post('/update/password', {
      current_password: currentPassword.value,
      new_password: newPassword.value
    });
    if (response.data.status === 'success') {
      showNotificationMessage('密码更新成功！');
      closePasswordModal();
    }
  } catch (error) {
    console.log(error.response.data);
    showNotificationMessage('密码更新失败，请稍后重试：' + error.response.data.detail, true);
  }
};

// 显示通知消息
const showNotificationMessage = (message, isError = false, duration = 3000) => {
  notificationMessage.value = message;
  notificationError.value = isError;
  showNotification.value = true;

  setTimeout(() => {
    showNotification.value = false;
  }, duration);
};
</script>

<style scoped>
/* 磨砂玻璃效果覆盖整个容器 */
.profile-container {
  width: 80%;
  max-height: 68vh;
  margin: 2rem auto;
  padding: 2rem;
  background: rgba(30, 30, 40, 0.7);
  border-radius: 16px;
  box-shadow: 0 12px 40px rgba(0, 0, 0, 0.4);
  backdrop-filter: blur(1px);
  -webkit-backdrop-filter: blur(1px);
  border: 1px solid rgba(255, 255, 255, 0.15);
  position: relative;
  overflow: hidden;
}


.profile-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 2rem;
  padding-bottom: 1.5rem;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  position: relative;
}

.profile-header::after {
  content: '';
  position: absolute;
  bottom: -1px;
  left: 0;
  width: 100%;
  height: 1px;
  background: linear-gradient(90deg, transparent, #4776E6, transparent);
}

.profile-header h1 {
  font-weight: 700;
  font-size: 2.5rem;
  color: #ffffff;
  margin: 0;
  text-shadow: 0 0 10px rgba(71, 118, 230, 0.5);
}

.profile-avatar {
  width: 80px;
  height: 80px;
  background: linear-gradient(135deg, #4776E6, #8E54E9);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 2rem;
  box-shadow: 0 0 20px rgba(71, 118, 230, 0.6);
  position: relative;
  overflow: hidden;
}

.profile-avatar::before {
  content: '';
  position: absolute;
  top: -50%;
  left: -50%;
  width: 200%;
  height: 200%;
  background: radial-gradient(circle, rgba(255, 255, 255, 0.4) 0%, transparent 70%);
  transform: rotate(30deg);
}

.profile-content {
  padding: 0 1rem;
}

.profile-info {
  margin-bottom: 2rem;
}

/* 优化信息项布局 */
.info-item {
  display: grid;
  grid-template-columns: minmax(120px, auto) 1fr minmax(100px, auto);
  align-items: center;
  padding: 0.8rem 0;
  border-bottom: 1px solid rgba(255, 255, 255, 0.05);
  position: relative;
  gap: 10px;
}

.info-item::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 0;
  width: 100%;
  height: 1px;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.1), transparent);
}

.info-label {
  font-weight: 500;
  color: rgba(255, 255, 255, 0.7);
  display: flex;
  align-items: center;
  gap: 8px;
}

.info-label i {
  font-size: 1rem;
  color: #8E54E9;
}

.info-value {
  color: #ffffff;
  font-size: 1rem;
  padding: 0 10px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

/* 优化编辑按钮样式 */
.edit-btn {
  padding: 0.5rem 0.8rem;
  background: rgba(71, 118, 230, 0.2);
  color: #4776E6;
  border: 1px solid rgba(71, 118, 230, 0.4);
  border-radius: 8px;
  cursor: pointer;
  font-size: 0.9rem;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 6px;
  min-width: 120px;
  max-width: 160px;
  margin-left: auto;
}

.edit-btn:hover {
  background: rgba(71, 118, 230, 0.3);
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(71, 118, 230, 0.3);
}

.edit-btn i {
  font-size: 0.9rem;
}

.change-password-btn {
  width: 100%;
  padding: 1rem;
  background: linear-gradient(135deg, rgba(231, 76, 60, 0.2), rgba(192, 57, 43, 0.3));
  color: #e74c3c;
  border: 1px solid rgba(231, 76, 60, 0.4);
  border-radius: 8px;
  cursor: pointer;
  font-size: 1.1rem;
  font-weight: 500;
  transition: all 0.3s ease;
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 10px;
}

.change-password-btn:hover {
  background: linear-gradient(135deg, rgba(231, 76, 60, 0.3), rgba(192, 57, 43, 0.4));
  transform: translateY(-3px);
  box-shadow: 0 7px 20px rgba(231, 76, 60, 0.3);
}

/* 编辑模态框样式 */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.7);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
  backdrop-filter: blur(2px);
  -webkit-backdrop-filter: blur(10px);
}

.edit-modal {
  background: linear-gradient(135deg, #1e3c72, #2a5298);
  border-radius: 16px;
  width: 90%;
  max-width: 500px;
  padding: 2rem;
  box-shadow: 0 20px 50px rgba(0, 0, 0, 0.5);
  position: relative;
  overflow: hidden;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.edit-modal::before {
  content: '';
  position: absolute;
  top: -50%;
  left: -50%;
  width: 200%;
  height: 200%;
  background: radial-gradient(circle, rgba(255, 255, 255, 0.1) 0%, transparent 70%);
  z-index: -1;
}

.modal-header {
  margin-bottom: 1.5rem;
  padding-bottom: 1rem;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  display: flex;
  justify-content: space-between;
  align-items: center;
  position: relative;
}

.close-modal-btn {
  background: transparent;
  border: none;
  color: #e74c3c;
  font-size: 1.2rem;
  cursor: pointer;
  transition: opacity 0.2s ease;
  padding: 0.3rem;
  position: relative;
  width: 20px;
  height: 20px;
}

.close-modal-btn::before,
.close-modal-btn::after {
  content: '';
  position: absolute;
  top: 50%;
  left: 50%;
  width: 100%;
  height: 2px;
  background-color: #e74c3c;
}

.close-modal-btn::before {
  transform: translate(-50%, -50%) rotate(45deg);
}

.close-modal-btn::after {
  transform: translate(-50%, -50%) rotate(-45deg);
}

.close-modal-btn:hover {
  opacity: 0.8;
}

.modal-header h2 {
  font-size: 1.8rem;
  color: #fff;
  text-align: center;
  text-shadow: 0 0 10px rgba(255, 255, 255, 0.3);
}

.input-group {
  margin-bottom: 1.5rem;
}

.input-group label {
  display: block;
  margin-bottom: 0.5rem;
  color: rgba(255, 255, 255, 0.8);
}

.input-field {
  width: 100%;
  padding: 0.8rem 1.2rem;
  background: rgba(0, 0, 0, 0.3);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 8px;
  color: white;
  font-size: 1rem;
  transition: all 0.3s ease;
}

.input-field:focus {
  outline: none;
  border-color: #4776E6;
  box-shadow: 0 0 0 3px rgba(71, 118, 230, 0.3);
}

.modal-actions {
  display: flex;
  justify-content: flex-end;
  gap: 15px;
  margin-top: 2rem;
}

.cancel-btn, .submit-btn {
  padding: 0.8rem 1.5rem;
  border-radius: 8px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  gap: 8px;
}

.cancel-btn {
  background: rgba(255, 255, 255, 0.1);
  color: rgba(255, 255, 255, 0.8);
  border: 1px solid rgba(255, 255, 255, 0.2);
}

.cancel-btn:hover {
  background: rgba(255, 255, 255, 0.2);
}

.submit-btn {
  background: linear-gradient(135deg, #4776E6, #8E54E9);
  color: white;
  border: none;
  box-shadow: 0 4px 15px rgba(71, 118, 230, 0.4);
}

.submit-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 7px 20px rgba(71, 118, 230, 0.6);
}

.notification {
  position: fixed;
  top: 20px;
  right: 20px;
  padding: 1rem 1.5rem;
  border-radius: 8px;
  background: rgba(30, 30, 40, 0.9);
  border-left: 4px solid #2ecc71;
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
  display: flex;
  align-items: center;
  gap: 10px;
  z-index: 2000;
  transform: translateX(120%);
  transition: transform 0.4s ease;
}

.notification.show {
  transform: translateX(0);
}

.notification.error {
  border-left-color: #e74c3c;
}

.notification i {
  font-size: 1.5rem;
}

.notification.success i {
  color: #2ecc71;
}

.notification.error i {
  color: #e74c3c;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .profile-container {
    padding: 1.5rem;
    width: 90%;
  }

  .profile-header {
    flex-direction: column;
    text-align: center;
    gap: 1rem;
  }

  .info-item {
    grid-template-columns: 1fr;
    gap: 8px;
  }

  .info-value {
    padding: 0;
    width: 100%;
  }

  .edit-btn {
    width: 100%;
    max-width: none;
    margin-top: 10px;
    margin-left: 0;
  }
}

@media (max-width: 480px) {
  .profile-header h1 {
    font-size: 2rem;
  }

  .profile-avatar {
    width: 70px;
    height: 70px;
  }

  .edit-modal {
    padding: 1.5rem;
  }

  .modal-actions {
    flex-direction: column;
    gap: 10px;
  }

  .cancel-btn, .submit-btn {
    width: 100%;
    justify-content: center;
  }
}
</style>