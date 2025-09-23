import {defineStore} from 'pinia'
import {computed, ref} from 'vue'
import router from '@/router'
import apiClient from '@/utils/axios';
import {useSelectionStore} from "@/stores/selectionStore.js";

export const useAuthStore = defineStore('auth', () => {
    const accessToken = ref(null);
    const user = ref(null);
    const isAuthenticated = ref(false);

    // Initialize computed properties with default values
    const isDepartment = computed(() => user.value?.role === 'department' || false);
    const isFactory = computed(() => user.value?.role === 'factory' || false);
    const isHeadquarter = computed(() => user.value?.role === 'headquarter' || false);
    const isAdmin = computed(() => user.value?.role === 'admin' || false);
    const factory = computed(() => user.value?.factory || '');
    const departments = computed(() => user.value?.departments || []);
    const QUANT_TYPES = ['material', 'energy', 'water', 'waste', 'emission', 'investment', 'management', 'employment', 'training', 'ohs', 'satisfaction', 'supply', 'responsibility', 'ip', 'community', 'governance']
    const ANALYTICAL_TYPES = ['env_qual', 'env_quant', 'social_qual_labor', 'social_qual_other', 'social_quant_labor', 'social_quant_other', 'governance']

    // 部门权限检查
    const hasDepartmentAccess = (departmentType) => {
        if (isFactory.value || isHeadquarter.value || isAdmin.value) {
            return true
        }
        if (isDepartment.value && departments.value) {
            return Array.isArray(departments.value) ? departments.value.includes(departmentType) : false
        }
        return false
    }
    const setDataMode = (dataType) => {
        isDataMode.value = !ANALYTICAL_TYPES.includes(dataType)
    }
    // 获取用户可访问的部门列表
    const getReviewableDataTypes = computed(() => {
        if (isHeadquarter.value || isAdmin.value) return [...QUANT_TYPES, ...ANALYTICAL_TYPES]
        if (isFactory.value) return QUANT_TYPES
        if (isDepartment.value) return departments.value
        return []
    })

    // 权限相关计算属性
    const canLevel1Review = computed(() => (isDataMode && isFactory.value) || (!isDataMode && (isHeadquarter.value || isAdmin.value))) // 工厂一级审核月度，总部/管理员一级审核年度
    const canLevel2Review = computed(() => isDataMode && (isHeadquarter.value || isAdmin.value)) // 总部/管理员可以二级审核月度
    const canViewAllData = computed(() => isHeadquarter.value || isAdmin.value)
    const canViewFactoryData = computed(() => isFactory.value || isHeadquarter.value || isAdmin.value)
    const isDataMode = ref(true);
    const selectionStore = useSelectionStore();

    // Add a loading state to track initialization

    // 初始化认证信息
    const initAuth = (token, userData) => {
        accessToken.value = token
        user.value = userData
        // 为头像添加时间戳以避免缓存问题
        const avatarPath = userData.avatar ? userData.avatar : '/static/avatars/default-avatar.jpg';
        user.value.avatar = `${apiClient.defaults.baseURL}${avatarPath}?t=${new Date().getTime()}`;
        console.log("用户登录认证数据：", user);
        localStorage.setItem('access_token', token)
        localStorage.setItem('user', JSON.stringify(user.value))
        localStorage.removeItem('lastPath_data');
        localStorage.removeItem('lastPath_analyze');
        localStorage.removeItem('reviewManagementState');
        selectionStore.initSelection();
        apiClient.defaults.headers.common['Authorization'] = `Bearer ${token}`
        isAuthenticated.value = true;
    }

    // 更新头像
    const updateAvatar = (avatarPath) => {
        if (user.value) {
            user.value.avatar = `${apiClient.defaults.baseURL}${avatarPath}?t=${new Date().getTime()}`;
            localStorage.setItem('user', JSON.stringify(user.value));
        }
    }

    // 设置认证信息
    const setAuth = (token, userData) => {
        accessToken.value = token
        user.value = userData
        console.log("用户数据：", userData)
        if (userData && userData.avatar) {
            user.value.avatar = `${apiClient.defaults.baseURL}${userData.avatar}?t=${new Date().getTime()}`;
        } else if (userData) {
            user.value.avatar = `${apiClient.defaults.baseURL}/static/avatars/default-avatar.jpg?t=${new Date().getTime()}`;
        }
        localStorage.setItem('access_token', token)
        localStorage.setItem('user', JSON.stringify(user.value))
        apiClient.defaults.headers.common['Authorization'] = `Bearer ${token}`
    }

    // 清除认证信息
    const clearAuth = () => {
        selectionStore.resetSelection();
        accessToken.value = null;
        user.value = null;
        localStorage.removeItem('access_token');
        localStorage.removeItem('user');
        localStorage.removeItem('lastPath_data');
        localStorage.removeItem('lastPath_analyze');
        localStorage.removeItem('reviewManagementState');
        delete apiClient.defaults.headers.common['Authorization'];
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
                return remainingTime > 0 ? 'valid' : 'expire';
            } catch (error) {
                console.error('解析 Token 失败:', error);
            }
        }
        return 'expire'
    }

    // 刷新token
    const refreshToken = async () => {
        if (!accessToken.value) {
            console.warn('已无有效的访问令牌，无法将其刷新');
            return null;
        }
        try {
            const response = await apiClient.post('/auth/refresh', {
                access_token: accessToken.value,
            });
            setAuth(response.data.new_token, user.value);
            if (response.data.new_token) {
                return response.data.new_token;
            }
        } catch (error) {
            console.error('Token刷新失败:', error);
        }
        return null;
    }

    // 登出
    const logout = async () => {
        clearAuth();
        router.push('/login');
    }

    return {
        accessToken,
        user,
        isAuthenticated,
        isHeadquarter,
        isAdmin,
        isFactory,
        isDepartment,
        isDataMode,
        factory,
        departments,
        hasDepartmentAccess,
        setDataMode,
        getReviewableDataTypes,
        QUANT_TYPES,
        ANALYTICAL_TYPES,
        canLevel1Review,
        canLevel2Review,
        canViewAllData,
        canViewFactoryData,
        initAuth,
        setAuth,
        clearAuth,
        checkTokenValid,
        refreshToken,
        logout,
        updateAvatar,
    }
})