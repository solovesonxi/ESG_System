<template>
  <div class="shared-form">
    <form @submit.prevent="submitOHS">
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
                <div v-for="f in factories" :key="f" class="option" :class="{ 'selected-option': f === factory }" @click="selectionStore.selectFactory(f)">{{ f }}</div>
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
                <div v-for="y in years" :key="y" class="option" :class="{ 'selected-option': y === year }" @click="selectionStore.selectYear(y)">{{ y }}年</div>
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
              <th>工厂</th>
              <th>单位</th>
              <th v-for="(m, idx) in monthNames" :key="`tc-h-${idx}`">{{ m }}</th>
              <th>合计</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="(factoryName, r) in factories" :key="`tc-r-${r}`">
              <td class="factory-cell">{{ factoryName }}</td>
              <td>次</td>
              <td v-for="c in 12" :key="`tc-c-${r}-${c-1}`"><input type="number" min="0" step="1" v-model.number="trainingCount[r][c-1]"></td>
              <td class="total-cell">{{ rowSum(trainingCount[r]) }}</td>
            </tr>
            <tr class="grand-total">
              <td>合计</td>
              <td>-</td>
              <td v-for="c in 12" :key="`tc-gt-${c-1}`">{{ colSum(trainingCount, c-1) }}</td>
              <td>{{ tableSum(trainingCount) }}</td>
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
              <th>工厂</th>
              <th>单位</th>
              <th v-for="(m, idx) in monthNames" :key="`tp-h-${idx}`">{{ m }}</th>
              <th>合计</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="(factoryName, r) in factories" :key="`tp-r-${r}`">
              <td class="factory-cell">{{ factoryName }}</td>
              <td>人次</td>
              <td v-for="c in 12" :key="`tp-c-${r}-${c-1}`"><input type="number" min="0" step="1" v-model.number="trainingParticipants[r][c-1]"></td>
              <td class="total-cell">{{ rowSum(trainingParticipants[r]) }}</td>
            </tr>
            <tr class="grand-total">
              <td>合计</td>
              <td>-</td>
              <td v-for="c in 12" :key="`tp-gt-${c-1}`">{{ colSum(trainingParticipants, c-1) }}</td>
              <td>{{ tableSum(trainingParticipants) }}</td>
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
              <th>工厂</th>
              <th>单位</th>
              <th v-for="(m, idx) in monthNames" :key="`th-h-${idx}`">{{ m }}</th>
              <th>合计</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="(factoryName, r) in factories" :key="`th-r-${r}`">
              <td class="factory-cell">{{ factoryName }}</td>
              <td>小时</td>
              <td v-for="c in 12" :key="`th-c-${r}-${c-1}`"><input type="number" min="0" step="0.1" v-model.number="trainingHours[r][c-1]"></td>
              <td class="total-cell">{{ rowSum(trainingHours[r]) }}</td>
            </tr>
            <tr class="grand-total">
              <td>合计</td>
              <td>-</td>
              <td v-for="c in 12" :key="`th-gt-${c-1}`">{{ colSum(trainingHours, c-1) }}</td>
              <td>{{ tableSum(trainingHours) }}</td>
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
              <th>工厂</th>
              <th>单位</th>
              <th v-for="(m, idx) in monthNames" :key="`inj-h-${idx}`">{{ m }}</th>
              <th>合计</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="(factoryName, r) in factories" :key="`inj-r-${r}`">
              <td class="factory-cell">{{ factoryName }}</td>
              <td>次</td>
              <td v-for="c in 12" :key="`inj-c-${r}-${c-1}`"><input type="number" min="0" step="1" v-model.number="injuryCount[r][c-1]"></td>
              <td class="total-cell">{{ rowSum(injuryCount[r]) }}</td>
            </tr>
            <tr class="grand-total">
              <td>合计</td>
              <td>-</td>
              <td v-for="c in 12" :key="`inj-gt-${c-1}`">{{ colSum(injuryCount, c-1) }}</td>
              <td>{{ tableSum(injuryCount) }}</td>
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
              <th>工厂</th>
              <th>单位</th>
              <th v-for="(m, idx) in monthNames" :key="`acc-h-${idx}`">{{ m }}</th>
              <th>合计</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="(factoryName, r) in factories" :key="`acc-r-${r}`">
              <td class="factory-cell">{{ factoryName }}</td>
              <td>次</td>
              <td v-for="c in 12" :key="`acc-c-${r}-${c-1}`"><input type="number" min="0" step="1" v-model.number="incidentCount[r][c-1]"></td>
              <td class="total-cell">{{ rowSum(incidentCount[r]) }}</td>
            </tr>
            <tr class="grand-total">
              <td>合计</td>
              <td>-</td>
              <td v-for="c in 12" :key="`acc-gt-${c-1}`">{{ colSum(incidentCount, c-1) }}</td>
              <td>{{ tableSum(incidentCount) }}</td>
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
              <th>工厂</th>
              <th>单位</th>
              <th v-for="(m, idx) in monthNames" :key="`fat-h-${idx}`">{{ m }}</th>
              <th>合计</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="(factoryName, r) in factories" :key="`fat-r-${r}`">
              <td class="factory-cell">{{ factoryName }}</td>
              <td>人</td>
              <td v-for="c in 12" :key="`fat-c-${r}-${c-1}`"><input type="number" min="0" step="1" v-model.number="fatalityCount[r][c-1]"></td>
              <td class="total-cell">{{ rowSum(fatalityCount[r]) }}</td>
            </tr>
            <tr class="grand-total">
              <td>合计</td>
              <td>-</td>
              <td v-for="c in 12" :key="`fat-gt-${c-1}`">{{ colSum(fatalityCount, c-1) }}</td>
              <td>{{ tableSum(fatalityCount) }}</td>
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
              <th>工厂</th>
              <th>单位</th>
              <th v-for="(m, idx) in monthNames" :key="`lost-h-${idx}`">{{ m }}</th>
              <th>合计</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="(factoryName, r) in factories" :key="`lost-r-${r}`">
              <td class="factory-cell">{{ factoryName }}</td>
              <td>天</td>
              <td v-for="c in 12" :key="`lost-c-${r}-${c-1}`"><input type="number" min="0" step="1" v-model.number="lostWorkdays[r][c-1]"></td>
              <td class="total-cell">{{ rowSum(lostWorkdays[r]) }}</td>
            </tr>
            <tr class="grand-total">
              <td>合计</td>
              <td>-</td>
              <td v-for="c in 12" :key="`lost-gt-${c-1}`">{{ colSum(lostWorkdays, c-1) }}</td>
              <td>{{ tableSum(lostWorkdays) }}</td>
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
              <th>工厂</th>
              <th>单位</th>
              <th v-for="(m, idx) in monthNames" :key="`safeinv-h-${idx}`">{{ m }}</th>
              <th>合计</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="(factoryName, r) in factories" :key="`safeinv-r-${r}`">
              <td class="factory-cell">{{ factoryName }}</td>
              <td>万元</td>
              <td v-for="c in 12" :key="`safeinv-c-${r}-${c-1}`"><input type="number" min="0" step="0.01" v-model.number="safetyInvestment[r][c-1]"></td>
              <td class="total-cell">{{ rowSum(safetyInvestment[r]) }}</td>
            </tr>
            <tr class="grand-total">
              <td>合计</td>
              <td>-</td>
              <td v-for="c in 12" :key="`safeinv-gt-${c-1}`">{{ colSum(safetyInvestment, c-1) }}</td>
              <td>{{ tableSum(safetyInvestment) }}</td>
            </tr>
            </tbody>
          </table>
        </div>
        <small style="opacity:.7">安全费用包含安全标准化、应急预案、职业健康评测、体检等系统费用，安全设备/装置维护，消防培训与演练等相关费用。</small>
      </fieldset>

      <!-- 职业健康安全统计 - 汇总（总部统计） -->
      <fieldset class="summary-fieldset">
        <legend>{{ year }}年职业健康安全统计 - 汇总（总部统计）</legend>
        <div class="table-wrapper">
          <table class="ohs-table">
            <thead>
            <tr>
              <th>工厂</th>
              <th>单位</th>
              <th>专职安全管理人员(人)</th>
              <th>员工体检人数(人)</th>
              <th>员工体检覆盖率(%)</th>
              <th>安全应急演练次数(次)</th>
              <th>安全检查排查隐患数(个)</th>
              <th>职业病体检人数(人)</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="(factoryName, r) in factories" :key="`sum-r-${r}`">
              <td class="factory-cell">{{ factoryName }}</td>
              <td>-</td>
              <td><input type="number" min="0" step="1" v-model.number="safetyManagers[r]"></td>
              <td><input type="number" min="0" step="1" v-model.number="medicalChecks[r]"></td>
              <td><input type="number" min="0" step="0.01" v-model.number="coverageRate[r]"></td>
              <td><input type="number" min="0" step="1" v-model.number="emergencyDrills[r]"></td>
              <td><input type="number" min="0" step="1" v-model.number="hazardsFound[r]"></td>
              <td><input type="number" min="0" step="1" v-model.number="occupationalChecks[r]"></td>
            </tr>
            <tr class="grand-total">
              <td>合计</td>
              <td>-</td>
              <td>{{ sumArray(safetyManagers) }}</td>
              <td>{{ sumArray(medicalChecks) }}</td>
              <td>-</td>
              <td>{{ sumArray(emergencyDrills) }}</td>
              <td>{{ sumArray(hazardsFound) }}</td>
              <td>{{ sumArray(occupationalChecks) }}</td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <button type="submit" :disabled="isSubmitting">{{ isSubmitting ? '提交中...' : '提交职业健康与安全数据' }}</button>
    </form>
  </div>
