<template>
  <div class="shared-form">
    <form>
      <BaseInfoSelector :review="review" form-type="responsibility" @selection-changed="fetchData"/>
      <fieldset class="summary-fieldset">
        <legend>产品责任数据统计</legend>
        <div class="loading" v-if="isLoading">数据加载中...</div>
        <div v-else>
          <div class="form-row">
            <div class="form-group">
              <label>客户投诉统计 (件)</label>
              <input type="number" v-model.number="formData.complaints[month-1]" min="0" step="1"
                     :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
            </div>
            <div class="form-group">
              <label>有效处理件数 (件)</label>
              <input type="number" v-model.number="formData.handled[month-1]" min="0" step="1" :readonly="!isEditing"
                     :class="{ 'editable-field': isEditing }" required>
            </div>
            <div class="form-group">
              <label>产品安全质量问题 (次)</label>
              <input type="number" v-model.number="formData.qualityIssues[month-1]" min="0" step="1"
                     :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
            </div>
            <div class="form-group">
              <label>产品召回统计 (次)</label>
              <input type="number" v-model.number="formData.recalls[month-1]" min="0" step="1" :readonly="!isEditing"
                     :class="{ 'editable-field': isEditing }" required>
            </div>
            <div class="form-group">
              <label>出货批次 (次)</label>
              <input type="number" v-model.number="formData.shipments[month-1]" min="0" step="1" :readonly="!isEditing"
                     :class="{ 'editable-field': isEditing }" required>
            </div>
            <div class="form-group">
              <label>客户满意度统计 (%)</label>
              <input type="number" v-model.number="formData.customerSatisfaction[month-1]" min="0" step="0.01" max="100"
                     :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
            </div>
            <div class="form-group">
              <label>网络数据安全事件 (次)</label>
              <input type="number" v-model.number="formData.cyberIncidents[month-1]" min="0" step="1"
                     :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
            </div>
          </div>
        </div>
      </fieldset>
      <fieldset class="summary-fieldset">
        <legend>{{ year }}年产品责任统计 - 汇总</legend>
        <div class="form-row">
          <div class="form-group">
            <label>客户投诉总数 (件)</label>
            <input type="number" :value="complaintsTotal" disabled class="calculated-field">
          </div>
          <div class="form-group">
            <label>有效处理总数 (件)</label>
            <input type="number" v-model.number="handledTotal" disabled class="calculated-field">
          </div>
          <div class="form-group">
            <label>客户投诉有效处理率 (%)</label>
            <input type="number" :value="handledRate" disabled class="calculated-field">
          </div>
          <div class="form-group">
            <label>客户满意度平均值 (%)</label>
            <input type="number" :value="customerSatisfactionAverage" disabled class="calculated-field">
          </div>
          <div class="form-group">
            <label>发生产品召回次数 (次)</label>
            <input type="number" :value="recallsTotal" disabled class="calculated-field">
          </div>
          <div class="form-group">
            <label>出货总批次 (次)</label>
            <input type="number" v-model.number="shipmentsTotal" disabled class="calculated-field">
          </div>
          <div class="form-group">
            <label>产品召回百分比 (%)</label>
            <input type="number" :value="recallRate" disabled class="calculated-field">
          </div>
          <div class="form-group">
            <label>产品安全质量问题 (次)</label>
            <input type="number" v-model.number="qualityIssuesTotal" disabled class="calculated-field">
          </div>
          <div class="form-group">
            <label>网络数据安全事件 (次)</label>
            <input type="number" :value="cyberIncidentsTotal" disabled class="calculated-field">
          </div>
        </div>
      </fieldset>
    </form>
  </div>
</template>

<script setup>
import {computed, onBeforeUnmount, onMounted, reactive, ref} from 'vue'
import {useSelectionStore} from '@/stores/selectionStore'
import apiClient from '@/utils/axios'
import BaseInfoSelector from "@/components/BaseInfoSelector.vue";
import {showError, showInfo, showSuccess, handleError} from "@/utils/toast.js";

