import {createRouter, createWebHistory} from 'vue-router'
import {useAuthStore} from '@/stores/authStore'
import LoginView from "@/views/LoginView.vue";
import ProfileView from "@/views/ProfileView.vue";
import Home from "@/views/Home.vue";
import ReviewManagement from "@/views/ReviewManagement.vue";
import AccountManagementView from "@/views/AccountManagementView.vue";
import IndicatorLibraryView from "@/views/IndicatorLibraryView.vue";
import AnnouncementBoardView from "@/views/AnnouncementBoardView.vue";
import MonthlyDataView from '@/views/MonthlyDataView.vue';
import YearlyDataView from '@/views/YearlyDataView.vue';
import {showError} from "@/utils/toast.js";
import DataView from "@/views/DataView.vue";

const routes = [{path: '/', redirect: '/login'}, {path: '/login', component: LoginView}, {
    path: '/profile', component: ProfileView
}, {path: '/home', component: Home}, {path: '/data-view', component: DataView}, {path: '/month', component: MonthlyDataView}, {
    path: '/year', component: YearlyDataView
}, {path: '/year/:category_id', component: YearlyDataView}, {path: '/month/:category_id', component: MonthlyDataView}, {
    path: '/review-management', component: ReviewManagement
}, {
    path: '/account-management', component: AccountManagementView
}, {
    path: '/indicator-library', component: IndicatorLibraryView
}, {
    path: '/announcement-board', component: AnnouncementBoardView
}]

const router = createRouter({
    history: createWebHistory(import.meta.env.BASE_URL), routes
})

const publicRoutes = ['/login']
export const commonRoutes = ['/home', '/account-management', '/indicator-library', '/announcement-board', '/review-management', '/profile'];

// 路由守卫 - 保护需要认证的路由
router.beforeEach((to, from, next) => {
    const authStore = useAuthStore()
    if (to.path === '' || publicRoutes.includes(to.path)) {
        return next();
    }
    if (!authStore.isAuthenticated) {
        return next('/login');
    }

    if (authStore.isDepartment) {
        let requiredDepartment = null;
        const monthMatch = to.path.match(/^\/month\/(\d+)(?:\/|$)/);
        if (monthMatch) {
            const id = Number(monthMatch[1]);
            const monthList = authStore.monthCategories;
            requiredDepartment = monthList.find(i => Number(i.id) === id);
            if (requiredDepartment) {
                if (!authStore.hasDepartmentAccess(id)) {
                    showError(`无权限访问${requiredDepartment.name_zh}页面, 需要${requiredDepartment.name_zh}部门权限`);
                    return next(false);
                }
            }
        }
    }
    next();
})

export default router