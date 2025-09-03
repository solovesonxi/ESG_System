import {createRouter, createWebHistory} from 'vue-router'
import { useAuthStore } from '@/stores/authStore'
import MaterialView from '@/views/MaterialView.vue'
import EnergyView from "@/views/EnergyView.vue";
import WaterView from "@/views/WaterView.vue";
import EmissionView from "@/views/EmissionView.vue";
import WasteView from "@/views/WasteView.vue";
import InvestmentView from "@/views/InvestmentView.vue";
import EmploymentView from "@/views/EmploymentView.vue";
import TrainingView from "@/views/TrainingView.vue";
import OHSView from "@/views/OHSView.vue";
import SatisfactionView from "@/views/SatisfactionView.vue";
import SupplyView from "@/views/SupplyView.vue";
import IPView from "@/views/IPView.vue";
import ResponsibilityView from "@/views/ResponsibilityView.vue";
import CommunityView from "@/views/CommunityView.vue";
import EnvQuantitativeView from "@/views/EnvQuantitativeView.vue";
import EnvQualitativeView from "@/views/EnvQualitativeView.vue";
import SocialQuantitativeLaborView from "@/views/SocialQuantitativeLaborView.vue";
import SocialQualitativeLaborView from "@/views/SocialQualitativeLaborView.vue";
import SocialQuantitativeOtherView from "@/views/SocialQuantitativeOtherView.vue";
import SocialQualitativeOtherView from "@/views/SocialQualitativeOtherView.vue";
import GovernanceView from "@/views/GovernanceView.vue";
import LoginView from "@/views/LoginView.vue";
import ProfileView from "@/views/ProfileView.vue";

const routes = [
    {path: '/', redirect: '/login'},
    {path: '/login', component: LoginView},
    {path: '/profile', component: ProfileView },
    {path: '/material', component: MaterialView},
    {path: '/energy', component: EnergyView},
    {path: '/water', component: WaterView},
    {path: '/emission', component: EmissionView},
    {path: '/waste', component: WasteView},
    {path: '/investment', component: InvestmentView},
    {path: '/employment', component: EmploymentView},
    {path: '/training', component: TrainingView},
    {path: '/ohs', component: OHSView},
    {path: '/satisfaction', component: SatisfactionView},
    {path: '/supply', component: SupplyView},
    {path: '/ip', component: IPView},
    {path: '/responsibility', component: ResponsibilityView},
    {path: '/community', component: CommunityView},
    {path: '/env-quantitative', component: EnvQuantitativeView},
    {path: '/env-qualitative', component: EnvQualitativeView},
    {path: '/social-quantitative-labor', component: SocialQuantitativeLaborView},
    {path: '/social-qualitative-labor', component: SocialQualitativeLaborView},
    {path: '/social-quantitative-other', component: SocialQuantitativeOtherView},
    {path: '/social-qualitative-other', component: SocialQualitativeOtherView},
    {path: '/governance', component: GovernanceView},
]

const router = createRouter({
    history: createWebHistory(import.meta.env.BASE_URL), routes
})

// 路由守卫 - 保护需要认证的路由
router.beforeEach((to, from, next) => {
  const authStore = useAuthStore()
  const publicRoutes = ['/login']
  
  // 如果访问的是公开路由，直接放行
  if (publicRoutes.includes(to.path)) {
    return next()
  }
  
  // 检查是否已认证
  if (!authStore.isAuthenticated) {
    // 未认证，重定向到登录页
    return next('/login')
  }
  
  // 权限验证
  const headquartersRoutes = [
    '/env-quantitative', '/env-qualitative', 
    '/social-quantitative-labor', '/social-qualitative-labor',
    '/social-quantitative-other', '/social-qualitative-other',
    '/governance'
  ]
  
  // 检查总部账号权限
  if (headquartersRoutes.some(route => to.path.startsWith(route))) {
    if (!authStore.isHeadquarters) {
      // 工厂账号尝试访问总部页面，重定向到material页面
      return next('/material')
    }
  }
  
  // 已认证且权限验证通过，放行
  next()
})

export default router