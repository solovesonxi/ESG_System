<template>
  <div class="shared-form">
    <form>
      <BaseInfoSelector @selection-changed="fetchData"/>
      <fieldset class="summary-fieldset">
        <legend>{{ year }}年{{ month }}月物料进出统计</legend>
        <div class="loading" v-if="isLoading">数据加载中...</div>
        <div class="form-row" v-else>
          <!-- 进料部分 -->
          <div class="form-group">
            <label>进料-可再生料总量 (T)</label>
            <input type="number" v-model.number="formData.renewableInput[month - 1]" step="0.1"
                   :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
          </div>
          <div class="form-group">
            <label>进料-不可再生料总量 (T)</label>
            <input type="number" v-model.number="formData.nonRenewableInput[month - 1]" step="0.1"
                   :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
          </div>

          <!-- 出料部分 -->
          <div class="form-group">
            <label>出料-可再生料总量 (T)</label>
            <input type="number" v-model.number="formData.renewableOutput[month - 1]" step="0.1"
                   :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
          </div>
          <div class="form-group">
            <label>出料-不可再生料总量 (T)</label>
            <input type="number" v-model.number="formData.nonRenewableOutput[month - 1]" step="0.1"
                   :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
          </div>

          <!-- 消耗部分 -->
          <div class="form-group">
            <label>物料消耗总量 (T)</label>
            <input type="number" v-model.number="formData.materialConsumption[month - 1]" step="0.1"
                   :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
          </div>

          <div class="form-group">
            <label>木纤维 (T)</label>
            <input type="number" v-model.number="formData.woodFiber[month - 1]" step="0.1"
                   :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
          </div>
          <div class="form-group">
            <label>铝 (T)</label>
            <input type="number" v-model.number="formData.aluminum[month - 1]" step="0.1"
                   :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
          </div>
          <div class="form-group">
            <label>包装材料总量 (T)</label>
            <input type="number" v-model.number="formData.packagingMaterial[month - 1]" step="0.1"
                   :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
          </div>
          <div class="form-group">
            <label>纸张总量 (T)</label>
            <input type="number" v-model.number="formData.paper[month - 1]" step="0.1"
                   :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
          </div>
        </div>
      </fieldset>

      <fieldset class="summary-fieldset">
        <legend>{{ year }}年物料统计 - 汇总</legend>
        <div class="loading" v-if="isLoading">数据加载中...</div>
        <div class="form-row" v-else>
          <!-- 进料部分 -->
          <div class="form-group">
            <label>进料总量 (T)</label>
            <input type="number" :value="totalInput" disabled class="calculated-field">
          </div>
          <div class="form-group">
            <label>可再生进料占比 (%)</label>
            <input type="number" :value="renewableInputRatio" disabled class="calculated-field">
          </div>
          <div class="form-group">
            <label>出料总量 (T)</label>
            <input type="number" :value="totalOutput" disabled class="calculated-field">
          </div>
          <div class="form-group">
            <label>可再生出料占比 (%)</label>
            <input type="number" :value="renewableOutputRatio" disabled class="calculated-field">
          </div>
          <div class="form-group">
            <label>总营收 (万元)</label>
            <input type="number" v-model.number="formData.total_revenue" step="0.1"
                   :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
          </div>
          <div class="form-group">
            <label>包装材料消耗强度 (T/万元)</label>
            <input type="number" :value="packagingIntensity" disabled class="calculated-field">
          </div>
          <div class="form-group">
            <label>纸张消耗强度 (T/万元)</label>
            <input type="number" :value="paperIntensity" disabled class="calculated-field">
          </div>
        </div>
      </fieldset>
    </form>
  </div>
</template>

<script setup>
import {computed, onBeforeUnmount, onMounted, ref} from 'vue'
import apiClient from '@/utils/axios';
import {useSelectionStore} from "@/stores/selectionStore.js"
import BaseInfoSelector from "@/components/BaseInfoSelector.vue";

const selectionStore = useSelectionStore()
const factory = computed(() => selectionStore.selectedFactory);
const year = computed(() => selectionStore.selectedYear);
const month = computed(() => selectionStore.selectedMonth);
const isEditing = ref(false)
const isLoading = ref(false)

// 表单数据结构（按月存储，1~12月）
const formData = ref({
  renewableInput: Array(12).fill(0),
  nonRenewableInput: Array(12).fill(0),
  renewableOutput: Array(12).fill(0),
  nonRenewableOutput: Array(12).fill(0),
  materialConsumption: Array(12).fill(0),
  woodFiber: Array(12).fill(0),
  aluminum: Array(12).fill(0),
  total_revenue: 0, // 按年存储
  packagingMaterial: Array(12).fill(0),
  paper: Array(12).fill(0),
})

