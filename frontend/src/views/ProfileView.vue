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
          <label>用户名</label>
          <div class="info-value">
            <span>{{ user.username }}</span>
          </div>
          <button @click="editField('username')">编辑</button>
        </div>
        <div class="info-item">
          <label>工厂名</label>
          <span>{{ user.factory }}</span>
        </div>
        <div class="info-item">
          <label>账号类型</label>
          <span>{{ user.type }}</span>
        </div>
        <div class="info-item">
          <label>电话</label>
          <div class="info-value">
            <span>{{ user.phone }}</span>
          </div>
          <button @click="editField('phone')">编辑</button>
        </div>
        <div class="info-item">
          <label>邮箱</label>
          <div class="info-value">
            <span>{{ user.email }}</span>
          </div>
          <button @click="editField('email')">编辑</button>
        </div>
      </div>
      <button class="change-password-btn" @click="changePassword">更改密码</button>
    </div>
  </div>
</template>

<script setup>
import {ref} from 'vue';
import {useAuthStore} from '@/stores/authStore';

const authStore = useAuthStore();
const user = ref({
  username: authStore.user?.username || '未设置',
  factory: authStore.user?.factory || '未设置',
  type: authStore.user?.account_type === "factory" ? '工厂账号' : '总部账号',
  phone: authStore.user?.phone || '未设置',
  email: authStore.user?.email || '未设置'
});

const editField = (field) => {
  const newValue = prompt(`请输入新的${field === 'username' ? '用户名' : field === 'phone' ? '电话' : '邮箱'}:`);
  if (newValue) {
    user.value[field] = newValue;
    // 这里可以添加保存到后端的逻辑
  }
};

const changePassword = () => {
  alert('更改密码功能暂未实现');
};
</script>

<style scoped>
.profile-container {
  max-width: 800px;
  margin: 2rem auto;
  padding: 2rem;
  background: rgba(255, 255, 255, 0.05);
  border-radius: 12px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
  backdrop-filter: blur(8px);
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.profile-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 2rem;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  padding-bottom: 1rem;
}

.profile-header h1 {
  font-family: 'Playfair Display', serif;
  font-weight: 700;
  font-size: 2rem;
  color: #ffffff;
  margin: 0;
}

.profile-avatar {
  width: 50px;
  height: 50px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.5rem;
}

.profile-content {
  padding: 0 1rem;
}

.profile-info {
  margin-bottom: 2rem;
}

.info-item {
  display: flex;
  justify-content: left;
  align-items: center;
  padding: 1rem 0;
  border-bottom: 1px solid rgba(255, 255, 255, 0.05);
}

.info-item label {
  font-weight: 500;
  color: rgba(255, 255, 255, 0.7);
  min-width: 100px;
}

.info-item span {
  color: #ffffff;
}

.info-value {
  display: flex;
  align-items: center;
  gap: 1rem;
  min-width: 50vh;
}

button {
  padding: 0.5rem 1rem;
  background: rgba(52, 152, 219, 0.2);
  color: #3498db;
  border: 1px solid rgba(52, 152, 219, 0.3);
  border-radius: 4px;
  cursor: pointer;
  font-size: 0.9rem;
  transition: all 0.3s ease;
}

button:hover {
  background: rgba(52, 152, 219, 0.3);
  border-color: rgba(52, 152, 219, 0.5);
}

.change-password-btn {
  width: 100%;
  padding: 0.75rem;
  background: rgba(231, 76, 60, 0.2);
  color: #e74c3c;
  border: 1px solid rgba(231, 76, 60, 0.3);
  border-radius: 4px;
  cursor: pointer;
  font-size: 1rem;
  transition: all 0.3s ease;
  margin-top: 1rem;
}

.change-password-btn:hover {
  background: rgba(231, 76, 60, 0.3);
  border-color: rgba(231, 76, 60, 0.5);
}
</style>
