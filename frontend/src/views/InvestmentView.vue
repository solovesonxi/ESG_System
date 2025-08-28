<template>
  <div class="shared-form">
    <form @submit.prevent="submitForm">
      <!-- 基础信息 -->
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

      <!-- 环保投入表格 -->
      <fieldset>
        <legend>{{ year }}年环保投入 （万元）</legend>
        <div class="table-wrapper">
          <table class="waste-table">
            <thead>
            <tr>
              <th v-for="(m, idx) in monthNames" :key="`env-h-${idx}`">{{ m }}</th>
              <th>合计</th>
            </tr>
            </thead>
            <tbody>
            <tr>
              <td v-for="c in 12" :key="`env-c-${c-1}`">
                <input type="number" min="0" step="0.01" v-model.number="envInvest[c-1]">
              </td>
              <td class="total-cell">{{ envInvestTotal }}</td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <!-- 清洁技术投入表格 -->
      <fieldset>
        <legend>{{ year }}年清洁技术投入 （万元）</legend>
        <div class="table-wrapper">
          <table class="waste-table">
            <thead>
            <tr>
              <th v-for="(m, idx) in monthNames" :key="`clean-h-${idx}`">{{ m }}</th>
              <th>合计</th>
            </tr>
            </thead>
            <tbody>
            <tr>
              <td v-for="c in 12" :key="`clean-c-${c-1}`">
                <input type="number" min="0" step="0.01" v-model.number="cleanTechInvest[c-1]">
              </td>
              <td class="total-cell">{{ cleanTechInvestTotal }}</td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <!-- 气候投入表格 -->
      <fieldset>
        <legend>{{ year }}年气候投入 （万元）</legend>
        <div class="table-wrapper">
          <table class="waste-table">
            <thead>
            <tr>
              <th v-for="(m, idx) in monthNames" :key="`climate-h-${idx}`">{{ m }}</th>
              <th>合计</th>
            </tr>
            </thead>
            <tbody>
            <tr>
              <td v-for="c in 12" :key="`climate-c-${c-1}`">
                <input type="number" min="0" step="0.01" v-model.number="climateInvest[c-1]">
              </td>
              <td class="total-cell">{{ climateInvestTotal }}</td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <!-- 绿色收入表格 -->
      <fieldset>
        <legend>{{ year }}年绿色收入 （万元）</legend>
        <div class="table-wrapper">
          <table class="waste-table">
            <thead>
            <tr>
              <th v-for="(m, idx) in monthNames" :key="`green-h-${idx}`">{{ m }}</th>
              <th>合计</th>
            </tr>
            </thead>
            <tbody>
            <tr>
              <td v-for="c in 12" :key="`green-c-${c-1}`">
                <input type="number" min="0" step="0.01" v-model.number="greenIncome[c-1]">
              </td>
              <td class="total-cell">{{ greenIncomeTotal }}</td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <!-- 汇总 -->
      <fieldset class="summary-fieldset">
        <legend>{{ year }}年资金投入统计 - 汇总 （万元）</legend>
        <div class="table-wrapper">
          <table class="waste-table">
            <thead>
            <tr>
              <th>环保投入</th>
              <th>清洁技术投入</th>
              <th>气候投入</th>
              <th>绿色收入</th>
              <th>总投入</th>
              <th>总营收</th>
              <th>环保投入强度 （%）</th>
              <th>绿色收入占比 （%）</th>
            </tr>
            </thead>
            <tbody>
            <tr>
              <td>{{ envInvestTotal }}</td>
              <td>{{ cleanTechInvestTotal }}</td>
              <td>{{ climateInvestTotal }}</td>
              <td>{{ greenIncomeTotal }}</td>
              <td>{{ totalInvestment }}</td>
              <td>
                <input type="number" min="0" step="0.01" v-model.number="totalRevenue">
              </td>
              <td>{{ envInvestIntensity}}</td>
              <td>{{ greenIncomeRatio }}</td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <button type="submit" :disabled="isSubmitting">
        {{ isSubmitting ? '提交中...' : '提交数据' }}
      </button>
    </form>
  </div>
</template>

<script setup>
import {computed, onBeforeUnmount, onMounted, reactive, ref} from 'vue'
import axios from 'axios'
import {useSelectionStore} from '@/stores/selectionStore'

