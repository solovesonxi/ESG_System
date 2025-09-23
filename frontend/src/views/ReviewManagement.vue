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
              <span class="role-badge department">部门</span>
              <span v-if="authStore.isDepartment" class="current-label">您当前角色</span>
            </div>
            <div class="role-permissions">
              <div class="permission-item">
                查看管辖部门每月的定量数据和一二级审核结果
              </div>
              <div class="permission-item">
                每月填写管辖部门的数据
              </div>
            </div>
          </div>

          <!-- 工厂账号 -->
          <div class="role-card" :class="{ 'current-user': authStore.isFactory }">
            <div class="role-card-header">
              <span class="role-badge factory">工厂</span>
              <span v-if="authStore.isFactory" class="current-label">您当前角色</span>
            </div>
            <div class="role-permissions">
              <div class="permission-item">
                查看所有部门的定量数据和一二级审核结果
              </div>
              <div class="permission-item">
                审核所有部门的定量数据
              </div>
              <div class="permission-item">
                查看本工厂的年度数据和审核结果
              </div>
              <div class="permission-item">
                每年填写本工厂的年度数据
              </div>
            </div>
          </div>

          <!-- 总部账号 -->
          <div class="role-card" :class="{ 'current-user': authStore.isHeadquarter }">
            <div class="role-card-header">
              <span class="role-badge headquarter">总部</span>
              <span v-if="authStore.isHeadquarter" class="current-label">您当前角色</span>
            </div>
            <div class="role-permissions">
              <div class="permission-item">
                查看所有月度和年度数据和一二级审核结果
              </div>
              <div class="permission-item">
                审核所有工厂所有部门的定量数据
              </div>
              <div class="permission-item">
                审核所有工厂的年度数据
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
            <div style="flex: 1;">
              <strong>您当前的操作权限：</strong>
              <div class="user-permissions">
              <span v-if="authStore.isDepartment" class="permission-tag">
                仅限以下部门数据: {{ departmentsListZh.join('、') }}
              </span>
                <span v-if="authStore.isFactory" class="permission-tag">
                本工厂: {{ authStore.factory }}
              </span>
                <span v-if="authStore.isHeadquarter" class="permission-tag">
                全公司数据访问
              </span>
                <span v-if="authStore.isAdmin" class="permission-tag">
                超级管理员权限
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
            <option v-for="dept in departmentsList" :key="dept" :value="dept">{{ CATEGORY[dept] }}</option>
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
            <option v-for="month in Array.from({length: 12}, (_, i) => i + 1)" :key="month" :value="month">{{
                month
              }}月
            </option>
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
          <label>搜索评论</label>
          <input v-model="filterCommentKeyword" type="text" placeholder="请输入搜索内容"/>
        </div>
        <button class="reset-btn" @click="resetFilters">
          <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 16 16">
            <path d="M8 3a5 5 0 1 0 4.546 2.914.5.5 0 0 1 .908-.417A6 6 0 1 1 8 2v1z"/>
            <path
                d="M8 4.466V.534a.25.25 0 0 1 .41-.192l2.36 1.966c.12.1.12.284 0 .384L8.41 4.658A.25.25 0 0 1 8 4.466z"/>
          </svg>
          重置
        </button>
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
          <span class="cell">{{ record.factory }}</span>
          <span class="cell">{{ CATEGORY[record.data_type] }}</span>
          <span class="cell">{{ record.year }}年{{ record.month ? (record.month + '月') : '' }}</span>
          <span class="cell status-badge" :class="record.is_submitted ? 'submitted' : 'not-submitted'">{{
              record.is_submitted ? '已提交' : '未提交'
            }}</span>
          <span class="cell status-badge" :class="record.level1_status">{{
              getStatusLabel(record.level1_status)
            }}</span>
          <span class="cell comment" :title="record.level1_comment">{{ record.level1_comment?.slice(0, 12) || '' }}
            <span v-if="record.level1_comment?.length > 12">...</span>
          </span>
          <span class="cell status-badge" v-if="!isAnnualType(record.data_type)"
                :class="record.level2_status || 'pending'">{{ getStatusLabel(record.level2_status) }}
          </span>
          <span class="cell comment" v-if="!isAnnualType(record.data_type)"
                :title="record.level2_comment">{{ record.level2_comment?.slice(0, 12) || '' }}<span
              v-if="record.level2_comment?.length > 12">...</span></span>
        </div>
        <div v-if="filteredRecords.length === 0" class="no-records">暂无符合条件的审核记录</div>
      </div>
    </div>
    <div class="pagination-bar pagination-horizontal">
      <button @click="goToPage(1)" :disabled="currentPage===1">首页</button>
      <button @click="goToPage(currentPage-1)" :disabled="currentPage===1">上一页</button>
      <span class="page-text">第 <input type="number" v-model.number="currentPage" min="1" :max="totalPages"
                                        style="width:3em;"> 页 / 共 {{ totalPages }} 页</span>
      <button @click="goToPage(currentPage+1)" :disabled="currentPage===totalPages">下一页</button>
      <button @click="goToPage(totalPages)" :disabled="currentPage===totalPages">尾页</button>
    </div>
    <ReviewDetailsModal v-if="showDetailsModal" :record="selectedRecord" @close="showDetailsModal=false"/>
  </div>