// 计算属性（按年计算）
const rowSum = (arr) => arr.reduce((s, v) => s + (Number(v) || 0), 0).toFixed(2)

const totalInput = computed(() => {
  const renewable = rowSum(formData.value.renewableInput)
  const nonRenewable = rowSum(formData.value.nonRenewableInput)
  return (parseFloat(renewable) + parseFloat(nonRenewable)).toFixed(2)
})

const totalOutput = computed(() => {
  const renewable = rowSum(formData.value.renewableOutput)
  const nonRenewable = rowSum(formData.value.nonRenewableOutput)
  return (parseFloat(renewable) + parseFloat(nonRenewable)).toFixed(2)
})

const renewableInputRatio = computed(() => {
  const total = parseFloat(totalInput.value)
  const renewable = rowSum(formData.value.renewableInput)
  return total > 0 ? ((parseFloat(renewable) / total) * 100).toFixed(2) : 0
})

const renewableOutputRatio = computed(() => {
  const total = parseFloat(totalOutput.value)
  const renewable = rowSum(formData.value.renewableOutput)
  return total > 0 ? ((parseFloat(renewable) / total) * 100).toFixed(2) : 0
})
const packagingIntensity = computed(() => {
  return formData.value.total_revenue > 0 ?
      (rowSum(formData.value.packagingMaterial) / formData.value.total_revenue).toFixed(2) : 0
})
const paperIntensity = computed(() => {
  return formData.value.total_revenue > 0 ?
      (rowSum(formData.value.paper) / formData.value.total_revenue).toFixed(2) : 0
})
onMounted(() => {
  document.addEventListener("click", selectionStore.handleClickOutside);
});

onBeforeUnmount(() => {
  document.removeEventListener("click", selectionStore.handleClickOutside);
});

// 获取数据方法
const fetchData = async () => {
  if (!factory.value || !year.value) {
    resetFormData()
    return
  }
  isLoading.value = true
  try {
    const response = await apiClient.get(`/quantitative/material`, {params: {factory: factory.value, year: year.value}})
    console.log(response.data)
    if (response.data && response.data.data) {
      const data = response.data.data;
      formData.value = {
        renewableInput: data.renewableInput || Array(12).fill(0),
        nonRenewableInput: data.nonRenewableInput || Array(12).fill(0),
        renewableOutput: data.renewableOutput || Array(12).fill(0),
        nonRenewableOutput: data.nonRenewableOutput || Array(12).fill(0),
        materialConsumption: data.materialConsumption || Array(12).fill(0),
        woodFiber: data.woodFiber || Array(12).fill(0),
        aluminum: data.aluminum || Array(12).fill(0),
        total_revenue: data.total_revenue || 0,
        packagingMaterial: data.packagingMaterial || Array(12).fill(0),
        paper: data.paper || Array(12).fill(0)
      }
    } else {
      resetFormData()
    }
  } catch (error) {
    if (error.response?.status === 404) {
      resetFormData()
    } else {
      console.error('获取数据失败:', error)
    }
  } finally {
    isLoading.value = false
  }
}

// 重置表单数据
const resetFormData = () => {
  formData.value = {
    renewableInput: Array(12).fill(0),
    nonRenewableInput: Array(12).fill(0),
    renewableOutput: Array(12).fill(0),
    nonRenewableOutput: Array(12).fill(0),
    materialConsumption: Array(12).fill(0),
    woodFiber: Array(12).fill(0),
    aluminum: Array(12).fill(0),
    total_revenue: 0,
    packagingMaterial: Array(12).fill(0),
    paper: Array(12).fill(0),
  }
}

// 提交编辑方法
const submitEdit = async () => {
  try {
    const payload = {
      factory: factory.value,
      year: year.value,
      month: month.value, // 添加当前月份
      ...formData.value,
      packagingIntensity: packagingIntensity.value,
      paperIntensity: paperIntensity.value,
      totalInput: totalInput.value,
      totalOutput: totalOutput.value,
      renewableInputRatio: renewableInputRatio.value,
      renewableOutputRatio: renewableOutputRatio.value
    }
    const response = await apiClient.post('/quantitative/material', payload);
    if (response.data.status === 'success') {
      alert('数据提交成功!')
    }
  } catch (error) {
    console.error('提交失败:', error)
    alert(`提交失败: ${error.response?.data?.detail || error.message}`)
  } finally {
    console.log('提交完成，即将刷新');
    isEditing.value = false;
    await fetchData();
  }
}

// 暴露方法给父组件
defineExpose({
  startEditing: () => isEditing.value = true,
  cancelEditing: () => {
    isEditing.value = false
    fetchData()
  },
  submitEdit,
  fetchData
})
</script>