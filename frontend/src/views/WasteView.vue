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

      <!-- 2024年废弃物统计-回收料（EPE) -->
      <fieldset>
        <legend>{{ year }}年废弃物统计 - 回收料（EPE）(T)</legend>
        <div class="table-wrapper">
          <table class="waste-table">
            <thead>
            <tr>
              <th>工厂</th>
              <th>单位</th>
              <th v-for="(m, idx) in monthNames" :key="`epe-h-${idx}`">{{ m }}</th>
              <th>合计</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="(factoryName, r) in factories" :key="`epe-r-${r}`">
              <td class="factory-cell">{{ factoryName }}</td>
              <td>T</td>
              <td v-for="c in 12" :key="`epe-c-${r}-${c-1}`">
                <input type="number" min="0" step="0.01" v-model.number="epe[r][c-1]">
              </td>
              <td class="total-cell">{{ rowSum(epe[r]) }}</td>
            </tr>
            <tr class="grand-total">
              <td>合计</td>
              <td>-</td>
              <td v-for="c in 12" :key="`epe-gt-${c-1}`">{{ colSum(epe, c-1) }}</td>
              <td>{{ tableSum(epe) }}</td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <!-- 2024年废弃物统计-回收料（吸塑、纸塑) -->
      <fieldset>
        <legend>{{ year }}年废弃物统计 - 回收料（吸塑、纸塑）(T)</legend>
        <div class="table-wrapper">
          <table class="waste-table">
            <thead>
            <tr>
              <th>工厂</th>
              <th>单位</th>
              <th v-for="(m, idx) in monthNames" :key="`pp-h-${idx}`">{{ m }}</th>
              <th>合计</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="(factoryName, r) in factories" :key="`pp-r-${r}`">
              <td class="factory-cell">{{ factoryName }}</td>
              <td>T</td>
              <td v-for="c in 12" :key="`pp-c-${r}-${c-1}`">
                <input type="number" min="0" step="0.01" v-model.number="plasticPaper[r][c-1]">
              </td>
              <td class="total-cell">{{ rowSum(plasticPaper[r]) }}</td>
            </tr>
            <tr class="grand-total">
              <td>合计</td>
              <td>-</td>
              <td v-for="c in 12" :key="`pp-gt-${c-1}`">{{ colSum(plasticPaper, c-1) }}</td>
              <td>{{ tableSum(plasticPaper) }}</td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <!-- 2024年废弃物统计-生活&工业垃圾 -->
      <fieldset>
        <legend>{{ year }}年废弃物统计 - 生活&工业垃圾 (T)</legend>
        <div class="table-wrapper">
          <table class="waste-table">
            <thead>
            <tr>
              <th>工厂</th>
              <th>单位</th>
              <th v-for="(m, idx) in monthNames" :key="`lig-h-${idx}`">{{ m }}</th>
              <th>合计</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="(factoryName, r) in factories" :key="`lig-r-${r}`">
              <td class="factory-cell">{{ factoryName }}</td>
              <td>T</td>
              <td v-for="c in 12" :key="`lig-c-${r}-${c-1}`">
                <input type="number" min="0" step="0.01" v-model.number="domesticIndustrial[r][c-1]">
              </td>
              <td class="total-cell">{{ rowSum(domesticIndustrial[r]) }}</td>
            </tr>
            <tr class="grand-total">
              <td>合计</td>
              <td>-</td>
              <td v-for="c in 12" :key="`lig-gt-${c-1}`">{{ colSum(domesticIndustrial, c-1) }}</td>
              <td>{{ tableSum(domesticIndustrial) }}</td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <!-- 2024年废弃物统计-危废 -->
      <fieldset>
        <legend>{{ year }}年废弃物统计 - 危废 (T)</legend>
        <div class="table-wrapper">
          <table class="waste-table">
            <thead>
            <tr>
              <th>工厂</th>
              <th>单位</th>
              <th v-for="(m, idx) in monthNames" :key="`haz-h-${idx}`">{{ m }}</th>
              <th>合计</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="(factoryName, r) in factories" :key="`haz-r-${r}`">
              <td class="factory-cell">{{ factoryName }}</td>
              <td>T</td>
              <td v-for="c in 12" :key="`haz-c-${r}-${c-1}`">
                <input type="number" min="0" step="0.01" v-model.number="hazardous[r][c-1]">
              </td>
              <td class="total-cell">{{ rowSum(hazardous[r]) }}</td>
            </tr>
            <tr class="grand-total">
              <td>合计</td>
              <td>-</td>
              <td v-for="c in 12" :key="`haz-gt-${c-1}`">{{ colSum(hazardous, c-1) }}</td>
              <td>{{ tableSum(hazardous) }}</td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <!-- 2024年废水排放量统计 -->
      <fieldset>
        <legend>{{ year }}年废水排放量统计 (T)</legend>
        <div class="table-wrapper">
          <table class="waste-table">
            <thead>
            <tr>
              <th>工厂</th>
              <th>单位</th>
              <th v-for="(m, idx) in monthNames" :key="`ww-h-${idx}`">{{ m }}</th>
              <th>合计</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="(factoryName, r) in factories" :key="`ww-r-${r}`">
              <td class="factory-cell">{{ factoryName }}</td>
              <td>T</td>
              <td v-for="c in 12" :key="`ww-c-${r}-${c-1}`">
                <input type="number" min="0" step="0.01" v-model.number="wastewater[r][c-1]">
              </td>
              <td class="total-cell">{{ rowSum(wastewater[r]) }}</td>
            </tr>
            <tr class="grand-total">
              <td>合计</td>
              <td>-</td>
              <td v-for="c in 12" :key="`ww-gt-${c-1}`">{{ colSum(wastewater, c-1) }}</td>
              <td>{{ tableSum(wastewater) }}</td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <!-- 汇总 -->
      <fieldset class="summary-fieldset">
        <legend>{{ year }}年废弃物统计 - 汇总</legend>
        <div class="table-wrapper">
          <table class="waste-table">
            <thead>
            <tr>
              <th>工厂</th>
              <th>单位</th>
              <th>回收料EPE</th>
              <th>回收料吸塑/纸塑</th>
              <th>生活&工业垃圾</th>
              <th>无害废弃物总量</th>
              <th>有害废弃物总量</th>
              <th>废弃物总量</th>
              <th>可回收废弃物总量</th>
              <th>需处置废弃物总量</th>
              <th>废弃物回收率(%)</th>
              <th>防护产品废弃物综合利用率(%)</th>
              <th>营业收入(万元)</th>
              <th>有害废弃物强度(T/万元)</th>
              <th>废水排放量(T)</th>
              <th>废水排放强度(T/万元)</th>
              <th>排放超标事件(次)</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="(factoryName, r) in factories" :key="`sum-r-${r}`">
              <td class="factory-cell">{{ factoryName }}</td>
              <td>T</td>
              <td>{{ epeTotals[r] }}</td>
              <td>{{ plasticPaperTotals[r] }}</td>
              <td>{{ domesticIndustrialTotals[r] }}</td>
              <td>{{ nonHazardousTotals[r] }}</td>
              <td>{{ hazardousTotals[r] }}</td>
              <td>{{ totalWaste[r] }}</td>
              <td>{{ recyclableTotals[r] }}</td>
              <td>{{ disposalRequiredTotals[r] }}</td>
              <td>{{ recycleRate[r] }}</td>
              <td>
                <input type="number" min="0" step="0.01" v-model.number="protectiveReuseRate[r]">
              </td>
              <td>
                <input type="number" min="0" step="0.01" v-model.number="revenue[r]">
              </td>
              <td>{{ hazardousIntensity[r] }}</td>
              <td>{{ wastewaterTotals[r] }}</td>
              <td>{{ wastewaterIntensity[r] }}</td>
              <td>
                <input type="number" min="0" step="1" v-model.number="exceedEvents[r]">
              </td>
            </tr>
            <tr class="grand-total">
              <td>合计</td>
              <td>-</td>
              <td>{{ sumArray(epeTotals) }}</td>
              <td>{{ sumArray(plasticPaperTotals) }}</td>
              <td>{{ sumArray(domesticIndustrialTotals) }}</td>
              <td>{{ sumArray(nonHazardousTotals) }}</td>
              <td>{{ sumArray(hazardousTotals) }}</td>
              <td>{{ sumArray(totalWaste) }}</td>
              <td>{{ sumArray(recyclableTotals) }}</td>
              <td>{{ sumArray(disposalRequiredTotals) }}</td>
              <td>{{ overallRecycleRate }}</td>
              <td>-</td>
              <td>{{ sumArray(revenue) }}</td>
              <td>{{ overallHazardousIntensity }}</td>
              <td>{{ sumArray(wastewaterTotals) }}</td>
              <td>{{ overallWastewaterIntensity }}</td>
              <td>{{ sumArray(exceedEvents) }}</td>
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

