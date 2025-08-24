<template>
  <nav class="navbar" :style="navbarStyle">
    <ul class="nav-list">
      <li v-for="route in menuItems" :key="route.name">
        <router-link
            :to="route.path"
            :class="{ 'router-link-active': isActive(route.path) }"
        >
          {{ route.label }}
        </router-link>
      </li>
    </ul>
  </nav>
</template>

<script setup>
import {useRoute} from 'vue-router'
import { ref, computed } from 'vue';

const route = useRoute()
const isDataMode = ref(false)

const menuItems = computed(() => {
  return isDataMode.value ? dataModeItems : defaultModeItems
})

const defaultModeItems = [
  {name: 'material', path: '/material', label: '物料'},
  {name: 'energy', path: '/energy', label: '能源'},
  {name: 'water', path: '/water', label: '水资源'},
  {name: 'emission', path: '/emission', label: '排放'},
  {name: 'waste', path: '/waste', label: '废弃物'},
  {name: 'investment', path: '/investment', label: '资金投入'},
  {name: 'employment', path: '/employment', label: '雇佣'},
  {name: 'training', path: '/training', label: '教育与培训'},
  {name: 'ohs', path: '/ohs', label: '职健与安全'},
  {name: 'satisfaction', path: '/satisfaction', label: '员工满意度'},
  {name: 'supply', path: '/supply', label: '供应链'},
  {name: 'ip', path: '/ip', label: '知识产权'},
  {name: 'responsibility', path: '/responsibility', label: '产品责任'},
  {name: 'community', path: '/community', label: '社区参与'},
]

const dataModeItems = [
  {name: 'env-quantitative', path: '/env-quantitative', label: '环境定量'},
  {name: 'env-qualitative', path: '/env-qualitative', label: '环境定性'},
  {name: 'social-quantitative-labor', path: '/social-quantitative-labor', label: '社会定量-劳工'},
  {name: 'social-qualitative-labor', path: '/social-qualitative-labor', label: '社会定性-劳工'},
  {name: 'social-quantitative-other', path: '/social-quantitative-other', label: '社会定量-其他'},
  {name: 'social-qualitative-other', path: '/social-qualitative-other', label: '社会定性-其他'},
  {name: 'governance', path: '/governance', label: '管治'},
]

const navbarStyle = computed(() => {
  return {
    background: isDataMode.value ? 'linear-gradient(to right, #90ee90, #2c3e50)' : 'linear-gradient(to right, #2c3e50, #3498db)'
  }
})

// 检查当前路由是否匹配
const isActive = (path) => {
  return route.path === path || route.path.startsWith(path + '/')
}

// 切换模式
const toggleMode = () => {
  isDataMode.value = !isDataMode.value
}

defineExpose({
  toggleMode
})
</script>

<style scoped>
.navbar {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  background: linear-gradient(to right, #2c3e50, #3498db);
  z-index: 1000;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
}

.nav-list {
  list-style: none;
  display: flex;
  justify-content: center;
  margin: 0;
  padding: 0;
  width: 100%;
}

.nav-list li {
  flex: 1;
  max-width: 200px;
  text-align: center;
  position: relative;
}

.nav-list a {
  display: flex;
  justify-content: center;
  align-items: center;
  color: white;
  text-decoration: none;
  font-weight: 500;
  padding: 0 20px;
  height: 100%;
  min-height: 60px;
  transition: all 0.3s;
  font-size: 1.1rem;
  position: relative;
}

.nav-list a:hover {
  background: rgba(255, 255, 255, 0.15);
}

@media (max-width: 768px) {
  .nav-list {
    flex-direction: column;
  }

  .nav-list li {
    max-width: none;
    width: 100%;
  }

}
</style>