<template>
  <NavBar v-if="isAuthedPage" ref="navBar"/>
  <div class="app-layout">
    <Siderbar v-if="isAuthedPage" ref="siderBar"/>
    <div :class="'content-wrapper'">
      <router-view v-slot="{ Component }">
        <component :is="Component" ref="currentComponent"/>
      </router-view>
    </div>
    <EditControls
        v-if="isEditPage && (authStore.isDepartment || authStore.isFactory)"
        :is-editing="isEditing"
        @start-edit="handleStartEdit"
        @cancel-edit="handleCancelEdit"
        @save-edit="handleSubmitEdit(false)"
        @submit-edit="handleSubmitEdit(true)"
    />
    <ToastContainer/>
  </div>
</template>

<script setup>
import {RouterView, useRoute} from 'vue-router';
import NavBar from '@/components/NavBar.vue';
import Siderbar from '@/components/Siderbar.vue';
import EditControls from '@/components/EditControls.vue';
import ToastContainer from '@/components/ToastContainer.vue';
import {computed, ref, watch} from 'vue';
import {useAuthStore} from '@/stores/authStore';

const authStore = useAuthStore();
const navBar = ref(null);
const isEditing = ref(false);
const currentComponent = ref(null);
const route = useRoute();
const isAuthedPage = computed(() => route.path !== '/' && route.path !== '/login');
const isEditPage = computed(
    () => isAuthedPage.value && route.path === '/monthly-data' || route.path === '/yearly-data' || route.path === '/summary-data'
);

const handleStartEdit = () => {
  if (currentComponent.value && currentComponent.value.startEditing) {
    console.log('开始编辑');
    currentComponent.value.startEditing();
    isEditing.value = true;
  } else {
    console.error('当前视图不支持编辑功能');
  }
};

const handleCancelEdit = () => {
  if (currentComponent.value && currentComponent.value.cancelEditing) {
    console.log('取消编辑');
    currentComponent.value.cancelEditing();
    isEditing.value = false;
  } else {
    console.error('当前视图不支持取消编辑功能');
  }
};

const handleSubmitEdit = (ifSubmit) => {
  if (currentComponent.value && currentComponent.value.submitEdit) {
    console.log('提交编辑内容');
    currentComponent.value.submitEdit(ifSubmit);
    isEditing.value = false;
  } else {
    console.error('当前视图不支持提交编辑功能');
  }
};

watch(() => route.path, (newPath, oldPath) => {
  isEditing.value = false;
  setTimeout(() => {
    if (currentComponent.value) {
      if (typeof currentComponent.value.fetchData === 'function') {
        try {
          currentComponent.value.fetchData();
        } catch (error) {
          console.error('调用 fetchData 时出错：', error);
        }
      }
    }
  }, 10);
}, {immediate: false});


</script>


<style>
@import url('https://fonts.googleapis.com/css2?family=Lora:wght@500;700&family=Playfair+Display:wght@600;800&display=swap');

/* Ensure the document and root app element fill the viewport so children using 100vh/dvh behave correctly */
html, body, #app {
  height: 100%;
  width: 100vw;
  overflow-x: hidden;
}

* {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

body {
  font-family: 'Lora', serif;
  font-weight: 500;
  font-size: 1.2rem;
  line-height: 1.6;
  color: #ffffff;
  background: linear-gradient(180deg, #0a0a23 0%, #1b1b4f 100%);
  overflow-x: hidden;
  text-shadow: 0 1px 3px rgba(0, 0, 0, 0.5);
}

.app-layout {
  display: flex;
  min-height: 100%;
  width: 100%;
  margin: 0;
  padding: 0;
}

.content-wrapper {
  flex: 1;
  margin-left: 0; /* default no sidebar */
  display: flex;
  flex-direction: column;
  width: 100%;
}

main {
  flex: 1;
  background: rgba(255, 255, 255, 0.05);
  border-radius: 10px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
  position: relative;
  width: 100%;
  max-width: 1200px; /* keep content centered and readable */
}

/* 表格样式（保持不变） */
table {
  width: 100%;
  border-collapse: collapse;
  background: #ffffff;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
}

th, td {
  padding: 0.8rem;
  text-align: left;
  color: #333333;
  font-family: 'Lora', serif;
  font-weight: 500;
  font-size: 1.1rem;
  text-shadow: none;
}

th {
  background: #e0e0e0;
  font-weight: 700;
}

tr:nth-child(even) {
  background: #f9f9f9;
}

tr:hover {
  background: #e6f0fa;
}

td {
  border-bottom: 1px solid #ddd;
}

/* 响应式调整 */
@media (max-width: 768px) {
  body {
    font-size: 1rem;
  }

  h1 {
    font-size: 2rem;
  }
}
</style>