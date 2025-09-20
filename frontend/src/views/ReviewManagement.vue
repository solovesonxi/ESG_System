<template>
  <div class="review-management">
    <!-- 页面标题 -->
    <div class="page-header">
      <div class="user-info">
        <span class="username">{{ authStore.user?.username }}</span>
        <span class="role-badge" :class="authStore.user?.role">
          {{ getRoleLabel(authStore.user?.role) }}
        </span>
        <button class="permission-toggle-btn" @click="showPermissionDetails = !showPermissionDetails"
                :class="{ 'active': showPermissionDetails }">
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
      </div>
    </div>

    <!-- 过滤器和审核记录列表将在此插入 -->
    <div class="filter-section card">
      <h3>筛选审核记录</h3>
      <div class="filter-grid-modern">
        <div class="filter-item">
          <label>工厂</label>
          <select v-model="filterFactory">
            <option value="">全部</option>
            <option v-for="factory in factoryList" :key="factory" :value="factory">{{ factory }}</option>
          </select>
        </div>
        <div class="filter-item">
          <label>数据类型</label>
          <select v-model="filterDepartment">
            <option value="">全部</option>
            <option v-for="dept in departmentsListZh" :key="dept" :value="dept">{{ dept }}</option>
          </select>
        </div>
        <div class="filter-item">
          <label>年份</label>
          <select v-model="filterYear">
            <option value="">全部</option>
            <option v-for="year in selectionStore.years" :key="year" :value="year">{{ year }}</option>
          </select>
        </div>
        <div class="filter-item">
          <label>月份</label>
          <select v-model="filterMonth">
            <option value="">全部</option>
            <option v-for="month in Array.from({length: 12}, (_, i) => i + 1)" :key="month" :value="month">{{ month }}月</option>
          </select>
        </div>
        <div class="filter-item">
          <label>提交状态</label>
          <select v-model="filterSubmitted">
            <option value="">全部</option>
            <option value="true">已提交</option>
            <option value="false">未提交</option>
          </select>
        </div>
        <div class="filter-item">
          <label>一级审核</label>
          <select v-model="filterLevel1Status">
            <option value="">全部</option>
            <option value="pending">待审核</option>
            <option value="approved">通过</option>
            <option value="rejected">不通过</option>
          </select>
        </div>
        <div class="filter-item">
          <label>二级审核</label>
          <select v-model="filterLevel2Status">
            <option value="">全部</option>
            <option value="pending">待审核</option>
            <option value="approved">通过</option>
            <option value="rejected">不通过</option>
          </select>
        </div>
        <div class="filter-item">
          <label>评论关键字</label>
          <input v-model="filterCommentKeyword" type="text" placeholder="搜索评论"/>
        </div>
        <div class="filter-item">
          <button class="reset-btn" @click="resetFilters">
            <i class="fas fa-redo"></i> 重置
          </button>
        </div>
      </div>
    </div>
    <div class="records-section">
      <h3>审核记录列表</h3>
      <div class="records-list-modern">
        <div class="record-header-row">
          <span class="header-cell">工厂</span>
          <span class="header-cell">数据类型</span>
          <span class="header-cell">年份/月份</span>
          <span class="header-cell">提交状态</span>
          <span class="header-cell">一级审核</span>
          <span class="header-cell">一级评论</span>
          <span class="header-cell" v-if="filteredRecords.some(r => !isAnnualType(r.data_type))">二级审核</span>
          <span class="header-cell" v-if="filteredRecords.some(r => !isAnnualType(r.data_type))">二级评论</span>
        </div>
        <div v-for="record in filteredRecords" :key="record.id" class="record-row" @click="openDetails(record)">
          <span class="cell factory">{{ record.factory }}</span>
          <span class="cell data-type">{{ CATEGORY[record.data_type] }}</span>
          <span class="cell date">{{ record.year }}{{ record.month ? ('-' + record.month + '月') : '' }}</span>
          <span class="cell status-badge" :class="record.is_submitted ? 'submitted' : 'not-submitted'">{{ record.is_submitted ? '已提交' : '未提交' }}</span>
          <span class="cell status-badge" :class="record.level1_status">{{ getStatusLabel(record.level1_status) }}</span>
          <span class="cell comment" :title="record.level1_comment">{{ record.level1_comment?.slice(0, 12) || '—' }}<span v-if="record.level1_comment?.length > 12">...</span></span>
          <span class="cell status-badge" v-if="!isAnnualType(record.data_type)" :class="record.level2_status">{{ getStatusLabel(record.level2_status) }}</span>
          <span class="cell comment" v-if="!isAnnualType(record.data_type)" :title="record.level2_comment">{{ record.level2_comment?.slice(0, 12) || '—' }}<span v-if="record.level2_comment?.length > 12">...</span></span>
        </div>
        <div v-if="filteredRecords.length === 0" class="no-records">暂无符合条件的审核记录</div>
      </div>
      <div class="pagination-bar pagination-horizontal">
        <button @click="goToPage(1)" :disabled="currentPage===1">首页</button>
        <button @click="goToPage(currentPage-1)" :disabled="currentPage===1">上一页</button>
        <span class="page-text">第 <input type="number" v-model.number="currentPage" min="1" :max="totalPages" style="width:3em;"> 页 / 共 {{ totalPages }} 页</span>
        <button @click="goToPage(currentPage+1)" :disabled="currentPage===totalPages">下一页</button>
        <button @click="goToPage(totalPages)" :disabled="currentPage===totalPages">尾页</button>
      </div>
      <ReviewDetailsModal v-if="showDetailsModal" :record="selectedRecord" @close="showDetailsModal=false" />
    </div>
  </div>