</template>

<script setup>
import {computed, onBeforeUnmount, onMounted, reactive, ref} from 'vue'
import axios from 'axios'
import {useSelectionStore} from '@/stores/selectionStore'

const selectionStore = useSelectionStore()
const factory = computed(()=> selectionStore.selectedFactory)
const factories = computed(()=> selectionStore.factories)
const year = computed(()=> selectionStore.selectedYear)
const years = computed(()=> selectionStore.years)
const isSubmitting = ref(false)

onMounted(()=>{
  selectionStore.initYears()
  document.addEventListener('click', selectionStore.handleClickOutside)
})
onBeforeUnmount(()=>{
  document.removeEventListener('click', selectionStore.handleClickOutside)
})

const monthNames = ['1月','2月','3月','4月','5月','6月','7月','8月','9月','10月','11月','12月']
function buildMatrix(rows){
  return Array.from({length: rows}, ()=> Array(12).fill(0))
}

// 月度矩阵
const trainingCount = reactive(buildMatrix(factories.value.length))
const trainingParticipants = reactive(buildMatrix(factories.value.length))
const trainingHours = reactive(buildMatrix(factories.value.length))
const injuryCount = reactive(buildMatrix(factories.value.length))
const incidentCount = reactive(buildMatrix(factories.value.length))
const fatalityCount = reactive(buildMatrix(factories.value.length))
const lostWorkdays = reactive(buildMatrix(factories.value.length))
const safetyInvestment = reactive(buildMatrix(factories.value.length))

