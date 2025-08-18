<template>
  <div id="app">
    <NavBar/>
    <main>
      <router-view/>
    </main>
  </div>
</template>

<script setup>
import {RouterView} from 'vue-router'
import NavBar from '@/components/NavBar.vue'
</script>

<style>
* {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

body {
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  line-height: 1;
  color: #333;
  background-color: #f5f7fa;
}

#app {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  position: relative;
}

header {
  background: linear-gradient(135deg, #3498db, #2c3e50);
  color: white;
  padding: 1.5rem;
  text-align: center;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  position: relative;
}

h1 {
  font-size: 2rem;
}

main {
  padding: 80px !important;
}
</style>