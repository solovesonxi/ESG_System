<template>
  <div class="review-management">
    <!-- 页面标题 -->
    <div class="page-header">
      <div class="user-info">
        <span class="username">{{ authStore.user?.username }}</span>
        <span class="role-badge" :class="authStore.user?.role">
          {{ getRoleLabel(authStore.user?.role) }}
        </span>
        <button class="permission-toggle-btn" @click="showPermissionDetails = !showPermissionDetails" :class="{ 'active': showPermissionDetails }">
          {{ showPermissionDetails ? '隐藏权限' : '查看权限' }}
        </button>
      </div>
    </div>
    <div v-show="showPermissionDetails" class="permission-card">
      <div class="permission-details">
        <h4>系统角色权限说明</h4>
        <div class="roles-grid">
          <!-- 部门账号 -->
          <div class="role-card" :class="{ 'current-user': authStore.isDepartment }">
            <div class="role-card-header">
              <span class="role-badge department">部门账号</span>
              <span v-if="authStore.isDepartment" class="current-label">您当前角色</span>
            </div>
            <div class="role-permissions">
              <div class="permission-item">
                查看自己部门的定量数据
              </div>
              <div class="permission-item">
                查看自己部门的一二级审核结果
              </div>
              <div class="permission-item">
                填写自己部门的数据
              </div>
            </div>
          </div>

          <!-- 工厂账号 -->
          <div class="role-card" :class="{ 'current-user': authStore.isFactory }">
            <div class="role-card-header">
              <span class="role-badge factory">工厂账号</span>
              <span v-if="authStore.isFactory" class="current-label">您当前角色</span>
            </div>
            <div class="role-permissions">
              <div class="permission-item">
                查看所有部门的定量数据月报
              </div>
              <div class="permission-item">
                编辑所有部门的一级审核结果
              </div>
            </div>
          </div>

          <!-- 总部账号 -->
          <div class="role-card" :class="{ 'current-user': authStore.isHeadquarter }">
            <div class="role-card-header">
              <span class="role-badge headquarter">总部账号</span>
              <span v-if="authStore.isHeadquarter" class="current-label">您当前角色</span>
            </div>
            <div class="role-permissions">
              <div class="permission-item">
                查看所有定量和年度数据
              </div>
              <div class="permission-item">
                查看一级审核结果
              </div>
              <div class="permission-item">
                编辑二级审核结果
              </div>
              <div class="permission-item">
                最终审核确认
              </div>
            </div>
          </div>

          <!-- 管理员账号 -->
          <div class="role-card" :class="{ 'current-user': authStore.isAdmin }">
            <div class="role-card-header">
              <span class="role-badge admin">管理员</span>
              <span v-if="authStore.isAdmin" class="current-label">您当前角色</span>
            </div>
            <div class="role-permissions">
              <div class="permission-item">
                访问所有功能模块
              </div>
              <div class="permission-item">
                账号管理和权限分配
              </div>
              <div class="permission-item">
                指标库管理
              </div>
              <div class="permission-item">
                系统维护和配置
              </div>
            </div>
          </div>

          <div class="current-user-notice">
            <div class="notice-icon">
              <i class="fas fa-info-circle"></i>
            </div>
            <div class="notice-content">
              <strong>您当前的操作权限：</strong>
              <div class="user-permissions">
              <span v-if="authStore.isDepartment" class="permission-tag">
                限部门数据: {{ authStore.departments.join('、') }}
              </span>
                <span v-if="authStore.isFactory" class="permission-tag">
                本工厂: {{ authStore.factory }}
              </span>
                <span v-if="authStore.isHeadquarter" class="permission-tag">
                全公司数据访问
              </span>
                <span v-if="authStore.isAdmin" class="permission-tag">
                超级管理员
              </span>
              </div>
            </div>
          </div>
        </div>

        <!-- 当前用户的具体权限提醒 -->

      </div>
    </div>

    <!-- 快速统计 -->
    <div class="stats-section">
      <div class="stat-card" v-if="authStore.isFactory">
        <div class="stat-number">{{ pendingLevel1Reviews }}</div>
        <div class="stat-label">待一级审核</div>
      </div>
      <div class="stat-card" v-if="authStore.isHeadquarter">
        <div class="stat-number">{{ pendingLevel2Reviews }}</div>
        <div class="stat-label">待二级审核</div>
      </div>
      <div class="stat-card">
        <div class="stat-number">{{ completedReviews }}</div>
        <div class="stat-label">已完成审核</div>
      </div>
    </div>

    <!-- 审核任务提醒 -->
    <div v-if="hasUrgentTasks" class="urgent-tasks-banner">
      <i class="fas fa-exclamation-triangle"></i>
      <span>您有 {{ urgentTasksCount }} 个紧急审核任务待处理</span>
      <button @click="showUrgentTasks = true" class="view-btn">查看详情</button>
    </div>

    <!-- 数据类型选择 -->
    <div class="data-type-selector">
      <h3>选择要查看的数据类型</h3>
      <div class="type-grid">
        <div
            v-for="type in availableDataTypes"
            :key="type.key"
            class="type-card"
            :class="{ 'active': selectedDataType === type.key }"
            @click="selectDataType(type.key)"
        >
          <i :class="type.icon"></i>
          <span>{{ type.label }}</span>
          <div v-if="getTypeStats(type.key)" class="type-stats">
            <small>{{ getTypeStats(type.key) }}</small>
          </div>
        </div>
      </div>
    </div>

    <!-- 审核详情页面 -->
    <div v-if="selectedDataType" class="review-details">
      <div class="details-header">
        <h3>{{ getDataTypeLabel(selectedDataType) }} - 审核状态</h3>
        <div class="time-selector">
          <select v-model="selectedYear" @change="loadReviewData">
            <option v-for="year in years" :key="year" :value="year">
              {{ year }}年
            </option>
          </select>
          <select v-if="isMonthlyData" v-model="selectedMonth" @change="loadReviewData">
            <option value="">全年</option>
            <option v-for="month in 12" :key="month" :value="month">
              {{ month }}月
            </option>
          </select>
        </div>
      </div>

      <!-- 月度数据审核表格 -->
      <div v-if="isMonthlyData" class="monthly-review-table">
        <table>
          <thead>
          <tr>
            <th>月份</th>
            <th>提交状态</th>
            <th v-if="authStore.canViewLevel1Results">一级审核</th>
            <th v-if="authStore.canViewLevel2Results">二级审核</th>
            <th v-if="canEdit">操作</th>
          </tr>
          </thead>
          <tbody>
          <tr v-for="month in 12" :key="month">
            <td>{{ month }}月</td>
            <td>
                <span class="status-badge" :class="getSubmitStatus(month)">
                  {{ getSubmitStatusLabel(month) }}
                </span>
            </td>
            <td v-if="authStore.canViewLevel1Results">
              <div class="review-cell">
                  <span class="status-badge" :class="getLevel1Status(month)">
                    {{ getLevel1StatusLabel(month) }}
                  </span>
                <div v-if="canEditLevel1" class="edit-controls">
                  <select
                      :value="getLevel1StatusValue(month)"
                      @change="updateLevel1Status(month, $event.target.value)"
                  >
                    <option value="pending">待审核</option>
                    <option value="approved">通过</option>
                    <option value="rejected">不通过</option>
                  </select>
                </div>
              </div>
            </td>
            <td v-if="authStore.canViewLevel2Results">
              <div class="review-cell">
                  <span class="status-badge" :class="getLevel2Status(month)">
                    {{ getLevel2StatusLabel(month) }}
                  </span>
                <div v-if="canEditLevel2" class="edit-controls">
                  <select
                      :value="getLevel2StatusValue(month)"
                      @change="updateLevel2Status(month, $event.target.value)"
                  >
                    <option value="pending">待审核</option>
                    <option value="approved">通过</option>
                    <option value="rejected">不通过</option>
                  </select>
                </div>
              </div>
            </td>
            <td v-if="canEdit">
              <button
                  class="comment-btn"
                  @click="showCommentModal(month)"
                  :disabled="!hasComments(month)"
              >
                查看评论
              </button>
            </td>
          </tr>
          </tbody>
        </table>
      </div>

      <!-- 年度数据审核 -->
      <div v-else class="yearly-review">
        <div class="review-item">
          <h4>{{ getDataTypeLabel(selectedDataType) }}</h4>
          <div class="review-status">
            <div v-if="authStore.canViewLevel1Results" class="status-group">
              <label>一级审核:</label>
              <span class="status-badge" :class="yearlyLevel1Status">
                {{ getStatusLabel(yearlyLevel1Status) }}
              </span>
              <select
                  v-if="canEditLevel1"
                  :value="yearlyLevel1Status"
                  @change="updateYearlyLevel1Status($event.target.value)"
              >
                <option value="pending">待审核</option>
                <option value="approved">通过</option>
                <option value="rejected">不通过</option>
              </select>
            </div>
            <div v-if="authStore.canViewLevel2Results" class="status-group">
              <label>二级审核:</label>
              <span class="status-badge" :class="yearlyLevel2Status">
                {{ getStatusLabel(yearlyLevel2Status) }}
              </span>
              <select
                  v-if="canEditLevel2"
                  :value="yearlyLevel2Status"
                  @change="updateYearlyLevel2Status($event.target.value)"
              >
                <option value="pending">待审核</option>
                <option value="approved">通过</option>
                <option value="rejected">不通过</option>
              </select>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 评论弹窗 -->
    <div v-if="showCommentDialog" class="modal-overlay" @click="closeCommentModal">
      <div class="modal-container" @click.stop>
        <div class="modal-header">
          <h3>审核评论</h3>
          <button class="close-btn" @click="closeCommentModal">×</button>
        </div>
        <div class="modal-content">
          <div class="comment-section">
            <h4>一级审核评论</h4>
            <p>{{ currentComments.level1 || '暂无评论' }}</p>
          </div>
          <div class="comment-section">
            <h4>二级审核评论</h4>
            <p>{{ currentComments.level2 || '暂无评论' }}</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import {computed, onMounted, ref} from 'vue'
