<template>
  <div class="navbar-wrapper">
    <nav class="navbar" @mouseenter="handleNavbarEnter" @mouseleave="handleNavbarLeave">
      <ul class="nav-list">
        <li v-for="route in menuItems" :key="route.name">
          <router-link
              :to="route.path"
              :class="{ 'router-link-active': isActive(route.path) }"
          >
            <span class="link-text">{{ route.label }}</span>
            <div class="link-hover-effect"></div>
          </router-link>
        </li>
      </ul>
    </nav>

    <transition name="dropdown">
      <div class="logout-dropdown" v-if="showLogout" @mouseenter="handleDropdownEnter"
           @mouseleave="handleDropdownLeave">
        <div class="user-avatar">
          <svg viewBox="0 0 100 100">
            <circle cx="50" cy="40" r="25" fill="#fff"/>
            <circle cx="50" cy="100" r="40" fill="#fff"/>
          </svg>
        </div>
        <span class="welcome-text">你好, {{ authStore.user?.username }}</span>
        <button class="logout-btn" @click="handleLogout">
          <span>登出</span>
          <svg width="16" height="16" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
            <path
                d="M17 7L21 12M21 12L17 17M21 12H9M13 16V17C13 18.6569 11.6569 20 10 20H7C5.34315 20 4 18.6569 4 17V7C4 5.34315 5.34315 4 7 4H10C11.6569 4 13 5.34315 13 7V8"
                stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
        </button>
      </div>
    </transition>
  </div>
</template>

<script setup>
import {useRoute} from 'vue-router'
import {computed, ref, watch} from 'vue';
import {useAuthStore} from '@/stores/authStore';

const authStore = useAuthStore();
const showLogout = ref(false);
let hideTimeout = null;

const handleNavbarEnter = () => {
  clearTimeout(hideTimeout);
  showLogout.value = true;
};

const handleNavbarLeave = () => {
  hideTimeout = setTimeout(() => {
    if (!document.querySelector('.logout-dropdown:hover')) {
      showLogout.value = false;
    }
  }, 300);
};

const handleDropdownEnter = () => {
  clearTimeout(hideTimeout);
};

const handleDropdownLeave = () => {
  showLogout.value = false;
};

const handleLogout = () => {
  authStore.logout();
};
const route = useRoute()

const isActive = (path) => {
  return route.path === path || route.path.startsWith(path + '/');
}

const menuItems = computed(() => {
  return authStore.isDataMode ? dataModeItems : analyzeModeItems
})

const dataModeItems = [
  {name: 'material', path: '/material', label: '物料'},
  {name: 'energy', path: '/energy', label: '能源'},
  {name: 'water', path: '/water', label: '水资源'},
  {name: 'emission', path: '/emission', label: '排放'},
  {name: 'waste', path: '/waste', label: '废弃物'},
  {name: 'investment', path: '/investment', label: '资金投入'},
  {name: 'management', path: '/management', label: '环境管理'},
  {name: 'employment', path: '/employment', label: '雇佣'},
  {name: 'training', path: '/training', label: '教育与培训'},
  {name: 'ohs', path: '/ohs', label: '职健与安全'},
  {name: 'satisfaction', path: '/satisfaction', label: '员工满意度'},
  {name: 'supply', path: '/supply', label: '供应链'},
  {name: 'ip', path: '/ip', label: '知识产权'},
  {name: 'responsibility', path: '/responsibility', label: '产品责任'},
  {name: 'community', path: '/community', label: '社区参与'},
  {name: 'profile', path: '/profile', label: '个人中心'}
]

const analyzeModeItems = [
  {name: 'env-quantitative', path: '/env-quantitative', label: '环境定量'},
  {name: 'env-qualitative', path: '/env-qualitative', label: '环境定性'},
  {name: 'social-quantitative-labor', path: '/social-quantitative-labor', label: '社会定量-劳工'},
  {name: 'social-qualitative-labor', path: '/social-qualitative-labor', label: '社会定性-劳工'},
  {name: 'social-quantitative-other', path: '/social-quantitative-other', label: '社会定量-其他'},
  {name: 'social-qualitative-other', path: '/social-qualitative-other', label: '社会定性-其他'},
  {name: 'governance', path: '/governance', label: '管治'},
  {name: 'profile', path: '/profile', label: '个人中心'}
]

// 监听路由变化并更新 localStorage
watch(() => route.path, (newPath) => {
  authStore.checkTokenValid()
  const currentMode = authStore.isDataMode ? 'data' : 'analyze';
  localStorage.setItem(`lastPath_${currentMode}`, newPath);
  console.log("路由变化，更新lastPath_" + currentMode + "由" + route.path + "变为" + newPath)
});
</script>

<style scoped>
.navbar-wrapper {
  position: relative;
  height: 70px;
}

.navbar {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 70px;
  background-size: 200% 200%;
  z-index: 1000;
  overflow: hidden;
  animation: gradientShift 8s ease infinite;
  box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1);
  backdrop-filter: blur(5px);
  -webkit-backdrop-filter: blur(5px);
  border-bottom: 1px solid rgba(255, 255, 255, 0.2);
}


@keyframes gradientShift {
  0% {
    background-position: 0 50%;
  }
  50% {
    background-position: 100% 50%;
  }
  100% {
    background-position: 0 50%;
  }
}

.nav-list {
  list-style: none;
  display: flex;
  justify-content: center;
  margin: 0;
  padding: 0;
  width: 100%;
  height: 100%;
}

.nav-list li {
  position: relative;
  flex: 1;
  max-width: 200px;
  text-align: center;
}

