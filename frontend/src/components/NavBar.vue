<template>
  <nav class="navbar">
    <ul class="nav-list">
      <li v-for="route in menuItems" :key="route.name">
        <router-link :to="route.path">{{ route.label }}</router-link>
      </li>
    </ul>
  </nav>
</template>

<script setup>
const menuItems = [
  { name: 'material', path: '/material', label: '物料' },
  { name: 'energy', path: '/energy', label: '能源' },
  { name: 'water', path: '/water', label: '水资源' }
]
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
}

.nav-list a {
  display: block;
  color: white;
  text-decoration: none;
  font-weight: 500;
  padding: 15px 20px;
  transition: all 0.3s;
  font-size: 1.1rem;
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