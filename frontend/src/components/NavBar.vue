<template>
  <div class="navbar-wrapper">
    <nav class="navbar" :class="{ 'navbar-hidden': isNavbarHidden }" @mouseenter="handleNavbarEnter"
         @mouseleave="handleNavbarLeave">
      <div class="esg-logo" @click="navigateToDashboard">
        ESG
      </div>
      <ul class="nav-list">
        <li v-for="route in menuItems" :key="route.name">
          <template v-if="!route.children">
            <router-link
                :to="route.path"
                :class="{ 'router-link-active': isActive(route.path) }"
            >
              <span class="link-text">{{ route.label }}</span>
              <div class="link-hover-effect"></div>
            </router-link>
          </template>
          <template v-else>
            <div
                class="dropdown-trigger"
                :class="{ 'router-link-active': isDropdownActive(route) }"
                @mouseenter="handleDropdownEnter(route.name)"
                @mouseleave="handleDropdownLeave"
            >
              <span class="link-text">{{ route.label }}</span>
              <i class="arrow-down"></i>
              <div class="link-hover-effect"></div>
            </div>
            <ul class="dropdown-menu"
                :class="{ 'show': activeDropdown === route.name }"
                @mouseenter="handleMenuEnter"
                @mouseleave="handleMenuLeave">
              <li v-for="child in route.children" :key="child.name">
                <router-link
                    :to="child.path"
                    :class="{ 'router-link-active': isActive(child.path) }"
                >
                  <span class="link-text">{{ child.label }}</span>
                </router-link>
              </li>
            </ul>
          </template>
        </li>
      </ul>
    </nav>

    <transition name="dropdown">
      <div class="logout-dropdown" v-if="showLogout" @mouseenter="handleDropdownEnter"
           @mouseleave="handleDropdownLeave">
        <div class="user-avatar">
          <img :src="authStore.user?.avatar" alt="用户头像" class="avatar-image"
               style="width: 80px; height: 80px; object-fit: cover; border-radius: 50%;"/>
        </div>
        <span class="welcome-text">你好, {{ authStore.user?.username }}</span>
        <button class="logout-btn" @click="handleLogout">
          <span>退出登录</span>
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
import {useRoute, useRouter} from 'vue-router'
import {computed, onMounted, onUnmounted, ref, watch} from 'vue';
import {useAuthStore} from '@/stores/authStore';

const authStore = useAuthStore();
const showLogout = ref(false);
const isNavbarHidden = ref(false);
const activeDropdown = ref(null);
const lastScrollY = ref(0);
let hideTimeout = null;
let dropdownTimeout = null;

// 滚轮监听逻辑
const handleScroll = () => {
  const currentScrollY = window.scrollY;

  if (currentScrollY > lastScrollY.value && currentScrollY > 100) {
    // 向下滚动且超过100px时隐藏
    isNavbarHidden.value = true;
  } else if (currentScrollY < lastScrollY.value) {
    // 向上滚动时显示
    isNavbarHidden.value = false;
  }

  lastScrollY.value = currentScrollY;
};

// 新增：右上角区域检测逻辑
function handleMouseMove(e) {
  const {clientX, clientY} = e;
  const w = window.innerWidth;
  const h = window.innerHeight;
  showLogout.value = clientX > w * 0.7 && clientY < h * 0.3;
}

onMounted(() => {
  window.addEventListener('scroll', handleScroll, {passive: true});
  window.addEventListener('mousemove', handleMouseMove);
});

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll);
  window.removeEventListener('mousemove', handleMouseMove);
});

const handleDropdownEnter = (dropdownName = null) => {
  clearTimeout(dropdownTimeout);
  clearTimeout(hideTimeout);
  if (dropdownName) {
    activeDropdown.value = dropdownName;
  }
};

const handleDropdownLeave = () => {
  dropdownTimeout = setTimeout(() => {
    if (!document.querySelector('.logout-dropdown:hover')) {
      showLogout.value = false;
      activeDropdown.value = null;
    }
  }, 100);
};

// 下拉菜单容器的鼠标事件
const handleMenuEnter = () => {
  clearTimeout(dropdownTimeout);
};

const handleMenuLeave = () => {
  dropdownTimeout = setTimeout(() => {
    activeDropdown.value = null;
  }, 100);
};