// 汇总数组
const safetyManagers = reactive(Array(factories.value.length).fill(0))
const medicalChecks = reactive(Array(factories.value.length).fill(0))
const coverageRate = reactive(Array(factories.value.length).fill(0))
const emergencyDrills = reactive(Array(factories.value.length).fill(0))
const hazardsFound = reactive(Array(factories.value.length).fill(0))
const occupationalChecks = reactive(Array(factories.value.length).fill(0))

// 计算工具
const rowSum = (row)=> row.reduce((s,v)=> s + (Number(v)||0), 0)
const colSum = (matrix, c)=> matrix.reduce((s,r)=> s + (Number(r[c])||0), 0)
const tableSum = (matrix)=> matrix.reduce((s,r)=> s + rowSum(r), 0)
const sumArray = (arr)=> arr.reduce((s,v)=> s + (Number(v)||0), 0)

async function submitOHS(){
  isSubmitting.value = true
  try{
    const payload = {
      year: Number(year.value),
      factories: factories.value,
      trainingCount,
      trainingParticipants,
      trainingHours,
      injuryCount,
      incidentCount,
      fatalityCount,
      lostWorkdays,
      safetyInvestment,
      trainingCountTotals: trainingCount.map(r=> rowSum(r)),
      trainingParticipantsTotals: trainingParticipants.map(r=> rowSum(r)),
      trainingHoursTotals: trainingHours.map(r=> rowSum(r)),
      injuryCountTotals: injuryCount.map(r=> rowSum(r)),
      incidentCountTotals: incidentCount.map(r=> rowSum(r)),
      fatalityCountTotals: fatalityCount.map(r=> rowSum(r)),
      lostWorkdaysTotals: lostWorkdays.map(r=> rowSum(r)),
      safetyInvestmentTotals: safetyInvestment.map(r=> rowSum(r)),
      summary: {
        safetyManagers: [...safetyManagers],
        medicalChecks: [...medicalChecks],
        coverageRate: [...coverageRate],
        emergencyDrills: [...emergencyDrills],
        hazardsFound: [...hazardsFound],
        occupationalChecks: [...occupationalChecks]
      }
    }
    const resp = await axios.post('http://localhost:8000/submit/ohs', payload)
    if(resp.data.status==='success') alert('职业健康与安全数据提交成功!')
  }catch(e){
    console.error(e)
    alert(`提交失败: ${e.response?.data?.detail || e.message}`)
  }finally{
    isSubmitting.value = false
  }
}
</script>

<style scoped>
.table-wrapper{overflow:auto}
.ohs-table{width:100%; border-collapse:collapse}
.ohs-table th,.ohs-table td{border:1px solid #ddd; padding:6px; text-align:center}
.ohs-table thead th{position:sticky; top:0; background:#f7f7f7; z-index:1}
.factory-cell{white-space:nowrap; text-align:left}
.total-cell{font-weight:600}
.grand-total td{font-weight:700; background:#fafafa}
.ohs-table input{width:100px}
@media (max-width: 768px){.ohs-table input{width:80px}}
</style>