// —— 与能源统计保持一致的状态 —— //
const selectionStore = useSelectionStore()
const factory = computed(() => selectionStore.selectedFactory)
const year = computed(() => selectionStore.selectedYear);
const month = computed(() => selectionStore.selectedMonth);

const isEditing = ref(false)
const isLoading = ref(false)
const review = ref({});

// —— 产品责任数据 —— //
const formData = reactive({
  complaints: Array(12).fill(0),
  handled: Array(12).fill(0),
  qualityIssues: Array(12).fill(0),
  recalls: Array(12).fill(0),
  shipments: Array(12).fill(0),
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
const handledTotal = computed(() => rowSum(formData.handled))
const handledRate = computed(() => percent(handledTotal.value, complaintsTotal.value))
const customerSatisfactionAverage = computed(() => averageRow(formData.customerSatisfaction))
const recallsTotal = computed(() => rowSum(formData.recalls))
const recallRate = computed(() => percent(recallsTotal.value, shipmentsTotal.value))
const shipmentsTotal = computed(() => rowSum(formData.shipments))
const qualityIssuesTotal = computed(() => rowSum(formData.qualityIssues))
const cyberIncidentsTotal = computed(() => rowSum(formData.cyberIncidents))


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
  isLoading.value = true
  try {
    const response = await apiClient.get('/quantitative/responsibility', {
      params: {factory: factory.value, year: year.value}
    })
    const data = response?.data?.data
    if (data) {
      // 兼容后端下划线/驼峰
      setArray(formData.complaints, data.complaints || Array(12).fill(0))
      setArray(formData.handled, data.handled || Array(12).fill(0))
      setArray(formData.qualityIssues, data.qualityIssues || Array(12).fill(0))
      setArray(formData.recalls, data.recalls || Array(12).fill(0))
      setArray(formData.shipments, data.shipments || Array(12).fill(0))
      setArray(formData.customerSatisfaction, data.customerSatisfaction || Array(12).fill(0))
      setArray(formData.cyberIncidents, data.cyberIncidents || Array(12).fill(0))
      review.value = response.data.review;
    } else {
      resetFormData()
      showInfo('未找到数据')
    }
  } catch (error) {
      handleError(error);
      resetFormData()
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
  setArray(formData.handled, Array(12).fill(0))
  setArray(formData.qualityIssues, Array(12).fill(0))
  setArray(formData.recalls, Array(12).fill(0))
  setArray(formData.shipments, Array(12).fill(0))
  setArray(formData.customerSatisfaction, Array(12).fill(0))
  setArray(formData.cyberIncidents, Array(12).fill(0))
  review.value = {
    id: Array(12).fill(-1), is_submitted: Array(12).fill(false), status1: Array(12).fill("pending"), comment1: Array(12).fill(''),
    status2: Array(12).fill("pending"), comment22: Array(12).fill('')
  };
}


const submitEdit = async (ifSubmit) => {
  try {
    const payload = {
      factory: factory.value,
      year: Number(year.value),
      month: month.value,
      complaints: [...formData.complaints],
      handled: formData.handled,
      qualityIssues: [...formData.qualityIssues],
      recalls: [...formData.recalls],
      shipments: formData.shipments,
      customerSatisfaction: [...formData.customerSatisfaction],
      cyberIncidents: [...formData.cyberIncidents],
      complaintsTotal: complaintsTotal.value,
      handledTotal: handledTotal.value,
      handledRate: handledRate.value,
      customerSatisfactionAverage: customerSatisfactionAverage.value,
      recallsTotal: recallsTotal.value,
      recallRate: recallRate.value,
      qualityIssuesTotal: qualityIssuesTotal.value,
      cyberIncidentsTotal: cyberIncidentsTotal.value,
      isSubmitted: ifSubmit
    }
    const response = await apiClient.post('/quantitative/responsibility', payload)
    if (response.data.status === 'success') {
      showSuccess('数据提交成功!')
    }else {
      showError(`数据提交失败: ${response.data.message || '未知错误'}`)
    }
  } catch (error) {
    console.error('提交失败:', error)
    handleError(error);
  } finally {
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