const selectionStore = useSelectionStore()
const factory = computed(() => selectionStore.selectedFactory)
const factories = computed(() => selectionStore.factories)
const year = computed(() => selectionStore.selectedYear)
const years = computed(() => selectionStore.years)
const isSubmitting = ref(false)

onMounted(() => {
  selectionStore.initYears()
  document.addEventListener('click', selectionStore.handleClickOutside)
})

onBeforeUnmount(() => {
  document.removeEventListener('click', selectionStore.handleClickOutside)
})

const monthNames = [
  '1月','2月','3月','4月','5月','6月','7月','8月','9月','10月','11月','12月'
]

// 初始化数据 - 只存储当前工厂的数据
const envInvest = reactive(Array(12).fill(0))        // 环保投入
const cleanTechInvest = reactive(Array(12).fill(0))  // 清洁技术投入
const climateInvest = reactive(Array(12).fill(0))    // 气候投入
const greenIncome = reactive(Array(12).fill(0))      // 绿色收入

// 工具函数 - 计算行合计
const rowSum = (arr) => arr.reduce((s, v) => s + (Number(v) || 0), 0).toFixed(2)

// 计算各类资金合计
const envInvestTotal = computed(() => rowSum(envInvest))
const cleanTechInvestTotal = computed(() => rowSum(cleanTechInvest))
const climateInvestTotal = computed(() => rowSum(climateInvest))
const greenIncomeTotal = computed(() => rowSum(greenIncome))

// 计算汇总指标
const totalInvestment = computed(() => {
  return (parseFloat(envInvestTotal.value) +
      parseFloat(cleanTechInvestTotal.value) +
      parseFloat(climateInvestTotal.value)).toFixed(2)
})

const totalRevenue = ref(0);
const envInvestIntensity = computed(() => {
  if (totalRevenue.value === 0) return 0;
  return ((parseFloat(envInvestTotal.value) / parseFloat(totalRevenue.value)) * 100).toFixed(2);
});

const greenIncomeRatio = computed(() => {
  if (parseFloat(totalInvestment.value) > 0) {
    return ((parseFloat(greenIncomeTotal.value) / parseFloat(totalInvestment.value)) * 100).toFixed(2)
  }
  return 0
})

async function submitForm(){
  isSubmitting.value = true
  try{
    const payload = {
      year: Number(year.value),
      factory: factory.value,
      envInvest: [...envInvest],
      cleanTechInvest: [...cleanTechInvest],
      climateInvest: [...climateInvest],
      greenIncome: [...greenIncome],
      envInvestTotal: envInvestTotal.value,
      cleanTechInvestTotal: cleanTechInvestTotal.value,
      climateInvestTotal: climateInvestTotal.value,
      greenIncomeTotal: greenIncomeTotal.value,
      totalInvestment: totalInvestment.value,
      greenIncomeRatio: greenIncomeRatio.value,
      totalRevenue: totalRevenue.value,
      envInvestIntensity: envInvestIntensity.value
    }

    const resp = await axios.post('http://localhost:8000/quantitative/investment', payload)
    if(resp.data.status === 'success'){
      alert('资金投入数据提交成功!')
    }
  }catch(err){
    console.error('提交失败:', err)
    alert(`提交失败: ${err.response?.data?.detail || err.message}`)
  }finally{
    isSubmitting.value = false
  }
}
</script>

<style scoped>
.table-wrapper {
  overflow: auto;
}

.waste-table {
  width: 100%;
  border-collapse: collapse;
}

.waste-table th, .waste-table td {
  border: 1px solid #ddd;
  padding: 8px;
  text-align: center;
}

.waste-table thead th {
  position: sticky;
  top: 0;
  background: #f7f7f7;
  z-index: 1;
}

.total-cell {
  font-weight: 600;
  background-color: #f5f5f5;
}

.summary-fieldset .waste-table td {
  min-width: 100px;
}

.waste-table input {
  width: 80px;
  padding: 4px;
  text-align: center;
}

@media (max-width: 768px) {
  .table-wrapper {
    overflow-x: auto;
  }

  .waste-table {
    font-size: 12px;
  }

  .waste-table th, .waste-table td {
    padding: 6px;
  }

  .waste-table input {
    width: 60px;
    padding: 2px;
  }
}
</style>