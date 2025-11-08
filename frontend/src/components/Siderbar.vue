<template>
  <div class="siderbar" :class="{ 'collapsed': isCollapsed }">
    <div class="toggle-icon" @click="toggleCollapse">
      <span class="toggle-symbol" aria-hidden="true">
        <img
            :src="apiClient.defaults.baseURL + '/static/icons/' + (isCollapsed ? 'siderbar-right.png' : 'siderbar-left.png')"
            alt="toggle"
            style="width:1.2rem; height:auto; display:inline-block;"
        />
      </span>
    </div>
    <ul class="menu-list">
      <li v-for="item in menuItems" :key="item.name">
        <router-link :to="item.path" :class="{ 'active': isActive(item.path) }">
          <font-awesome-icon :icon="item.icon" class="menu-icon" />
          <span v-if="!isCollapsed" class="menu-text">{{ item.label }}</span>
        </router-link>
      </li>
    </ul>
  </div>
</template>

<script setup>
import {useRoute} from 'vue-router';
import {computed, onMounted, ref} from 'vue';
import apiClient from "@/utils/axios.js";
import {useAuthStore} from '@/stores/authStore';
import {library} from '@fortawesome/fontawesome-svg-core';
import {faBullhorn, faCalendarAlt, faCalendarDay, faChartPie, faChartLine, faCheckCircle, faTags, faUserCog, faSlidersH, faRobot} from '@fortawesome/free-solid-svg-icons';
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome';
// 添加图标到库
library.add(faChartLine, faCalendarAlt, faCalendarDay, faChartPie, faCheckCircle, faUserCog, faTags, faBullhorn, faSlidersH, faRobot);

const route = useRoute();
const isCollapsed = ref(false);
const authStore = useAuthStore();

const menuItems = computed(() => {
  const items = [
    { name: 'monthly-data', path: '/monthly-data', label: '月度数据', icon: 'calendar-day' }
  ];
  if (!authStore.isDepartment) {
    items.push({ name: 'yearly-data', path: '/yearly-data', label: '年度数据', icon: 'calendar-alt' });
    if(authStore.isHeadquarter||authStore.isAdmin) {
      items.push({ name: 'audit', path: '/summary-data', label: '汇总数据', icon: 'chart-pie' });
    }
    items.push({ name: 'announcement', path: '/announcement-board', label: '公告发布', icon: 'bullhorn' });
    items.push({ name: 'review', path: '/review-management', label: '审核管理', icon: 'check-circle' });
    items.push({ name: 'ai', path: '/ai-chat', label: '聊天助手', icon: 'robot' });
  }
  if (authStore.isAdmin) {
    items.push(
        { name: 'account', path: '/account-management', label: '账号管理', icon: 'user-cog' },
        { name: 'category', path: '/category-management', label: '分类管理', icon: 'tags' },
        { name: 'field', path: '/field-management', label: '指标管理', icon: 'sliders-h' },
    );
  }
  return items;
});


const isActive = (path) => {
  return route.path === path || route.path.startsWith(path + '/');
};

const toggleCollapse = () => {
  isCollapsed.value = !isCollapsed.value;
  localStorage.setItem('sidebarCollapsed', isCollapsed.value);
};

onMounted(() => {
  const savedState = localStorage.getItem('sidebarCollapsed');
  if (savedState !== null) {
    isCollapsed.value = savedState === 'true';
  }
});
</script>

<style scoped>
.siderbar {
  width: 10%;
  min-height: 100%;
  background: linear-gradient(180deg, #171616 0%, #3e1616 100%);
  color: #ffffff;
  box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
  transition: width 0.3s ease;
}

.siderbar.collapsed {
  width: 45px;
}

.toggle-icon {
  display: flex;
  justify-content: flex-end;
  padding: 10px;
  cursor: pointer;
  color: rgba(255, 255, 255, 0.8);
  transition: all 0.3s ease;
}

.toggle-icon:hover {
  color: #ffffff;
}

.toggle-icon i {
  font-size: 1.2rem;
}

/* styling for the plain-text toggle symbol */
.toggle-symbol {
  font-size: 1.2rem;
  font-weight: 700;
  color: inherit;
  line-height: 1;
  user-select: none;
}

.menu-list {
  list-style: none;
}

.menu-list li {
  margin: 5px 0;
}

.menu-list a {
  display: flex;
  align-items: center;
  padding: 12px 20px;
  color: rgba(255, 255, 255, 0.7);
  text-decoration: none;
  transition: all 0.3s ease;
}

.siderbar.collapsed .menu-list a {
  padding: 12px 12px 12px 8px;
}


.menu-list a:hover {
  background: rgba(255, 255, 255, 0.1);
  color: rgba(184, 212, 243, 0.9);
}

.menu-list a.active {
  background: rgba(255, 255, 255, 0.2);
  color: #f6d709;
  border-left: 3px solid #4b6cb7;
}

.menu-list i {
  margin-right: 10px;
  font-size: 1.2rem;
}

.menu-text {
  font-size: 1rem;
}

.menu-icon {
  margin-right: 12px;
  font-size: 1.2rem;
}

</style>