import {useAuthStore} from '@/stores/authStore'
import apiClient from '@/utils/axios'

const authStore = useAuthStore()

// 响应式数据
const selectedDataType = ref('')
const selectedYear = ref(2024)
const selectedMonth = ref('')
const showCommentDialog = ref(false)
const currentComments = ref({level1: '', level2: ''})
const reviewData = ref({})
const showUrgentTasks = ref(false)
const showPermissionDetails = ref(false)

// 统计数据
const pendingLevel1Reviews = ref(0)
const pendingLevel2Reviews = ref(0)
const completedReviews = ref(0)

// 可用数据类型
const availableDataTypes = computed(() => {
  const types = []

  if (authStore.isDepartment) {
    // 部门账号只能看自己部门的数据
    authStore.departments.forEach(dept => {
      types.push({
        key: dept,
        label: getDataTypeLabel(dept),
        icon: getDataTypeIcon(dept)
      })
    })
  } else if (authStore.isFactory || authStore.isHeadquarter || authStore.isAdmin) {
    // 工厂、总部、管理员可以看所有数据
    const allTypes = [
      'material', 'energy', 'water', 'waste', 'emission', 'investment', 'management',
      'employment', 'training', 'ohs', 'satisfaction', 'supply', 'responsibility', 'ip', 'community'
    ]
    allTypes.forEach(type => {
      types.push({
        key: type,
        label: getDataTypeLabel(type),
        icon: getDataTypeIcon(type)
      })
    })
  }

  return types
})

