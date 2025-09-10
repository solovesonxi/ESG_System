```vue
<template>
  <div class="shared-form">
    <form>
      <fieldset>
        <legend>基础信息</legend>
        <div class="form-row">
          <div class="form-group">
            <label>工厂名称</label>
            <div class="custom-select">
              <div class="selected" @click="selectionStore.toggleFactoryDropdown">
                {{ factory }}
                <i class="arrow" :class="{ 'up': selectionStore.showFactoryDropdown }"></i>
              </div>
              <div class="options" v-show="selectionStore.showFactoryDropdown"
                   :style="{ maxHeight: '200px', overflowY: 'auto' }">
                <div
                    v-for="f in selectionStore.factories"
                    :key="f"
                    class="option"
                    :class="{ 'selected-option': f === factory }"
                    @click="selectionStore.selectFactory(f)"
                >
                  {{ f }}
                </div>
              </div>
            </div>
          </div>
          <div class="form-group">
            <label>统计年份</label>
            <div class="custom-select">
              <div class="selected" @click="selectionStore.toggleYearDropdown">
                {{ year }}年
                <i class="arrow" :class="{ 'up': selectionStore.showYearDropdown }"></i>
              </div>
              <div class="options" v-show="selectionStore.showYearDropdown">
                <div
                    v-for="y in selectionStore.years"
                    :key="y"
                    class="option"
                    :class="{ 'selected-option': y === year }"
                    @click="selectionStore.selectYear(y)"
                >
                  {{ y }}年
                </div>
              </div>
            </div>
          </div>
          <div class="form-group">
            <label>统计月份</label>
            <div class="custom-select">
              <div class="selected" @click="selectionStore.toggleMonthDropdown">
                {{ month }}月
                <i class="arrow" :class="{ 'up': selectionStore.showMonthDropdown }"></i>
              </div>
              <div class="options" v-show="selectionStore.showMonthDropdown">
                <div
                    v-for="m in selectionStore.months"
                    :key="m"
                    class="option"
                    :class="{ 'selected-option': m === month }"
                    @click="selectionStore.selectMonth(m)"
                >
                  {{ m }}月
                </div>
              </div>
            </div>
          </div>
        </div>
      </fieldset>

      <!-- 产品责任数据部分（样式与能源统计保持一致） -->
      <fieldset class="summary-fieldset">
        <legend>产品责任数据统计</legend>

        <div class="loading" v-if="isLoading">数据加载中...</div>

        <div v-else>
          <!-- 客户投诉统计 -->
          <fieldset>
            <legend>{{ year }}年客户投诉统计 (件)</legend>
            <div class="monthly-grid">
              <div v-for="(_, index) in formData.complaints" :key="'cmp-'+index" class="month-input">
                <label>{{ getMonthName(index) }}</label>
                <input
                  type="number"
                  v-model.number="formData.complaints[index]"
                  :placeholder="`${getMonthName(index)}投诉件数`"
                  min="0"
                  step="1"
                  :readonly="!isEditing"
                  :class="{ 'editable-field': isEditing }"
                  required
                >
              </div>
              <div class="month-input">
                <label>有效处理件数</label>
                <input
                  type="number"
                  v-model.number="formData.handled"
                  placeholder="有效处理件数"
                  min="0"
                  step="1"
                  :readonly="!isEditing"
                  :class="{ 'editable-field': isEditing }"
                  required
                >
              </div>
              <div class="month-input">
                <label>合计</label>
                <input type="number" :value="complaintsTotal" disabled class="calculated-field">
              </div>
              <div class="month-input">
                <label>有效处理率 (%)</label>
                <input type="number" :value="handledRate" disabled class="calculated-field">
              </div>
            </div>
          </fieldset>

          <!-- 产品安全质量问题 -->
          <fieldset>
            <legend>{{ year }}年产品安全质量问题 (次)</legend>
            <div class="monthly-grid">
              <div v-for="(_, index) in formData.qualityIssues" :key="'qual-'+index" class="month-input">
                <label>{{ getMonthName(index) }}</label>
                <input
                  type="number"
                  v-model.number="formData.qualityIssues[index]"
                  :placeholder="`${getMonthName(index)}质量问题`"
                  min="0"
                  step="1"
                  :readonly="!isEditing"
                  :class="{ 'editable-field': isEditing }"
                  required
                >
              </div>
              <div class="month-input">
                <label>合计</label>
                <input type="number" :value="qualityIssuesTotal" disabled class="calculated-field">
              </div>
            </div>
          </fieldset>

          <!-- 产品召回统计 -->
          <fieldset>
            <legend>{{ year }}年产品召回统计 (次)</legend>
            <div class="monthly-grid">
              <div v-for="(_, index) in formData.recalls" :key="'rec-'+index" class="month-input">
                <label>{{ getMonthName(index) }}</label>
                <input
                  type="number"
                  v-model.number="formData.recalls[index]"
                  :placeholder="`${getMonthName(index)}召回次数`"
                  min="0"
                  step="1"
                  :readonly="!isEditing"
                  :class="{ 'editable-field': isEditing }"
                  required
                >
              </div>
              <div class="month-input">
                <label>出货总批次</label>
                <input
                  type="number"
                  v-model.number="formData.shipments"
                  placeholder="出货总批次"
                  min="0"
                  step="1"
                  :readonly="!isEditing"
                  :class="{ 'editable-field': isEditing }"
                  required
                >
              </div>
              <div class="month-input">
                <label>合计</label>
                <input type="number" :value="recallsTotal" disabled class="calculated-field">
              </div>
              <div class="month-input">
                <label>召回百分比 (%)</label>
                <input type="number" :value="recallRate" disabled class="calculated-field">
              </div>
            </div>
          </fieldset>

          <!-- 客户满意度统计 -->
          <fieldset>
            <legend>{{ year }}年客户满意度统计 - 总部统一调查 (%)</legend>
            <div class="monthly-grid">
              <div v-for="(_, index) in formData.customerSatisfaction" :key="'csat-'+index" class="month-input">
                <label>{{ getMonthName(index) }}</label>
                <input
                  type="number"
                  v-model.number="formData.customerSatisfaction[index]"
                  :placeholder="`${getMonthName(index)}满意度`"
                  min="0"
                  max="100"
                  step="0.01"
                  :readonly="!isEditing"
                  :class="{ 'editable-field': isEditing }"
                  required
                >
              </div>
              <div class="month-input">
                <label>平均值</label>
                <input type="number" :value="customerSatisfactionAverage" disabled class="calculated-field">
              </div>
            </div>
          </fieldset>

          <!-- 网络数据安全事件 -->
          <fieldset>
            <legend>{{ year }}年网络数据安全事件 (次)</legend>
            <div class="monthly-grid">
              <div v-for="(_, index) in formData.cyberIncidents" :key="'cyb-'+index" class="month-input">
                <label>{{ getMonthName(index) }}</label>
                <input
                  type="number"
                  v-model.number="formData.cyberIncidents[index]"
                  :placeholder="`${getMonthName(index)}安全事件`"
                  min="0"
                  step="1"
                  :readonly="!isEditing"
                  :class="{ 'editable-field': isEditing }"
                  required
                >
              </div>
              <div class="month-input">
                <label>合计</label>
                <input type="number" :value="cyberIncidentsTotal" disabled class="calculated-field">
              </div>
            </div>
          </fieldset>
        </div>
      </fieldset>
    </form>
  </div>
</template>

<script setup>
import { computed, onBeforeUnmount, onMounted, reactive, ref, watch } from 'vue'
import { useSelectionStore } from '@/stores/selectionStore'
import apiClient from '@/utils/axios'

// —— 与能源统计保持一致的状态 —— //
const selectionStore = useSelectionStore()
const factory = computed(() => selectionStore.selectedFactory)
const year = computed(() => selectionStore.selectedYear);
const month = computed(() => selectionStore.selectedMonth);

const isEditing = ref(false)
const isLoading = ref(false)

// 月份名称映射 & 工具函数（与能源一致）
const monthNames = ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月']
const getMonthName = (index) => monthNames[index]

// —— 产品责任数据 —— //
const formData = reactive({
  complaints: Array(12).fill(0),
  handled: 0,
  qualityIssues: Array(12).fill(0),
  recalls: Array(12).fill(0),
  shipments: 0,
  customerSatisfaction: Array(12).fill(0),
  cyberIncidents: Array(12).fill(0)
})

// —— 汇总与计算（保持原逻辑与命名） —— //
const toNum = (v, d = 0) => {
  const n = Number(v)
  return Number.isFinite(n) ? n : d
}

const rowSum = (arr) => arr.reduce((s, v) => s + toNum(v), 0)
const percent = (num, den) => {
  const n = toNum(num)
  const d = toNum(den)
  return d > 0 ? ((n / d) * 100).toFixed(2) : 0
}
const averageRow = (arr) => (rowSum(arr) / 12).toFixed(2)

const complaintsTotal = computed(() => rowSum(formData.complaints))
const handledRate = computed(() => percent(formData.handled, complaintsTotal.value))
const qualityIssuesTotal = computed(() => rowSum(formData.qualityIssues))
const recallsTotal = computed(() => rowSum(formData.recalls))
const recallRate = computed(() => percent(recallsTotal.value, formData.shipments))
const customerSatisfactionAverage = computed(() => averageRow(formData.customerSatisfaction))
const cyberIncidentsTotal = computed(() => rowSum(formData.cyberIncidents))

// —— 与能源统计保持一致：监听工厂/年份变化并拉取数据 —— //
watch([factory, year], () => {
  fetchData()
})

onMounted(() => {
  document.addEventListener('click', selectionStore.handleClickOutside)
  // 首次进入拉取一次
  fetchData()
})

onBeforeUnmount(() => {
  document.removeEventListener('click', selectionStore.handleClickOutside)
})

// —— 获取数据（与能源统计风格相同） —— //
const fetchData = async () => {
  if (!factory.value || !year.value) {
    resetFormData()
    return
  }
  isLoading.value = true
  try {
    const resp = await apiClient.get('/quantitative/responsibility', {
      params: { factory: factory.value, year: year.value }
    })
    const data = resp?.data?.data
    if (data) {
      // 兼容后端下划线/驼峰
      setArray(formData.complaints, data.complaints || data.complaints_count || Array(12).fill(0))
      formData.handled = toNum(data.handled || data.handled_count)
      setArray(formData.qualityIssues, data.qualityIssues || data.quality_issues || Array(12).fill(0))
      setArray(formData.recalls, data.recalls || data.recall_count || Array(12).fill(0))
      formData.shipments = toNum(data.shipments || data.shipment_count)
      setArray(formData.customerSatisfaction, data.customerSatisfaction || data.customer_satisfaction || Array(12).fill(0))
      setArray(formData.cyberIncidents, data.cyberIncidents || data.cyber_incidents || Array(12).fill(0))
    } else {
      resetFormData()
    }
  } catch (err) {
    if (err.response?.status === 404) {
      resetFormData()
    } else {
      console.error('获取产品责任数据失败:', err)
      resetFormData()
    }
  } finally {
    isLoading.value = false
  }
}

const setArray = (reactiveArr, sourceArr) => {
  for (let i = 0; i < 12; i++) reactiveArr[i] = toNum(sourceArr?.[i] ?? 0)
}

// —— 重置（与能源一致的重置思路） —— //
const resetFormData = () => {
  setArray(formData.complaints, Array(12).fill(0))
  formData.handled = 0
  setArray(formData.qualityIssues, Array(12).fill(0))
  setArray(formData.recalls, Array(12).fill(0))
  formData.shipments = 0
  setArray(formData.customerSatisfaction, Array(12).fill(0))
  setArray(formData.cyberIncidents, Array(12).fill(0))
}

// —— 提交编辑（保持原字段，不改动内容，只改样式） —— //
const submitEdit = async () => {
  if (!factory.value) {
    alert('请选择工厂名称')
    return
  }
  try {
    const payload = {
      factory: factory.value,
      year: Number(year.value),
      complaints: [...formData.complaints],
      handled: formData.handled,
      qualityIssues: [...formData.qualityIssues],
      recalls: [...formData.recalls],
      shipments: formData.shipments,
      customerSatisfaction: [...formData.customerSatisfaction],
      cyberIncidents: [...formData.cyberIncidents],
      complaintsTotal: complaintsTotal.value,
      handledRate: handledRate.value,
      qualityIssuesTotal: qualityIssuesTotal.value,
      recallsTotal: recallsTotal.value,
      recallRate: recallRate.value,
      customerSatisfactionAverage: customerSatisfactionAverage.value,
      cyberIncidentsTotal: cyberIncidentsTotal.value
    }

    const resp = await apiClient.post('/quantitative/responsibility', payload)
    if (resp.data?.status === 'success') {
      alert('产品责任数据提交成功!')
    }
  } catch (err) {
    console.error('提交失败:', err)
    alert(`提交失败: ${err.response?.data?.detail || err.message}`)
  } finally {
    // 与能源一致：提交后退出编辑并刷新
    isEditing.value = false
    await fetchData()
  }
}

// —— 暴露方法，与能源统计完全一致 —— //
defineExpose({
  startEditing: () => (isEditing.value = true),
  cancelEditing: () => {
    isEditing.value = false
    fetchData()
  },
  submitEdit,
  fetchData
})
</script>
```