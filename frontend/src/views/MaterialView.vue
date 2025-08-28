<template>
  <div class="shared-form">
    <form @submit.prevent="submitEdit">
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
                    v-for="f in factories"
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
                    v-for="y in years"
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
        </div>
      </fieldset>

      <!-- 物料统计部分 -->
      <fieldset class="summary-fieldset">
        <legend>物料进出统计</legend>
        <div class="form-row">
          <!-- 进料部分 -->
          <div class="form-group">
            <label>进料-可再生料总量 (T)</label>
            <input type="number" v-model.number="tempFormData.renewableInput" step="0.1"
                   :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
          </div>
          <div class="form-group">
            <label>进料-不可再生料总量 (T)</label>
            <input type="number" v-model.number="tempFormData.nonRenewableInput" step="0.1"
                   :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
          </div>
          <div class="form-group">
            <label>进料总量 (T)</label>
            <input type="number" :value="totalInput" disabled class="calculated-field">
          </div>
          <div class="form-group">
            <label>可再生进料占比 (%)</label>
            <input type="number" :value="renewableInputRatio" disabled class="calculated-field">
          </div>

          <!-- 出料部分 -->
          <div class="form-group">
            <label>出料-可再生料总量 (T)</label>
            <input type="number" v-model.number="tempFormData.renewableOutput" step="0.1"
                   :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
          </div>
          <div class="form-group">
            <label>出料-不可再生料总量 (T)</label>
            <input type="number" v-model.number="tempFormData.nonRenewableOutput" step="0.1"
                   :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
          </div>
          <div class="form-group">
            <label>出料总量 (T)</label>
            <input type="number" :value="totalOutput" disabled class="calculated-field">
          </div>
          <div class="form-group">
            <label>可再生出料占比 (%)</label>
            <input type="number" :value="renewableOutputRatio" disabled class="calculated-field">
          </div>

          <!-- 消耗部分 -->
          <div class="form-group">
            <label>物料消耗总量 (T)</label>
            <input type="number" v-model.number="tempFormData.materialConsumption" step="0.1"
                   :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
          </div>

          <div class="form-group">
            <label>木纤维 (T)</label>
            <input type="number" v-model.number="tempFormData.woodFiber" step="0.1"
                   :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
          </div>
          <div class="form-group">
            <label>铝 (T)</label>
            <input type="number" v-model.number="tempFormData.aluminum" step="0.1"
                   :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
          </div>

          <div class="form-group">
            <label>总营收 (万元)</label>
            <input type="number" v-model.number="tempFormData.total_revenue" step="0.1"
                   :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
          </div>

          <div class="form-group">
            <label>包装材料总量 (T)</label>
            <input type="number" v-model.number="tempFormData.packagingMaterial" step="0.1"
                   :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
          </div>
          <div class="form-group">
            <label>纸张总量 (T)</label>
            <input type="number" v-model.number="tempFormData.paper" step="0.1"
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
import {computed, onBeforeUnmount, onMounted, reactive, ref} from 'vue'
import axios from 'axios'
import {useSelectionStore} from "@/stores/selectionStore.js";

const selectionStore = useSelectionStore()
const factory = computed(() => selectionStore.selectedFactory)
const factories = computed(() => selectionStore.factories)
const year = computed(() => selectionStore.selectedYear)
const years = computed(() => selectionStore.years)
const isSubmitting = ref(false)
const isEditing = ref(false)

// 原始表单数据结构
const formData = reactive({
  renewableInput: 0,
  nonRenewableInput: 0,
  renewableOutput: 0,
  nonRenewableOutput: 0,
  materialConsumption: 0,
  woodFiber: 0,
  aluminum: 0,
  total_revenue: 0,
  packagingMaterial: 0,
  paper: 0,
})

// 临时表单数据结构（用于编辑）
const tempFormData = reactive({...formData})

// 计算进料总量
const totalInput = computed(() => (tempFormData.renewableInput + tempFormData.nonRenewableInput).toFixed(2))
const totalOutput = computed(() => (tempFormData.renewableOutput + tempFormData.nonRenewableOutput).toFixed(2))

// 计算可再生进料占比
const renewableInputRatio = computed(() => {
  if (totalInput.value > 0) {
    return ((tempFormData.renewableInput / totalInput.value) * 100).toFixed(2)
  }
  return 0
})

// 计算可再生出料占比
const renewableOutputRatio = computed(() => {
  if (totalOutput.value > 0) {
    return ((tempFormData.renewableOutput / totalOutput.value) * 100).toFixed(2)
  }
  return 0
})

const packagingIntensity = computed(() => {
  if (tempFormData.total_revenue > 0) {
    return (tempFormData.packagingMaterial / tempFormData.total_revenue).toFixed(2)
  }
  return 0
})

const paperIntensity = computed(() => {
  if (tempFormData.total_revenue > 0) {
    return (tempFormData.paper / tempFormData.total_revenue).toFixed(2)
  }
  return 0
})

// 初始化年份列表
onMounted(() => {
  selectionStore.initYears()
  document.addEventListener('click', selectionStore.handleClickOutside)
})

onBeforeUnmount(() => {
  document.removeEventListener('click', selectionStore.handleClickOutside)
})

// 开始编辑方法
const startEditing = () => {
  isEditing.value = true
  // 将当前数据复制到临时数据
  Object.assign(tempFormData, formData)
}

// 取消编辑方法
const cancelEditing = () => {
  isEditing.value = false
  // 将临时数据恢复为原始数据
  Object.assign(tempFormData, formData)
}

// 提交编辑方法
const submitEdit = async () => {
  isSubmitting.value = true
  try {
    const payload = {
      factory: factory.value,
      year: year.value,
      ...tempFormData,
      packagingIntensity: packagingIntensity.value,
      paperIntensity: paperIntensity.value,
      totalInput: totalInput.value,
      totalOutput: totalOutput.value,
      renewableInputRatio: renewableInputRatio.value,
      renewableOutputRatio: renewableOutputRatio.value
    }
    const response = await axios.post('http://localhost:8000/submit/material', payload)

    if (response.data.status === 'success') {
      // 更新原始数据
      Object.assign(formData, tempFormData)
      isEditing.value = false
      alert('数据提交成功!')
    }
  } catch (error) {
    console.error('提交失败:', error)
    alert(`提交失败: ${error.response?.data?.detail || error.message}`)
  } finally {
    isSubmitting.value = false
  }
}

// 暴露方法给父组件
defineExpose({
  startEditing,
  cancelEditing,
  submitEdit,
});
</script>


