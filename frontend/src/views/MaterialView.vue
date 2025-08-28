<template>
  <div class="shared-form">
    <form @submit.prevent="submitEdit">
      <!-- 基础信息部分保持不变 -->
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
        </div>
      </fieldset>

      <!-- 物料统计部分 -->
      <fieldset class="summary-fieldset">
        <legend>物料进出统计</legend>
        <div class="loading" v-if="isLoading">数据加载中...</div>
        <div v-else-if="!hasData" class="no-data">暂无数据</div>
        <div class="form-row" v-else>
          <!-- 进料部分 -->
          <div class="form-group">
            <label>进料-可再生料总量 (T)</label>
            <input type="number" v-model.number="formData.renewableInput" step="0.1"
                   :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
          </div>
          <div class="form-group">
            <label>进料-不可再生料总量 (T)</label>
            <input type="number" v-model.number="formData.nonRenewableInput" step="0.1"
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
            <input type="number" v-model.number="formData.renewableOutput" step="0.1"
                   :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
          </div>
          <div class="form-group">
            <label>出料-不可再生料总量 (T)</label>
            <input type="number" v-model.number="formData.nonRenewableOutput" step="0.1"
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
            <input type="number" v-model.number="formData.materialConsumption" step="0.1"
                   :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
          </div>

          <div class="form-group">
            <label>木纤维 (T)</label>
            <input type="number" v-model.number="formData.woodFiber" step="0.1"
                   :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
          </div>
          <div class="form-group">
            <label>铝 (T)</label>
            <input type="number" v-model.number="formData.aluminum" step="0.1"
                   :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
          </div>

          <div class="form-group">
            <label>总营收 (万元)</label>
            <input type="number" v-model.number="formData.total_revenue" step="0.1"
                   :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
          </div>

          <div class="form-group">
            <label>包装材料总量 (T)</label>
            <input type="number" v-model.number="formData.packagingMaterial" step="0.1"
                   :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
          </div>
          <div class="form-group">
            <label>纸张总量 (T)</label>
            <input type="number" v-model.number="formData.paper" step="0.1"
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
import {computed, onMounted, ref, watch} from 'vue'
import axios from 'axios'
import {useSelectionStore} from "@/stores/selectionStore.js"

const selectionStore = useSelectionStore()
const factory = computed(() => selectionStore.selectedFactory)
const year = computed(() => selectionStore.selectedYear)
const isEditing = ref(false)
const isLoading = ref(false)
const hasData = ref(false)

// 表单数据结构
const formData = ref({
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

// 计算属性
const totalInput = computed(() => (formData.value.renewableInput + formData.value.nonRenewableInput).toFixed(2))
const totalOutput = computed(() => (formData.value.renewableOutput + formData.value.nonRenewableOutput).toFixed(2))
const renewableInputRatio = computed(() => {
  const total = parseFloat(totalInput.value)
  return total > 0 ? ((formData.value.renewableInput / total) * 100).toFixed(2) : 0
})
const renewableOutputRatio = computed(() => {
  const total = parseFloat(totalOutput.value)
  return total > 0 ? ((formData.value.renewableOutput / total) * 100).toFixed(2) : 0
})
const packagingIntensity = computed(() => {
  return formData.value.total_revenue > 0 ?
      (formData.value.packagingMaterial / formData.value.total_revenue).toFixed(2) : 0
})
const paperIntensity = computed(() => {
  return formData.value.total_revenue > 0 ?
      (formData.value.paper / formData.value.total_revenue).toFixed(2) : 0
})


// 监听工厂和年份变化
watch([factory, year], () => {
  fetchData()
})

// 获取数据方法
const fetchData = async () => {
  if (!factory.value || !year.value) {
    resetFormData()
    return
  }
  isLoading.value = true
  try {
    const response = await axios.get(`http://localhost:8000/quantitative/material`, {params: {factory: factory.value, year: year.value}})
    formData.value = response.data.data
    hasData.value = true
  } catch (error) {
    if (error.response?.status === 404) {
      resetFormData()
      hasData.value = false
    } else {
      console.error('获取数据失败:', error)
    }
  } finally {
    isLoading.value = false
  }
}

// 重置表单数据
const resetFormData = () => {
  Object.keys(formData.value).forEach(key => {
    formData.value[key] = 0
  })
}

// 提交编辑方法
const submitEdit = async () => {
  try {
    const payload = {
      factory: factory.value,
      year: year.value,
      ...formData.value
    }

    const response = await axios.post('http://localhost:8000/quantitative/material', payload)

    if (response.data.status === 'success') {
      isEditing.value = false
      alert('数据提交成功!')

      // 重新获取数据以确保计算字段正确
      await fetchData()
    }
  } catch (error) {
    console.error('提交失败:', error)
    alert(`提交失败: ${error.response?.data?.detail || error.message}`)
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