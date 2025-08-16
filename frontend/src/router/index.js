import {createRouter, createWebHistory} from 'vue-router'
import MaterialView from '@/views/MaterialView.vue'
import EnergyView from "@/views/EnergyView.vue";

const routes = [{
    path: '/', redirect: '/material'
}, {
    path: '/material',
    name: 'material', component: MaterialView
}, {
    path: '/energy',
    name: 'energy', component: EnergyView
}, // 其他大类路由...
]

const router = createRouter({
    history: createWebHistory(import.meta.env.BASE_URL), routes
})

export default router