</template>

<script setup>
import {computed, onMounted, ref, watch} from 'vue'
import {useAuthStore} from '@/stores/authStore'
import apiClient from '@/utils/axios'
import {useSelectionStore} from "@/stores/selectionStore.js";
import {showError} from "@/utils/toast.js";
import {CATEGORY} from '@/constants/indicators.js';

const authStore = useAuthStore()
const selectionStore = useSelectionStore()

const showPermissionDetails = ref(false)
const factoryList = computed(() => authStore.isFactory ? [authStore.factory] : selectionStore.factories)
const departmentsList = computed(() => authStore.getReviewableDataTypes)
const departmentsListZh = computed(() => departmentsList.value.map(dep => CATEGORY[dep] || dep))

// 分页相关
const currentPage = ref(1)
const pageSize = ref(10)
const totalRecords = ref(0)

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

const fetchRecords = async () => {
  try {
    const params = {
      page: currentPage.value,
      page_size: pageSize.value,
      factory: filterFactory.value || undefined,
      department: filterDepartment.value || undefined,
      year: filterYear.value || undefined,
      month: filterMonth.value || undefined,
      is_submitted: filterSubmitted.value !== '' ? filterSubmitted.value : undefined,
      level1_status: filterLevel1Status.value || undefined,
      level2_status: filterLevel2Status.value || undefined,
      comment_keyword: filterCommentKeyword.value || undefined
    }
    const response = await apiClient.get('/review/', { params })
    console.log("审核记录数据：", response.data)
    filteredRecords.value = response.data.records
    totalRecords.value = response.data.total
  } catch (error) {
    showError(error)
  }
}


const getStatusLabel = (status) => {
  const labels = {
    'pending': '待审核',
    'approved': '通过',
    'rejected': '不通过'
  }
  return labels[status] || status
}

// 过滤器相关
const filteredRecords = ref([
  {
    id: 1,
    factory: '工厂A',
    data_type: 'material',
    year: 2025,
    month: 8,
    is_submitted: true,
    level1_status: 'approved',
    level1_comment: '数据准确，审核通过',
    level2_status: 'pending',
    level2_comment: ''
  },
  {
    id: 2,
    factory: '工厂B',
    data_type: 'energy',
    year: 2025,
    month: 7,
    is_submitted: false,
    level1_status: 'pending',
    level1_comment: '',
    level2_status: 'pending',
    level2_comment: ''
  },
  {
    id: 3,
    factory: '工厂A',
    data_type: 'env_qual',
    year: 2024,
    month: null,
    is_submitted: true,
    level1_status: 'rejected',
    level1_comment: '分析内容不完整',
    level2_status: '',
    level2_comment: ''
  },
  {
    id: 4,
    factory: '工厂C',
    data_type: 'water',
    year: 2023,
    month: 12,
    is_submitted: true,
    level1_status: 'approved',
    level1_comment: '水资源利用合理',
    level2_status: 'approved',
    level2_comment: '总部复核通过'
  },
  {
    id: 5,
    factory: '工厂B',
    data_type: 'social_qual_labor',
    year: 2025,
    month: null,
    is_submitted: false,
    level1_status: 'pending',
    level1_comment: '',
    level2_status: '',
    level2_comment: ''
  }
])

