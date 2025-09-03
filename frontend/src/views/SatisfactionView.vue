<template>
  <div class="shared-form">
    <form @submit.prevent="submitSatisfaction">
      <!-- 基础信息保持不变 -->
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
                <div v-for="f in factories" :key="f"
                     class="option"
                     :class="{ 'selected-option': f === factory }"
                     @click="selectionStore.selectFactory(f)">
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
                <div v-for="y in years" :key="y"
                     class="option"
                     :class="{ 'selected-option': y === year }"
                     @click="selectionStore.selectYear(y)">
                  {{ y }}年
                </div>
              </div>
            </div>
          </div>
        </div>
      </fieldset>

      <!-- 满意度表格 - 已去除工厂和单位列 -->
      <fieldset>
        <legend>{{ year }}年员工满意度统计 (%)</legend>
        <div class="table-wrapper">
          <table class="satisfaction-table">
            <thead>
            <tr>
              <th v-for="(m, idx) in monthNames" :key="`sat-h-${idx}`">{{ m }}</th>
              <th>年度平均</th>
            </tr>
            </thead>
            <tbody>
            <tr>
              <td v-for="c in 12" :key="`sat-c-${c-1}`">
                <input type="number" min="0" max="100" step="0.1"
                       v-model.number="formData.satisfaction[c-1]">
              </td>
              <td class="total-cell">{{ annualAverage }}%</td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <button type="submit" :disabled="isSubmitting">
        {{ isSubmitting ? '提交中...' : '提交满意度数据' }}
      </button>
    </form>
  </div>
</template>

<script setup>
import {computed, reactive, ref} from 'vue'
import {useSelectionStore} from '@/stores/selectionStore'
import apiClient from "@/utils/axios.js";

const selectionStore = useSelectionStore()
const factory = computed(() => selectionStore.selectedFactory)
const factories = computed(() => selectionStore.factories)
const year = computed(() => selectionStore.selectedYear)
const years = computed(() => selectionStore.years)
const isSubmitting = ref(false)

const monthNames = ['1月', '2月', '3月', '4月', '5月', '6月',
  '7月', '8月', '9月', '10月', '11月', '12月']

// 表单数据模型
const formData = reactive({
  satisfaction: Array(12).fill(0) // 12个月份的满意度数据
})

// 计算年度平均值
const annualAverage = computed(() => {
  const sum = formData.satisfaction.reduce((total, value) =>
      total + (Number(value) || 0), 0)
  return (sum / 12).toFixed(1)
})

// 提交数据
const submitSatisfaction = async () => {
  if (!factory.value) {
    alert('请选择工厂名称')
    return
  }

  isSubmitting.value = true
  try {
    const payload = {
      factory: factory.value,
      year: Number(year.value),
      satisfaction: [...formData.satisfaction],
      annualAverage: annualAverage.value
    }

    const response = await apiClient.post('/quantitative/satisfaction', payload)

    if (response.data.status === 'success') {
      alert('满意度数据提交成功!')
      // 重置表单
      formData.satisfaction = Array(12).fill(0)
    }
  } catch (error) {
    console.error('提交失败:', error)
    alert(`提交失败: ${error.response?.data?.detail || error.message}`)
  } finally {
    isSubmitting.value = false
  }
}
</script>

<style scoped>
/* 保持原有样式不变 */
.table-wrapper {
  overflow: auto;
}

.satisfaction-table {
  width: 100%;
  border-collapse: collapse;
}

.satisfaction-table th,
.satisfaction-table td {
  border: 1px solid #ddd;
  padding: 8px;
  text-align: center;
}

.satisfaction-table thead th {
  position: sticky;
  top: 0;
  background: #f7f7f7;
  z-index: 1;
}

.total-cell {
  font-weight: 600;
  background-color: #f5f5f5;
}

.satisfaction-table input {
  width: 80px;
  padding: 6px;
  text-align: center;
}

@media (max-width: 768px) {
  .table-wrapper {
    overflow-x: auto;
  }

  .satisfaction-table {
    font-size: 14px;
  }

  .satisfaction-table th,
  .satisfaction-table td {
    padding: 6px;
  }

  .satisfaction-table input {
    width: 60px;
    padding: 4px;
  }
}
</style>