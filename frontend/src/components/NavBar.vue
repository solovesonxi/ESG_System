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
  { name: 'energy', path: '/energy', label: '能源' }
]
</script>

<style scoped>
.navbar {
  position: absolute;
  top: 20px;
  right: 30px;
  z-index: 1000;
}

.nav-list {
  list-style: none;
  display: flex;
  gap: 20px;
  margin: 0;
  padding: 0;
}

.nav-list a {
  color: white;
  text-decoration: none;
  font-weight: 500;
  padding: 8px 15px;
  border-radius: 4px;
  transition: all 0.3s;
}

.nav-list a:hover {
  background: rgba(255, 255, 255, 0.15);
}

.nav-list a.router-link-exact-active {
  background: rgba(255, 255, 255, 0.25);
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}
</style>