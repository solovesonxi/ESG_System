<template>
  <div id="app">
    <NavBar />
    <main>
      <router-view />
      <div class="sprite" id="sprite"></div> <!-- 小精灵元素 -->
    </main>
    <canvas id="starry-bg"></canvas>
  </div>
</template>

<script setup>
import { RouterView } from 'vue-router'
import NavBar from '@/components/NavBar.vue'
import { onMounted, onUnmounted } from 'vue'

// 动态星空背景（保持不变）
onMounted(() => {
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

  // 小精灵动画逻辑
  const sprite = document.getElementById('sprite')
  let spriteX = 0
  let spriteY = 0
  let speedX = 2
  let speedY = 1.5

  function animateSprite() {
    // 获取表格位置（假设页面只有一个表格）
    const table = document.querySelector('table')
    if (table) {
      const rect = table.getBoundingClientRect()
      const tableLeft = rect.left
      const tableTop = rect.top
      const tableRight = rect.right
      const tableBottom = rect.bottom

      // 小精灵围绕表格边界移动
      spriteX += speedX
      spriteY += speedY

      // 边界检查（沿表格外框移动）
      if (spriteX <= tableLeft || spriteX >= tableRight - 30) {
        speedX = -speedX
      }
      if (spriteY <= tableTop || spriteY >= tableBottom - 30) {
        speedY = -speedY
      }

      sprite.style.left = `${spriteX}px`
      sprite.style.top = `${spriteY}px`
    }

    requestAnimationFrame(animateSprite)
  }

  // 初始化小精灵位置
  const table = document.querySelector('table')
  if (table) {
    const rect = table.getBoundingClientRect()
    spriteX = rect.left
    spriteY = rect.top
    sprite.style.left = `${spriteX}px`
    sprite.style.top = `${spriteY}px`
  }

  animateSprite()

  // 小精灵交互：悬浮放大，点击触发闪光
  sprite.addEventListener('mouseenter', () => {
    sprite.style.transform = 'scale(1.5) rotate(10deg)'
    sprite.style.background = 'radial-gradient(circle, #ffeb3b, #f06292)'
  })

  sprite.addEventListener('mouseleave', () => {
    sprite.style.transform = 'scale(1) rotate(0deg)'
    sprite.style.background = 'radial-gradient(circle, #4fc3f7, #0288d1)'
  })

  sprite.addEventListener('click', () => {
    sprite.style.animation = 'flash 0.5s'
    setTimeout(() => {
      sprite.style.animation = ''
    }, 500)
  })
})

// 清理事件监听器
onUnmounted(() => {
  const sprite = document.getElementById('sprite')
  sprite.removeEventListener('mouseenter', () => {})
  sprite.removeEventListener('mouseleave', () => {})
  sprite.removeEventListener('click', () => {})
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
  letter-spacing: 1.5px;
  text-shadow: 0 2px 5px rgba(0, 0, 0, 0.4);
}

main {
  padding: 2rem;
  flex: 1;
  background: rgba(255, 255, 255, 0.05);
  border-radius: 10px;
  margin: 1rem;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
  position: relative; /* 为小精灵定位提供上下文 */
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

/* 小精灵样式 */
.sprite {
  position: absolute;
  width: 30px;
  height: 30px;
  background: radial-gradient(circle, #4fc3f7, #0288d1);
  border-radius: 50%;
  box-shadow: 0 0 10px rgba(79, 195, 247, 0.8);
  transition: transform 0.3s ease, background 0.3s ease;
  cursor: pointer;
  z-index: 10;
}

/* 闪光动画 */
@keyframes flash {
  0% { box-shadow: 0 0 10px rgba(79, 195, 247, 0.8); }
  50% { box-shadow: 0 0 20px 10px rgba(255, 235, 59, 0.9); }
  100% { box-shadow: 0 0 10px rgba(79, 195, 247, 0.8); }
}

/* 按钮样式（保持不变） */
.nav-button {
  display: inline-block;
  padding: 0.8rem 1.5rem;
  margin: 0.5rem;
  font-family: 'Lora', serif;
  font-size: 1.1rem;
  font-weight: 700;
  color: #ffffff;
  background: linear-gradient(45deg, #3498db, #8e44ad);
  border: none;
  border-radius: 25px;
  text-decoration: none;
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;
  cursor: pointer;
  text-shadow: 0 1px 3px rgba(0, 0, 0, 0.5);
}

.nav-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 15px rgba(0, 0, 0, 0.3);
  background: linear-gradient(45deg, #8e44ad, #3498db);
}

.nav-button::before {
  content: '';
  position: absolute;
  top: 50%;
  left: 50%;
  width: 0;
  height: 0;
  background: rgba(255, 255, 255, 0.3);
  border-radius: 50%;
  transform: translate(-50%, -50%);
  transition: width 0.6s ease, height 0.6s ease;
}

.nav-button:hover::before {
  width: 200px;
  height: 200px;
}

/* 响应式调整 */
@media (max-width: 768px) {
  body {
    font-size: 1rem;
  }
  h1 {
    font-size: 2rem;
  }
  .nav-button {
    font-size: 1rem;
    padding: 0.6rem 1.2rem;
  }
  th, td {
    font-size: 1rem;
    padding: 0.6rem;
  }
  .sprite {
    width: 20px;
    height: 20px;
  }
}
</style>
