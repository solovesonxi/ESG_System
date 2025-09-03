<template>
  <div class="shared-form">
    <form @submit.prevent="submitOHS">
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

      <!-- 培训次数（次） -->
      <fieldset>
        <legend>{{ year }}年职业健康安全统计 - 培训次数 (次)</legend>
        <div class="table-wrapper">
          <table class="ohs-table">
            <thead>
            <tr>
              <th v-for="(m, idx) in monthNames" :key="`tc-h-${idx}`">{{ m }}</th>
              <th>合计</th>
            </tr>
            </thead>
            <tbody>
            <tr>
              <td v-for="c in 12" :key="`tc-c-${c-1}`">
                <input type="number" min="0" step="1" v-model.number="formData.trainingCount[c-1]">
              </td>
              <td class="total-cell">{{ rowSum(formData.trainingCount) }}</td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <!-- 培训参与人次（人次） -->
      <fieldset>
        <legend>{{ year }}年职业健康安全统计 - 培训参与人次 (人次)</legend>
        <div class="table-wrapper">
          <table class="ohs-table">
            <thead>
            <tr>
              <th v-for="(m, idx) in monthNames" :key="`tp-h-${idx}`">{{ m }}</th>
              <th>合计</th>
            </tr>
            </thead>
            <tbody>
            <tr>
              <td v-for="c in 12" :key="`tp-c-${c-1}`">
                <input type="number" min="0" step="1" v-model.number="formData.trainingParticipants[c-1]">
              </td>
              <td class="total-cell">{{ rowSum(formData.trainingParticipants) }}</td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <!-- 培训学时（小时） -->
      <fieldset>
        <legend>{{ year }}年职业健康安全统计 - 培训学时 (小时)</legend>
        <div class="table-wrapper">
          <table class="ohs-table">
            <thead>
            <tr>
              <th v-for="(m, idx) in monthNames" :key="`th-h-${idx}`">{{ m }}</th>
              <th>合计</th>
            </tr>
            </thead>
            <tbody>
            <tr>
              <td v-for="c in 12" :key="`th-c-${c-1}`">
                <input type="number" min="0" step="0.1" v-model.number="formData.trainingHours[c-1]">
              </td>
              <td class="total-cell">{{ rowSum(formData.trainingHours) }}</td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <!-- 工伤数量（次） -->
      <fieldset>
        <legend>{{ year }}年职业健康安全统计 - 工伤数量 (次)</legend>
        <div class="table-wrapper">
          <table class="ohs-table">
            <thead>
            <tr>
              <th v-for="(m, idx) in monthNames" :key="`inj-h-${idx}`">{{ m }}</th>
              <th>合计</th>
            </tr>
            </thead>
            <tbody>
            <tr>
              <td v-for="c in 12" :key="`inj-c-${c-1}`">
                <input type="number" min="0" step="1" v-model.number="formData.injuryCount[c-1]">
              </td>
              <td class="total-cell">{{ rowSum(formData.injuryCount) }}</td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <!-- 安全事故数量（次） -->
      <fieldset>
        <legend>{{ year }}年职业健康安全统计 - 安全事故数量 (次)</legend>
        <div class="table-wrapper">
          <table class="ohs-table">
            <thead>
            <tr>
              <th v-for="(m, idx) in monthNames" :key="`acc-h-${idx}`">{{ m }}</th>
              <th>合计</th>
            </tr>
            </thead>
            <tbody>
            <tr>
              <td v-for="c in 12" :key="`acc-c-${c-1}`">
                <input type="number" min="0" step="1" v-model.number="formData.incidentCount[c-1]">
              </td>
              <td class="total-cell">{{ rowSum(formData.incidentCount) }}</td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <!-- 工亡人数（人） -->
      <fieldset>
        <legend>{{ year }}年职业健康安全统计 - 工亡人数 (人)</legend>
        <div class="table-wrapper">
          <table class="ohs-table">
            <thead>
            <tr>
              <th v-for="(m, idx) in monthNames" :key="`fat-h-${idx}`">{{ m }}</th>
              <th>合计</th>
            </tr>
            </thead>
            <tbody>
            <tr>
              <td v-for="c in 12" :key="`fat-c-${c-1}`">
                <input type="number" min="0" step="1" v-model.number="formData.fatalityCount[c-1]">
              </td>
              <td class="total-cell">{{ rowSum(formData.fatalityCount) }}</td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <!-- 工伤损失工作日数（天） -->
      <fieldset>
        <legend>{{ year }}年职业健康安全统计 - 工伤损失工作日数 (天)</legend>
        <div class="table-wrapper">
          <table class="ohs-table">
            <thead>
            <tr>
              <th v-for="(m, idx) in monthNames" :key="`lost-h-${idx}`">{{ m }}</th>
              <th>合计</th>
            </tr>
            </thead>
            <tbody>
            <tr>
              <td v-for="c in 12" :key="`lost-c-${c-1}`">
                <input type="number" min="0" step="1" v-model.number="formData.lostWorkdays[c-1]">
              </td>
              <td class="total-cell">{{ rowSum(formData.lostWorkdays) }}</td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <!-- 安全生产投入（万元） -->
      <fieldset>
        <legend>{{ year }}年职业健康安全统计 - 安全生产投入 (万元)</legend>
        <div class="table-wrapper">
          <table class="ohs-table">
            <thead>
            <tr>
              <th v-for="(m, idx) in monthNames" :key="`safeinv-h-${idx}`">{{ m }}</th>
              <th>合计</th>
            </tr>
            </thead>
            <tbody>
            <tr>
              <td v-for="c in 12" :key="`safeinv-c-${c-1}`">
                <input type="number" min="0" step="0.01" v-model.number="formData.safetyInvestment[c-1]">
              </td>
              <td class="total-cell">{{ rowSum(formData.safetyInvestment) }}</td>
            </tr>
            </tbody>
          </table>
        </div>
        <small
            style="opacity:.7">安全费用包含安全标准化、应急预案、职业健康评测、体检等系统费用，安全设备/装置维护，消防培训与演练等相关费用。</small>
      </fieldset>

      <!-- 职业健康安全统计 - 汇总（总部统计） -->
      <fieldset class="summary-fieldset">
        <legend>{{ year }}年职业健康安全统计 - 汇总</legend>
        <div class="table-wrapper">
          <table class="ohs-table">
            <thead>
            <tr>
              <th>专职安全管理人员(人)</th>
              <th>员工体检人数(人)</th>
              <th>员工体检覆盖率(%)</th>
              <th>安全应急演练次数(次)</th>
              <th>安全检查排查隐患数(个)</th>
              <th>职业病体检人数(人)</th>
            </tr>
            </thead>
            <tbody>
            <tr>
              <td><input type="number" min="0" step="1" v-model.number="formData.safetyManagers"></td>
              <td><input type="number" min="0" step="1" v-model.number="formData.medicalChecks"></td>
              <td><input type="number" min="0" step="0.01" v-model.number="formData.coverageRate"></td>
              <td><input type="number" min="0" step="1" v-model.number="formData.emergencyDrills"></td>
              <td><input type="number" min="0" step="1" v-model.number="formData.hazardsFound"></td>
              <td><input type="number" min="0" step="1" v-model.number="formData.occupationalChecks"></td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <button type="submit" :disabled="isSubmitting">
        {{ isSubmitting ? '提交中...' : '提交职业健康与安全数据' }}
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

