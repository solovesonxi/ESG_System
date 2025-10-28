import {defineStore} from 'pinia'
import {computed, nextTick, ref} from 'vue'
import router from '@/router'
import apiClient from '@/utils/axios';
import {useSelectionStore} from "@/stores/selectionStore.js";

export const useAuthStore = defineStore('auth', () => {
    const accessToken = ref(null);
    const user = ref(null);
    const isAuthenticated = ref(false);
    const categories = ref({});
    const isDepartment = computed(() => user.value?.role === 'department' || false);
    const isFactory = computed(() => user.value?.role === 'factory' || false);
    const isHeadquarter = computed(() => user.value?.role === 'headquarter' || false);
    const isAdmin = computed(() => user.value?.role === 'admin' || false);
    const factory = computed(() => user.value?.factory || '');
    const departments = computed(() => user.value?.departments || []);
    // 部门权限检查
    const hasDepartmentAccess = (departmentId) => {
        if (isFactory.value || isHeadquarter.value || isAdmin.value) {
            return true
        }
        if (isDepartment.value && departments.value.ids) {
            return Array.isArray(departments.value.ids) ? departments.value.ids.includes(departmentId) : false
        }
        return false
    }

    const flattenCategories = (catObj) => {
        if (!catObj || typeof catObj !== 'object') return [];
        try {
            const allItems = Object.values(catObj).flat();
            return (allItems || []).map(it => {
                const id = it?.id ?? null;
                const name_en = it?.name_en ?? null;
                const rawNameZh = it?.name_zh ?? null;
                const domain = it?.domain ?? null;
                let name_zh = rawNameZh;
                if (rawNameZh && (rawNameZh.includes('定量') || rawNameZh.includes('定性')) && domain) {
                    const trimmed = rawNameZh.trim();
                    if (!trimmed.startsWith(domain)) {
                        name_zh = `${domain}${trimmed}`;
                    } else {
                        name_zh = trimmed;
                    }
                }
                return {id, name_en, name_zh, domain};
            }).filter(x => x && x.name_en);
        } catch (e) {
            return [];
        }
    }

    const monthCategories = computed(() => flattenCategories(categories.value?.month));
    const yearCategories = computed(() => flattenCategories(categories.value?.year));

    // 获取用户可访问的部门列表
    const getReviewableDataTypes = computed(() => {
        const monthItems = monthCategories.value || [];
        const yearItems = yearCategories.value || [];

        if (isHeadquarter.value || isAdmin.value) return [...monthItems, ...yearItems];
        if (isFactory.value) return monthItems;

        if (isDepartment.value) {
            // departments.value.ids 可能是数字或字符串，标准化为字符串比较更稳健
            const deps = Array.isArray(departments.value?.ids) ? departments.value.ids.map(String) : [];
            return monthItems.filter(item => item && item.name_en && deps.includes(String(item.name_en)));
        }
        return [];
    });

    const categoryRouteMap = computed(() => {
        const map = {};
        const m = monthCategories.value || [];
        const y = yearCategories.value || [];
        m.forEach(item => {
            if (!item || !item.name_en) return;
            map[item.name_en] = map[item.name_en] || {name_en: item.name_en, name_zh: item.name_zh};
            map[item.name_en].id = item.id;
            map[item.name_en].name_zh = item.name_zh || map[item.name_en].name_zh;
            map[item.name_en].path = `/month/${item.id}`;
        });
        y.forEach(item => {
            if (!item || !item.name_en) return;
            map[item.name_en] = map[item.name_en] || {name_en: item.name_en, name_zh: item.name_zh};
            map[item.name_en].id = item.id;
            map[item.name_en].name_zh = item.name_zh || map[item.name_en].name_zh;
            map[item.name_en].path = `/year/${item.id}`;
        });
        return map;
    });

    const getCategoryMapping = (key) => {
        if (key) {
            if (typeof key === 'number') {
                return monthCategories.value.find(item => item.id === key) || yearCategories.value.find(item => item.id === key);
            } else if (typeof key === 'string') {
                return monthCategories.value.find(item => item.name_en === key) || yearCategories.value.find(item => item.name_en === key);
            }
        }
        return null;
    }

    const getCategoryRoute = (category) => {
        if (!category) return null;
        const entries = Object.values(categoryRouteMap.value);
        const entry = entries.find(item => item.id === category);
        return entry || null;
    };

    const selectionStore = useSelectionStore();
    // 初始化认证信息
    const initAuth = async (token, userData, cats, factories) => {
        accessToken.value = token
        user.value = userData
        categories.value = cats || {};
        selectionStore.factories = factories || [];
        const avatarPath = userData.avatar ? userData.avatar : '/static/avatars/default-avatar.jpg';
        user.value.avatar = `${apiClient.defaults.baseURL}${avatarPath}?t=${new Date().getTime()}`;
        console.log("用户登录认证数据：", user);
        localStorage.setItem('access_token', token)
        localStorage.setItem('user', JSON.stringify(user.value))
        localStorage.removeItem('monthly_path');
        localStorage.removeItem('yearly_path');
        localStorage.removeItem('reviewManagementState');
        selectionStore.initSelection();
        apiClient.defaults.headers.common['Authorization'] = `Bearer ${token}`
        isAuthenticated.value = true;
        try {
            await nextTick();
            monthCategories.value;
            yearCategories.value;
        } catch (e) {
            console.warn('initAuth: 下一帧触发计算失败', e);
        }
        await router.push('/home');
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
        console.log("更新用户数据：", userData)
        if (userData && userData.avatar) {
            user.value.avatar = `${apiClient.defaults.baseURL}${userData.avatar}?t=${new Date().getTime()}`;
        } else if (userData) {
            user.value.avatar = `${apiClient.defaults.baseURL}/static/avatars/default-avatar.jpg?t=${new Date().getTime()}`;
        }
        localStorage.setItem('access_token', token)
        localStorage.setItem('user', JSON.stringify(user.value))
        apiClient.defaults.headers.common['Authorization'] = `Bearer ${token}`
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
        selectionStore.resetSelection();
        accessToken.value = null;
        user.value = null;
        categories.value = null;
        localStorage.removeItem('access_token');
        localStorage.removeItem('user');
        localStorage.removeItem('monthly_path');
        localStorage.removeItem('yearly_path');
        localStorage.removeItem('reviewManagementState');
        delete apiClient.defaults.headers.common['Authorization'];
        await router.push('/login');
    }

    return {
        accessToken,
        user,
        isAuthenticated,
        categories,
        isHeadquarter,
        isAdmin,
        isFactory,
        isDepartment,
        factory,
        departments,
        getReviewableDataTypes,
        monthCategories,
        yearCategories,
        categoryRouteMap,
        getCategoryMapping,
        getCategoryRoute,
        hasDepartmentAccess,
        initAuth,
        setAuth,
        checkTokenValid,
        refreshToken,
        logout,
        updateAvatar,
    }
})