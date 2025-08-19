<template>
  <div class="shared-form">
    <form @submit.prevent="submitInvestment">
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

      <!-- 环保投入 -->
      <fieldset>
        <legend>{{ year }}年资金投入统计 - 环保 (万元)</legend>
        <div class="table-wrapper">
          <table class="waste-table">
            <thead>
            <tr>
              <th>工厂</th>
              <th>单位</th>
              <th v-for="(m, idx) in monthNames" :key="`env-h-${idx}`">{{ m }}</th>
              <th>合计</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="(factoryName, r) in factories" :key="`env-r-${r}`">
              <td class="factory-cell">{{ factoryName }}</td>
              <td>万元</td>
              <td v-for="c in 12" :key="`env-c-${r}-${c-1}`"><input type="number" min="0" step="0.01" v-model.number="envInvest[r][c-1]"></td>
              <td class="total-cell">{{ rowSum(envInvest[r]) }}</td>
            </tr>
            <tr class="grand-total">
              <td>合计</td>
              <td>-</td>
              <td v-for="c in 12" :key="`env-gt-${c-1}`">{{ colSum(envInvest, c-1) }}</td>
              <td>{{ tableSum(envInvest) }}</td>
            </tr>
            </tbody>
          </table>
        </div>
        <small style="opacity:.7">包括环保设施建设、运行维护、环评、清洁生产审核、废弃物处置、监测、排污/污水处理、培训等费用。</small>
      </fieldset>

      <!-- 清洁技术投入（研发费用） -->
      <fieldset>
        <legend>{{ year }}年资金投入统计 - 清洁技术投入（研发费用）(万元)</legend>
        <div class="table-wrapper">
          <table class="waste-table">
            <thead>
            <tr>
              <th>工厂</th>
              <th>单位</th>
              <th v-for="(m, idx) in monthNames" :key="`clean-h-${idx}`">{{ m }}</th>
              <th>合计</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="(factoryName, r) in factories" :key="`clean-r-${r}`">
              <td class="factory-cell">{{ factoryName }}</td>
              <td>万元</td>
              <td v-for="c in 12" :key="`clean-c-${r}-${c-1}`"><input type="number" min="0" step="0.01" v-model.number="cleanTechInvest[r][c-1]"></td>
              <td class="total-cell">{{ rowSum(cleanTechInvest[r]) }}</td>
            </tr>
            <tr class="grand-total">
              <td>合计</td>
              <td>-</td>
              <td v-for="c in 12" :key="`clean-gt-${c-1}`">{{ colSum(cleanTechInvest, c-1) }}</td>
              <td>{{ tableSum(cleanTechInvest) }}</td>
            </tr>
            </tbody>
          </table>
        </div>
        <small style="opacity:.7">剔除各类财政科技经费补助。</small>
      </fieldset>

      <!-- 气候变化的研发投入 -->
      <fieldset>
        <legend>{{ year }}年资金投入统计 - 气候变化的研发投入 (万元)</legend>
        <div class="table-wrapper">
          <table class="waste-table">
            <thead>
            <tr>
              <th>工厂</th>
              <th>单位</th>
              <th v-for="(m, idx) in monthNames" :key="`clim-h-${idx}`">{{ m }}</th>
              <th>合计</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="(factoryName, r) in factories" :key="`clim-r-${r}`">
              <td class="factory-cell">{{ factoryName }}</td>
              <td>万元</td>
              <td v-for="c in 12" :key="`clim-c-${r}-${c-1}`"><input type="number" min="0" step="0.01" v-model.number="climateInvest[r][c-1]"></td>
              <td class="total-cell">{{ rowSum(climateInvest[r]) }}</td>
            </tr>
            <tr class="grand-total">
              <td>合计</td>
              <td>-</td>
              <td v-for="c in 12" :key="`clim-gt-${c-1}`">{{ colSum(climateInvest, c-1) }}</td>
              <td>{{ tableSum(climateInvest) }}</td>
            </tr>
            </tbody>
          </table>
        </div>
        <small style="opacity:.7">聚焦减排（如CCS/CCUS、低/零碳能源等）。</small>
      </fieldset>

      <!-- 绿色收入 -->
      <fieldset>
        <legend>{{ year }}年资金投入统计 - 绿色收入 (万元)</legend>
        <div class="table-wrapper">
          <table class="waste-table">
            <thead>
            <tr>
              <th>工厂</th>
              <th>单位</th>
              <th v-for="(m, idx) in monthNames" :key="`green-h-${idx}`">{{ m }}</th>
              <th>合计</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="(factoryName, r) in factories" :key="`green-r-${r}`">
              <td class="factory-cell">{{ factoryName }}</td>
              <td>万元</td>
              <td v-for="c in 12" :key="`green-c-${r}-${c-1}`"><input type="number" min="0" step="0.01" v-model.number="greenIncome[r][c-1]"></td>
              <td class="total-cell">{{ rowSum(greenIncome[r]) }}</td>
            </tr>
            <tr class="grand-total">
              <td>合计</td>
              <td>-</td>
              <td v-for="c in 12" :key="`green-gt-${c-1}`">{{ colSum(greenIncome, c-1) }}</td>
              <td>{{ tableSum(greenIncome) }}</td>
            </tr>
            </tbody>
          </table>
        </div>
        <small style="opacity:.7">通过销售环保产品/服务、实施绿色项目（绿转绿）获得的收入。</small>
      </fieldset>

      <button type="submit" :disabled="isSubmitting">{{ isSubmitting ? '提交中...' : '提交资金投入数据' }}</button>
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

const envInvest = reactive(buildMatrix(factories.value.length))
const cleanTechInvest = reactive(buildMatrix(factories.value.length))
const climateInvest = reactive(buildMatrix(factories.value.length))
const greenIncome = reactive(buildMatrix(factories.value.length))

const rowSum = (row)=> row.reduce((s,v)=> s + (Number(v)||0), 0)
const colSum = (matrix, col)=> matrix.reduce((s,r)=> s + (Number(r[col])||0), 0)
const tableSum = (matrix)=> matrix.reduce((s,r)=> s + rowSum(r), 0)

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
      envInvestTotals: envInvest.map(r=> rowSum(r)),
      cleanTechInvestTotals: cleanTechInvest.map(r=> rowSum(r)),
      climateInvestTotals: climateInvest.map(r=> rowSum(r)),
      greenIncomeTotals: greenIncome.map(r=> rowSum(r))
    }
    const resp = await axios.post('http://localhost:8000/submit/investment', payload)
    if(resp.data.status==='success') alert('资金投入数据提交成功!')
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
.waste-table{width:100%; border-collapse:collapse}
.waste-table th,.waste-table td{border:1px solid #ddd; padding:6px; text-align:center}
.waste-table thead th{position:sticky; top:0; background:#f7f7f7; z-index:1}
.factory-cell{white-space:nowrap; text-align:left}
.total-cell{font-weight:600}
.grand-total td{font-weight:700; background:#fafafa}
.waste-table input{width:100px}
@media (max-width: 768px){.waste-table input{width:80px}}
</style>


