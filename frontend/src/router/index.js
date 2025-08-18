import {createRouter, createWebHistory} from 'vue-router'
import MaterialView from '@/views/MaterialView.vue'
import EnergyView from "@/views/EnergyView.vue";
import WaterView from "@/views/WaterView.vue";
import EmissionView from "@/views/EmissionView.vue";

const routes = [{path: '/', redirect: '/material'},
    {path: '/material', component: MaterialView}, {path: '/energy', component: EnergyView},
    {path: '/water', component: WaterView}, {path: '/emission', component: EmissionView},
]

const router = createRouter({
    history: createWebHistory(import.meta.env.BASE_URL), routes
})

export default router