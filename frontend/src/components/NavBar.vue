<template>
  <div class="navbar-wrapper">
    <nav class="navbar" :class="{ 'navbar-hidden': isNavbarHidden }">
      <div class="esg-logo" @click="navigateToDashboard">
        ESG
      </div>
      <ul class="nav-list">
        <li v-for="route in menuItems" :key="route.name">
          <template  v-if="!route.children">
            <router-link :to="route.path" :class="{ 'router-link-active': isActive(route.path)}" >
              <font-awesome-icon :icon="route.icon" :class="{'dark-icon': !isDarkTheme, 'light-icon': isDarkTheme }"/>
              <div class="link-hover-effect"></div>
            </router-link>
          </template>
        </li>
        <li>
          <a
            href="javascript:void(0)"
            class="logout-link"
            @click.prevent="handleLogout"
          >
            <font-awesome-icon :icon="'sign-out-alt'"  :class="{ 'dark-icon': !isDarkTheme, 'light-icon': isDarkTheme }" />
            <div class="link-hover-effect"></div>
          </a>
        </li>
      </ul>
    </nav>
  </div>
</template>

<script setup>
import {useRoute, useRouter} from 'vue-router'
import {computed, onMounted, onUnmounted, ref} from 'vue';
import {useAuthStore} from '@/stores/authStore';
import { useThemeStore } from '@/stores/themeStore';

const themeStore = useThemeStore();
const isDarkTheme = computed(() => {
  if (themeStore.mode === 'auto') {
    return window.matchMedia('(prefers-color-scheme: dark)').matches;
  }
  return themeStore.mode === 'dark';
});

const authStore = useAuthStore();
const showLogout = ref(false);
const isNavbarHidden = ref(false);
const lastScrollY = ref(0);


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

const route = useRoute()
const router = useRouter();

const navigateToDashboard = () => {
  router.push('/home');
};

const isActive = (path) => {
  return route.path === path || route.path.startsWith(path + '/');
}

const handleLogout = async () => {
  try {
    await authStore.logout();
  } catch (e) {
    console.error('退出登录过程中出错：', e);
    router.push('/login').catch(() => {});
  }
};

const menuItems = computed(() => {
  return [
    {name: 'home', path: '/home', label: '首页', icon: 'home'},
    {name: 'notifications', path: '/notifications', label: '通知', icon: 'bell'},
    {name: 'settings', path: '/settings', label: '设置', icon: 'cog'},
    {name: 'profile', path: '/profile', label: '个人中心', icon: 'user'}
  ];
})


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
  background: linear-gradient(135deg, #b1bfe5 0%, #fffcfc 50%, #e8e0ae 100%);
  z-index: 1000;
  overflow: visible;
  transform: translateY(0);
  transition: transform 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  display: flex;
  align-items: center;
}
.dark-theme .navbar {
  background: linear-gradient(135deg, #3e1617 0%, #1a1542 50%, #052142 100%);
}

  /* NavBar隐藏状态 */
.navbar-hidden {
  transform: translateY(-100%);
}

.esg-logo {
  font-family: 'Playfair Display', serif;
  font-weight: 800;
  font-size: 1.5rem;
  color: #141415;
  cursor: pointer;
  margin-right: 2rem;
  margin-left: 2rem;
  transition: all 0.3s ease;
  text-shadow: 0 0 20px rgba(255, 255, 255, 0.5);
}
.dark-theme .esg-logo {
  color: #ffffff;
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
  flex: 1;
  min-width: 45px;
  max-width: 60px;
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
.dark-icon {
  color: #333; /* 浅色模式下的深色图标 */
}

.light-icon {
  color: #fff; /* 深色模式下的浅色图标 */
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
  color: #000;
  text-shadow: none;
  transition: all 0.3s ease;
  overflow: hidden;
  word-break: break-all;
  white-space: normal
}
.dark-theme .link-text {
  color: #fff;
}

.nav-list a.router-link-active .link-text {
  color: #2b084d;
  text-shadow: 0 0 15px rgba(138, 43, 226, 0.5);
}
.dark-theme .nav-list a.router-link-active .link-text {
  color: #e5d56d;
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

  .dropdown-menu a {
    padding: 10px 15px;
    font-size: 0.8rem;
  }
}
</style>