</template>

<script setup>
import {computed, onMounted, ref, watch} from 'vue'
import {useAuthStore} from '@/stores/authStore'
import apiClient from '@/utils/axios'
import {useSelectionStore} from "@/stores/selectionStore.js";
import {showError} from "@/utils/toast.js";
import {CATEGORY} from '@/constants/indicators.js';
import ReviewDetailsModal from "@/components/ReviewDetailsModal.vue";
import debounce from 'lodash/debounce';

const authStore = useAuthStore()
const selectionStore = useSelectionStore()

const showPermissionDetails = ref(false)
const factoryList = computed(() => (authStore.isDepartment || authStore.isFactory) ? [authStore.factory] : selectionStore.factories)
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
    const response = await apiClient.get('/review/', {params})
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
  return labels[status] || '待审核'
}

// 过滤器相关
const filteredRecords = ref([])
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

const STORAGE_KEY = 'reviewManagementState'

onMounted(() => {
  const saved = localStorage.getItem(STORAGE_KEY)
  if (saved) {
    const state = JSON.parse(saved)
    filterFactory.value = state.filterFactory || ''
    filterDepartment.value = state.filterDepartment || ''
    filterYear.value = state.filterYear || ''
    filterMonth.value = state.filterMonth || ''
    filterSubmitted.value = state.filterSubmitted || ''
    filterLevel1Status.value = state.filterLevel1Status || ''
    filterLevel2Status.value = state.filterLevel2Status || ''
    filterCommentKeyword.value = state.filterCommentKeyword || ''
    currentPage.value = state.currentPage || 1
  }
  fetchRecords()
})

// 统一监听筛选条件和 pageSize，变化时重置页码并刷新
const debouncedFetchRecords = debounce(() => {
  fetchRecords();
}, 300);

watch([
  filterFactory, filterDepartment, filterYear, filterMonth,
  filterSubmitted, filterLevel1Status, filterLevel2Status, filterCommentKeyword, currentPage, pageSize
], () => {
  currentPage.value = 1;
  const state = {
    filterFactory: filterFactory.value,
    filterDepartment: filterDepartment.value,
    filterYear: filterYear.value,
    filterMonth: filterMonth.value,
    filterSubmitted: filterSubmitted.value,
    filterLevel1Status: filterLevel1Status.value,
    filterLevel2Status: filterLevel2Status.value,
    filterCommentKeyword: filterCommentKeyword.value,
    currentPage: currentPage.value
  };
  localStorage.setItem(STORAGE_KEY, JSON.stringify(state));
  debouncedFetchRecords();
});

const totalPages = computed(() => Math.max(1, Math.ceil(totalRecords.value / pageSize.value)))

function goToPage(page) {
  if (page < 1) page = 1
  if (page > totalPages.value) page = totalPages.value
  currentPage.value = page
}

const showDetailsModal = ref(false)
const selectedRecord = ref(null)

function openDetails(record) {
  selectedRecord.value = record
  showDetailsModal.value = true
}
</script>

<style scoped>
@import '@/assets/filter-list-styles.css';
</style>
