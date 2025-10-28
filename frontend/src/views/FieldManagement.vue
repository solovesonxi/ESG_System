<template>
  <div class="review-management">
    <!-- 过滤器区 -->
    <div class="filter-section card">
      <h3>字段管理</h3>
      <div class="filter-grid-modern">
        <div class="filter-item">
          <label>数据类型</label>
          <select v-model="filterCategory">
            <option value="">全部</option>
            <option v-for="d in allCategories" :key="d.id" :value="d.id">{{ d.name_zh }}</option>
          </select>
        </div>
        <div class="filter-item">
          <label>分组</label>
          <select v-model="filterSet">
            <option value="">全部</option>
            <option v-for="s in sets" :key="s" :value="s">{{ s }}</option>
          </select>
        </div>
        <div class="filter-item">
          <label>搜索字段</label>
          <input v-model="keyword" class="filter-input" placeholder="请输入字段中文名/英文名"/>
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

    <!-- 字段表格区 -->
    <div class="records-section">
      <div class="records-header-row">
        <h3>字段列表 <span class="text-muted">（共 {{ totalCount }} 条）</span></h3>
        <div class="quick-actions">
          <button class="btn btn-secondary" @click="openDetail(null)" title="添加字段"><span class="icon-add"></span> 添加字段</button>
          <button class="btn btn-secondary" @click="refreshFields" title="刷新"><span class="icon-refresh"></span> 刷新</button>
        </div>
      </div>

      <div class="records-list-modern">
        <div class="record-header-row">
          <span class="header-cell">数据类型</span>
          <span class="header-cell">分组</span>
          <span class="header-cell">英文标识</span>
          <span class="header-cell">中文名称</span>
          <span class="header-cell">释义</span>
          <span class="header-cell">来源</span>
          <span class="header-cell">启用</span>
        </div>
        <div v-for="field in fields" :key="field.id" class="record-row">
          <span class="cell" @click="openDetail(field)">{{ getCategoryName(field.category) }}</span>
          <span class="cell" @click="openDetail(field)">{{ field.set }}</span>
          <span class="cell" @click="openDetail(field)">{{ field.name_en }}</span>
          <span class="cell" @click="openDetail(field)">{{ field.name_zh }}</span>
          <span class="cell" @click="openDetail(field)">{{ field.description }}</span>
          <span class="cell" @click="openDetail(field)">{{ field.source }}</span>
          <span class="cell">
            <label class="switch">
              <input type="checkbox" :checked="field.is_active" @click.stop="toggleFieldStatus(field)">
              <span class="slider round"></span>
            </label>
          </span>
        </div>
        <div v-if="fields.length === 0" class="empty-state">
          <div class="empty-icon">😢</div>
          <p>暂无字段数据</p>
        </div>
      </div>

      <!-- 分页条 -->
      <div class="pagination-bar pagination-horizontal">
        <button @click="goToPage(1)" :disabled="currentPage===1">首页</button>
        <button @click="goToPage(currentPage-1)" :disabled="currentPage===1">上一页</button>
        <span class="page-text">第 <input type="number" v-model.number="currentPage" min="1" :max="totalPages" style="width:3em;"> 页 / 共 {{ totalPages }} 页</span>
        <button @click="goToPage(currentPage+1)" :disabled="currentPage===totalPages">下一页</button>
        <button @click="goToPage(totalPages)" :disabled="currentPage===totalPages">尾页</button>
      </div>
    </div>

    <!-- 字段详情弹窗 -->
    <teleport to="body">
      <div v-if="showDetail" class="modal-mask" @click.self="closeDetail">
        <div class="modal-content">
          <div class="modal-header">
            <h3>{{ detailField && detailField.id ? '编辑字段' : '添加字段' }}</h3>
          </div>
          <div class="modal-body"><div class="form-group">
              <label class="form-label">数据类型</label>
              <select v-model="detailField.category" class="form-input">
                <option v-for="c in allCategories" :key="c.id" :value="c.id">{{ c.name_zh }}</option>
              </select>
            </div>

            <div class="form-group">
              <label class="form-label">分组</label>
              <input v-model="detailField.set" class="form-input" placeholder="例如 default 或 v1" />
            </div>

            <div class="form-group">
              <label class="form-label">英文标识</label>
              <input v-model="detailField.name_en" class="form-input" />
            </div>

            <div class="form-group">
              <label class="form-label">中文名称</label>
              <input v-model="detailField.name_zh" class="form-input" />
            </div>

            <div class="form-group">
              <label class="form-label">步长</label>
              <input v-model.number="detailField.step" class="form-input" type="number" step="any" />
            </div>

            <div class="form-group">
              <label class="form-label">计算</label>
              <textarea v-model="calculationText" class="form-input" rows="4" placeholder='可以输入 JSON 或 简单公式文本'></textarea>
            </div>

            <div class="form-group">
              <label class="form-label">单位</label>
              <input v-model="detailField.unit" class="form-input" />
            </div>

            <div class="form-group">
              <label class="form-label">描述</label>
              <textarea v-model="detailField.description" class="form-input" rows="3"></textarea>
            </div>

            <div class="form-group">
              <label class="form-label">来源</label>
              <input v-model="detailField.source" class="form-input" />
            </div>

            <div class="button-row">
              <button v-if="detailField?.id" class="btn btn-danger" @click="prepareDeleteField(detailField)">删除字段</button>
              <button class="btn btn-primary" @click="saveField">{{ detailField?.id ? '保存修改' : '确认添加' }}</button>
            </div>
          </div>
        </div>
      </div>

      <!-- 确认删除弹窗 -->
      <div v-if="showConfirmDelete" class="modal-mask" style="z-index:2000;" @click.self="cancelDeleteField">
        <div class="modal-content" style="max-width:400px;">
          <div class="modal-body" style="text-align:center;">
            <p>确定要删除该字段吗？此操作不可恢复。</p>
          </div>
          <div class="button-row">
            <button class="btn btn-danger" @click="confirmDeleteField">确认删除</button>
          </div>
        </div>
      </div>
    </teleport>
  </div>
