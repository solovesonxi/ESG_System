<template>
  <div
    ref="floatingBall"
    class="floating-ball"
    :class="{ 'active': isActive }"
    @mousedown="startDrag"
    @mouseup="stopDrag"
  >
    <div class="ball-text">{{ isActive ? '填报': '分析'  }}</div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';

const emit = defineEmits(['toggleMode']);
const floatingBall = ref(null);
const route = useRoute();
const router = useRouter();
const isActive = ref(false);
const isDragging = ref(false);
const posX = ref(0);
const posY = ref(0);
const offsetX = ref(0);
const offsetY = ref(0);
const startPos = ref({ x: 0, y: 0 });

const startDrag = (e) => {
  isDragging.value = true;
  offsetX.value = e.clientX - posX.value;
  offsetY.value = e.clientY - posY.value;
  startPos.value = { x: e.clientX, y: e.clientY };
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



const updatePosition = () => {
  if (!floatingBall.value) return;
  
  const ball = floatingBall.value;
  const ballRect = ball.getBoundingClientRect();
  const windowWidth = window.innerWidth;
  const windowHeight = window.innerHeight;

  if (ballRect.left < 0) {
    posX.value = 0;
  } else if (ballRect.right > windowWidth) {
    posX.value = windowWidth - ballRect.width;
  } else if (ballRect.top < 0) {
    posY.value = 0;
  } else if (ballRect.bottom > windowHeight) {
    posY.value = windowHeight - ballRect.height;
  }

  ball.style.left = `${posX.value}px`;
  ball.style.top = `${posY.value}px`;
};

const toggleMode = () => {
  // 记录当前模式的最后浏览页面
  const currentMode = isActive.value ? 'data' : 'default';
  localStorage.setItem(`lastPath_${currentMode}`, route.path);
  
  isActive.value = !isActive.value;
  emit('toggleMode');
  
  if (isActive.value) {
    // 切换到分析模式
    const lastPath = localStorage.getItem('lastPath_data');
    const path = lastPath || '/env-quantitative';
    router.push(path);
  } else {
    // 切换到填报模式
    const lastPath = localStorage.getItem('lastPath_default');
    const path = lastPath || '/material';
    router.push(path);
  }
};

onMounted(() => {
  posX.value = window.innerWidth - 120;
  posY.value = window.innerHeight - 120;
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
  width: 100px;
  height: 100px;
  border-radius: 50%;
  background-color: rgba(144, 238, 144, 0.7);
  cursor: pointer;
  z-index: 9999;
  transition: all 0.2s ease;
  box-shadow: 0 0 10px rgba(144, 238, 144, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
}

.floating-ball.active {
  background-color: rgba(173, 216, 230, 0.7);
  box-shadow: 0 0 15px rgba(173, 216, 230, 0.7);
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