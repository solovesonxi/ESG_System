<template>
  <div class="shared-form">
    <form @submit.prevent="submitForm">
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
              <div class="options" v-show="selectionStore.showFactoryDropdown" :style="{ maxHeight: '200px', overflowY: 'auto' }">
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
      <fieldset>
        <legend>物料进出统计</legend>
        <div class="form-row">
          <!-- 进料部分 -->
          <div class="form-group">
            <label>进料-可再生料总量 (T)</label>
            <input type="number" v-model.number="formData.renewableInput" step="0.1" required>
          </div>
          <div class="form-group">
            <label>进料-不可再生料总量 (T)</label>
            <input type="number" v-model.number="formData.nonRenewableInput" step="0.1" required>
          </div>
          <div class="form-group">
            <label>进料总量 (T)</label>
            <input type="number" :value="totalInput" disabled>
          </div>
          <div class="form-group">
            <label>可再生进料占比 (%)</label>
            <input type="number" :value="renewableInputRatio" disabled>
          </div>

          <!-- 出料部分 -->
          <div class="form-group">
            <label>出料-可再生料总量 (T)</label>
            <input type="number" v-model.number="formData.renewableOutput" step="0.1" required>
          </div>
          <div class="form-group">
            <label>进料-不可再生料总量 (T)</label>
            <input type="number" v-model.number="formData.nonRenewableOutput" step="0.1" required>
          </div>
          <div class="form-group">
            <label>出料总量 (T)</label>
            <input type="number" v-model.number="totalOutput" disabled>
          </div>
          <div class="form-group">
            <label>可再生出料占比 (%)</label>
            <input type="number" :value="renewableOutputRatio" disabled>
          </div>

          <!-- 消耗部分 -->
          <div class="form-group">
            <label>物料消耗总量 (T)</label>
            <input type="number" v-model.number="formData.materialConsumption" step="0.1" required>
          </div>
          <div class="form-group">
            <label>包装材料总量 (T)</label>
            <input type="number" v-model.number="formData.packagingMaterial" step="0.1" required>
          </div>
          <div class="form-group">
            <label>纸张总量 (T)</label>
            <input type="number" v-model.number="formData.paper" step="0.1" required>
          </div>
          <div class="form-group">
            <label>总营收 (万元)</label>
            <input type="number" v-model.number="formData.revenue" step="0.1" required>
          </div>

          <!-- 消耗强度部分 -->
          <div class="form-group">
            <label>包装材料消耗强度 (T/万元)</label>
            <input type="number" v-model.number="packagingIntensity" disabled>
          </div>
          <div class="form-group">
            <label>纸张消耗强度 (T/万元)</label>
            <input type="number" v-model.number="paperIntensity" disabled>
          </div>
        </div>
      </fieldset>

      <button type="submit" :disabled="isSubmitting">
        {{ isSubmitting ? '提交中...' : '提交数据' }}
      </button>
    </form>
  </div>
</template>

<script setup>
import { computed, reactive, ref, onMounted, onBeforeUnmount } from 'vue'
import axios from 'axios'
import {useSelectionStore} from "@/stores/selectionStore.js";


const selectionStore = useSelectionStore()
const factory = computed(() => selectionStore.selectedFactory)
const factories = computed(() => selectionStore.factories)
const year = computed(() => selectionStore.selectedYear)
const years = computed(() => selectionStore.years)
const isSubmitting = ref(false)



// 表单数据结构
const formData = reactive({
  renewableInput: 0,
  nonRenewableInput: 0,
  renewableOutput: 0,
  nonRenewableOutput: 0,
  materialConsumption: 0,
  packagingMaterial: 0,
  paper: 0,
  packagingIntensity: 0,
  paperIntensity: 0,
  revenue: 0
})

// 计算进料总量
const totalInput = computed(() => (formData.renewableInput + formData.nonRenewableInput).toFixed(2))
const totalOutput = computed(() => (formData.renewableOutput + formData.nonRenewableOutput).toFixed(2))

// 计算可再生进料占比
const renewableInputRatio = computed(() => {
  if (totalInput.value > 0) {
    return ((formData.renewableInput / totalInput.value) * 100).toFixed(2)
  }
  return 0
})

// 计算可再生出料占比
const renewableOutputRatio = computed(() => {
  if (totalOutput.value > 0) {
    return ((formData.renewableOutput / totalOutput.value) * 100).toFixed(2)
  }
  return 0
})

const packagingIntensity=computed(() => {
  if (formData.revenue > 0) {
    return (formData.packagingMaterial / formData.revenue).toFixed(2)
  }
  return 0
})

const paperIntensity=computed(() => {
  if (formData.revenue > 0) {
    return (formData.paper / formData.revenue).toFixed(2)
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


async function submitForm() {
  isSubmitting.value = true
  try {
    const payload = {
      factory: factory.value,
      year: year.value,
      ...formData,
      totalInput: totalInput.value,
      totalOutput: totalOutput.value,
      renewableInputRatio: renewableInputRatio.value,
      renewableOutputRatio: renewableOutputRatio.value
    }

    const response = await axios.post('http://localhost:8000/submit/material', payload)

    if (response.data.status === 'success') {
      alert('数据提交成功!')
    }
  } catch (error) {
    console.error('提交失败:', error)
    alert(`提交失败: ${error.response?.data?.detail || error.message}`)
  } finally {
    isSubmitting.value = false
  }
}
</script>
