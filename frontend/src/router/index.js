import {createRouter, createWebHistory} from 'vue-router'
import {useAuthStore} from '@/stores/authStore'
import MaterialView from '@/views/MaterialView.vue'
import EnergyView from "@/views/EnergyView.vue";
import WaterView from "@/views/WaterView.vue";
import EmissionView from "@/views/EmissionView.vue";
import WasteView from "@/views/WasteView.vue";
import InvestmentView from "@/views/InvestmentView.vue";
import ManagementView from "@/views/ManagementView.vue";
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
import AccountView from "@/views/AccountView.vue";
import Home from "@/views/Home.vue";
import ReviewManagement from "@/views/ReviewManagement.vue";
import {showError} from "@/utils/toast.js";

const routes = [{path: '/', redirect: '/login'}, {path: '/login', component: LoginView}, {
    path: '/account', component: AccountView
}, {path: '/home', component: Home}, {path: '/material', component: MaterialView}, {
    path: '/energy',
    component: EnergyView
}, {
    path: '/water', component: WaterView
}, {path: '/emission', component: EmissionView}, {path: '/waste', component: WasteView}, {
    path: '/investment', component: InvestmentView
}, {path: '/management', component: ManagementView}, {
    path: '/employment', component: EmploymentView
}, {path: '/training', component: TrainingView}, {
    path: '/ohs', component: OHSView
}, {path: '/satisfaction', component: SatisfactionView}, {
    path: '/supply', component: SupplyView
}, {path: '/responsibility', component: ResponsibilityView}, {
    path: '/ip', component: IPView
}, {
    path: '/community', component: CommunityView
}, {path: '/env-quant', component: EnvQuantitativeView}, {
    path: '/env-qual', component: EnvQualitativeView
}, {path: '/social-quant-labor', component: SocialQuantitativeLaborView}, {
    path: '/social-qual-labor', component: SocialQualitativeLaborView
}, {path: '/social-quant-other', component: SocialQuantitativeOtherView}, {
    path: '/social-qual-other', component: SocialQualitativeOtherView
}, {path: '/governance', component: GovernanceView}, {
    path: '/review-management', component: ReviewManagement
},]

const router = createRouter({
    history: createWebHistory(import.meta.env.BASE_URL), routes
})

const publicRoutes = ['/login']

// 基于部门权限的页面访问控制
const routePermissionMap = {
    '/material': 'material',
    '/energy': 'energy',
    '/water': 'water',
    '/waste': 'waste',
    '/emission': 'emission',
    '/investment': 'investment',
    '/management': 'management',
    '/employment': 'employment',
    '/training': 'training',
    '/ohs': 'ohs',
    '/satisfaction': 'satisfaction',
    '/supply': 'supply',
    '/responsibility': 'responsibility',
    '/ip': 'ip',
    '/community': 'community',
    '/governance': 'governance'
};

// 路由守卫 - 保护需要认证的路由
router.beforeEach((to, from, next) => {
    const authStore = useAuthStore()
    if (to.path === '' || publicRoutes.includes(to.path)) {
        return next();
    }
    if (!authStore.isAuthenticated) {
        return next('/login');
    }

    const requiredDepartment = routePermissionMap[to.path];
    if (requiredDepartment) {
        // 部门账号权限检查 - 只能访问自己负责的部门数据
        if (authStore.isDepartment) {
            if (!authStore.hasDepartmentAccess(requiredDepartment)) {
                showError(`无权限访问页面: ${to.path}, 需要${requiredDepartment}部门权限`);
                return next(false);
            }
        }
    }
    next();
})

export default router