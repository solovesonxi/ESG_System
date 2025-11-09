<template>
  <div class="data-analysis-page">
    <div class="controls">
      <!-- First row: time range + category -->
      <div class="control-row control-row--top">
        <div class="time-group">
          <label class="control-label">时间：</label>
          <div class="time-inputs">
            <select v-model.number="startYearNum" class="small-select">
              <option v-for="y in selectionStore.years" :key="y" :value="y">{{ y }}</option>
            </select>
            <select v-model.number="startMonthNum" class="small-select">
              <option v-for="m in 12" :key="m" :value="m">{{ String(m).padStart(2,'0') }}</option>
            </select>
            <span class="tilde">~</span>
            <select v-model.number="endYearNum" class="small-select">
              <option v-for="y in selectionStore.years" :key="y" :value="y">{{ y }}</option>
            </select>
            <select v-model.number="endMonthNum" class="small-select">
              <option v-for="m in 12" :key="m" :value="m">{{ String(m).padStart(2,'0') }}</option>
            </select>
          </div>
        </div>

        <div class="category-group">
          <label class="control-label">数据分类：</label>
          <select v-model="selectedCategoryId" class="full-select">
            <option value=0>请选择分类</option>
            <option v-for="c in monthlyCategories" :key="c.id" :value="c.id">{{ c.name_zh }}</option>
          </select>
        </div>
      </div>

      <!-- Second row: three evenly spaced selectors: dim switch / factory / metric -->
      <div class="control-row selectors-row">
        <div class="selector-col">
          <label class="control-label">折线区分</label>
          <div class="dim-switch-wrap">
            <label class="theme-label">工厂</label>
            <input type="checkbox" v-model="isMetric" class="theme-switch" aria-label="切换对比维度" />
            <label class="theme-label">指标</label>
          </div>
        </div>

        <div class="selector-col">
          <label class="control-label">工厂</label>
          <div>
            <div v-if="dimMode==='metric'" class="single-dropdown" @click.stop>
              <button class="dropdown-btn" @click.stop="factoriesOpen = !factoriesOpen">
                <span v-if="selectedFactory">{{ selectedFactory }}</span>
                <span v-else class="muted">选择工厂</span>
                <span class="caret">▾</span>
              </button>
              <div class="dropdown-panel" v-if="factoriesOpen">
                <div class="dropdown-panel-header">
                  <button class="link" @click.stop="resetFactorySingle">重置</button>
                </div>
                <div class="dropdown-list">
                  <label v-for="f in selectionStore.factories" :key="f" class="chk single">
                    <span class="chk-text">{{ f }}</span>
                    <input type="radio" name="factoryRadio" :value="f" v-model="selectedFactory" @change="factoriesOpen=false" class="radio-input" />
                  </label>
                </div>
              </div>
            </div>
            <div v-else class="multi-dropdown" @click.stop>
              <button class="dropdown-btn" @click.stop="factoriesOpen = !factoriesOpen">
                <span v-if="selectedFactories.length">
                  <template v-for="f in selectedFactories.slice(0,3)" :key="f">
                    <span class="pill">{{ f }}</span>
                  </template>
                  <span v-if="selectedFactories.length > 3" class="muted">+{{ selectedFactories.length - 3 }}</span>
                </span>
                <span v-else class="muted">选择工厂</span>
                <span class="caret">▾</span>
              </button>
              <div class="dropdown-panel" v-if="factoriesOpen">
                <div class="dropdown-panel-header">
                  <button class="link" @click.stop="resetFactoryMulti">重置</button>
                </div>
                <div class="dropdown-list">
                  <label v-for="f in selectionStore.factories" :key="f" class="chk">
                    <span class="chk-text">{{ f }}</span>
                    <input type="checkbox" :value="f" v-model="selectedFactories" class="chk-input" />
                  </label>
                </div>
              </div>
            </div>
          </div>
        </div>

        <div class="selector-col">
          <label class="control-label">指标</label>
          <div>
            <div v-if="dimMode==='factory'" class="single-dropdown" @click.stop>
              <button class="dropdown-btn" @click.stop="fieldsOpen = !fieldsOpen">
                <span v-if="selectedField">{{ selectedField.name_zh }}</span>
                <span v-else class="muted">选择指标</span>
                <span class="caret">▾</span>
              </button>
              <div class="dropdown-panel" v-if="fieldsOpen">
                <div class="dropdown-panel-header">
                  <button class="link" @click.stop="resetFieldSingle">重置</button>
                </div>
                <div class="dropdown-list">
                  <label v-for="f in availableFields" :key="f.id" class="chk single">
                    <span class="chk-text">{{ f.name_zh }}</span>
                    <input type="radio" name="fieldRadio" :value="f" v-model="selectedField" @change="fieldsOpen=false" class="radio-input" />
                  </label>
                </div>
              </div>
            </div>
            <div v-else class="multi-dropdown" @click.stop>
              <button class="dropdown-btn" @click.stop="fieldsOpen = !fieldsOpen">
                <span v-if="selectedFields.length">
                  <template v-for="s in selectedFields.slice(0,3)" :key="s.id">
                    <span class="pill">{{ s.name_zh }}</span>
                  </template>
                  <span v-if="selectedFields.length > 3" class="muted">+{{ selectedFields.length - 3 }}</span>
                </span>
                <span v-else class="muted">选择指标</span>
                <span class="caret">▾</span>
              </button>
              <div class="dropdown-panel" v-if="fieldsOpen">
                <div class="dropdown-panel-header">
                  <button class="link" @click.stop="resetFieldMulti">重置</button>
                </div>
                <div class="dropdown-list">
                  <label v-for="f in availableFields" :key="f.id" class="chk">
                    <span class="chk-text">{{ f.name_zh }}</span>
                    <input type="checkbox" :value="f" v-model="selectedFields" class="chk-input" />
                  </label>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Actions: removed manual Reset/Render buttons (auto-render enabled) -->
    </div>

    <div class="grid vertical-grid">
      <div class="card chart-card">
        <div class="chart-card-controls left">
          <label class="theme-label">平滑折线图</label>
          <input type="checkbox" v-model="areaMode" class="theme-switch" aria-label="切换折线/堆叠" />
          <label class="theme-label">堆叠面积图</label>
        </div>
        <div ref="lineChartRef" class="chart chart-large"></div>
      </div>
      <div class="card chart-card">
        <div class="chart-card-controls left">
          <label class="theme-label">饼图</label>
          <input type="checkbox" v-model="pieIsRose" class="theme-switch" aria-label="切换饼图/玫瑰" />
          <label class="theme-label">玫瑰图</label>
        </div>
        <div ref="pieChartRef" class="chart chart-small"></div>
      </div>
    </div>
  </div>