</template>

<script setup>
import {computed, onMounted, ref, watch} from 'vue'
import axios from '@/utils/axios'
import {useAuthStore} from '@/stores/authStore.js'
import {useSelectionStore} from '@/stores/selectionStore.js'
import {handleError, showError, showInfo, showSuccess} from "@/utils/toast.js";
import debounce from 'lodash/debounce';

const authStore = useAuthStore()
const selectionStore = useSelectionStore()

const fields = ref([])
const sets = ref([])
const filterCategory = ref('')
const filterSet = ref('')
const keyword = ref('')

const detailField = ref(null)
const showDetail = ref(false)
const calculationText = ref('')
const showConfirmDelete = ref(false)
const deleteTarget = ref(null)

const currentPage = ref(1)
const pageSize = ref(10)
const totalPages = ref(1)
const totalCount = ref(0);

const allCategories = computed(() => {
  const m = Array.isArray(authStore.monthCategories) ? authStore.monthCategories : []
  const y = Array.isArray(authStore.yearCategories) ? authStore.yearCategories : []
  return [...m, ...y]
})


function getCategoryName(id) {
  if (!id) return ''
  const found = allCategories.value.find(c => c.id === id)
  return found ? found.name_zh || found.name_en || '' : id
}

async function fetchFields() {
  try {
    const res = await axios.get('/field', {
      params: {
        category: filterCategory.value || undefined,
        set: filterSet.value || undefined,
        keyword: keyword.value || undefined,
        page: currentPage.value,
        page_size: pageSize.value
      }
    })
    sets.value = res.data.sets || []
    fields.value = res.data.fields || []
    totalCount.value = res.data.total || fields.value.length
    totalPages.value = Math.max(1, Math.ceil(totalCount.value / res.data.page_size))
  } catch (e) {
    handleError(e)
  }
}

function resetFilters() {
  filterCategory.value = ''
  filterSet.value = ''
  keyword.value = ''
  currentPage.value = 1
  fetchFields()
}

function openDetail(field) {
  detailField.value = JSON.parse(JSON.stringify(field || {
    category: allCategories.value[0]?.id || null,
    set: 'default',
    name_en: '',
    name_zh: '',
    step: null,
    calculation: null,
    unit: '',
    description: '',
    source: '',
    is_active: true
  }))
  calculationText.value = typeof detailField.value.calculation === 'object' ? JSON.stringify(detailField.value.calculation, null, 2) : (detailField.value.calculation || '')
  showDetail.value = true
}

function closeDetail() {
  detailField.value = null
  calculationText.value = ''
  showDetail.value = false
}

async function saveField() {
  try {
    let calc = calculationText.value && calculationText.value.trim() !== '' ? (() => {
      try { return JSON.parse(calculationText.value) } catch (e) { return calculationText.value }
    })() : null

    const payload = {
      ...detailField.value,
      calculation: calc
    }
    let res
    if (!detailField.value.id) {
      res = await axios.post('/field/add', payload)
    } else {
      res = await axios.patch('/field/update', payload)
    }
    if (res.data && res.data.status === 'success') {
      showSuccess(detailField.value.id ? '保存成功' : '添加成功')
      closeDetail()
      await fetchFields()
    } else {
      showInfo('操作未成功，请检查输入')
    }
  } catch (e) {
    handleError(e)
  }
}

function prepareDeleteField(field) {
  deleteTarget.value = field
  showConfirmDelete.value = true
}

async function confirmDeleteField() {
  if (!deleteTarget.value) return
  try {
    const res = await axios.delete('/field/delete', { data: { id: deleteTarget.value.id } })
    if (res.data && res.data.status === 'success') {
      showSuccess('删除成功')
      await fetchFields()
    } else {
      showError('删除失败')
    }
  } catch (e) {
    handleError(e)
  } finally {
    showConfirmDelete.value = false
    deleteTarget.value = null
  }
}

function cancelDeleteField() {
  showConfirmDelete.value = false
  deleteTarget.value = null
}

async function toggleFieldStatus(field) {
  try {
    const newStatus = !field.is_active
    const res = await axios.patch('/field/toggle-status', { id: field.id, is_active: newStatus })
    if (res.data && res.data.status === 'success') {
      field.is_active = newStatus
      showSuccess('状态已更新')
    } else {
      showError('状态更新失败')
    }
  } catch (e) {
    handleError(e)
  }
}

function goToPage(page) {
  if (page < 1 || page > totalPages.value) return
  currentPage.value = page
  fetchFields()
}

function refreshFields() {
  fetchFields()
  showInfo('字段列表已刷新')
}

const debouncedFetchFields = debounce(() => {fetchFields();}, 300)
function changeFilter() {
  if (currentPage.value === 1) {
    debouncedFetchFields()
  }else {
    currentPage.value = 1
  }
}
watch([currentPage], debouncedFetchFields)
watch([filterCategory, filterSet, keyword], changeFilter)

onMounted(() => {
  // ensure selection store initialized to provide categories
  selectionStore.initSelection?.()
  fetchFields()
})
</script>

<style scoped>
@import '@/assets/filter-list-styles.css';

/* Page-specific small overrides (keep minimal) */
.record-row { min-height: 48px; }
</style>