// 计算属性
const isMonthlyData = computed(() => {
  const monthlyTypes = ['material', 'energy', 'water', 'waste', 'emission', 'investment', 'management',
    'employment', 'training', 'ohs', 'satisfaction', 'supply', 'responsibility', 'ip', 'community']
  return monthlyTypes.includes(selectedDataType.value)
})

const canEdit = computed(() => {
  return authStore.canLevel1Review || authStore.canLevel2Review
})

const canEditLevel1 = computed(() => {
  return authStore.canLevel1Review
})

const canEditLevel2 = computed(() => {
  return authStore.canLevel2Review
})

const hasUrgentTasks = computed(() => {
  return urgentTasksCount.value > 0
})

const urgentTasksCount = computed(() => {
  return pendingLevel1Reviews.value + pendingLevel2Reviews.value
})

const years = ref([2022, 2023, 2024, 2025])

const yearlyLevel1Status = ref('pending')
const yearlyLevel2Status = ref('pending')

// 方法
const getRoleLabel = (role) => {
  const labels = {
    'department': '部门账号',
    'factory': '工厂账号',
    'headquarter': '总部账号',
    'admin': '管理员'
  }
  return labels[role] || role
}

const getDataTypeLabel = (type) => {
  const labels = {
    'material': '物料消耗',
    'energy': '能源消耗',
    'water': '水资源',
    'waste': '废料管理',
    'emission': '排放数据',
    'investment': '环境投资',
    'management': '环境管理',
    'employment': '雇佣数据',
    'training': '培训数据',
    'ohs': '职业健康安全',
    'satisfaction': '员工满意度',
    'supply': '供应链',
    'responsibility': '产品责任',
    'ip': '知识产权',
    'community': '社区参与'
  }
  return labels[type] || type
}

const getDataTypeIcon = (type) => {
  const icons = {
    'material': 'fas fa-boxes',
    'energy': 'fas fa-bolt',
    'water': 'fas fa-tint',
    'waste': 'fas fa-trash',
    'emission': 'fas fa-smog',
    'investment': 'fas fa-coins',
    'management': 'fas fa-cogs',
    'employment': 'fas fa-users',
    'training': 'fas fa-graduation-cap',
    'ohs': 'fas fa-shield-alt',
    'satisfaction': 'fas fa-smile',
    'supply': 'fas fa-truck',
    'responsibility': 'fas fa-handshake',
    'ip': 'fas fa-copyright',
    'community': 'fas fa-heart'
  }
  return icons[type] || 'fas fa-file'
}

const selectDataType = (type) => {
  selectedDataType.value = type
  loadReviewData()
}

const loadReviewData = async () => {
  // 这里调用后端API获取审核数据
  try {
    const response = await apiClient.get('/api/review/data', {
      params: {
        dataType: selectedDataType.value,
        year: selectedYear.value,
        month: selectedMonth.value
      }
    })
    reviewData.value = response.data
  } catch (error) {
    console.error('获取审核数据失败:', error)
  }
}

const getSubmitStatus = (month) => {
  // 根据实际数据返回提交状态样式类
  return 'submitted'
}

const getSubmitStatusLabel = (month) => {
  return '已提交'
}

const getLevel1Status = (month) => {
  return 'pending'
}

const getLevel1StatusLabel = (month) => {
  return '待审核'
}

const getLevel1StatusValue = (month) => {
  return 'pending'
}

const getLevel2Status = (month) => {
  return 'pending'
}

const getLevel2StatusLabel = (month) => {
  return '待审核'
}

const getLevel2StatusValue = (month) => {
  return 'pending'
}

