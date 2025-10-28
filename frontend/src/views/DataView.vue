<template>
  <div class="shared-form">
    <form>
      <div class="base-info-container">
        <div class="info-header">
          <div class="basic-info">
            <h3 class="section-title">基础信息</h3>
            <div class="info-grid">
              <!-- 工厂名称 -->
              <div class="info-item">
                <label class="info-label">工厂名称</label>
                <div class="custom-select">
                  <div class="selected" @click="selectionStore.toggleFactoryDropdown">
                    <span class="value">{{ factory }}</span>
                    <i class="arrow" :class="{ 'up': selectionStore.showFactoryDropdown }"></i>
                  </div>
                  <div class="options" v-show="selectionStore.showFactoryDropdown">
                    <div v-for="f in selectionStore.factories" :key="f" class="option"
                         :class="{ 'selected-option': f === factory }" @click="selectionStore.selectFactory(f)">
                      {{ f }}
                    </div>
                  </div>
                </div>
              </div>

              <!-- 数据周期（优先选择，样式一致） -->
              <div class="info-item">
                <label class="info-label">数据周期</label>
                <div class="custom-select">
                  <div class="selected" @click="togglePeriodDropdown">
                    <span class="value">{{ periodLabel }}</span>
                    <i class="arrow" :class="{ 'up': showPeriodDropdown }"></i>
                  </div>
                  <div class="options" v-show="showPeriodDropdown">
                    <div class="option" :class="{ 'selected-option': periodType==='month' }" @click="selectPeriod('month')">月度</div>
                    <div class="option" :class="{ 'selected-option': periodType==='year' }" @click="selectPeriod('year')">年度</div>
                  </div>
                </div>
              </div>

              <!-- 统计年份 -->
              <div class="info-item">
                <label class="info-label">统计年份</label>
                <div class="custom-select">
                  <div class="selected" @click="selectionStore.toggleYearDropdown">
                    <span class="value">{{ year }}年</span>
                    <i class="arrow" :class="{ 'up': selectionStore.showYearDropdown }"></i>
                  </div>
                  <div class="options" v-show="selectionStore.showYearDropdown">
                    <div v-for="y in selectionStore.years" :key="y" class="option"
                         :class="{ 'selected-option': y === year }" @click="selectionStore.selectYear(y)">
                      {{ y }}年
                    </div>
                  </div>
                </div>
              </div>

              <!-- 统计月份（仅月度显示） -->
              <div class="info-item" v-if="periodType==='month'">
                <label class="info-label">统计月份</label>
                <div class="custom-select">
                  <div class="selected" @click="selectionStore.toggleMonthDropdown">
                    <span class="value">{{ month }}月</span>
                    <i class="arrow" :class="{ 'up': selectionStore.showMonthDropdown }"></i>
                  </div>
                  <div class="options" v-show="selectionStore.showMonthDropdown">
                    <div v-for="m in selectionStore.months" :key="m" class="option"
                         :class="{ 'selected-option': m === month }" @click="selectionStore.selectMonth(m)">
                      {{ m }}月
                    </div>
                  </div>
                </div>
              </div>

              <!-- 数据分类（样式与工厂一致） -->
              <div class="info-item">
                <label class="info-label">数据分类</label>
                <div class="custom-select">
                  <div class="selected" @click="toggleCategoryDropdown">
                    <span class="value">{{ currentCategoryName }}</span>
                    <i class="arrow" :class="{ 'up': showCategoryDropdown }"></i>
                  </div>
                  <div class="options" v-show="showCategoryDropdown">
                    <div v-for="opt in categoryOptions" :key="opt.id" class="option"
                         :class="{ 'selected-option': opt.id === selectedCategoryId }"
                         @click="selectCategory(opt.id)">
                      {{ opt.name_zh }}
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div v-if="isLoading" class="loading">数据加载中...</div>

      <template v-else>
        <!-- 月度视图（只读） -->
        <div v-if="periodType==='month'">
          <fieldset class="summary-fieldset">
            <legend>{{ currentCategoryName }}</legend>
            <div class="form-row" v-for="(s, si) in sets" :key="si">
              <div v-for="(f, fi) in s.fields" :key="fi" class="form-group">
                <label>{{ f.name_zh }}（{{ f.unit }}）</label>
                <div class="readonly-field">{{ formatMonthlyValue(f.value, month) }}</div>
              </div>
            </div>
          </fieldset>
        </div>

        <!-- 年度视图（只读） -->
        <div v-else>
          <fieldset class="summary-fieldset" v-for="setObj in sets || []" :key="setObj.set">
            <legend>{{ setObj.set }}</legend>
            <div class="form-row">
              <table class="data-table">
                <thead>
                <tr>
                  <th>指标</th>
                  <th>{{ isQuantitative ? '计算方式' : '指标释义' }}</th>
                  <th v-if="isQuantitative">单位</th>
                  <th>来源</th>
                  <th>{{ (year - 1) + (isQuantitative ? '年数据' : '年的方针、政策、文件、记录等') }}</th>
                  <th>{{ year + (isQuantitative ? '年数据' : '年的方针、政策、文件、记录等') }}</th>
                  <th>对比去年</th>
                  <th>原因分析</th>
                </tr>
                </thead>
                <tbody>
                <tr v-for="(item, idx) in setObj.fields" :key="idx">
                  <td>{{ item.name_zh || '' }}</td>
                  <td>{{ item.description || '' }}</td>
                  <td v-if="isQuantitative">{{ item.unit || '' }}</td>
                  <td>{{ item.source || '' }}</td>
                  <td>{{ item.lastYear || '' }}</td>
                  <td>{{ item.currentYear || '' }}</td>
                  <td>{{ item.comparison || '' }}</td>
                  <td>{{ item.reason || '' }}</td>
                </tr>
                </tbody>
              </table>
            </div>
          </fieldset>
        </div>
      </template>
    </form>
  </div>
  </template>