const monthNames = ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月']

// 表单数据模型
const formData = reactive({
  // 月度数据 (JSON格式存储)
  trainingCount: Array(12).fill(0),          // 培训次数（次）
  trainingParticipants: Array(12).fill(0),  // 培训参与人次（人次）
  trainingHours: Array(12).fill(0),          // 培训学时（小时）
  injuryCount: Array(12).fill(0),            // 工伤数量（次）
  incidentCount: Array(12).fill(0),          // 安全事故数量（次）
  fatalityCount: Array(12).fill(0),          // 工亡人数（人）
  lostWorkdays: Array(12).fill(0),           // 工伤损失工作日数（天）
  safetyInvestment: Array(12).fill(0),       // 安全生产投入（万元）

  // 汇总数据 (单个变量存储)
  safetyManagers: 0,         // 专职安全管理人员(人)
  medicalChecks: 0,          // 员工体检人数(人)
  coverageRate: 0,           // 员工体检覆盖率(%)
  emergencyDrills: 0,        // 安全应急演练次数(次)
  hazardsFound: 0,           // 安全检查排查隐患数(个)
  occupationalChecks: 0       // 职业病体检人数(人)
})

// 计算行合计
const rowSum = (arr) => arr.reduce((sum, val) => sum + (Number(val) || 0), 0)

// 提交数据
const submitOHS = async () => {
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
      // 添加计算字段
      trainingCountTotal: rowSum(formData.trainingCount),
      trainingParticipantsTotal: rowSum(formData.trainingParticipants),
      trainingHoursTotal: rowSum(formData.trainingHours),
      injuryCountTotal: rowSum(formData.injuryCount),
      incidentCountTotal: rowSum(formData.incidentCount),
      fatalityCountTotal: rowSum(formData.fatalityCount),
      lostWorkdaysTotal: rowSum(formData.lostWorkdays),
      safetyInvestmentTotal: rowSum(formData.safetyInvestment)
    }

    const response = await apiClient.post('/quantitative/ohs', payload)

    if (response.data.status === 'success') {
      alert('职业健康与安全数据提交成功!')
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
.table-wrapper {
  overflow: auto
}

.ohs-table {
  width: 100%;
  border-collapse: collapse
}

.ohs-table th, .ohs-table td {
  border: 1px solid #ddd;
  padding: 6px;
  text-align: center
}

.ohs-table thead th {
  position: sticky;
  top: 0;
  background: #f7f7f7;
  z-index: 1
}

.total-cell {
  font-weight: 600
}

.grand-total td {
  font-weight: 700;
  background: #fafafa
}

.ohs-table input {
  width: 100px
}

@media (max-width: 768px) {
  .ohs-table input {
    width: 80px
  }
}
</style>