</template>

<script setup>
import {computed, onBeforeUnmount, onMounted, ref, watch} from 'vue'
import * as echarts from 'echarts'
import {useSelectionStore} from '@/stores/selectionStore.js'
import axios from "@/utils/axios.js";

// ---- stores ----
const selectionStore = useSelectionStore()

// ---- state ----
const selectedCategoryId = ref(0)
const selectedFactory = ref('')
const selectedFactories = ref([])
const dimMode = ref('factory') // 'factory' | 'metric'

// selectedField now holds a field object {id, name_en, name_zh, unit, ...}
const selectedField = ref(null)
const selectedFields = ref([]) // array of field objects (each is {id,name_en,name_zh,unit})
const categoriesMeta = ref([]) // array of category objects

const now = new Date()
// Defaults: start = Jan current year, end = current month
const currentYear = now.getFullYear()
const currentMonth = now.getMonth() + 1

const startYearNum = ref(currentYear)
const startMonthNum = ref(1)
const endYearNum = ref(currentYear)
const endMonthNum = ref(currentMonth)

// Initialize year selects from selectionStore.years when available and keep values valid
watch(() => selectionStore.years, (yrs) => {
  if (!Array.isArray(yrs) || yrs.length === 0) return
  // normalize to numbers and compute min/max so we don't rely on order
  const nums = yrs.map(y => Number(y)).filter(n => !Number.isNaN(n))
  if (nums.length === 0) return
  const first = Math.min(...nums)
  const last = Math.max(...nums)
  if (!nums.includes(Number(startYearNum.value))) startYearNum.value = first
  if (!nums.includes(Number(endYearNum.value))) endYearNum.value = last
}, { immediate: true })

// computed YYYY-MM strings used by existing logic
const startMonth = computed({
  get() {
    return `${String(startYearNum.value).padStart(4,'0')}-${String(startMonthNum.value).padStart(2,'0')}`
  },
  set(v) {
    if (!v) return
    const [y,m] = (v||'').split('-').map(Number)
    if (!Number.isNaN(y)) startYearNum.value = y
    if (!Number.isNaN(m)) startMonthNum.value = m
  }
})
const endMonth = computed({
  get() {
    return `${String(endYearNum.value).padStart(4,'0')}-${String(endMonthNum.value).padStart(2,'0')}`
  },
  set(v) {
    if (!v) return
    const [y,m] = (v||'').split('-').map(Number)
    if (!Number.isNaN(y)) endYearNum.value = y
    if (!Number.isNaN(m)) endMonthNum.value = m
  }
})