<script setup>
import {computed, onMounted, ref, watch} from 'vue'
import apiClient from '@/utils/axios';
import {useSelectionStore} from "@/stores/selectionStore.js"
import {handleError, showInfo} from "@/utils/toast.js";
import {useAuthStore} from "@/stores/authStore.js";

const selectionStore = useSelectionStore()
const authStore = useAuthStore()

const factory = computed(() => selectionStore.selectedFactory)
const year = computed(() => selectionStore.selectedYear)
const month = computed(() => selectionStore.selectedMonth)

const periodType = ref('month')
const selectedCategoryId = ref(null)

const isLoading = ref(false)
const sets = ref([])
const review = ref({})
const isQuantitative = ref(false)

const categoryOptions = computed(() => {
  if (periodType.value === 'month') {
    // 部门过滤：仅展示有权限的分类
    const list = authStore.monthCategories || []
    if (authStore.isDepartment) {
      return list.filter((i) => authStore.hasDepartmentAccess(i.id))
    }
    return list
  } else {
    return authStore.yearCategories || []
  }
})

function setPeriod(p) {
  if (periodType.value !== p) {
    periodType.value = p
    // 默认选中第一个分类
    const first = categoryOptions.value && categoryOptions.value[0]
    selectedCategoryId.value = first ? first.id : null
    fetchData()
  }
}

function normalizeMonthlyValue(val) {
  if (Array.isArray(val)) return val
  if (val === null || val === undefined) return Array(12).fill(0)
  return Array(12).fill(Number(val))
}

function formatMonthlyValue(val, m) {
  const arr = normalizeMonthlyValue(val)
  const idx = Math.max(1, Math.min(12, Number(m))) - 1
  return arr[idx] ?? ''
}

async function fetchData() {
  if (!selectedCategoryId.value) {
    const first = categoryOptions.value && categoryOptions.value[0]
    selectedCategoryId.value = first ? first.id : null
    if (!selectedCategoryId.value) return
  }
  isLoading.value = true
  try {
    if (periodType.value === 'month') {
      const response = await apiClient.get(`/month`, { params: { category_id: selectedCategoryId.value, factory: factory.value, year: year.value } })
      if (response.data && response.data.sets) {
        // 转换月度字段，仅用于展示
        sets.value = (response.data.sets || []).map(s => ({
          set: s.set,
          fields: (s.fields || []).map(f => ({ name_en: f.name_en, name_zh: f.name_zh, unit: f.unit, value: normalizeMonthlyValue(f.value) }))
        }))
        review.value = response.data.review || {}
      } else {
        sets.value = []
        review.value = {}
        showInfo('未找到数据')
      }
    } else {
      const response = await apiClient.get('/year', { params: { category_id: selectedCategoryId.value, factory: factory.value, year: year.value } })
      if (response.data && response.data.sets) {
        isQuantitative.value = response.data.is_quant
        sets.value = response.data.sets
        review.value = response.data.review || {}
      } else {
        sets.value = []
        review.value = {}
        showInfo('未找到数据')
      }
    }
  } catch (e) {
    handleError(e)
  } finally {
    isLoading.value = false
  }
}

