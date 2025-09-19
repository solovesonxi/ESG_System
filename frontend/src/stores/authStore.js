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
    const isDepartment = computed(() => user.value?.role === 'department')
    const isFactory = computed(() => user.value?.role === 'factory')
    const isHeadquarter = computed(() => user.value?.role === 'headquarter')
    const isAdmin = computed(() => user.value?.role === 'admin')
    const factory = computed(() => user.value?.factory)
    const departments = computed(() => user.value?.departments)

    // 数据填写权限 - 部门账号可以填写自己部门的数据，工厂账号可以填写年报
    const canFillData = computed(() => isDepartment.value || isFactory.value || isAdmin.value)

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

    // 获取用户可访问的部门列表
    const getAccessibleDepartments = computed(() => {
        if (isFactory.value || isHeadquarter.value || isAdmin.value) {
            // 高级权限用户可以访问所有部门
            return [
                'material', 'energy', 'water', 'waste', 'emission', 'investment', 'management',
                'employment', 'training', 'ohs', 'satisfaction', 'supply', 'responsibility',
                'ip', 'community', 'governance'
            ]
        }
        return departments.value || []
    })

    // 审核权限 - 根据新规则调整
    const canLevel1Review = computed(() => isFactory.value || isAdmin.value) // 工厂可以编辑一级审核
    const canLevel2Review = computed(() => isHeadquarter.value || isAdmin.value) // 总部可以编辑二级审核

    // 查看审核结果权限 - 新增权限
    const canViewLevel1Results = computed(() => {
        // 部门：可以看自己部门的一二级审核结果
        // 工厂：可以看15个部门的一级审核结果，并能编辑
        // 总部：可以看一级审核结果，并能编辑二级审核结果
        return isDepartment.value || isFactory.value || isHeadquarter.value || isAdmin.value
    })

    const canViewLevel2Results = computed(() => {
        // 部门：可以看自己部门的二级审核结果
        // 工厂：可以看二级审核结果（只读）
        // 总部：可以看并编辑二级审核结果
        return isDepartment.value || isFactory.value || isHeadquarter.value || isAdmin.value
    })

    // 数据查看权限 - 根据新规则调整
    const canViewQuantitativeData = computed(() => {
        // 部门：可以看自己部门的15种定量数据
        // 工厂：可以看15个部门的定量数据月报
        // 总部：可以看定量数据
        return isDepartment.value || isFactory.value || isHeadquarter.value || isAdmin.value
    })

    const canViewYearlyData = computed(() => {
        // 工厂：可以填写年报
        // 总部：可以看年度数据
        return isFactory.value || isHeadquarter.value || isAdmin.value
    })

    // 查看权限
    const canViewAllData = computed(() => isHeadquarter.value || isAdmin.value)
    const canViewFactoryData = computed(() => isFactory.value || isHeadquarter.value || isAdmin.value)
    const isDataMode = ref(true);
    const selectionStore = useSelectionStore();

    // 初始化认证信息
    const initAuth = (token, userData) => {
        accessToken.value = token
        user.value = userData
        // 为头像添加时间戳以避免缓存问题
        const avatarPath = userData.avatar ? userData.avatar : '/static/avatars/default-avatar.jpg';
        user.value.avatar = `${apiClient.defaults.baseURL}${avatarPath}?t=${new Date().getTime()}`;
        console.log("用户登录认证数据：",user);
        console.log("用户部门：",departments.value);
        isDataMode.value = token;
        localStorage.setItem('access_token', token)
        localStorage.setItem('user', JSON.stringify(user.value)) // 保存更新后的用户信息
        localStorage.removeItem('lastPath_data');
        localStorage.removeItem('lastPath_analyze');
        selectionStore.initSelection();
        apiClient.defaults.headers.common['Authorization'] = `Bearer ${token}`
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
        console.log("用户数据：",userData)
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
            const response = await apiClient.post('/auth/refresh', {
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
        isHeadquarter,
        isAdmin,
        isFactory,
        isDepartment,
        isDataMode,
        factory,
        departments,
        canFillData,
        hasDepartmentAccess,
        getAccessibleDepartments,
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
        canViewLevel1Results,
        canViewLevel2Results,
        canViewQuantitativeData,
        canViewYearlyData
    }
})