const getStatusLabel = (status) => {
  const labels = {
    'pending': '待审核',
    'approved': '通过',
    'rejected': '不通过'
  }
  return labels[status] || status
}

const updateLevel1Status = async (month, status) => {
  // 调用API更新一级审核状态
  try {
    await apiClient.patch('/api/review/level1', {
      dataType: selectedDataType.value,
      year: selectedYear.value,
      month: month,
      status: status
    })
    loadReviewData()
  } catch (error) {
    console.error('更新一级审核状态失败:', error)
  }
}

const updateLevel2Status = async (month, status) => {
  // 调用API更新二级审核状态
  try {
    await apiClient.patch('/api/review/level2', {
      dataType: selectedDataType.value,
      year: selectedYear.value,
      month: month,
      status: status
    })
    loadReviewData()
  } catch (error) {
    console.error('更新二级审核状态失败:', error)
  }
}

const updateYearlyLevel1Status = async (status) => {
  yearlyLevel1Status.value = status
  // 调用API更新年度数据一级审核状态
}

const updateYearlyLevel2Status = async (status) => {
  yearlyLevel2Status.value = status
  // 调用API更新年度数据二级审核状态
}

const showCommentModal = (month) => {
  // 显示评论弹窗
  currentComments.value = {
    level1: `${month}月一级审核评论内容`,
    level2: `${month}月二级审核评论内容`
  }
  showCommentDialog.value = true
}

const closeCommentModal = () => {
  showCommentDialog.value = false
}

const hasComments = (month) => {
  return true // 根据实际数据判断
}

const getTypeStats = (type) => {
  return '12/12已审核' // 根据实际数据返回统计信息
}

/* 添加点击事件处理程序 */
const handleIconClick = (action) => {
  switch (action) {
    case 'viewDepartmentData':
      console.log('查看自己部门的定量数据');
      // 在这里添加实际的逻辑，例如导航到某个页面或显示弹窗
      break;
    case 'viewAuditResults':
      console.log('查看自己部门的一二级审核结果');
      break;
    case 'editDepartmentData':
      console.log('填写自己部门的数据');
      break;
    case 'viewAllDepartmentsData':
      console.log('查看所有部门的定量数据月报');
      break;
    case 'editAllDepartmentsAudit':
      console.log('编辑所有部门的一级审核结果');
      break;
    default:
      console.log('未定义的操作');
  }
};

// 生命周期
onMounted(() => {
  // 加载统计数据
  loadStatistics()
})

const loadStatistics = async () => {
  try {
    const response = await apiClient.get('/api/review/statistics')
    const stats = response.data
    pendingLevel1Reviews.value = stats.pendingLevel1 || 0
    pendingLevel2Reviews.value = stats.pendingLevel2 || 0
    completedReviews.value = stats.completed || 0
  } catch (error) {
    console.error('加载统计数据失败:', error)
  }
}
</script>

<style scoped>
/* ===== 默认主题 (浅色模式) ===== */
.review-management {
  padding: 2rem;
  min-height: 100vh;
  background: linear-gradient(135deg, #e3f2fd 0%, #f3e5f5 25%, #fce4ec 50%, #fff3e0 75%, #f1f8e9 100%);
  background-attachment: fixed;
  transition: all 0.3s ease;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 2rem;
  padding: 1.5rem;
  background: rgba(255, 255, 255, 0.9);
  border-radius: 16px;
  backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.3);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
}

