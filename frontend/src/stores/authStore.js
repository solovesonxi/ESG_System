import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import axios from 'axios'
import router from '@/router'

export const useAuthStore = defineStore('auth', () => {
  const accessToken = ref(localStorage.getItem('access_token'))
  const user = ref(JSON.parse(localStorage.getItem('user') || 'null'))
  const isAuthenticated = computed(() => !!accessToken.value)
  
  // 权限相关计算属性
  const isHeadquarters = computed(() => user.value?.account_type === 'headquarters')
  const isFactory = computed(() => user.value?.account_type === 'factory')
  const boundFactory = computed(() => user.value?.bound_factory || user.value?.factory)

  // 设置认证信息
  const setAuth = (token, userData) => {
    accessToken.value = token
    user.value = userData
    localStorage.setItem('access_token', token)
    localStorage.setItem('user', JSON.stringify(userData))
    axios.defaults.headers.common['Authorization'] = `Bearer ${token}`
  }

  // 清除认证信息
  const clearAuth = () => {
    accessToken.value = null
    user.value = null
    localStorage.removeItem('access_token')
    localStorage.removeItem('user')
    delete axios.defaults.headers.common['Authorization']
  }

  // 检查token是否有效（简单检查）
  const checkTokenValid = () => {
    if (!accessToken.value) return false
    // 这里可以添加更复杂的token验证逻辑
    return true
  }

  // 刷新token（需要后端支持refresh token机制）
  const refreshToken = async () => {
    try {
      // 这里需要后端提供refresh token接口
      const response = await axios.post('http://localhost:8000/refresh', {
        refresh_token: localStorage.getItem('refresh_token')
      })
      
      const { token, token_type } = response.data
      setAuth(token, user.value)
      return true
    } catch (error) {
      console.error('Token刷新失败:', error)
      clearAuth()
      return false
    }
  }

  // 登出
  const logout = () => {
    clearAuth()
    router.push('/login')
  }

  return {
    accessToken,
    user,
    isAuthenticated,
    isHeadquarters,
    isFactory,
    boundFactory,
    setAuth,
    clearAuth,
    checkTokenValid,
    refreshToken,
    logout
  }
})