onMounted(() => {
  // 初始化默认分类并拉取
  const first = categoryOptions.value && categoryOptions.value[0]
  selectedCategoryId.value = first ? first.id : null
  fetchData()
})

watch([factory, year, month], () => {
  fetchData()
})

// 分类下拉逻辑（与 BaseInfoSelector 风格保持一致）
const showCategoryDropdown = ref(false)
function toggleCategoryDropdown() {
  showCategoryDropdown.value = !showCategoryDropdown.value
}
function selectCategory(id) {
  selectedCategoryId.value = id
  showCategoryDropdown.value = false
  fetchData()
}
const currentCategoryName = computed(() => {
  const found = (categoryOptions.value || []).find(i => i.id === selectedCategoryId.value)
  return found ? found.name_zh : '请选择'
})

// 周期下拉逻辑（统一样式）
const showPeriodDropdown = ref(false)
function togglePeriodDropdown() {
  showPeriodDropdown.value = !showPeriodDropdown.value
}
function selectPeriod(p) {
  showPeriodDropdown.value = false
  setPeriod(p)
}
const periodLabel = computed(() => periodType.value === 'month' ? '月度' : '年度')
</script>

<style scoped>
.base-info-container {
  background: #f7f8fa;
  border-radius: 16px;
  padding: 1.5rem;
  margin-bottom: 1.5rem;
  border: 1px solid #e3e6ee;
}
.info-header { display: flex; justify-content: space-between; align-items: flex-start; }
.basic-info { flex: 1; }
.section-title {
  color: #2c3e50; font-size: 1.25rem; font-weight: 700; margin-bottom: 1rem;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text;
}
.info-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1rem; }
.info-item { display: flex; flex-direction: column; gap: 0.5rem; }
.info-label { font-weight: 600; color: #495057; font-size: 0.875rem; }

/* 下拉样式，复用 BaseInfoSelector 风格 */
.custom-select { position: relative; }
.selected {
  background: #f7f8fa; border: 2px solid #e3e6ee; border-radius: 8px; padding: 0.75rem 1rem;
  cursor: pointer; display: flex; justify-content: space-between; align-items: center; transition: all 0.3s ease;
}
.selected:hover { border-color: #667eea; box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.08); }
.selected .value { color: #2c3e50; font-weight: 500; }
.options {
  position: absolute; top: 100%; left: 0; right: 0; background: #fff; border: 2px solid #e3e6ee; border-radius: 8px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.10); z-index: 1000; max-height: 200px; overflow-y: auto; margin-top: 0.25rem;
}
.option { padding: 0.75rem 1rem; cursor: pointer; transition: background-color 0.2s; color: #2c3e50; }
.option:hover { background-color: #e3e6ee; }
.selected-option { background-color: #e3e6ee; color: #667eea; font-weight: 600; }

.controls-row {
  display: flex;
  gap: 16px;
  margin: 12px 0 16px 0;
}
.control {
  display: flex;
  align-items: center;
  gap: 8px;
}
.toggle-group button {
  padding: 6px 12px;
  border: 1px solid #ccc;
  background: #f7f7f7;
  cursor: pointer;
}
.toggle-group button.active {
  background: #667eea;
  color: #fff;
  border-color: #667eea;
}
.readonly-field {
  padding: 8px 10px;
  background: #f7f8fa;
  border: 1px solid #e3e6ee;
  border-radius: 6px;
  color: #000000;
}
.data-table { width: 100%; table-layout: fixed; }
.data-table th, .data-table td { padding: 8px; border-bottom: 1px solid #eee; text-align: left; }
</style>