.page-header h1 {
  color: #2c3e50;
  margin: 0;
  font-size: 2rem;
  font-weight: 700;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.role-badge {
  padding: 0.5rem 1rem;
  border-radius: 25px;
  font-size: 0.875rem;
  font-weight: 600;
  color: white;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
}

.role-badge.department {
  background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
}

.role-badge.factory {
  background: linear-gradient(135deg, #007bff 0%, #6610f2 100%);
}

.role-badge.headquarter {
  background: linear-gradient(135deg, #6f42c1 0%, #e83e8c 100%);
}

.role-badge.admin {
  background: linear-gradient(135deg, #dc3545 0%, #fd7e14 100%);
}

.username {
  color: #495057;
  font-weight: 600;
}

.permission-card {
  background: rgba(255, 255, 255, 0.9);
  border-radius: 16px;
  padding: 1.5rem;
  margin-bottom: 2rem;
  backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.3);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
}

.permission-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1rem;
}

.current-role-info {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.role-indicator {
  color: #6c757d;
  font-size: 0.875rem;
  font-weight: 500;
}

.role-badge.current {
  position: relative;
  animation: pulse 2s infinite;
}

.permission-toggle-btn {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border: none;
  color: white;
  font-size: 0.75rem; /* 调整字体大小 */
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.3rem 0.8rem;
  border-radius: 12px; /* 调整圆角 */
  transition: all 0.3s ease;
  font-weight: 500;
  width: auto;
  justify-self: left;
}

.permission-toggle-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 15px rgba(103, 126, 234, 0.3);
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.permission-toggle-btn.active {
  background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
}

.permission-details {
  margin-top: 1rem;
  padding-top: 1rem;
  border-top: 1px solid rgba(0, 0, 0, 0.1);
  animation: slideDown 0.3s ease-out;
}

.permission-details h4 {
  color: #2c3e50;
  margin: 0 0 1rem 0;
  font-weight: 700;
  font-size: 1.1rem;
}

.roles-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 1rem;
  margin-bottom: 1.5rem;
}

.role-card {
  background: rgba(255, 255, 255, 0.8);
  border: 2px solid rgba(103, 126, 234, 0.2);
  border-radius: 12px;
  padding: 1rem;
  transition: all 0.3s ease;
  backdrop-filter: blur(10px);
}

.role-card:hover {
  background: rgba(255, 255, 255, 0.95);
  border-color: rgba(103, 126, 234, 0.4);
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(103, 126, 234, 0.2);
}

.role-card.current-user {
  border-color: #e94560;
  background: linear-gradient(135deg, rgba(233, 69, 96, 0.1) 0%, rgba(255, 255, 255, 0.9) 100%);
  box-shadow: 0 0 20px rgba(233, 69, 96, 0.3);
  animation: glow 2s ease-in-out infinite alternate;
}

.role-card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 0.75rem;
}

.current-label {
  background: linear-gradient(135deg, #e94560 0%, #ff6b9d 100%);
  color: white;
  padding: 0.2rem 0.6rem;
  border-radius: 12px;
  font-size: 0.7rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  animation: bounce 2s infinite;
}

.role-permissions {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.role-permissions .permission-item {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  color: #495057;
  padding: 0.5rem;
  border-radius: 8px;
  background: rgba(103, 126, 234, 0.05);
  border: 1px solid rgba(103, 126, 234, 0.1);
  font-size: 0.875rem;
}

.role-permissions .permission-item i {
  color: #28a745;
  width: 16px;
  font-size: 0.875rem;
  position: relative;
}

.role-permissions .permission-item i::after {
  content: attr(data-tooltip); /* 使用data-tooltip属性作为说明文字 */
  position: absolute;
  top: 50%;
  left: 100%;
  transform: translateY(-50%);
  background: rgba(0, 0, 0, 0.8);
  color: white;
  padding: 0.2rem 0.5rem;
  border-radius: 4px;
  font-size: 0.7rem;
  white-space: nowrap;
  opacity: 0;
  pointer-events: none;
  transition: opacity 0.2s ease;
}

.role-permissions .permission-item i:hover::after {
  opacity: 1;
  pointer-events: auto;
}

.current-user-notice {
  background: linear-gradient(135deg, rgba(233, 69, 96, 0.1) 0%, rgba(103, 126, 234, 0.1) 100%);
  border: 2px solid rgba(233, 69, 96, 0.3);
  border-radius: 12px;
  padding: 1rem;
  display: flex;
  align-items: flex-start;
  gap: 1rem;
  animation: fadeIn 0.5s ease-out;
}

.notice-icon {
  background: linear-gradient(135deg, #e94560 0%, #ff6b9d 100%);
  color: white;
  width: 40px;
  height: 40px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.2rem;
  flex-shrink: 0;
}

.notice-content {
  flex: 1;
}

.notice-content strong {
  color: #2c3e50;
  display: block;
  margin-bottom: 0.5rem;
  font-size: 0.95rem;
}

.user-permissions {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
}

.permission-tag {
  background: linear-gradient(135deg, #e94560 0%, #ff6b9d 100%);
  color: white;
  padding: 0.3rem 0.8rem;
  border-radius: 15px;
  font-size: 1.5rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  box-shadow: 0 2px 10px rgba(233, 69, 96, 0.3);
}

.stats-section {
  display: flex;
  gap: 1.5rem;
  margin-bottom: 2rem;
}

.stat-card {
  flex: 1;
  background: rgba(255, 255, 255, 0.9);
  border-radius: 16px;
  padding: 1.5rem;
  text-align: center;
  backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.3);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
  transition: all 0.3s ease;
}

.stat-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 12px 40px rgba(0, 0, 0, 0.15);
}

.stat-number {
  font-size: 2.5rem;
  font-weight: 700;
  color: #667eea;
  margin-bottom: 0.5rem;
}

.stat-label {
  color: #6c757d;
  font-size: 0.875rem;
  font-weight: 500;
}

.urgent-tasks-banner {
  background: linear-gradient(135deg, rgba(255, 193, 7, 0.1) 0%, rgba(255, 152, 0, 0.1) 100%);
  border: 1px solid rgba(255, 193, 7, 0.3);
  border-radius: 12px;
  padding: 1rem 1.5rem;
  margin-bottom: 2rem;
  display: flex;
  align-items: center;
  gap: 1rem;
  color: #856404;
}

.urgent-tasks-banner i {
  font-size: 1.5rem;
  color: #ff9800;
}

.view-btn {
  background: linear-gradient(135deg, #ffc107 0%, #ff9800 100%);
  color: white;
  border: none;
  padding: 0.5rem 1rem;
  border-radius: 8px;
  cursor: pointer;
  margin-left: auto;
  font-weight: 600;
  box-shadow: 0 4px 15px rgba(255, 193, 7, 0.3);
  transition: all 0.3s ease;
}

.view-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(255, 193, 7, 0.4);
}

.data-type-selector {
  background: rgba(255, 255, 255, 0.9);
  border-radius: 16px;
  padding: 1.5rem;
  margin-bottom: 2rem;
  backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.3);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
}

.data-type-selector h3 {
  color: #2c3e50;
  margin: 0 0 1rem 0;
  font-weight: 700;
}

.type-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
  gap: 1rem;
}

.type-card {
  background: rgba(255, 255, 255, 0.8);
  border: 2px solid rgba(103, 126, 234, 0.2);
  border-radius: 12px;
  padding: 1rem;
  text-align: center;
  cursor: pointer;
  transition: all 0.3s ease;
  backdrop-filter: blur(10px);
}

.type-card:hover {
  background: rgba(255, 255, 255, 0.95);
  border-color: rgba(103, 126, 234, 0.4);
  transform: translateY(-4px);
  box-shadow: 0 8px 25px rgba(103, 126, 234, 0.2);
}

.type-card.active {
  background: linear-gradient(135deg, rgba(103, 126, 234, 0.1) 0%, rgba(118, 75, 162, 0.1) 100%);
  border-color: #667eea;
  box-shadow: 0 0 30px rgba(103, 126, 234, 0.3);
}

.type-card i {
  font-size: 2rem;
  color: #667eea;
  margin-bottom: 0.5rem;
}

.type-card span {
  display: block;
  color: #2c3e50;
  font-weight: 600;
  margin-bottom: 0.5rem;
}

.type-stats {
  color: #6c757d;
  font-size: 0.75rem;
  font-weight: 500;
}

.review-details {
  background: rgba(255, 255, 255, 0.9);
  border-radius: 16px;
  padding: 1.5rem;
  backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.3);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
}