const filterFactory = ref('')
const filterDepartment = ref('')
const filterYear = ref('')
const filterMonth = ref('')
const filterSubmitted = ref('')
const filterLevel1Status = ref('')
const filterLevel2Status = ref('')
const filterCommentKeyword = ref('')

function resetFilters() {
  filterFactory.value = ''
  filterDepartment.value = ''
  filterYear.value = ''
  filterMonth.value = ''
  filterSubmitted.value = ''
  filterLevel1Status.value = ''
  filterLevel2Status.value = ''
  filterCommentKeyword.value = ''
}

function isAnnualType(type) {
  // 年度分析数据类型
  return ['env_qual', 'env_quant', 'social_qual_labor', 'social_qual_other', 'social_quant_labor', 'social_quant_other', 'governance'].includes(type)
}

onMounted(async () => {
  try {
    await fetchRecords()
  } catch (error) {
    showError(error)
  }
})

// 生命周期
onMounted(() => {
  // 加载审核数据
  fetchRecords();
})

watch([
  filterFactory, filterDepartment, filterYear, filterMonth,
  filterSubmitted, filterLevel1Status, filterLevel2Status, filterCommentKeyword, pageSize
], () => {
  currentPage.value = 1
  fetchRecords()
})
watch(currentPage, fetchRecords)

const totalPages = computed(() => Math.max(1, Math.ceil(totalRecords.value / pageSize.value)))
function goToPage(page) {
  if (page < 1) page = 1
  if (page > totalPages.value) page = totalPages.value
  currentPage.value = page
}
</script>