// 构建二维矩阵 [工厂行][12个月]
function buildMatrix(rows){
  return Array.from({length: rows}, () => Array(12).fill(0))
}

const epe = reactive(buildMatrix(factories.value.length))
const plasticPaper = reactive(buildMatrix(factories.value.length))
const domesticIndustrial = reactive(buildMatrix(factories.value.length))
const hazardous = reactive(buildMatrix(factories.value.length))
const wastewater = reactive(buildMatrix(factories.value.length))

// 资金投入矩阵
const envInvest = reactive(buildMatrix(factories.value.length))
const cleanTechInvest = reactive(buildMatrix(factories.value.length))
const climateInvest = reactive(buildMatrix(factories.value.length))
const greenIncome = reactive(buildMatrix(factories.value.length))

// 汇总输入项
const revenue = reactive(Array(factories.value.length).fill(0))
const exceedEvents = reactive(Array(factories.value.length).fill(0))
const protectiveReuseRate = reactive(Array(factories.value.length).fill(0))

// 工具函数
const rowSum = (row) => row.reduce((s,v)=> s + (Number(v)||0), 0)
const colSum = (matrix, colIdx) => matrix.reduce((s,row)=> s + (Number(row[colIdx])||0), 0)
const tableSum = (matrix) => matrix.reduce((s,row)=> s + rowSum(row), 0)
const sumArray = (arr) => arr.reduce((s,v)=> s + (Number(v)||0), 0)