.details-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1.5rem;
}

.details-header h3 {
  color: #2c3e50;
  margin: 0;
  font-weight: 700;
}

.time-selector {
  display: flex;
  gap: 1rem;
}

.time-selector select {
  padding: 0.5rem 1rem;
  border: 2px solid rgba(103, 126, 234, 0.2);
  border-radius: 8px;
  background: rgba(255, 255, 255, 0.9);
  color: #495057;
  font-weight: 500;
  outline: none;
  transition: all 0.3s ease;
}

.time-selector select:focus {
  border-color: #667eea;
  box-shadow: 0 0 0 3px rgba(103, 126, 234, 0.1);
}

.monthly-review-table {
  overflow-x: auto;
  border-radius: 12px;
}

.monthly-review-table table {
  width: 100%;
  border-collapse: collapse;
  background: rgba(255, 255, 255, 0.95);
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
}

.monthly-review-table th {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  padding: 1rem;
  text-align: left;
  font-weight: 600;
  font-size: 0.9rem;
}

.monthly-review-table td {
  padding: 1rem;
  border-bottom: 1px solid rgba(0, 0, 0, 0.05);
  color: #495057;
  background: rgba(255, 255, 255, 0.9);
}

.monthly-review-table tr:hover td {
  background: rgba(103, 126, 234, 0.05);
}

