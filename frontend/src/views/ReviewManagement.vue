<template>
  <div class="review-management">
    <!-- 过滤器和审核记录列表将在此插入 -->
    <div class="filter-section card">
      <h3>筛选审核记录</h3>
      <div class="filter-grid-modern">
        <div class="filter-item">
          <label>数据类型</label>
          <select v-model="filterCategory">
            <option value=0>全部</option>
            <option v-for="dept in departmentsList" :key="dept.id" :value="dept.id">{{
                dept.name_zh
              }}
            </option>
          </select>
        </div>
        <div class="filter-item">
          <label>工厂</label>
          <select v-model="filterFactory">
            <option value="">全部</option>
            <option v-for="factory in factoryList" :key="factory" :value="factory">{{ factory }}</option>
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
          <label>工厂审核状态</label>
          <select v-model="filterLevel1Status">
            <option value="">全部</option>
            <option value="pending">待审核</option>
            <option value="approved">通过</option>
            <option value="rejected">不通过</option>
          </select>
        </div>
        <div class="filter-item">
          <label>总部审核状态</label>
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
        <button class="btn btn-secondary" @click="resetFilters">
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
      <div class="records-header-row">
        <h3>审核记录列表</h3>
      </div>
      <div class="records-list-modern">
        <div class="record-header-row">
          <span class="header-cell">数据类型</span>
          <span class="header-cell">工厂</span>
          <span class="header-cell">年份/月份</span>
          <span class="header-cell">提交状态</span>
          <span class="header-cell">工厂审核状态</span>
          <span class="header-cell">工厂评论</span>
          <span class="header-cell" v-if="filteredRecords.some(r => !isAnnualType(r.data_type))">总部审核状态</span>
          <span class="header-cell" v-if="filteredRecords.some(r => !isAnnualType(r.data_type))">总部评论</span>
        </div>
        <div v-for="record in filteredRecords" :key="record.id" class="record-row" @click="openDetails(record)">
          <span class="cell">{{ authStore.getCategoryMapping(record.category).name_zh }}</span>
          <span class="cell">{{ record.factory }}</span>
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
import {useSelectionStore} from '@/stores/selectionStore.js';
import {showError} from '@/utils/toast.js';
import ReviewDetailsModal from "@/components/ReviewDetailsModal.vue";
import debounce from 'lodash/debounce';

const authStore = useAuthStore()
const selectionStore = useSelectionStore()

const factoryList = computed(() => (authStore.isDepartment || authStore.isFactory) ? [authStore.factory] : selectionStore.factories)
const departmentsList = computed(() => authStore.getReviewableDataTypes || [])


// 分页相关
const currentPage = ref(1)
const pageSize = ref(10)
const totalRecords = ref(0)


const fetchRecords = async () => {
  try {
    const params = {
      page: currentPage.value,
      page_size: pageSize.value,
      category: filterCategory.value || undefined,
      factory: filterFactory.value || undefined,
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
  return labels[status] || ''
}

// 过滤器相关
const filteredRecords = ref([])
const filterFactory = ref('')
const filterCategory = ref(0)
const filterYear = ref('')
const filterMonth = ref('')
const filterSubmitted = ref('')
const filterLevel1Status = ref('')
const filterLevel2Status = ref('')
const filterCommentKeyword = ref('')

function resetFilters() {
  filterFactory.value = ''
  filterCategory.value = 0
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
    filterCategory.value = state.filterCategory || 0
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
  filterFactory, filterCategory, filterYear, filterMonth,
  filterSubmitted, filterLevel1Status, filterLevel2Status, filterCommentKeyword, pageSize
], () => {
  currentPage.value = 1;
  const state = {
    filterFactory: filterFactory.value,
    filterCategory: filterCategory.value,
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

watch(currentPage, () => {
  const state = {
    filterFactory: filterFactory.value,
    filterCategory: filterCategory.value,
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
  console.log(currentPage.value)
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