// 各类行合计
const epeTotals = computed(()=> epe.map(r=> rowSum(r)))
const plasticPaperTotals = computed(()=> plasticPaper.map(r=> rowSum(r)))
const domesticIndustrialTotals = computed(()=> domesticIndustrial.map(r=> rowSum(r)))
const hazardousTotals = computed(()=> hazardous.map(r=> rowSum(r)))
const wastewaterTotals = computed(()=> wastewater.map(r=> rowSum(r)))

// 推导汇总
const nonHazardousTotals = computed(()=> epeTotals.value.map((_,i)=> epeTotals.value[i] + plasticPaperTotals.value[i] + domesticIndustrialTotals.value[i]))
const recyclableTotals = computed(()=> epeTotals.value.map((_,i)=> epeTotals.value[i] + plasticPaperTotals.value[i]))
const totalWaste = computed(()=> nonHazardousTotals.value.map((_,i)=> nonHazardousTotals.value[i] + hazardousTotals.value[i]))
const disposalRequiredTotals = computed(()=> domesticIndustrialTotals.value.map((_,i)=> domesticIndustrialTotals.value[i] + hazardousTotals.value[i]))
const recycleRate = computed(()=> totalWaste.value.map((tw,i)=> tw>0? ((recyclableTotals.value[i]/tw)*100).toFixed(2): 0))

