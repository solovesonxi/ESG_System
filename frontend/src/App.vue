<template>
  <div id="app">
    <NavBar ref="navBar"/>
    <main>
      <router-view v-slot="{ Component }">
        <component :is="Component" ref="currentComponent"/>
      </router-view>
    </main>
    <FloatingBall @toggleMode="toggleMode"/>
    <EditControls :is-editing="isEditing" @start-edit="handleStartEdit" @cancel-edit="handleCancelEdit"
                  @submit-edit="handleSubmitEdit"/>
    <canvas id="starry-bg"></canvas>
  </div>
</template>

<script setup>
import {RouterView, useRoute} from 'vue-router'
import NavBar from '@/components/NavBar.vue'
import FloatingBall from '@/components/FloatingBall.vue'
import EditControls from '@/components/EditControls.vue'
import {onMounted, ref, watch} from 'vue'

const navBar = ref(null)
const isEditing = ref(false)
const currentComponent = ref(null)
const route = useRoute()

const toggleMode = () => {
  if (navBar.value) {
    navBar.value.toggleMode()
  }
}

const handleStartEdit = () => {
  console.log('Start Edit triggered');
  console.log('currentComponent:', currentComponent.value);
  if (currentComponent.value && currentComponent.value.startEditing) {
    console.log('Calling startEditing on currentComponent');
    currentComponent.value.startEditing();
    isEditing.value = true;
  } else {
    console.error('当前视图不支持编辑功能');
  }
};

const handleCancelEdit = () => {
  console.log('Cancel Edit triggered');
  if (currentComponent.value && currentComponent.value.cancelEditing) {
    console.log('Calling cancelEditing on currentComponent');
    currentComponent.value.cancelEditing();
    isEditing.value = false;
  } else {
    console.error('当前视图不支持取消编辑功能');
  }
};

const handleSubmitEdit = () => {
  console.log('Submit Edit triggered');
  if (currentComponent.value && currentComponent.value.submitEdit) {
    console.log('Calling submitEdit on currentComponent');
    currentComponent.value.submitEdit();
    isEditing.value = false;
  } else {
    console.error('当前视图不支持提交编辑功能');
  }
};

// 监听路由变化，重置编辑状态并触发数据获取
watch(() => route.path, (newPath) => {
  isEditing.value = false;
  setTimeout(() => {
    if (currentComponent.value && currentComponent.value.fetchData) {
      currentComponent.value.fetchData();
    }
  }, 10);
});
// 动态星空背景（保持不变）
onMounted(() => {
  console.log('App mounted, currentComponent:', currentComponent.value);
  const canvas = document.getElementById('starry-bg')
  const ctx = canvas.getContext('2d')

  canvas.width = window.innerWidth
  canvas.height = window.innerHeight

  const stars = []
  const numStars = 100

  for (let i = 0; i < numStars; i++) {
    stars.push({
      x: Math.random() * canvas.width,
      y: Math.random() * canvas.height,
      radius: Math.random() * 1.5 + 0.5,
      speed: Math.random() * 0.5 + 0.2,
    })
  }

  function animateStars() {
    ctx.clearRect(0, 0, canvas.width, canvas.height)
    ctx.fillStyle = 'rgba(255, 255, 255, 0.8)'

    stars.forEach(star => {
      ctx.beginPath()
      ctx.arc(star.x, star.y, star.radius, 0, Math.PI * 2)
      ctx.fill()
      star.y += star.speed
      if (star.y > canvas.height) star.y = 0
    })

    requestAnimationFrame(animateStars)
  }

  window.addEventListener('resize', () => {
    canvas.width = window.innerWidth
    canvas.height = window.innerHeight
  })

  animateStars()
})
</script>


<style>
@import url('https://fonts.googleapis.com/css2?family=Lora:wght@500;700&family=Playfair+Display:wght@600;800&display=swap');

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

#app {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  position: relative;
}

#starry-bg {
  position: fixed;
  top: 0;
  left: 0;
  z-index: -1;
  pointer-events: none;
}

header {
  background: linear-gradient(135deg, rgba(52, 152, 219, 0.8), rgba(44, 62, 80, 0.8));
  color: #ffffff;
  padding: 1.5rem;
  text-align: center;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);
  position: relative;
  backdrop-filter: blur(5px);
}

h1 {
  font-family: 'Playfair Display', serif;
  font-weight: 800;
  font-size: 3rem;
  letter-spacing: 2px;
  text-shadow: 0 2px 5px rgba(0, 0, 0, 0.4);
}

main {
  padding: 2rem;
  flex: 1;
  background: rgba(255, 255, 255, 0.05);
  border-radius: 10px;
  margin: 1rem;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
  position: relative;
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