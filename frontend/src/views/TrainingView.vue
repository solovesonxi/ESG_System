<template>
  <div class="shared-form">
    <form @submit.prevent="submitTraining">
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

      <!-- 教育与培训数据表格 - 去除工厂列 -->
      <fieldset>
        <legend>{{ year }}年教育和培训统计</legend>
        <div class="table-wrapper">
          <table class="training-table">
            <thead>
            <tr>
              <th>总人数(人)</th>
              <th>受训人数(人次)</th>
              <th>培训覆盖率(%)</th>
              <th>男性(人次)</th>
              <th>女性(人次)</th>
              <th>男性占比(%)</th>
              <th>女性占比(%)</th>
              <th>管理层受训(人次)</th>
              <th>中层受训(人次)</th>
              <th>普通受训(人次)</th>
              <th>管理层占比(%)</th>
              <th>中层占比(%)</th>
              <th>普通占比(%)</th>
              <th>培训总学时(小时)</th>
              <th>男性学时(小时)</th>
              <th>女性学时(小时)</th>
              <th>管理层学时(小时)</th>
              <th>中层学时(小时)</th>
              <th>普通学时(小时)</th>
            </tr>
            </thead>
            <tbody>
            <tr>
              <!-- 输入字段 -->
              <td><input type="number" min="0" step="1" v-model.number="formData.total"></td>
              <td><input type="number" min="0" step="1" v-model.number="formData.trained"></td>
              <td class="total-cell">{{ coverageRate }}%</td>
              <td><input type="number" min="0" step="1" v-model.number="formData.male"></td>
              <td><input type="number" min="0" step="1" v-model.number="formData.female"></td>
              <td class="total-cell">{{ maleRate }}%</td>
              <td class="total-cell">{{ femaleRate }}%</td>
              <td><input type="number" min="0" step="1极简风格" v-model.number="formData.mgmt"></td>
              <td><input type="number" min="0" step="1" v-model.number="formData.middle"></td>
              <td><input type="number" min="0" step="1" v-model.number="formData.general"></td>
              <td class="total-cell">{{ mgmtRate }}%</td>
              <td class="total-cell">{{ middleRate }}%</td>
              <td class="total-cell">{{ generalRate }}%</td>
              <td><input type="number" min="0" step="0.1" v-model.number="formData.hoursTotal"></td>
              <td><input type="number" min="0" step="0.1" v-model.number="formData.hoursMale"></td>
              <td><input type="number" min="0" step="0.1" v-model.number="formData.hoursFemale"></td>
              <td><input type="number" min="0" step="0.1" v-model.number="formData.hoursMgmt"></td>
              <td><input type="number" min="0" step="0.1" v-model.number="formData.hoursMiddle"></td>
              <td><input type="number" min="0" step="0.1" v-model.number="formData.hoursGeneral"></td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <button type="submit" :disabled="isSubmitting">
        {{ isSubmitting ? '提交中...' : '提交教育与培训数据' }}
      </button>
    </form>
  </div>
</template>

<script setup>
import { computed, reactive, ref } from 'vue'
import { useSelectionStore } from '@/stores/selectionStore'
import apiClient from "@/utils/axios.js";

const selectionStore = useSelectionStore()
const factory = computed(() => selectionStore.selectedFactory)
const factories = computed(() => selectionStore.factories)
const year = computed(() => selectionStore.selectedYear)
const years = computed(() => selectionStore.years)
const isSubmitting = ref(false)

// 表单数据模型
const formData = reactive({
  total: 0,       // 总人数
  trained: 0,     // 受训人数
  male: 0,        // 男性受训人次
  female: 0,      // 女性受训人次
  mgmt: 0,        // 管理层受训人次
  middle: 0,      // 中层受训人次
  general: 0,     // 普通员工受训人次
  hoursTotal: 0,  // 培训总学时
  hoursMale: 0,   // 男性学时
  hoursFemale: 0, // 女性学时
  hoursMgmt: 0,   // 管理层学时
  hoursMiddle: 0, // 中层学时
  hoursGeneral: 0 // 普通学时
})

// 计算属性：培训覆盖率
const coverageRate = computed(() => {
  return calculateRate(formData.trained, formData.total)
})

// 计算属性：男性占比
const maleRate = computed(() => {
  return calculateRate(formData.male, formData.trained)
})

// 计算属性：女性占比
const femaleRate = computed(() => {
  return calculateRate(formData.female, formData.trained)
})

// 计算属性：管理层占比
const mgmtRate = computed(() => {
  return calculateRate(formData.mgmt, formData.trained)
})

// 计算属性：中层占比
const middleRate = computed(() => {
  return calculateRate(formData.middle, formData.trained)
})

// 计算属性：普通员工占比
const generalRate = computed(() => {
  return calculateRate(formData.general, formData.trained)
})

// 计算百分比函数
const calculateRate = (numerator, denominator) => {
  if (denominator <= 0) return 0
  return ((numerator / denominator) * 100).toFixed(2)
}

// 提交教育与培训数据
const submitTraining = async () => {
  if (!factory.value) {
    alert('请选择工厂名称')
    return
  }

  isSubmitting.value = true
  try {
    const payload = {
      factory: factory.value,
      year: Number(year.value),
      ...formData,
      coverageRate: coverageRate.value,
      maleRate: maleRate.value,
      femaleRate: femaleRate.value,
      mgmtRate: mgmtRate.value,
      middleRate: middleRate.value,
      generalRate: generalRate.value
    }

    const response = await apiClient.post('/quantitative/training', payload)

    if (response.data.status === 'success') {
      alert('教育与培训数据提交成功!')
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
/* 样式保持不变 */
.table-wrapper{overflow:auto}
.training-table{width:100%; border-collapse:collapse}
.training-table th,.training-table td{border:1px solid #ddd; padding:6px; text-align:center}
.training-table thead th{position:sticky; top:0; background:#f7f7f7; z-index:1}
.total-cell{font-weight:600}
.training-table input{width:110px}
@media (max-width: 768px){.training-table input{width:90px}}
</style>