// Visualization mode switches
const pieIsRose = ref(false) // false = normal pie by default
const areaMode = ref(false) // true = gradient stacked area, false = normal smooth line

// gradient color pairs used for stacked area chart (start/end)
const gradientPairs = [
  ['rgb(128, 255, 165)', 'rgb(1, 191, 236)'],
  ['rgb(0, 221, 255)', 'rgb(77, 119, 255)'],
  ['rgb(55, 162, 255)', 'rgb(116, 21, 219)'],
  ['rgb(255, 0, 135)', 'rgb(135, 0, 157)'],
  ['rgb(255, 191, 0)', 'rgb(224, 62, 76)']
]

// ---- refs ----
const lineChartRef = ref(null)
const pieChartRef = ref(null)
let lineChart = null
let pieChart = null
const monthlyCategories = ref([])
// dropdown open states for custom multi-selects
const factoriesOpen = ref(false)
const fieldsOpen = ref(false)
// debounce timers for scheduled renders
let lineRenderTimer = null
let pieRenderTimer = null
const availableFields = computed(() => {
  if (!selectedCategoryId.value) return []
  const meta = categoriesMeta.value.find(c => c.id === selectedCategoryId.value)
  if (!meta) return []
  return meta.fields || []
})

// expose computed binding for the checkbox switch
const isMetric = computed({
  get() { return dimMode.value === 'metric' },
  set(v) { dimMode.value = v ? 'metric' : 'factory' }
})

// close dropdowns when clicking outside
function onDocClick() {
  factoriesOpen.value = false
  fieldsOpen.value = false
}

function scheduleLineRender(delay = 250) {
  if (lineRenderTimer) clearTimeout(lineRenderTimer)
  lineRenderTimer = setTimeout(() => {
    try { renderLineChart() } catch (e) { /* ignore */ }
  }, delay)
}

function schedulePieRender(delay = 250) {
  if (pieRenderTimer) clearTimeout(pieRenderTimer)
  pieRenderTimer = setTimeout(() => {
    const pieBy = dimMode.value === 'factory' ? 'factory' : 'metric'
    try { renderPieChart(pieBy) } catch (e) { /* ignore */ }
  }, delay)
}

function showInfo(msg) {
  if (window && typeof window.showInfo === 'function') {
    window.showInfo(msg)
  } else {
    window.alert(msg)
  }
}

function monthListBetween(start, end) {
  const [sy, sm] = (start || '').split('-').map(Number)
  const [ey, em] = (end || '').split('-').map(Number)
  if (!sy || !ey) return []
  const res = []
  let y = sy, m = sm
  while (y < ey || (y === ey && m <= em)) {
    res.push({year: y, month: m, label: `${y}-${String(m).padStart(2, '0')}`})
    m++
    if (m > 12) {
      m = 1;
      y++
    }
  }
  return res
}

function monthIndex(month) {
  return month - 1
}

function safeValueFromRow(val, year, month) {
  if (val == null) return null
  if (Array.isArray(val)) {
    const idx = monthIndex(month)
    return typeof val[idx] !== 'undefined' ? val[idx] : null
  }
  if (typeof val === 'object') {
    const idx1 = String(month)
    const idx2 = String(month).padStart(2, '0')
    if (val[idx1] != null) return val[idx1]
    if (val[idx2] != null) return val[idx2]
    const keyYMD = `${year}-${String(month).padStart(2, '0')}`
    if (val[keyYMD] != null) return val[keyYMD]
  }
  return null
}

async function fetchBatchData({ categoryId, factories = [], fieldIds = [], years = [] }) {
  const numericFields = Array.isArray(fieldIds) ? fieldIds.map(id => Number(id)) : []
  const payload = { category_id: categoryId, factories, fields: numericFields, years }
  const response = await axios.post('/data-analysis', payload)
  if (!response || !response.data || !Array.isArray(response.data.fields)) {
    throw new Error('后端批量查询接口返回空或失败')
  }
  const fieldMap = {}
  for (const f of response.data.fields) {
    const id = String(f.id)
    const meta = { id: f.id, name_en: f.name_en, name_zh: f.name_zh, unit: f.unit, step: f.step }
    const rows = {}
    if (Array.isArray(f.values)) {
      for (const r of f.values) {
        const yk = String(r.year)
        if (!rows[yk]) rows[yk] = {}
        const fac = r.factory == null ? '' : String(r.factory)
        rows[yk][fac] = r.value
      }
    }
    fieldMap[id] = { meta, rows }
  }
  return { raw: response.data, fieldMap }
}

