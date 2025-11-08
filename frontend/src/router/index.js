import {createRouter, createWebHistory} from 'vue-router'
import {useAuthStore} from '@/stores/authStore'
import {useSelectionStore} from "@/stores/selectionStore.js";
import {pinia} from "../main";
import LoginView from "@/views/LoginView.vue";
import ProfileView from "@/views/ProfileView.vue";
import Home from "@/views/Home.vue";
import ReviewManagement from "@/views/ReviewManagement.vue";
import AccountManagementView from "@/views/AccountManagementView.vue";
import CategoryManagement from "@/views/CategoryManagement.vue";
import FieldManagement from "@/views/FieldManagement.vue";
import AnnouncementBoardView from "@/views/AnnouncementBoardView.vue";
import MonthlyDataView from '@/views/MonthlyDataView.vue';
import YearlyDataView from '@/views/YearlyDataView.vue';
import SummaryDataView from "@/views/SummaryDataView.vue";
import NotificationsView from "@/views/NotificationsView.vue";
import SettingsView from "@/views/SettingsView.vue";
import AIChatView from '@/views/AIChatView.vue';

const routes = [{path: '/', redirect: '/home'}, {path: '/login', component: LoginView}, {
    path: '/home', component: Home
}, {path: '/notifications', component: NotificationsView}, {
    path: '/profile', component: ProfileView
}, {path: '/settings', component: SettingsView}, {
    path: '/monthly-data', component: MonthlyDataView
}, {path: '/yearly-data', component: YearlyDataView}, {path: '/summary-data', component: SummaryDataView}, {
    path: '/review-management', component: ReviewManagement
}, {path: '/account-management', component: AccountManagementView}, {
    path: '/category-management', component: CategoryManagement
}, {
    path: '/field-management', component: FieldManagement
}, {
    path: '/announcement-board', component: AnnouncementBoardView
},
{ path: '/ai-chat', component: AIChatView }
]

const router = createRouter({
    history: createWebHistory(import.meta.env.BASE_URL), routes
})
const publicRoutes = ['/login', '/docs']


// 路由守卫 - 保护需要认证的路由
router.beforeEach((to, from, next) => {
    const authStore = useAuthStore(pinia);
    const selectionStore = useSelectionStore(pinia);

    if (to.path === '' || publicRoutes.includes(to.path)) {
        return next();
    }
    if (!authStore.isAuthenticated) {
        return next('/login');
    }
    try {
        if (from.path === '/monthly-data') {
            localStorage.setItem('monthly_path', selectionStore.selectedCategoryMonthly?.id || 0);
        } else if (from.path === '/yearly-data') {
            localStorage.setItem('yearly_path', selectionStore.selectedCategoryYearly?.id || 0);
        }

        let categoryId;
        let localCategory;
        if (to.path === '/monthly-data') {
            categoryId = localStorage.getItem('monthly_path');
            if (categoryId) {
                localCategory = authStore.monthCategories.find(c => c.id === Number(categoryId))
                if (localCategory && localCategory.length) {
                    selectionStore.selectCategoryMonthly(localCategory);
                }
            }
        } else if (to.path === '/yearly-data') {
            categoryId = localStorage.getItem('yearly_path');
            if (categoryId) {
                localCategory = authStore.yearCategories.find(c => c.id === Number(categoryId))
                if (localCategory && localCategory.length) {
                    selectionStore.selectCategoryYearly(localCategory);
                }
            }
        }
    } catch (e) {
        console.warn('路由变化时无法初始化数据类型选择器:', e);
    }
    next();
})

export default router