// 认证功能测试脚本
import { useAuthStore } from '@/stores/authStore'
import apiClient from './axios'

// 测试认证功能
export const testAuth = async () => {
  const authStore = useAuthStore()
  
  console.log('=== 认证功能测试 ===')
  
  // 1. 检查初始状态
  console.log('初始认证状态:', authStore.isAuthenticated)
  console.log('当前用户:', authStore.user)
  console.log('当前token:', authStore.accessToken)
  
  // 2. 测试设置认证信息
  const testUser = { username: 'testuser', id: 1 }
  const testToken = 'test-token-123456'
  
  authStore.setAuth(testToken, testUser)
  console.log('设置认证信息后:')
  console.log('认证状态:', authStore.isAuthenticated)
  console.log('用户:', authStore.user)
  console.log('token:', authStore.accessToken)
  
  // 3. 测试清除认证信息
  authStore.clearAuth()
  console.log('清除认证信息后:')
  console.log('认证状态:', authStore.isAuthenticated)
  console.log('用户:', authStore.user)
  console.log('token:', authStore.accessToken)
  
  // 4. 测试登出功能
  authStore.setAuth(testToken, testUser)
  console.log('登出前认证状态:', authStore.isAuthenticated)
  authStore.logout()
  console.log('登出后认证状态:', authStore.isAuthenticated)
  
  console.log('=== 认证功能测试完成 ===')
}

// 运行测试
if (typeof window !== 'undefined') {
  window.testAuth = testAuth
}