<template>
  <div class="review-management">
    <!-- 过滤器区 -->
    <div class="filter-section card">
      <h3>分类管理</h3>
      <div class="filter-grid-modern">
        <div class="filter-item">
          <label>领域</label>
          <select v-model="filterDomain">
            <option value="">全部</option>
            <option v-for="d in domains" :key="d" :value="d">{{ d }}</option>
          </select>
        </div>
        <div class="filter-item">
          <label>周期</label>
          <select v-model="periodType">
            <option value="">全部</option>
            <option :key="'month'" :value="'month'">月</option>
            <option :key="'year'" :value="'year'">年</option>
          </select>
        </div>
        <div class="filter-item">
          <label>搜索字段</label>
          <input v-model="keyword" class="filter-input" placeholder="请输入字段中文名/英文名"/>
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

    <!-- 字段表格区 -->
    <div class="records-section">
      <div class="records-header-row">
        <h3>分类列表<span class="text-muted">（共 {{ totalCount }} 条）</span></h3>
        <div class="quick-actions">
          <button class="btn btn-secondary" @click="openAddCategory"><span class="icon-add"></span>添加分类</button>
          <button class="btn btn-secondary" @click="refreshCategories"><span class="icon-refresh"></span>刷新</button>
        </div>
      </div>

      <div class="records-list-modern">
        <div class="record-header-row">
          <span class="header-cell">英文标识</span>
          <span class="header-cell">中文名称</span>
          <span class="header-cell">模型类</span>
          <span class="header-cell">领域</span>
          <span class="header-cell">周期</span>
          <span class="header-cell">启用</span>
        </div>
        <div v-for="cat in categories" :key="cat.id" class="record-row">
          <span class="cell" @click="openCategoryDetail(cat)">{{ cat.name_en }}</span>
          <span class="cell" @click="openCategoryDetail(cat)">{{ cat.name_zh }}</span>
          <span class="cell" @click="openCategoryDetail(cat)">{{ cat.model_class }}</span>
          <span class="cell" @click="openCategoryDetail(cat)">{{ cat.domain }}</span>
          <span class="cell" @click="openCategoryDetail(cat)">{{ cat.period_type === 'month' ? '月度' : '年度' }}</span>
          <span class="cell">
            <label class="switch">
              <input type="checkbox" :checked="cat.is_active" @click.stop="toggleCategoryStatus(cat)">
              <span class="slider round"></span>
            </label>
          </span>
        </div>
        <div v-if="categories.length === 0" class="empty-state">
          <div class="empty-icon">😢</div>
          <p>暂无分类数据</p>
        </div>
      </div>


      <div class="pagination-bar pagination-horizontal">
        <button @click="goToPage(1)" :disabled="page===1">首页</button>
        <button @click="goToPage(page-1)" :disabled="page===1">上一页</button>
        <span class="page-text">第 <input type="number" v-model.number="page" min="1" :max="totalPages"
                        style="width:3em;"> 页 / 共 {{ totalPages }} 页</span>
        <button @click="goToPage(page+1)" :disabled="page===totalPages">下一页</button>
        <button @click="goToPage(totalPages)" :disabled="page===totalPages">尾页</button>
      </div>
    </div>

    <!-- 新增/编辑弹窗 -->
    <teleport to="body">
      <div v-if="showCategoryDetail" class="modal-mask" @click.self="closeCategoryDetail">
        <div class="modal-content">
          <div class="modal-header">
            <h3>{{ detailCategory && detailCategory.id ? '编辑分类' : '添加分类' }}</h3>
          </div>
          <div class="modal-body">
            <div class="form-group">
              <label class="form-label">英文标识</label>
              <input v-model="detailCategory.name_en" class="form-input"/>
            </div>

            <div class="form-group">
              <label class="form-label">中文名称</label>
              <input v-model="detailCategory.name_zh" class="form-input"/>
            </div>

            <div class="form-group">
              <label class="form-label">模型类</label>
              <input v-model="detailCategory.model_class" class="form-input"/>
            </div>

            <div class="form-group">
              <label class="form-label">领域</label>
              <input v-model="detailCategory.domain" class="form-input"/>
            </div>

            <div class="form-group">
              <label class="form-label">周期</label>
              <select v-model="detailCategory.period_type" class="form-input">
                <option value="month">月度</option>
                <option value="year">年度</option>
              </select>
            </div>

            <div class="button-row">
              <button v-if="detailCategory?.id" class="btn btn-danger" @click="prepareDeleteCategory(detailCategory)">
                删除分类
              </button>
              <button class="btn btn-primary" @click="saveCategory">{{
                  detailCategory?.id ? '保存修改' : '确认添加'
                }}
              </button>
            </div>
          </div>
        </div>
      </div>

      <!-- 删除确认 -->
      <div v-if="showConfirmDeleteCategory" class="modal-mask" @click.self="cancelDeleteCategory">
        <div class="modal-content" style="max-width:420px;">
          <div class="modal-body" style="text-align:center; padding:24px;">
            <p>确定要删除该分类吗？此操作不可恢复。</p>
            <div style="display:flex; gap:12px; justify-content:center; margin-top:12px;">
              <button class="btn btn-danger" @click="confirmDeleteCategory">确认删除</button>
            </div>
          </div>
        </div>
      </div>
    </teleport>
  </div>