.nav-list a {
  display: flex;
  justify-content: center;
  align-items: center;
  color: rgba(255, 255, 255, 0.85);
  text-decoration: none;
  font-weight: 500;
  padding: 0 15px;
  height: 100%;
  min-height: 70px;
  transition: all 0.3s ease;
  font-size: 1rem;
  position: relative;
  overflow: hidden;
  border-bottom: 2px solid transparent;
}

.nav-list a:hover {
  color: #fff;
  background: rgba(255, 255, 255, 0.08);
}

.nav-list a:hover .link-hover-effect {
  transform: translateX(0) scale(1);
  opacity: 1;
}

.link-text {
  color: white;
  text-shadow: -1px -1px 2px #e512e5,
  1px -1px 4px #a61a58,
  -1px 1px 6px #591bb7,
  1px 1px 8px #04108f;
  transition: all 0.3s ease;
}

.nav-list a.router-link-active .link-text {
  color: #8a2be2;
  text-shadow: 0 0 10px #8a2be2, 0 0 20px #8a2be2, 0 0 30px #8a2be2;
  animation: pulse 1.5s infinite;
}

@keyframes pulse {
  0%, 100% {
    text-shadow: 0 0 10px #8a2be2, 0 0 20px #8a2be2, 0 0 30px #8a2be2;
  }
  50% {
    text-shadow: 0 0 15px #8a2be2, 0 0 30px #8a2be2, 0 0 45px #8a2be2;
  }
}

.link-hover-effect {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: linear-gradient(to right, transparent, rgba(255, 255, 255, 0.15), transparent);
  transform: translateX(-100%) scale(0.8);
  opacity: 0;
  transition: all 0.5s ease;
  z-index: 1;
}

/* 激活状态样式 - 更加炫酷 */
.nav-list a.router-link-active {
  color: #fff;
  background: rgba(255, 255, 255, 0.15);
  border-bottom: 2px solid #fff;
  box-shadow: 0 0 15px rgba(255, 255, 255, 0.5),
  inset 0 0 10px rgba(255, 255, 255, 0.2);
  font-weight: 600;
  text-shadow: 0 0 10px rgba(255, 255, 255, 0.8);
  animation: backgroundBreathe 2s infinite;
}

@keyframes backgroundBreathe {
  0%, 100% {
    background: rgba(255, 255, 255, 0.15);
  }
  50% {
    background: rgba(255, 255, 255, 0.25);
  }
}

.nav-list a.router-link-active::before {
  content: '';
  position: absolute;
  top: -10px;
  left: 50%;
  transform: translateX(-50%);
  width: 6px;
  height: 6px;
  background: #fff;
  border-radius: 50%;
  box-shadow: 0 0 10px 2px rgba(255, 255, 255, 0.8);
  animation: activePulse 1.5s infinite;
}

@keyframes activePulse {
  0%, 100% {
    opacity: 0.5;
    transform: translateX(-50%) scale(1);
  }
  50% {
    opacity: 1;
    transform: translateX(-50%) scale(1.5);
  }
}

.nav-list a.router-link-active::after {
  content: '';
  position: absolute;
  bottom: -2px;
  left: 0;
  width: 100%;
  height: 3px;
  background: linear-gradient(90deg, transparent, #fff, transparent);
  animation: shimmer 2s infinite;
}

@keyframes shimmer {
  0% {
    background-position: -100% 0;
  }
  100% {
    background-position: 200% 0;
  }
}


/* 登出下拉菜单 */
.logout-dropdown {
  position: fixed;
  top: 75px;
  right: 5px;
  background: rgba(25, 25, 35, 0.95);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  padding: 1rem 1.2rem;
  border-radius: 12px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2),
  0 0 0 1px rgba(255, 255, 255, 0.1);
  z-index: 1001;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.8rem;
  min-width: 180px;
}

.dropdown-enter-active,
.dropdown-leave-active {
  transition: all 0.3s ease;
}

.dropdown-enter-from,
.dropdown-leave-to {
  opacity: 0;
  transform: translateY(-10px);
}

.user-avatar {
  width: 50px;
  height: 50px;
  border-radius: 50%;
  background: linear-gradient(135deg, #4776E6, #8E54E9);
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 0 15px rgba(71, 118, 230, 0.5);
}

.user-avatar svg {
  width: 60%;
  height: 60%;
}

.welcome-text {
  color: #fff;
  font-size: 0.9rem;
  text-align: center;
}

.logout-btn {
  background: linear-gradient(135deg, #ff6b6b, #ee5a52);
  color: white;
  border: none;
  padding: 0.5rem 1rem;
  border-radius: 25px;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  transition: all 0.3s ease;
  font-weight: 500;
  box-shadow: 0 4px 15px rgba(238, 90, 82, 0.3);
}

.logout-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(238, 90, 82, 0.4);
}

.logout-btn:active {
  transform: translateY(0);
}

/* 响应式设计 */
@media (max-width: 1200px) {
  .nav-list li {
    max-width: 160px;
  }

  .nav-list a {
    font-size: 0.9rem;
    padding: 0 10px;
  }
}

@media (max-width: 992px) {
  .navbar {
    height: 60px;
  }

  .nav-list {
    overflow-x: auto;
    justify-content: flex-start;
    padding: 0 10px;
    -ms-overflow-style: none;
    scrollbar-width: none;
  }

  .nav-list::-webkit-scrollbar {
    display: none;
  }

  .nav-list li {
    flex: 0 0 auto;
    max-width: none;
  }

  .nav-list a {
    min-height: 60px;
    min-width: 100px;
  }

  .logout-dropdown {
    top: 65px;
    right: 10px;
  }
}

@media (max-width: 576px) {
  .nav-list a {
    min-width: 80px;
    font-size: 0.8rem;
  }

  .welcome-text {
    font-size: 0.8rem;
  }

  .logout-btn {
    padding: 0.4rem 0.8rem;
    font-size: 0.8rem;
  }
}
</style>