const hazardousIntensity = computed(()=> hazardousTotals.value.map((v,i)=> revenue[i] > 0 ? (v / revenue[i]).toFixed(4) : 0))
const wastewaterIntensity = computed(()=> wastewaterTotals.value.map((v,i)=> revenue[i] > 0 ? (v / revenue[i]).toFixed(4) : 0))

const overallRecycleRate = computed(()=> {
  const tw = sumArray(totalWaste.value)
  const rc = sumArray(recyclableTotals.value)
  return tw>0? ((rc/tw)*100).toFixed(2) : 0
})
const overallHazardousIntensity = computed(()=> {
  const hz = sumArray(hazardousTotals.value)
  const rev = sumArray(revenue)
  return rev>0? (hz/rev).toFixed(4) : 0
})
const overallWastewaterIntensity = computed(()=> {
  const ww = sumArray(wastewaterTotals.value)
  const rev = sumArray(revenue)
  return rev>0? (ww/rev).toFixed(4) : 0
})

async function submitForm(){
  isSubmitting.value = true
  try{
    const payload = {
      year: Number(year.value),
      factories: factories.value,
      epe,
      plasticPaper,
      domesticIndustrial,
      hazardous,
      wastewater,
      epeTotals: epeTotals.value,
      plasticPaperTotals: plasticPaperTotals.value,
      domesticIndustrialTotals: domesticIndustrialTotals.value,
      hazardousTotals: hazardousTotals.value,
      wastewaterTotals: wastewaterTotals.value,
      nonHazardousTotals: nonHazardousTotals.value,
      recyclableTotals: recyclableTotals.value,
      totalWaste: totalWaste.value,
      disposalRequiredTotals: disposalRequiredTotals.value,
      recycleRate: recycleRate.value,
      revenue: [...revenue],
      protectiveReuseRate: [...protectiveReuseRate],
      exceedEvents: [...exceedEvents],
      overall: {
        overallRecycleRate: overallRecycleRate.value,
        overallHazardousIntensity: overallHazardousIntensity.value,
        overallWastewaterIntensity: overallWastewaterIntensity.value
      }
    }

    const resp = await axios.post('http://localhost:8000/submit/waste', payload)
    if(resp.data.status === 'success'){
      alert('废弃物数据提交成功!')
    }
  }catch(err){
    console.error('提交失败:', err)
    alert(`提交失败: ${err.response?.data?.detail || err.message}`)
  }finally{
    isSubmitting.value = false
  }
}

async function submitInvestment(){
  isSubmitting.value = true
  try{
    const payload = {
      year: Number(year.value),
      factories: factories.value,
      envInvest,
      cleanTechInvest,
      climateInvest,
      greenIncome,
      envInvestTotals: envInvest.map(row=> rowSum(row)),
      cleanTechInvestTotals: cleanTechInvest.map(row=> rowSum(row)),
      climateInvestTotals: climateInvest.map(row=> rowSum(row)),
      greenIncomeTotals: greenIncome.map(row=> rowSum(row))
    }
    const resp = await axios.post('http://localhost:8000/submit/investment', payload)
    if(resp.data.status==='success'){
      alert('资金投入数据提交成功!')
    }
  }catch(err){
    console.error(err)
    alert(`提交失败: ${err.response?.data?.detail || err.message}`)
  }finally{
    isSubmitting.value = false
  }
}
</script>

<style scoped>
.table-wrapper{overflow:auto}
.waste-table{width:100%; border-collapse:collapse}
.waste-table th,.waste-table td{border:1px solid #ddd; padding:6px; text-align:center}
.waste-table thead th{position:sticky; top:0; background:#f7f7f7; z-index:1}
.factory-cell{white-space:nowrap; text-align:left}
.total-cell{font-weight:600}
.grand-total td{font-weight:700; background:#fafafa}
.waste-table input{width:100px}
@media (max-width: 768px){.waste-table input{width:80px}}
</style>