// removed per-year fallback: batch API required by frontend now

async function initFields() {
  try {
    const response = await axios.get('/data-analysis/categories')
    if (response && response.data) {
      categoriesMeta.value = response.data.categories
      monthlyCategories.value = response.data.categories.map(c => ({ id: c.id, name_en: c.name_en, name_zh: c.name_zh }))
      if (monthlyCategories.value.length > 0) {
        selectedCategoryId.value = monthlyCategories.value[0].id
        const firstField = (categoriesMeta.value[0].fields && categoriesMeta.value[0].fields[0]) || null
        if (firstField) {
          selectedField.value = firstField
          selectedFields.value = [firstField]
        }
      }
    } else {
      monthlyCategories.value = []
      selectedCategoryId.value = 0
      selectedField.value = null
      selectedFields.value = []
    }
  } catch (e) {
    console.warn('initFields failed', e)
    monthlyCategories.value = []
  }
}

// when user changes category, reset selectedField / selectedFields to first available
watch(selectedCategoryId, (nv) => {
  const meta = categoriesMeta.value.find(c => c.id === nv)
  if (meta && meta.fields && meta.fields.length) {
    selectedField.value = meta.fields[0]
    selectedFields.value = [meta.fields[0]]
  } else {
    selectedField.value = null
    selectedFields.value = []
  }
})

// keep selections in sync when user toggles dimMode
watch(dimMode, (mode) => {
  if (mode === 'metric') {
    if ((!selectedFactory.value || !selectionStore.factories.includes(selectedFactory.value)) && selectedFactories.value.length) {
      selectedFactory.value = selectedFactories.value[0]
    }
    if (!selectedFields.value.length && selectedField.value) selectedFields.value = [selectedField.value]
  } else {
    if (selectedFactory.value && !selectedFactories.value.includes(selectedFactory.value)) {
      selectedFactories.value = [selectedFactory.value]
    }
    if (!selectedField.value && selectedFields.value.length) selectedField.value = selectedFields.value[0]
  }
})

