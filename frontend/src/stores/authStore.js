import {defineStore} from 'pinia'
import {computed, ref} from 'vue'
import router from '@/router'
import apiClient from '@/utils/axios';
import {useSelectionStore} from "@/stores/selectionStore.js";

export const useAuthStore = defineStore('auth', () => {
    const accessToken = ref(localStorage.getItem('access_token'))
    const user = ref(JSON.parse(localStorage.getItem('user') || 'null'))
    const isAuthenticated = computed(() => !!accessToken.value)

    // 权限相关计算属性
    const isHeadquarters = computed(() => user.value?.account_type === 'headquarters')
    const isFactory = computed(() => user.value?.account_type === 'factory')
    const factory = computed(() => user.value?.factory)
    const isDataMode = ref(true);
    const selectionStore = useSelectionStore();

    // 初始化认证信息
    const initAuth = (token, userData) => {
        accessToken.value = token
        user.value = userData
        user.value.avatar = apiClient.defaults.baseURL + userData.avatar;
        isDataMode.value = isFactory.value;
        localStorage.setItem('access_token', token)
        localStorage.setItem('user', JSON.stringify(userData))
        localStorage.setItem('lastPath_data', '/material');
        localStorage.removeItem('lastPath_analyze');
        selectionStore.initSelection();
        apiClient.defaults.headers.common['Authorization'] = `Bearer ${token}`
    }

    // 设置认证信息
    const setAuth = (token, userData) => {
        accessToken.value = token
        user.value = userData
        localStorage.setItem('access_token', token)
        apiClient.defaults.headers.common['Authorization'] = `Bearer ${token}`
    }

    // 清除认证信息
    const clearAuth = () => {
        accessToken.value = null
        user.value = null
        localStorage.removeItem('access_token')
        localStorage.removeItem('user')
        delete apiClient.defaults.headers.common['Authorization']
    }

    // 检查token是否有效
    const checkTokenValid = () => {
        if (accessToken.value) {
            try {
                const payload = JSON.parse(atob(accessToken.value.split('.')[1]));
                if (!payload || !payload.exp) return 'expire';
                const expireTime = payload.exp * 1000; // 转换为毫秒
                const currentTime = Date.now();
                const remainingTime = expireTime - currentTime;
                console.log('Token剩余时间（秒）:', remainingTime / 1000);
                return remainingTime > 0 ? 'valid' : 'expire';
            } catch (error) {
                console.error('解析 Token 失败:', error);
            }
        }
        return 'expire'
    }

    // 刷新token
    const refreshToken = async () => {
        try {
            const response = await apiClient.post('/refresh', {
                access_token: accessToken.value,
            });
            setAuth(response.data.new_token, user.value)
            if (response.data.new_token) {
                return response.data.new_token
            }
        } catch (error) {
            console.error('Token刷新失败:', error)
        }
        return null
    }

    // 登出
    const logout = async () => {
        clearAuth();
        if (router.currentRoute.value.path !== '/login') {
            router.push('/login').then(r => console.log(r));
        }
    }

    return {
        accessToken,
        user,
        isAuthenticated,
        isHeadquarters,
        isFactory,
        isDataMode,
        factory,
        initAuth,
        setAuth,
        clearAuth,
        checkTokenValid,
        refreshToken,
        logout
    }
})