<template>
  <div class="shared-form">
    <form>
      <BaseInfoSelector @selection-changed="fetchData"/>
      <fieldset class="summary-fieldset">
        <legend>{{ year }}年{{ month }}月供应商统计</legend>
        <div class="loading" v-if="isLoading">数据加载中...</div>
        <div v-else>
          <div class="form-row">
            <div class="form-group">
              <label>华东地区 (家)</label>
              <input type="number" v-model.number="formData.east" min="0" step="1"
                     :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
            </div>
            <div class="form-group">
              <label>华南地区 (家)</label>
              <input type="number" v-model.number="formData.south" min="0" step="1"
                     :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
            </div>
            <div class="form-group">
              <label>其他地区 (家)</label>
              <input type="number" v-model.number="formData.other" min="0" step="1"
                     :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
            </div>
            <div class="form-group">
              <label>环境筛选供应商 (家)</label>
              <input type="number" v-model.number="formData.envScreened" min="0" step="1"
                     :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
            </div>
            <div class="form-group">
              <label>社会标准供应商 (家)</label>
              <input type="number" v-model.number="formData.socScreened" min="0" step="1"
                     :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
            </div>
            <div class="form-group">
              <label>当地采购金额 (万元)</label>
              <input type="number" v-model.number="formData.localAmount" min="0" step="0.01"
                     :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
            </div>
            <div class="form-group">
              <label>采购总金额 (万元)</label>
              <input type="number" v-model.number="formData.totalAmount" min="0" step="0.01"
                     :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
            </div>
            <div class="form-group">
              <label>环境处罚次数 (次)</label>
              <input type="number" v-model.number="formData.envPenaltyCount" min="0" step="1"
                     :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
            </div>
            <div class="form-group">
              <label>环境处罚金额 (万元)</label>
              <input type="number" v-model.number="formData.envPenaltyAmount" min="0" step="0.01"
                     :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
            </div>
            <div class="form-group">
              <label>数据安全事件 (次)</label>
              <input type="number" v-model.number="formData.cyberIncidents" min="0" step="1"
                     :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
            </div>
          </div>
        </div>
      </fieldset>
      <fieldset class="summary-fieldset">
        <legend>{{ year }}年供应链统计 - 汇总</legend>
        <div class="form-row">
          <div class="form-group">
            <label>合计 (家)</label>
            <input type="number" :value="totalSuppliers" disabled class="calculated-field">
          </div>
          <div class="form-group">
            <label>环境维度占比 (%)</label>
            <input type="number" :value="envRatio" disabled class="calculated-field">
          </div>
          <div class="form-group">
            <label>社会标准占比 (%)</label>
            <input type="number" :value="socRatio" disabled class="calculated-field">
          </div>
          <div class="form-group">
            <label>当地采购比例 (%)</label>
            <input type="number" :value="localPurchaseRatio" disabled class="calculated-field">
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

// —— 与能源统计保持一致的状态 —— //
const selectionStore = useSelectionStore()
const factory = computed(() => selectionStore.selectedFactory)
const year = computed(() => selectionStore.selectedYear);
const month = computed(() => selectionStore.selectedMonth);

const isEditing = ref(false)
const isLoading = ref(false)

// —— 供应链数据 —— //
const formData = reactive({
  east: 0,
  south: 0,
  other: 0,
  envScreened: 0,
  socScreened: 0,
  localAmount: 0,
  totalAmount: 0,
  envPenaltyCount: 0,
  envPenaltyAmount: 0,
  cyberIncidents: 0
})

// —— 计算属性（保持原逻辑与命名，默认保留两位小数行为） —— //
const toNum = (v, d = 0) => {
  const n = Number(v)
  return Number.isFinite(n) ? n : d
}

const totalSuppliers = computed(() => toNum(formData.east) + toNum(formData.south) + toNum(formData.other))
const envRatio = computed(() => calculatePercent(formData.envScreened, totalSuppliers.value))
const socRatio = computed(() => calculatePercent(formData.socScreened, totalSuppliers.value))
const localPurchaseRatio = computed(() => calculatePercent(formData.localAmount, formData.totalAmount))

const calculatePercent = (numerator, denominator) => {
  const num = toNum(numerator)
  const denom = toNum(denominator)
  return denom > 0 ? ((num / denom) * 100).toFixed(2) : 0
}

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
    const resp = await apiClient.get('/quantitative/supply', {
      params: {factory: factory.value, year: year.value}
    })
    const data = resp?.data?.data
    if (data) {
      // 兼容后端下划线/驼峰
      formData.east = toNum(data.east || data.east_region)
      formData.south = toNum(data.south || data.south_region)
      formData.other = toNum(data.other || data.other_region)
      formData.envScreened = toNum(data.envScreened || data.env_screened)
      formData.socScreened = toNum(data.socScreened || data.soc_screened)
      formData.localAmount = toNum(data.localAmount || data.local_amount)
      formData.totalAmount = toNum(data.totalAmount || data.total_amount)
      formData.envPenaltyCount = toNum(data.envPenaltyCount || data.env_penalty_count)
      formData.envPenaltyAmount = toNum(data.envPenaltyAmount || data.env_penalty_amount)
      formData.cyberIncidents = toNum(data.cyberIncidents || data.cyber_incidents)
    } else {
      resetFormData()
    }
  } catch (err) {
    if (err.response?.status === 404) {
      resetFormData()
    } else {
      console.error('获取供应链数据失败:', err)
      resetFormData()
    }
  } finally {
    isLoading.value = false
  }
}

// —— 重置（与能源一致的重置思路） —— //
const resetFormData = () => {
  formData.east = 0
  formData.south = 0
  formData.other = 0
  formData.envScreened = 0
  formData.socScreened = 0
  formData.localAmount = 0
  formData.totalAmount = 0
  formData.envPenaltyCount = 0
  formData.envPenaltyAmount = 0
  formData.cyberIncidents = 0
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
      east: formData.east,
      south: formData.south,
      other: formData.other,
      envScreened: formData.envScreened,
      socScreened: formData.socScreened,
      localAmount: formData.localAmount,
      totalAmount: formData.totalAmount,
      envPenaltyCount: formData.envPenaltyCount,
      envPenaltyAmount: formData.envPenaltyAmount,
      cyberIncidents: formData.cyberIncidents,
      totalSuppliers: totalSuppliers.value,
      envRatio: envRatio.value,
      socRatio: socRatio.value,
      localPurchaseRatio: localPurchaseRatio.value
    }

    const resp = await apiClient.post('/quantitative/supply', payload)
    if (resp.data?.status === 'success') {
      alert('供应链数据提交成功!')
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