const handleLogout = () => {
  authStore.logout();
};
const route = useRoute()

const router = useRouter();

const navigateToDashboard = () => {
  router.push('/home');
};

const isActive = (path) => {
  return route.path === path || route.path.startsWith(path + '/');
}

const menuItems = computed(() => {
  return authStore.isDataMode ? dataModeItems : analyzeModeItems
})

const dataModeItems = [
  {name: 'home', path: '/home', label: '首页'},
  {
    name: 'environment', label: '环境',
    children: [
      {name: 'material', path: '/material', label: '物料'},
      {name: 'energy', path: '/energy', label: '能源'},
      {name: 'water', path: '/water', label: '水资源'},
      {name: 'emission', path: '/emission', label: '排放'},
      {name: 'waste', path: '/waste', label: '废弃物'},
      {name: 'investment', path: '/investment', label: '资金投入'},
      {name: 'management', path: '/management', label: '环境管理'}
    ]
  },
  {
    name: 'social', label: '社会-劳工',
    children: [
      {name: 'employment', path: '/employment', label: '雇佣'},
      {name: 'training', path: '/training', label: '教育与培训'},
      {name: 'ohs', path: '/ohs', label: '职健与安全'},
      {name: 'satisfaction', path: '/satisfaction', label: '员工满意度'}
    ]
  },
  {
    name: 'governance', label: '社会-其他',
    children: [
      {name: 'supply', path: '/supply', label: '供应链'},
      {name: 'responsibility', path: '/responsibility', label: '产品责任'},
      {name: 'ip', path: '/ip', label: '知识产权'},
      {name: 'community', path: '/community', label: '社区参与与志愿活动'}
    ]
  },
  {name: 'review', path: '/review-management', label: '审核管理'},
  {name: 'account', path: '/account', label: '账号管理'}
]

const analyzeModeItems = [
  {name: 'home', path: '/home', label: '首页'},
  {
    name: 'env', label: '环境', children: [{name: 'env-quant', path: '/env-quant', label: '定量'},
      {name: 'env-qual', path: '/env-qual', label: '定性'},
    ]
  },
  {
    name: 'social', label: '社会',
    children: [{name: 'social-quant-labor', path: '/social-quant-labor', label: '定量-劳工'},
      {name: 'social-qual-labor', path: '/social-qual-labor', label: '定性-劳工'},
      {name: 'social-quant-other', path: '/social-quant-other', label: '定量-其他'},
      {name: 'social-qual-other', path: '/social-qual-other', label: '定性-其他'},
    ]
  },
  {name: 'governance', path: '/governance', label: '治理'},
  {name: 'review', path: '/review-management', label: '审核管理'},
  {name: 'account', path: '/account', label: '账号管理'}
]

// 监听路由变化并更新 localStorage
watch(() => route.path, (newPath, oldPath) => {
  authStore.checkTokenValid()
  const currentMode = authStore.isDataMode ? 'data' : 'analyze';
  if (newPath !== '/login' && newPath !== '/home' && newPath !== '/account') {
    localStorage.setItem(`lastPath_${currentMode}`, newPath);
    console.log("路由变化，更新lastPath_" + currentMode + "由" + (oldPath || '未知') + "变为" + newPath)
  }
});

// 新增方法：判断下拉父项是否激活
const isDropdownActive = (route) => {
  if (!route.children) return false;
  return route.children.some(child => isActive(child.path));
};
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
  height: 60px;
  background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
  z-index: 1000;
  overflow: visible;
  transform: translateY(0);
  transition: transform 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  display: flex;
  align-items: center;
}

/* NavBar隐藏状态 */
.navbar-hidden {
  transform: translateY(-100%);
}

.esg-logo {
  font-family: 'Playfair Display', serif;
  font-weight: 800;
  font-size: 1.5rem;
  color: #ffffff;
  cursor: pointer;
  margin-right: 2rem;
  margin-left: 2rem;
  transition: all 0.3s ease;
  text-shadow: 0 0 20px rgba(255, 255, 255, 0.5);
}

.esg-logo:hover {
  transform: scale(1.05);
  text-shadow: 0 0 30px rgba(255, 255, 255, 0.8);
}