// renderers: update to use selectedField.id and selectedFields[].id
async function renderLineChart() {
  const months = monthListBetween(startMonth.value, endMonth.value)
  if (!months.length) { showInfo('时间区间不正确'); return }

  const years = Array.from(new Set(months.map(m => m.year)))

  if (dimMode.value === 'factory') {
    const factoryList = selectedFactories.value
    if (!factoryList || factoryList.length === 0) { showInfo('请先选择至少一个工厂'); return }
    if (!selectedField.value) { showInfo('请先选择指标'); return }

    // try batch fetch: multiple factories, single metric -> one request per year
    const metricId = String(selectedField.value.id)
    const metricName = selectedField.value.name_zh || metricId

    // attempt strict batch (will throw if backend returns nothing)
    let batch
    try {
      batch = await fetchBatchData({ categoryId: selectedCategoryId.value, factories: factoryList, fieldIds: [metricId], years })
    } catch (err) {
      showInfo('批量查询失败：' + (err.message || '后端返回错误'))
      return
    }
    const series = []
    for (const f of factoryList) {
      const points = []
      for (const mo of months) {
        let v = null
        try {
          // backend returns fields array; fetchBatchData builds fieldMap and returned as batch.fieldMap
          const map = batch.fieldMap && batch.fieldMap[metricId]
          const rowVal = map && map.rows && map.rows[String(mo.year)] && map.rows[String(mo.year)][String(f)]
          v = rowVal == null ? null : safeValueFromRow(rowVal, mo.year, mo.month)
        } catch (e) { v = null }
        points.push(v == null ? null : Number(v))
      }
      series.push({ name: f, data: points })
    }

    let option
    if (!areaMode.value) {
      option = {
        title: { text: `折线 - ${metricName}` },
        tooltip: { trigger: 'axis' },
        legend: { data: series.map(s => s.name), type: 'scroll' },
        xAxis: { type: 'category', data: months.map(m => m.label) },
        yAxis: { type: 'value' },
        series: series.map(s => ({ name: s.name, type: 'line', data: s.data, smooth: true }))
      }
    } else {
      // gradient stacked area
      const colorList = gradientPairs.map(p => p[0])
      option = {
        color: colorList,
        title: { text: `渐变堆叠面积 - ${metricName}` },
        tooltip: { trigger: 'axis', axisPointer: { type: 'cross' } },
        legend: { data: series.map(s => s.name) },
        toolbox: { feature: { saveAsImage: {} } },
        xAxis: [{ type: 'category', boundaryGap: false, data: months.map(m => m.label) }],
        yAxis: [{ type: 'value' }],
        series: series.map((s, idx) => {
          const gp = gradientPairs[idx % gradientPairs.length]
          return {
            name: s.name,
            type: 'line',
            stack: 'Total',
            smooth: true,
            lineStyle: { width: 0 },
            showSymbol: false,
            areaStyle: {
              opacity: 0.8,
              color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                { offset: 0, color: gp[0] },
                { offset: 1, color: gp[1] }
              ])
            },
            emphasis: { focus: 'series' },
            data: s.data
          }
        })
      }
    }
    if (!lineChart && lineChartRef.value) lineChart = echarts.init(lineChartRef.value)
    if (lineChart) {
      lineChart.clear()
      lineChart.setOption(option)
    }

  } else {
    // metric mode: single factory, multiple metrics
    const factory = selectedFactory.value || (selectionStore.factories[0] || '')
    if (!factory) { showInfo('请先选择工厂'); return }
    const metrics = selectedFields.value.length ? selectedFields.value : (selectedField.value ? [selectedField.value] : [])
    if (!metrics.length) { showInfo('请先选择至少一个指标'); return }

    // prepare metric ids
    const metricIds = metrics.map(m => String(m.id))
    const batch = await fetchBatchData({ categoryId: selectedCategoryId.value, factories: [factory], fieldIds: metricIds, years })

    const series = []
    for (const metric of metrics) {
      const points = []
      for (const mo of months) {
        let v = null
        try {
          const map = batch.fieldMap && batch.fieldMap[String(metric.id)]
          const rowVal = map && map.rows && map.rows[String(mo.year)] && map.rows[String(mo.year)][String(factory)]
          v = rowVal == null ? null : safeValueFromRow(rowVal, mo.year, mo.month)
        } catch (e) { v = null }
        points.push(v == null ? null : Number(v))
      }
      series.push({ name: metric.name_zh || String(metric.id), data: points })
    }

    let option
    if (!areaMode.value) {
      option = {
        title: { text: `折线 - 指标对比 (${factory})` },
        tooltip: { trigger: 'axis' },
        legend: { data: series.map(s => s.name), type: 'scroll' },
        xAxis: { type: 'category', data: months.map(m => m.label) },
        yAxis: { type: 'value' },
        series: series.map(s => ({ name: s.name, type: 'line', data: s.data, smooth: true }))
      }
    } else {
      // gradient stacked area
      const colorList = gradientPairs.map(p => p[0])
      option = {
        color: colorList,
        title: { text: `渐变堆叠面积 - 指标对比 (${factory})` },
        tooltip: { trigger: 'axis', axisPointer: { type: 'cross' } },
        legend: { data: series.map(s => s.name) },
        toolbox: { feature: { saveAsImage: {} } },
        xAxis: [{ type: 'category', boundaryGap: false, data: months.map(m => m.label) }],
        yAxis: [{ type: 'value' }],
        series: series.map((s, idx) => {
          const gp = gradientPairs[idx % gradientPairs.length]
          return {
            name: s.name,
            type: 'line',
            stack: 'Total',
            smooth: true,
            lineStyle: { width: 0 },
            showSymbol: false,
            areaStyle: {
              opacity: 0.8,
              color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                { offset: 0, color: gp[0] },
                { offset: 1, color: gp[1] }
              ])
            },
            emphasis: { focus: 'series' },
            data: s.data
          }
        })
      }
    }

    if (!lineChart && lineChartRef.value) lineChart = echarts.init(lineChartRef.value)
    if (lineChart) {
      lineChart.clear()
      lineChart.setOption(option)
    }
  }
}

