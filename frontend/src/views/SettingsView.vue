<template>
  <div class="settings-view">
    <h1>设置</h1>
    <div class="settings-section">
      <h2>主题设置</h2>
      <div class="theme-toggle">
        <label>浅色模式</label>
        <input type="checkbox" v-model="isDark" @change="toggleTheme"/>
        <label>深色模式</label>
      </div>
    </div>
    <div class="settings-section">
      <h2>通知设置</h2>
      <div class="notification-toggle">
        <label>接收系统通知</label>
        <input type="checkbox" v-model="receiveNotifications"/>
      </div>
    </div>
  </div>
</template>

<script setup>
import {ref} from 'vue';
import {useAuthStore} from "@/stores/authStore.js";

const authStore = useAuthStore();
const isDark = ref(false);
const receiveNotifications = ref(true);

const toggleTheme = () => {
  // 切换主题逻辑
};
</script>

<style scoped>
.settings-view {
  padding: 20px;
}

.settings-section {
  margin-bottom: 20px;
}

.theme-toggle, .notification-toggle {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-top: 10px;
}
</style>