.status-badge {
  padding: 0.3rem 0.8rem;
  border-radius: 15px;
  font-size: 0.75rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.status-badge.submitted {
  background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
  color: white;
}

.status-badge.pending {
  background: linear-gradient(135deg, #ffc107 0%, #ff9800 100%);
  color: white;
}

.status-badge.approved {
  background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
  color: white;
}

.status-badge.rejected {
  background: linear-gradient(135deg, #dc3545 0%, #e91e63 100%);
  color: white;
}

.review-cell {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.edit-controls select {
  padding: 0.4rem 0.6rem;
  border: 2px solid rgba(103, 126, 234, 0.2);
  border-radius: 6px;
  background: rgba(255, 255, 255, 0.9);
  color: #495057;
  font-size: 0.875rem;
  font-weight: 500;
  outline: none;
  transition: all 0.3s ease;
}

.edit-controls select:focus {
  border-color: #667eea;
  box-shadow: 0 0 0 2px rgba(103, 126, 234, 0.1);
}

.comment-btn {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border: none;
  padding: 0.5rem 1rem;
  border-radius: 8px;
  cursor: pointer;
  font-size: 0.875rem;
  font-weight: 600;
  transition: all 0.3s ease;
}

.comment-btn:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 4px 15px rgba(103, 126, 234, 0.3);
}

.comment-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
  transform: none;
}

.yearly-review {
  background: rgba(255, 255, 255, 0.8);
  border-radius: 12px;
  padding: 1.5rem;
  border: 1px solid rgba(0, 0, 0, 0.05);
}

.review-item h4 {
  color: #2c3e50;
  margin: 0 0 1rem 0;
  font-weight: 700;
}

.review-status {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.status-group {
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 0.75rem;
  background: rgba(103, 126, 234, 0.05);
  border-radius: 8px;
}

.status-group label {
  color: #495057;
  font-weight: 600;
  min-width: 100px;
}

.status-group select {
  padding: 0.5rem 1rem;
  border: 2px solid rgba(103, 126, 234, 0.2);
  border-radius: 8px;
  background: rgba(255, 255, 255, 0.9);
  color: #495057;
  font-weight: 500;
  outline: none;
  transition: all 0.3s ease;
}

.status-group select:focus {
  border-color: #667eea;
  box-shadow: 0 0 0 3px rgba(103, 126, 234, 0.1);
}

.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.6);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
  backdrop-filter: blur(10px);
}

.modal-container {
  background: white;
  border-radius: 16px;
  width: 90%;
  max-width: 600px;
  max-height: 80vh;
  overflow: hidden;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
}

.modal-header {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  padding: 1.5rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.modal-header h3 {
  margin: 0;
  font-weight: 700;
}

.close-btn {
  background: none;
  border: none;
  color: white;
  font-size: 1.5rem;
  cursor: pointer;
  width: 35px;
  height: 35px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s ease;
}

.close-btn:hover {
  background: rgba(255, 255, 255, 0.2);
  transform: rotate(90deg);
}

.modal-content {
  padding: 1.5rem;
  max-height: 60vh;
  overflow-y: auto;
}

.comment-section {
  margin-bottom: 1.5rem;
}

.comment-section:last-child {
  margin-bottom: 0;
}

.comment-section h4 {
  color: #2c3e50;
  margin: 0 0 0.5rem 0;
  font-size: 1rem;
  font-weight: 700;
}

.comment-section p {
  background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
  padding: 1rem;
  border-radius: 10px;
  margin: 0;
  color: #495057;
  line-height: 1.6;
  border: 1px solid rgba(0, 0, 0, 0.05);
}

/* 深色模式下的权限展示样式 */
.dark-theme .permission-details h4 {
  color: #e2e8f0;
}

.dark-theme .role-indicator {
  color: #a0aec0;
}

.dark-theme .permission-toggle-btn {
  background: linear-gradient(135deg, #e94560 0%, #533483 100%);
}

.dark-theme .permission-toggle-btn.active {
  background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
}

.dark-theme .permission-details {
  border-top: 1px solid rgba(255, 255, 255, 0.1);
}

.dark-theme .role-card {
  background: rgba(30, 30, 50, 0.8);
  border: 2px solid rgba(233, 69, 96, 0.3);
}

.dark-theme .role-card:hover {
  background: rgba(30, 30, 50, 0.95);
  border-color: rgba(233, 69, 96, 0.5);
}

.dark-theme .role-card.current-user {
  border-color: #e94560;
  background: linear-gradient(135deg, rgba(233, 69, 96, 0.2) 0%, rgba(30, 30, 50, 0.9) 100%);
  box-shadow: 0 0 20px rgba(233, 69, 96, 0.4);
}

.dark-theme .role-permissions .permission-item {
  color: #cbd5e0;
  background: rgba(233, 69, 96, 0.1);
  border: 1px solid rgba(233, 69, 96, 0.2);
}

.dark-theme .role-permissions .permission-item i {
  color: #e94560;
}

.dark-theme .current-user-notice {
  background: linear-gradient(135deg, rgba(233, 69, 96, 0.2) 0%, rgba(83, 52, 131, 0.2) 100%);
  border: 2px solid rgba(233, 69, 96, 0.4);
}

.dark-theme .notice-content strong {
  color: #e2e8f0;
}

/* ===== 深色模式 ===== */
.dark-theme .review-management {
  background: linear-gradient(135deg, #1a1a2e 0%, #16213e 25%, #0f3460 50%, #533483 75%, #e94560 100%);
  background-attachment: fixed;
}

.dark-theme .page-header {
  background: rgba(30, 30, 50, 0.9);
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.dark-theme .page-header h1 {
  background: linear-gradient(135deg, #e94560 0%, #533483 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.dark-theme .username {
  color: #e2e8f0;
}

.dark-theme .permission-card,
.dark-theme .data-type-selector,
.dark-theme .review-details {
  background: rgba(30, 30, 50, 0.9);
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.dark-theme .permission-card h3,
.dark-theme .data-type-selector h3,
.dark-theme .details-header h3 {
  color: #e2e8f0;
}

.dark-theme .stat-card {
  background: rgba(30, 30, 50, 0.9);
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.dark-theme .stat-number {
  color: #e94560;
}

.dark-theme .stat-label {
  color: #a0aec0;
}

.dark-theme .urgent-tasks-banner {
  background: linear-gradient(135deg, rgba(233, 69, 96, 0.2) 0%, rgba(255, 152, 0, 0.2) 100%);
  border: 1px solid rgba(233, 69, 96, 0.4);
  color: #fbb6ce;
}

.dark-theme .urgent-tasks-banner i {
  color: #e94560;
}

.dark-theme .view-btn {
  background: linear-gradient(135deg, #e94560 0%, #ff6b9d 100%);
}

.dark-theme .type-card {
  background: rgba(30, 30, 50, 0.8);
  border: 2px solid rgba(233, 69, 96, 0.3);
}

.dark-theme .type-card:hover {
  background: rgba(30, 30, 50, 0.95);
  border-color: rgba(233, 69, 96, 0.5);
}

.dark-theme .type-card.active {
  background: linear-gradient(135deg, rgba(233, 69, 96, 0.2) 0%, rgba(83, 52, 131, 0.2) 100%);
  border-color: #e94560;
  box-shadow: 0 0 30px rgba(233, 69, 96, 0.4);
}

.dark-theme .type-card i {
  color: #e94560;
}

.dark-theme .type-card span {
  color: #e2e8f0;
}

.dark-theme .type-stats {
  color: #a0aec0;
}

.dark-theme .time-selector select {
  background: rgba(30, 30, 50, 0.9);
  border: 2px solid rgba(233, 69, 96, 0.3);
  color: #e2e8f0;
}

.dark-theme .time-selector select:focus {
  border-color: #e94560;
  box-shadow: 0 0 0 3px rgba(233, 69, 96, 0.2);
}

.dark-theme .monthly-review-table table {
  background: rgba(30, 30, 50, 0.95);
}

.dark-theme .monthly-review-table th {
  background: linear-gradient(135deg, #e94560 0%, #533483 100%);
}

.dark-theme .monthly-review-table td {
  background: rgba(30, 30, 50, 0.9);
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  color: #e2e8f0;
}

.dark-theme .monthly-review-table tr:hover td {
  background: rgba(233, 69, 96, 0.1);
}

.dark-theme .edit-controls select {
  background: rgba(30, 30, 50, 0.9);
  border: 2px solid rgba(233, 69, 96, 0.3);
  color: #e2e8f0;
}

.dark-theme .edit-controls select:focus {
  border-color: #e94560;
  box-shadow: 0 0 0 2px rgba(233, 69, 96, 0.2);
}

.dark-theme .comment-btn {
  background: linear-gradient(135deg, #e94560 0%, #533483 100%);
}

.dark-theme .comment-btn:hover:not(:disabled) {
  box-shadow: 0 4px 15px rgba(233, 69, 96, 0.4);
}

.dark-theme .yearly-review {
  background: rgba(30, 30, 50, 0.8);
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.dark-theme .review-item h4 {
  color: #e2e8f0;
}

.dark-theme .status-group {
  background: rgba(233, 69, 96, 0.1);
}

.dark-theme .status-group label {
  color: #e2e8f0;
}

.dark-theme .status-group select {
  background: rgba(30, 30, 50, 0.9);
  border: 2px solid rgba(233, 69, 96, 0.3);
  color: #e2e8f0;
}

.dark-theme .status-group select:focus {
  border-color: #e94560;
  box-shadow: 0 0 0 3px rgba(233, 69, 96, 0.2);
}

.dark-theme .modal-container {
  background: #2d3748;
}

.dark-theme .modal-header {
  background: linear-gradient(135deg, #e94560 0%, #533483 100%);
}

.dark-theme .modal-content {
  background: #2d3748;
}

.dark-theme .comment-section h4 {
  color: #e2e8f0;
}

.dark-theme .comment-section p {
  background: linear-gradient(135deg, #4a5568 0%, #2d3748 100%);
  color: #cbd5e0;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

/* 动画效果 */
@keyframes slideDown {
  from {
    opacity: 0;
    transform: translateY(-20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes pulse {
  0% {
    box-shadow: 0 0 0 0 rgba(233, 69, 96, 0.7);
  }
  70% {
    box-shadow: 0 0 0 10px rgba(233, 69, 96, 0);
  }
  100% {
    box-shadow: 0 0 0 0 rgba(233, 69, 96, 0);
  }
}

@keyframes glow {
  from {
    box-shadow: 0 0 20px rgba(233, 69, 96, 0.3);
  }
  to {
    box-shadow: 0 0 30px rgba(233, 69, 96, 0.6);
  }
}

@keyframes bounce {
  0%, 20%, 50%, 80%, 100% {
    transform: translateY(0);
  }
  40% {
    transform: translateY(-5px);
  }
  60% {
    transform: translateY(-3px);
  }
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: scale(0.95);
  }
  to {
    opacity: 1;
    transform: scale(1);
  }
}

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* 响应式设计 */
@media (max-width: 768px) {
  .review-management {
    padding: 1rem;
  }

  .page-header {
    flex-direction: column;
    text-align: center;
    gap: 1rem;
  }

  .permission-header {
    flex-direction: column;
    gap: 1rem;
  }

  .roles-grid {
    grid-template-columns: 1fr;
  }

  .stats-section {
    flex-direction: column;
  }

  .type-grid {
    grid-template-columns: 1fr;
  }

  .details-header {
    flex-direction: column;
    gap: 1rem;
  }

  .time-selector {
    flex-direction: column;
  }

  .status-group {
    flex-direction: column;
    align-items: flex-start;
  }

  .status-group label {
    min-width: auto;
  }
}

/* 页面入场动画 */
.review-management > * {
  animation: fadeInUp 0.6s ease-out;
}

.review-management > *:nth-child(2) {
  animation-delay: 0.1s;
}

.review-management > *:nth-child(3) {
  animation-delay: 0.2s;
}

.review-management > *:nth-child(4) {
  animation-delay: 0.3s;
}

.review-management > *:nth-child(5) {
  animation-delay: 0.4s;
}
</style>