async function renderPieChart(pieBy) {
  const months = monthListBetween(startMonth.value, endMonth.value)
  if (!months.length) { showInfo('时间区间不正确'); return }

  if (pieBy === 'factory') {
    const metric = selectedField.value
    if (!metric) { showInfo('请先选择指标'); return }
    const metricId = String(metric.id)
    const metricName = metric.name_zh || metricId
    const factoryList = selectedFactories.value
    if (!factoryList || factoryList.length === 0) { showInfo('请先选择至少一个工厂'); return }

    // try batch
    const years = Array.from(new Set(monthListBetween(startMonth.value, endMonth.value).map(m => m.year)))
    const batch = await fetchBatchData({ categoryId: selectedCategoryId.value, factories: factoryList, fieldIds: [metricId], years })

    const values = []
    for (const f of factoryList) {
      let sum = 0
      for (const mo of months) {
        try {
          const map = batch.fieldMap && batch.fieldMap[metricId]
          const rowVal = map && map.rows && map.rows[String(mo.year)] && map.rows[String(mo.year)][String(f)]
          const v = rowVal == null ? 0 : Number(safeValueFromRow(rowVal, mo.year, mo.month) || 0)
          sum += v
        } catch (e) { /* ignore */ }
      }
      values.push({ name: f, value: sum })
    }

    let option
    if (pieIsRose.value) {
      option = {
        title: { text: `南丁格尔玫瑰 - 工厂占比 (${metricName})`, left: 'center' },
        tooltip: { trigger: 'item', formatter: '{b}<br/>{c} ({d}%)' },
        legend: { bottom: '6%', left: 'center' },
        toolbox: { show: true, feature: { saveAsImage: { show: true } } },
        series: [
          {
            name: metricName,
            type: 'pie',
            radius: ['20%', '65%'],
            center: ['50%', '50%'],
            roseType: 'area',
            avoidLabelOverlap: false,
            itemStyle: { borderRadius: 6 },
            label: { show: true, formatter: '{b}: {c}' },
            emphasis: { label: { show: true } },
            data: values
          }
        ]
      }
    } else {
      option = {
        title: { text: `饼图 - 工厂占比 (${metricName})`, left: 'center' },
        tooltip: { trigger: 'item', formatter: '{b}<br/>{c} ({d}%)' },
        legend: { bottom: '6%', left: 'center' },
        toolbox: { show: true, feature: { saveAsImage: { show: true } } },
        series: [
          {
            name: metricName,
            type: 'pie',
            radius: '50%',
            center: ['50%', '50%'],
            itemStyle: { borderRadius: 6 },
            label: { show: true, formatter: '{b}: {c}' },
            data: values
          }
        ]
      }
    }
    if (!pieChart && pieChartRef.value) pieChart = echarts.init(pieChartRef.value)
    if (pieChart) {
      pieChart.clear()
      pieChart.setOption(option)
    }

  } else {
    // metric mode
    const metrics = selectedFields.value.length ? selectedFields.value : (selectedField.value ? [selectedField.value] : [])
    if (!metrics.length) { showInfo('请先选择指标列表'); return }
    const factory = selectedFactory.value || (selectionStore.factories[0] || '')
    if (!factory) { showInfo('请先选择工厂'); return }

    // check units using field objects
    const unitMap = new Map()
    for (const m of metrics) {
      const uid = String(m.id)
      unitMap.set(uid, { name: m.name_zh || String(m.id), unit: m.unit || '（无单位）' })
    }
    const unitsSet = new Set(Array.from(unitMap.values()).map(x => x.unit))
    if (unitsSet.size > 1) {
      const rows = Array.from(unitMap.entries()).map(([id, info]) => `${info.name} (${id}) : ${info.unit}`)
      showInfo('选中指标单位不一致：\n' + rows.join('\n'))
      return
    }

    // batch fetch sums per metric for the factory
    const years = Array.from(new Set(months.map(m => m.year)))
    const metricIds = metrics.map(m => String(m.id))
    const batch = await fetchBatchData({ categoryId: selectedCategoryId.value, factories: [factory], fieldIds: metricIds, years })

    const values = []
    for (const metric of metrics) {
      let sum = 0
      for (const mo of months) {
        // v not needed here; compute vv directly
         try {
           const map = batch.fieldMap && batch.fieldMap[String(metric.id)]
           const rowVal = map && map.rows && map.rows[String(mo.year)] && map.rows[String(mo.year)][String(factory)]
           const vv = rowVal == null ? 0 : Number(safeValueFromRow(rowVal, mo.year, mo.month) || 0)
           sum += vv
         } catch (e) { /* ignore */ }
       }
       values.push({ name: metric.name_zh || String(metric.id), value: sum })
     }
     const unitLabel = Array.from(unitsSet)[0]
     let option2
     if (pieIsRose.value) {
       option2 = {
         title: { text: `南丁格尔玫瑰 - 指标占比 （单位: ${unitLabel}）`, left: 'center' },
         tooltip: { trigger: 'item', formatter: '{b}<br/>{c} ({d}%)' },
         legend: { bottom: '6%', left: 'center' },
         toolbox: { show: true, feature: { saveAsImage: { show: true } } },
         series: [
           {
             name: unitLabel,
             type: 'pie',
             radius: ['20%', '65%'],
             center: ['50%', '50%'],
             roseType: 'area',
             avoidLabelOverlap: false,
             itemStyle: { borderRadius: 6 },
             label: { show: true, formatter: '{b}: {c}' },
             emphasis: { label: { show: true } },
             data: values
           }
         ]
       }
     } else {
       option2 = {
         title: { text: `饼图 - 指标占比 （单位: ${unitLabel}）`, left: 'center' },
         tooltip: { trigger: 'item', formatter: '{b}<br/>{c} ({d}%)' },
         legend: { bottom: '6%', left: 'center' },
         toolbox: { show: true, feature: { saveAsImage: { show: true } } },
         series: [
           {
             name: unitLabel,
             type: 'pie',
             radius: '50%',
             center: ['50%', '50%'],
             itemStyle: { borderRadius: 6 },
             label: { show: true, formatter: '{b}: {c}' },
             data: values
           }
         ]
       }
     }
     if (!pieChart && pieChartRef.value) pieChart = echarts.init(pieChartRef.value)
     if (pieChart) {
       pieChart.clear()
       pieChart.setOption(option2)
     }
   }
 }