<style scoped>
.review-management {
  padding: 2rem;
  min-height: 100vh;
  background: linear-gradient(135deg, #e3f2fd 0%, #f3e5f5 25%, #fce4ec 50%, #fff3e0 75%, #f1f8e9 100%);
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

.permission-details {
  margin-top: 1rem;
  padding-top: 1rem;
  border-top: 1px solid rgba(0, 0, 0, 0.1);
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
}

.role-card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 0.75rem;
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

.current-label {
  background: linear-gradient(135deg, #e94560 0%, #ff6b9d 100%);
  color: white;
  padding: 0.2rem 0.6rem;
  border-radius: 12px;
  font-size: 0.7rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 1px;
}

.role-permissions {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.permission-item {
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

.current-user-notice {
  background: linear-gradient(135deg, rgba(233, 69, 96, 0.1) 0%, rgba(103, 126, 234, 0.1) 100%);
  border: 2px solid rgba(233, 69, 96, 0.3);
  border-radius: 12px;
  padding: 1rem;
  display: flex;
  align-items: flex-start;
  gap: 1rem;
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
  letter-spacing: 1px;
  box-shadow: 0 2px 10px rgba(233, 69, 96, 0.3);
}

.card {
  background: #fff;
  border-radius: 16px;
  box-shadow: 0 4px 24px rgba(103, 126, 234, 0.08);
  padding: 1.5rem;
  margin-bottom: 2rem;
}

.filter-section {
  margin-bottom: 2rem;
}

.filter-grid {
  display: flex;
  flex-wrap: wrap;
  gap: 1.2rem;
  align-items: center;
  margin-bottom: 0.5rem;
}

.filter-grid-modern {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
  gap: 0.7rem;
  align-items: center;
}

.filter-item {
  flex: 1;
}

.filter-item label {
  display: block;
  font-size: 0.95rem;
  color: #667eea;
  margin-bottom: 0.2rem;
  font-weight: 500;
}

.filter-item select,
.filter-item input {
  width: 100%;
  padding: 0.35rem 0.7rem;
  border-radius: 6px;
  border: 1px solid #d1d5db;
  background: #f8f9fa;
  font-size: 0.95rem;
}

.reset-btn {
  padding: 0.35rem 0.9rem;
  border-radius: 8px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: #fff;
  border: none;
  font-weight: 600;
  cursor: pointer;
  font-size: 0.95rem;
  display: flex;
  align-items: center;
  gap: 0.3rem;
  min-width: 80px;
  justify-content: center;
}

.reset-btn i {
  font-size: 1rem;
}

.records-section {
  margin-bottom: 2rem;
}

.records-list-modern {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}
.record-row {
  display: grid;
  grid-template-columns: 1.2fr 1fr 1fr 1fr 1.2fr 1.5fr 1.2fr 1.5fr;
  align-items: flex-start;
  background: #fff;
  border-radius: 10px;
  box-shadow: 0 1px 6px rgba(103,126,234,0.07);
  padding: 0.4rem 0.4rem;
  font-size: 0.95rem;
  transition: box-shadow 0.2s;
}
.record-row:hover {
  box-shadow: 0 4px 16px rgba(233,69,96,0.10);
}
.cell {
  padding: 0.1rem 0.2rem;
  overflow: hidden;
  white-space: nowrap;
  text-overflow: ellipsis;
  color: #222;
  font-size: 0.95rem;
}
.cell.comment {
  color: #764ba2;
  background: #f3e5f5;
  border-radius: 6px;
  padding: 0.1rem 0.5rem;
  font-size: 0.92rem;
  cursor: pointer;
  max-width: 120px;
}
.cell.comment:hover {
  background: #fff3e0;
  color: #e94560;
}
.cell.reviewer {
  color: #888;
  font-size: 0.85em;
  margin-left: 0.2em;
}
.cell.review-time {
  color: #bbb;
  font-size: 0.8em;
  margin-left: 0.1em;
}
.status-badge {
  display: inline-block;
  width: fit-content;
  height: 22px;
  line-height: 22px;
  padding: 0 0.6em;
  border-radius: 12px;
  font-size: 0.92rem;
  font-weight: 600;
  color: #fff;
  background: #d1d5db;
  letter-spacing: 0.5px;
  margin-right: 0.2em;
  vertical-align: middle;
}
.status-badge.submitted {
  background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
}
.status-badge.not-submitted {
  background: linear-gradient(135deg, #ffc107 0%, #ff9800 100%);
}
.status-badge.pending {
  background: linear-gradient(135deg, #ffc107 0%, #ff9800 100%);
}
.status-badge.approved {
  background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
}
.status-badge.rejected {
  background: linear-gradient(135deg, #dc3545 0%, #e91e63 100%);
}
.pagination-bar.pagination-horizontal {
  display: flex;
  flex-direction: row;
  gap: 0.5rem;
  justify-content: center;
  align-items: center;
  background: transparent;
  height: 32px;
}
.pagination-bar button {
  width: fit-content;
  height: 28px;
  padding: 0 0.7em;
  font-size: 0.95rem;
  background: transparent;
  color: #2f2f2f;
  cursor: pointer;
  transition: color 0.2s, border 0.2s, background 0.2s;
  display: flex;
  align-items: center;
}
.page-text {
  font-size: 0.95rem;
  color: #2f2f2f;
  padding-top: 1.7em;
  display: flex;
  align-items: center;
  gap: 0.3rem;
  height: 28px;
}
.pagination-bar button:disabled {
  cursor: not-allowed;
  color: #555;
  border: 1px solid #eee;
}
.pagination-bar input[type="number"] {
  height: 24px;
  min-width: 70px;
  font-size: 0.95rem;
  color: #222;
  background: #fff3e0;
  border-radius: 6px;
  border: 1px solid #d1d5db;
  margin: 0 0.2em;
  display: flex;
  align-items: center;
}
:root .dark-theme .pagination-bar.pagination-horizontal {
  background: transparent;
}
:root .dark-theme .pagination-bar button {
  color: #f8f9fa;
  background: transparent;
  border: 1px solid #444;
}
:root .dark-theme .pagination-bar button:disabled {
  color: #888;
  border-color: #333;
}
:root .dark-theme .pagination-bar input[type="number"] {
  color: #f8f9fa;
  background: #222;
  border: 1px solid #444;
}
:root .dark-theme .page-text {
  color: #ccc;
}
:root .dark-theme .records-section,
:root .dark-theme .card,
:root .dark-theme .filter-section {
  background: #181818 !important;
  color: #f8f9fa !important;
}
:root .dark-theme .record-row {
  background: #222 !important;
  color: #f8f9fa !important;
  box-shadow: 0 1px 6px rgba(103,126,234,0.15);
}
:root .dark-theme .cell {
  color: #f8f9fa !important;
}
:root .dark-theme .cell.comment {
  background: #333 !important;
  color: #e94560 !important;
}
:root .dark-theme .cell.comment:hover {
  background: #444 !important;
  color: #ff6b9d !important;
}
:root .dark-theme .cell.reviewer {
  color: #aaa !important;
}
:root .dark-theme .cell.review-time {
  color: #888 !important;
}
:root .dark-theme .status-badge.submitted {
  background: linear-gradient(135deg, #28a745 0%, #20c997 100%) !important;
  color: #fff !important;
}
:root .dark-theme .status-badge.not-submitted {
  background: linear-gradient(135deg, #ffc107 0%, #ff9800 100%) !important;
  color: #fff !important;
}
:root .dark-theme .status-badge.pending {
  background: linear-gradient(135deg, #ffc107 0%, #ff9800 100%) !important;
  color: #fff !important;
}
:root .dark-theme .status-badge.approved {
  background: linear-gradient(135deg, #28a745 0%, #20c997 100%) !important;
  color: #fff !important;
}
:root .dark-theme .status-badge.rejected {
  background: linear-gradient(135deg, #dc3545 0%, #e91e63 100%) !important;
  color: #fff !important;
}
:root .dark-theme .filter-item label {
  color: #e94560 !important;
}
:root .dark-theme .filter-item select,
:root .dark-theme .filter-item input {
  background: #222 !important;
  color: #f8f9fa !important;
  border: 1px solid #444 !important;
}
:root .dark-theme .reset-btn {
  background: linear-gradient(135deg, #e94560 0%, #764ba2 100%) !important;
  color: #fff !important;
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

@media (max-width: 900px) {
  .filter-grid {
    flex-direction: column;
    gap: 0.7rem;
    align-items: stretch;
  }

  .record-header {
    flex-direction: column;
    gap: 0.5rem;
    align-items: flex-start;
  }

  .record-card {
    padding: 1rem 0.7rem;
  }
}

.page-header {
  display: flex;
  justify-content: flex-start;
  align-items: center;
  margin-bottom: 2rem;
  padding: 1.5rem;
  background: rgba(255, 255, 255, 0.9);
  border-radius: 16px;
  backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.3);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
}

.user-info {
  display: flex;
  align-items: center;
  gap: 1rem;
  flex-wrap: nowrap;
  white-space: nowrap;
}

.username,
.role-badge {
  display: inline-block;
  white-space: nowrap;
}

.username {
  color: #495057;
  font-weight: 600;
}

.role-badge {
  padding: 0.5rem 1rem;
  border-radius: 25px;
  font-size: 0.875rem;
  font-weight: 600;
  color: white;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
}

.permission-toggle-btn {
  background: transparent;
  border: none;
  color: #764ba2;
  font-size: 0.95rem;
  cursor: pointer;
  display: inline-flex;
  align-items: center;
  gap: 0.3rem;
  padding: 0.2rem 0.6rem;
  border-radius: 0;
  font-weight: 500;
  text-decoration: underline;
  transition: color 0.2s, text-decoration 0.2s;
  box-shadow: none;
}

.permission-toggle-btn:hover {
  color: #e94560;
  text-decoration: underline;
  background: transparent;
}

.permission-toggle-btn.active {
  color: #28a745;
  text-decoration: underline;
  background: transparent;
}

.permission-details h4,
.filter-section h3,
.records-section h3 {
  color: #222;
  font-weight: 700;
  font-size: 1.2rem;
  margin-bottom: 1rem;
  letter-spacing: 1px;
}

:root .dark-theme .permission-details h4,
:root .dark-theme .filter-section h3,
:root .dark-theme .records-section h3 {
  color: #fff;
  background: linear-gradient(90deg, #e94560 0%, #764ba2 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  text-shadow: 0 2px 8px #53348399;
}

.record-header-row {
  display: grid;
  grid-template-columns: 1.2fr 1fr 1fr 1fr 1.2fr 1.5fr 1.2fr 1.5fr;
  align-items: center;
  background: #f8f9fa;
  color: #222;
  font-weight: 600;
  font-size: 0.97rem;
  border-radius: 10px 10px 0 0;
  padding: 0.4rem 0.7rem;
  margin-bottom: 2px;
}
.header-cell {
  padding: 0.1rem 0.2rem;
  text-align: left;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
:root .dark-theme .record-header-row {
  background: #222 !important;
  color: #f8f9fa !important;
}
:root .dark-theme .header-cell {
  color: #f8f9fa !important;
}
</style>
