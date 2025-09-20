<template>
  <div
      ref="floatingBall"
      class="floating-ball"
      :class="{ 'active': authStore.isDataMode }"
      @mousedown="startDrag"
      @mouseup="stopDrag"
  >
    <div class="ball-text">{{ authStore.isDataMode ? '月度填报' : '年度分析' }}</div>
  </div>
</template>

<script setup>
import {onMounted, onUnmounted, ref} from 'vue';
import {useRoute, useRouter} from 'vue-router';
import {useAuthStore} from "@/stores/authStore.js";

const authStore = useAuthStore();

const floatingBall = ref(null);
const route = useRoute();
const router = useRouter();
const isDragging = ref(false);
const posX = ref(0);
const posY = ref(0);
const offsetX = ref(0);
const offsetY = ref(0);
const startPos = ref({x: 0, y: 0});

const startDrag = (e) => {
  isDragging.value = true;
  offsetX.value = e.clientX - posX.value;
  offsetY.value = e.clientY - posY.value;
  startPos.value = {x: e.clientX, y: e.clientY};
  document.addEventListener('mousemove', dragBall);
};

const dragBall = (e) => {
  if (isDragging.value) {
    posX.value = e.clientX - offsetX.value;
    posY.value = e.clientY - offsetY.value;
    updatePosition();
  }
};

const stopDrag = (e) => {
  if (isDragging.value) {
    const dragDistance = Math.sqrt(
        Math.pow(e.clientX - startPos.value.x, 2) +
        Math.pow(e.clientY - startPos.value.y, 2)
    );

    if (dragDistance < 5) {
      toggleMode();
    }
  }

  isDragging.value = false;
  document.removeEventListener('mousemove', dragBall);
};

// 切换模式
const toggleMode = () => {
  if (route.path === '/home' || route.path === '/account' && route.path === 'review-management') {
    authStore.isDataMode = !authStore.isDataMode;
  } else {
    const currentMode = authStore.isDataMode ? 'data' : 'analyze';
    localStorage.setItem(`lastPath_${currentMode}`, route.path);
    authStore.isDataMode = !authStore.isDataMode;
    const targetPath = localStorage.getItem(`lastPath_${authStore.isDataMode ? 'data' : 'analyze'}`) ||
        (authStore.isDataMode ? '/material' : '/env-quant');
    router.push(targetPath);
  }
};

const updatePosition = () => {
  if (!floatingBall.value) return;
  const ball = floatingBall.value;
  const ballRect = ball.getBoundingClientRect();
  const windowWidth = window.innerWidth;
  const windowHeight = window.innerHeight;

  // 只做边界保护
  if (posX.value < 0) posX.value = 0;
  if (posX.value > windowWidth - ballRect.width) posX.value = windowWidth - ballRect.width;
  if (posY.value < 0) posY.value = 0;
  if (posY.value > windowHeight - ballRect.height) posY.value = windowHeight - ballRect.height;

  ball.style.left = `${posX.value}px`;
  ball.style.top = `${posY.value}px`;
};

onMounted(() => {
  const ballHeight = 120;
  const ballWidth = 120;
  posX.value = window.innerWidth * 0.94 - ballWidth / 2;
  posY.value = window.innerHeight * 0.9 - ballHeight / 2;
  updatePosition();
  document.addEventListener('mouseup', stopDrag);
});

onUnmounted(() => {
  document.removeEventListener('mouseup', stopDrag);
  document.removeEventListener('mousemove', dragBall);
});
</script>

<style scoped>
.floating-ball {
  position: fixed;
  width: 120px;
  height: 120px;
  border-radius: 50%;
  background-color: rgba(245, 235, 125, 0.85);
  cursor: pointer;
  z-index: 9999;
  transition: all 0.2s ease;
  box-shadow: 0 0 10px rgba(144, 238, 144, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
}

.floating-ball.active {
  background-color: rgba(47, 163, 203, 0.85);
  box-shadow: 0 0 15px rgba(88, 131, 145, 0.85);
}

.floating-ball:hover {
  transform: scale(1.1);
  box-shadow: 0 0 20px rgba(144, 238, 144, 0.8);
}

.ball-text {
  color: white;
  font-weight: bold;
  font-size: 25px;
  user-select: none;
}
</style>