.nav-list {
  list-style: none;
  display: flex;
  justify-content: flex-end;
  flex-grow: 1;
  margin: 0;
  padding: 0;
  width: 100%;
  height: 100%;
}

.nav-list li {
  position: relative;
  display: flex;
  align-items: center;
  /* 统一所有导航项的宽度 */
  flex: 1;
  min-width: 120px;
  max-width: 150px;
}

.nav-list a {
  display: flex;
  justify-content: center;
  align-items: center;
  color: rgba(255, 255, 255, 0.9);
  text-decoration: none;
  font-weight: 500;
  padding: 0 15px;
  height: 100%;
  transition: all 0.3s ease;
  font-size: 1rem;
  position: relative;
  overflow: hidden;
  background: rgba(255, 255, 255, 0.05);
  backdrop-filter: blur(10px);
  width: 100%;
  box-sizing: border-box;
}

.nav-list a:hover {
  color: #fff;
  background: rgba(255, 255, 255, 0.15);
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.2);
}

.dropdown-trigger {
  display: flex;
  justify-content: center;
  align-items: center;
  color: rgba(255, 255, 255, 0.9);
  text-decoration: none;
  font-weight: 500;
  padding: 0 15px;
  height: 100%;
  transition: all 0.3s ease;
  font-size: 1rem;
  position: relative;
  overflow: hidden;
  background: rgba(255, 255, 255, 0.05);
  backdrop-filter: blur(10px);
  cursor: pointer;
  gap: 8px;
  width: 100%;
  box-sizing: border-box;
}

.dropdown-trigger:hover {
  color: #fff;
  background: rgba(255, 255, 255, 0.15);
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.2);
}

/* 下拉箭头 */
.arrow-down {
  width: 0;
  height: 0;
  border-left: 4px solid transparent;
  border-right: 4px solid transparent;
  border-top: 6px solid currentColor;
  transition: transform 0.3s ease;
}

.dropdown-trigger:hover .arrow-down,
.dropdown-menu.show + .dropdown-trigger .arrow-down {
  transform: rotate(180deg);
}

/* 改进的下拉菜单 */
.dropdown-menu {
  position: absolute;
  top: 100%;
  left: 50%;
  transform: translateX(-50%) translateY(-10px) scale(0.95);
  background: linear-gradient(145deg, #2b2b85 0%, #4b052f 100%);
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.4);
  opacity: 0;
  visibility: hidden;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  z-index: 1001;
  width: 100%;
  border: 1px solid rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(20px);
  padding: 0;
  list-style: none;
  margin: 0;
  overflow: hidden; /* 防止子元素溢出 */
}

.dropdown-menu.show {
  opacity: 1;
  visibility: visible;
  transform: translateX(-50%) translateY(0) scale(1);
}

.dropdown-menu::before {
  content: '';
  position: absolute;
  top: -8px;
  left: 50%;
  transform: translateX(-50%);
  width: 0;
  height: 0;
  border-left: 8px solid transparent;
  border-right: 8px solid transparent;
  border-bottom: 8px solid #1e1e3f;
}

.dropdown-menu li {
  padding: 0;
  margin: 0;
  width: 100%;
}

.dropdown-menu li:first-child a {
  border-radius: 0 0 0 0;

}

.dropdown-menu li:last-child a {
  border-bottom: none;
  border-radius: 0 0 0 0;

}

.dropdown-menu a {
  display: block;
  color: rgba(255, 255, 255, 0.8);
  text-decoration: none;
  font-weight: 500;
  padding: 14px 20px; /* 增加左右内边距 */
  transition: all 0.3s ease;
  border-bottom: 1px solid rgba(255, 255, 255, 0.05);
  position: relative;
  overflow: hidden;
  width: 100%;
  box-sizing: border-box;
  text-align: left;
  white-space: nowrap;
  text-overflow: ellipsis;
  margin: 0;
}

.dropdown-menu a:hover {
  color: #fff;
  background: linear-gradient(90deg, rgba(138, 43, 226, 0.2), rgba(75, 0, 130, 0.2));
  padding: 14px 0;
}