function handleResize() {
  if (lineChart) lineChart.resize()
  if (pieChart) pieChart.resize()
}

onMounted(async () => {
  try {
    await selectionStore.initSelection()
  } catch (e) { /* ignore */
  }

  await initFields();
  if (selectionStore.factories && selectionStore.factories.length) {
    selectedFactory.value = selectionStore.factories[0]
    selectedFactories.value = [selectionStore.factories[0]]
  }

  // ensure charts exist and listen to resize
  if (lineChartRef.value) lineChart = echarts.init(lineChartRef.value)
  if (pieChartRef.value) pieChart = echarts.init(pieChartRef.value)
  window.addEventListener('resize', handleResize)
  document.addEventListener('click', onDocClick)
})

onBeforeUnmount(() => {
  window.removeEventListener('resize', handleResize)
  document.removeEventListener('click', onDocClick)
  if (lineChart) {
    lineChart.dispose();
    lineChart = null
  }
  if (pieChart) {
    pieChart.dispose();
    pieChart = null
  }
})

// watchers: auto render when user toggles visualization switches
watch(areaMode, () => {
  // re-render line chart immediately with current selections
  scheduleLineRender(50)
})

watch(pieIsRose, () => {
  // re-render pie chart immediately according to current dimMode
  schedulePieRender(50)
})

// When dimMode changes (factory <-> metric) re-render both charts
watch(dimMode, () => {
  scheduleLineRender(50)
  schedulePieRender(80)
})

// auto render when selections change
watch([selectedFactories, selectedFactory, selectedField, selectedFields, startMonth, endMonth, selectedCategoryId], () => {
  scheduleLineRender()
  schedulePieRender()
}, { deep: true })

// ---- methods for reset buttons ----
function resetFactorySingle() {
  selectedFactory.value = (selectionStore.factories && selectionStore.factories.length) ? selectionStore.factories[0] : ''
  factoriesOpen.value = false
}

function resetFactoryMulti() {
  selectedFactories.value = (selectionStore.factories && selectionStore.factories.length) ? [selectionStore.factories[0]] : []
  factoriesOpen.value = false
}

function resetFieldSingle() {
  selectedField.value = (categoriesMeta.value[0].fields) ? (categoriesMeta.value[0].fields[0]) : null
  fieldsOpen.value = false
}

function resetFieldMulti() {
  selectedFields.value = (categoriesMeta.value[0].fields) ? [categoriesMeta.value[0].fields[0]] : []
  fieldsOpen.value = false
}
</script>

<style scoped>
.data-analysis-page {
  padding: 18px;
}