</template>

<script setup>
import {computed, onMounted, ref, watch} from 'vue'
import axios from '@/utils/axios'
import {handleError, showError, showInfo, showSuccess} from '@/utils/toast'
import debounce from 'lodash/debounce'

const categories = ref([])
const domains = ref([])
const page = ref(1)
const pageSize = ref(10)
const totalPages = ref(1)

// filters
const filterDomain = ref('')
const periodType = ref('')
const keyword = ref('')

const detailCategory = ref(null)
const showCategoryDetail = ref(false)
const showConfirmDeleteCategory = ref(false)
const deleteCategoryTarget = ref(null)
const totalCount = ref(0);

async function fetchCategories() {
  try {
    const res = await axios.get('/category', {
      params: {
        page: page.value,
        page_size: pageSize.value,
        domain: filterDomain.value || undefined,
        period_type: periodType.value || undefined,
        keyword: keyword.value || undefined
      }
    })
    domains.value = res.data.domains || []
    categories.value = res.data.categories || res.data.items || []
    totalCount.value = res.data.total || categories.value.length
    totalPages.value = Math.max(1, Math.ceil(totalCount.value / res.data.page_size))
  } catch (e) {
    handleError(e)
  }
}

function openAddCategory() {
  detailCategory.value = {name_en: '', name_zh: '', model_class: '', domain: '', period_type: 'month', is_active: true}
  showCategoryDetail.value = true
}

function openCategoryDetail(cat) {
  detailCategory.value = JSON.parse(JSON.stringify(cat || {}))
  showCategoryDetail.value = true
}

function closeCategoryDetail() {
  detailCategory.value = null
  showCategoryDetail.value = false
}

async function saveCategory() {
  try {
    const payload = {...detailCategory.value}
    let res
    if (!detailCategory.value.id) {
      res = await axios.post('/category/add', payload)
    } else {
      res = await axios.patch('/category/update', payload)
    }
    if (res.data && res.data.status === 'success') {
      showSuccess('保存成功')
      closeCategoryDetail()
      // after save, refresh list and reset page
      page.value = 1
      await fetchCategories()
    } else {
      showInfo('操作未成功，请检查输入')
    }
  } catch (e) {
    handleError(e)
  }
}

function prepareDeleteCategory(cat) {
  deleteCategoryTarget.value = cat
  showConfirmDeleteCategory.value = true
}

async function confirmDeleteCategory() {
  if (!deleteCategoryTarget.value) return
  try {
    const res = await axios.delete('/category/delete', {data: {id: deleteCategoryTarget.value.id}})
    if (res.data && res.data.status === 'success') {
      showSuccess('删除成功')
      page.value = 1
      await fetchCategories()
    } else {
      showError('删除失败')
    }
  } catch (e) {
    handleError(e)
  } finally {
    showConfirmDeleteCategory.value = false
    deleteCategoryTarget.value = null
  }
}

function cancelDeleteCategory() {
  showConfirmDeleteCategory.value = false
  deleteCategoryTarget.value = null
}

async function toggleCategoryStatus(cat) {
  try {
    const newStatus = !cat.is_active
    const res = await axios.patch('/category/toggle-status', {id: cat.id, is_active: newStatus})
    if (res.data && res.data.status === 'success') {
      cat.is_active = newStatus
      showSuccess('状态已更新')
    } else {
      showError('状态更新失败')
    }
  } catch (e) {
    handleError(e)
  }
}

function goToPage(p) {
  if (p < 1) p = 1
  if (p > totalPages.value) p = totalPages.value
  page.value = p
  fetchCategories()
}

function refreshCategories() {
  fetchCategories()
  showInfo('分类列表已刷新')
}

function resetFilters() {
  filterDomain.value = ''
  periodType.value = ''
  keyword.value = ''
  page.value = 1
  fetchCategories()
}

onMounted(() => {
  fetchCategories()
})

// debounce filter changes to avoid too many requests
const debouncedFetch = debounce(() => {
  page.value = 1
  fetchCategories()
}, 300)

watch([filterDomain, periodType, keyword], () => {
  debouncedFetch()
})

watch(page, (v, o) => {
  if (v !== o) fetchCategories()
})
</script>

<style scoped>
@import '@/assets/filter-list-styles.css';

/* Page-specific small overrides */
.record-row {
  min-height: 48px;
}
</style>