.dropdown-menu a::before {
  content: '';
  position: absolute;
  left: 0;
  top: 0;
  height: 100%;
  width: 4px; /* 增加紫色条的宽度 */
  background: linear-gradient(180deg, #8a2be2, #4b0082);
  transform: scaleY(0);
  transition: transform 0.3s ease;
}

.dropdown-menu a:hover::before {
  transform: scaleY(1);
}

.dropdown-menu a .link-text {
  display: inline-block;
  width: 100%;
  padding-left: 10px;
  box-sizing: border-box;
  position: relative;
  z-index: 1;
  word-break: break-all;
}

.dropdown-menu a:hover .link-text {
  padding-left: 20px;
}

.link-text {
  color: inherit;
  text-shadow: none;
  transition: all 0.3s ease;
  overflow: hidden;
  word-break: break-all;
  white-space: normal
}

.nav-list a.router-link-active .link-text {
  color: #bb7df5;
  text-shadow: 0 0 15px #8a2be2;
}

.nav-list a.router-link-active {
  background: linear-gradient(135deg, rgba(138, 43, 226, 0.3), rgba(75, 0, 130, 0.3));
  border: 1px solid rgba(187, 125, 245, 0.4);
  color: #fff;
  box-shadow: 0 0 20px rgba(138, 43, 226, 0.5);
}

.dropdown-trigger.router-link-active {
  background: linear-gradient(135deg, rgba(138, 43, 226, 0.3), rgba(75, 0, 130, 0.3));
  border: 1px solid rgba(187, 125, 245, 0.4);
  color: #fff;
  box-shadow: 0 0 20px rgba(138, 43, 226, 0.5);
}

.link-hover-effect {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.1), transparent);
  transform: translateX(-100%);
  opacity: 0;
  transition: all 0.2s ease;
}

.nav-list a:hover .link-hover-effect,
.dropdown-trigger:hover .link-hover-effect {
  transform: translateX(100%);
  opacity: 1;
}

/* 登出下拉菜单 */
.logout-dropdown {
  position: fixed;
  top: 65px;
  right: 5px;
  background: linear-gradient(145deg, #1e1e3f 0%, #2a2a5a 100%);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  padding: 1rem;
  border-radius: 12px;
  box-shadow: 0 15px 50px rgba(0, 0, 0, 0.3),
  0 0 0 1px rgba(255, 255, 255, 0.1);
  z-index: 1001;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.5rem;
  min-width: 160px;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.dropdown-enter-active,
.dropdown-leave-active {
  transition: all 0.6s cubic-bezier(0.4, 0, 0.2, 1);
}

.dropdown-enter-from,
.dropdown-leave-to {
  opacity: 0;
  transform: translateY(-15px) scale(0.95);
}

.user-avatar {
  width: 60px;
  height: 60px;
  border-radius: 50%;
  background: linear-gradient(135deg, #4776E6, #8E54E9);
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 0 25px rgba(71, 118, 230, 0.6);
  border: 2px solid rgba(255, 255, 255, 0.2);
}

.user-avatar svg {
  width: 65%;
  height: 65%;
}

.welcome-text {
  color: #fff;
  font-size: 1rem;
  text-align: center;
  font-weight: 500;
}

.logout-btn {
  background: linear-gradient(135deg, #fd8383, #e53a30);
  color: white;
  padding: 0.75rem 1.5rem;
  border-radius: 30px;
  cursor: pointer;
  display: flex;
  align-items: center;
  transition: all 0.5s ease;
  box-shadow: 0 8px 25px rgba(238, 90, 82, 0.4);
}

.logout-btn:hover {
  transform: translateY(-3px);
  background: linear-gradient(135deg, #f5dc8a, #c5065c);
}

.logout-btn:active {
  transform: translateY(-1px);
}


@media (max-width: 576px) {
  .navbar {
    padding: 0 0.5rem;
  }

  .esg-logo {
    font-size: 1.1rem;
    margin-right: 0.5rem;
  }

  .nav-list li {
    min-width: 75px;
  }

  .nav-list a,
  .dropdown-trigger {
    font-size: 0.75rem;
    padding: 0 8px;
  }

  .dropdown-menu {
    width: 120px;
  }

  .dropdown-menu a {
    padding: 10px 15px;
    font-size: 0.8rem;
  }

  .welcome-text {
    font-size: 0.85rem;
  }

  .logout-btn {
    padding: 0.6rem 1.2rem;
    font-size: 0.85rem;
  }
}
</style>