.controls {
  background:  #ffffff;
  padding: 14px 16px;
  border-radius: 10px;
  box-shadow: 0 6px 18px rgba(31, 41, 55, 0.06);
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.control-row {
  display: flex;
  align-items: center;
  gap: 10px; /* slightly tighter */
}
.control-row--top {
  justify-content: flex-start;
  align-items: center;
  gap: 18px;
}

.control-label {
  font-weight: 700;
  margin-right: 8px;
  color: #222;
  display: inline-block;
  min-width: 64px;
  font-size: 20px;
}

.time-inputs { display:flex; gap:8px; align-items:center }
.small-select { padding:6px 8px; border-radius:6px; border:1px solid #e5e7eb; background:#fff }
.full-select { width: 260px; padding:8px 10px; border-radius:8px; border:1px solid #e5e7eb }
.selectors-row { display:flex; gap:16px; }
.selector-col { flex: 1; display:flex; flex-direction:column; gap:6px; }

.category-group { display:flex; flex-direction:column; gap:6px; }

.dim-switch-wrap { display:inline-flex; align-items:center; gap:8px }

.theme-label { font-size: 15px }

/* Button styles removed (UI auto-renders; buttons were deleted) */

/* Vertical grid: stacked charts */
.grid.vertical-grid { display:grid; grid-template-columns: 1fr; grid-auto-rows: auto; gap: 16px; margin-top:16px }
.chart { width:100%; border-radius:8px; background: #fff }
.chart-large { height: 420px }
.chart-small { height: 320px }

.tilde { margin: 0 6px; color:#666 }

.theme-switch { width: 44px; height: 24px; -webkit-appearance: none; appearance: none; border-radius: 12px; background: #dcdcdc; display: inline-block; vertical-align: middle; position: relative; outline: none; cursor: pointer; transition: background .18s }
.theme-switch:after { content: ''; position: absolute; top: 2px; left: 2px; width: 20px; height: 20px; background: #fff; border-radius: 50%; transition: transform .18s }
.theme-switch:checked { background: #2d8cf0 }
.theme-switch:checked:after { transform: translateX(20px) }

/* Card appearance */
.card { padding: 10px; background: transparent }
.chart-card { position: relative; }
.chart-card-controls {
  position: absolute;
  top: 10px;
  right: 10px;
  display: flex;
  align-items: center;
  gap: 8px;
  z-index: 10;
}
.chart-card-controls.left {
  top: 10px;
  left: 10px;
  right: auto;
}

/* Add styles for dropdowns */
.multi-dropdown {
  position: relative;
  width: 260px;
  height: fit-content;
}
.single-dropdown {
  position: relative;
  width: 260px;
  height: fit-content;
}
.dropdown-btn {
  width: 100%;
  padding: 8px 10px;
  border: 1px solid #e5e7eb;
  border-radius: 8px;
  background: #fff;
  text-align: left;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: space-between;
}
.dropdown-btn .caret {
  transition: transform .18s;
}
.dropdown-panel {
  position: absolute;
  top: 100%;
  left: 0;
  right: 0;
  z-index: 100;
  background: #fff;
  border: 1px solid #e5e7eb;
  border-radius: 8px;
  padding: 8px 0;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  max-height: 300px;
  overflow-y: auto;
}
.dropdown-panel label {
  padding: 8px 10px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: space-between;
}
.dropdown-panel label { color: #111827 }
.dropdown-panel label:hover {
  background: #f9fafb;
}
.dropdown-panel .chk-input {
  margin-left: 8px; /* keep checkbox on right */
  margin-right: 0;
  width: 18px;
  height: 18px;
}
.dropdown-panel .radio-input {
  margin-left: 8px;
  margin-right: 0;
  width: 18px;
  height: 18px;
}
.dropdown-panel .chk-text { flex: 1; }

/* Small, subtle clear link in dropdown header */
.dropdown-panel-header { display:flex; justify-content:flex-end; padding:6px 8px }
.dropdown-panel-header .link {
  background: transparent;
  border: none;
  color: #9ca3af; /* slightly lighter gray */
  cursor: pointer;
  padding: 0 3px;
  font-size: 12px;
  line-height: 2;
  border-radius: 4px;
}
.dropdown-panel-header .link:hover { color: #6b7280; background: rgba(55,65,81,0.03) }

/* Ensure dropdown button / selected text is always readable */
.dropdown-btn { color: #111827 !important; }
.dropdown-btn span { color: #111827 !important }
.dropdown-btn .muted { color: #6b7280 !important }
.dropdown-btn:focus { outline: none }

/* Style selected option so text is readable even if theme changes elsewhere */
/* Use :has() to detect checked inputs inside label (modern browsers) */
.dropdown-panel label:has(input:checked) {
  background: rgba(59,130,246,0.08) !important;
}
.dropdown-panel label:has(input:checked) .chk-text {
  color: #0f172a !important; /* strong dark text */
  font-weight: 600;
}

/* Force label text color to be readable regardless of outer theme overrides */
.dropdown-panel label .chk-text {
  color: #111827 !important;
}

/* Fallback for browsers not supporting :has(): ensure radio/checkbox visible */
/* force inputs to be visible */
.dropdown-panel input[type="radio"], .dropdown-panel input[type="checkbox"] {
  accent-color: #2563eb;
}

/* Pills */
.pill { display:inline-block; background:#eef6ff; color:#0366d6; padding:4px 10px; border-radius:999px; margin-right:6px; font-size:13px }

/* Responsive adjustments */
@media (max-width: 900px) {
  .selectors-row { flex-direction: column }
  .full-select { width: 100% }
}
</style>
