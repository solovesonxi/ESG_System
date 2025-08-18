import './assets/main.css'
import './assets/shared-form-styles.css'
import { createApp } from 'vue'
import { createPinia } from 'pinia' // 导入 Pinia
import App from './App.vue'
import router from './router'


const app = createApp(App)

// 先安装 Pinia
const pinia = createPinia()
app.use(pinia)

// 再启用路由
app.use(router)

app.mount('#app')