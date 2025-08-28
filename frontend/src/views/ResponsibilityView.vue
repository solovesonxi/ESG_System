<template>
  <div class="shared-form">
    <form @submit.prevent="submitResponsibility">
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

      <!-- 客户投诉统计 -->
      <fieldset>
        <legend>{{ year }}年客户投诉统计 (件)</legend>
        <div class="table-wrapper">
          <table class="resp-table">
            <thead>
            <tr>
              <th>工厂</th>
              <th>单位</th>
              <th v-for="(m, idx) in monthNames" :key="`cmp-h-${idx}`">{{ m }}</th>
              <th>合计</th>
              <th>有效处理件数</th>
              <th>有效处理率(%)</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="(factoryName, r) in factories" :key="`cmp-r-${r}`">
              <td class="factory-cell">{{ factoryName }}</td>
              <td>件</td>
              <td v-for="c in 12" :key="`cmp-c-${r}-${c-1}`"><input type="number" min="0" step="1" v-model.number="complaints[r][c-1]"></td>
              <td class="total-cell">{{ rowSum(complaints[r]) }}</td>
              <td><input type="number" min="0" step="1" v-model.number="handled[r]"></td>
              <td class="total-cell">{{ percent(handled[r], rowSum(complaints[r])) }}</td>
            </tr>
            <tr class="grand-total">
              <td>合计</td>
              <td>件</td>
              <td v-for="c in 12" :key="`cmp-gt-${c-1}`">{{ colSum(complaints, c-1) }}</td>
              <td>{{ tableSum(complaints) }}</td>
              <td>{{ sumArray(handled) }}</td>
              <td>{{ percent(sumArray(handled), tableSum(complaints)) }}</td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <!-- 产品安全质量问题 -->
      <fieldset>
        <legend>{{ year }}年产品安全质量问题 (次)</legend>
        <div class="table-wrapper">
          <table class="resp-table">
            <thead>
            <tr>
              <th>工厂</th>
              <th>单位</th>
              <th v-for="(m, idx) in monthNames" :key="`qual-h-${idx}`">{{ m }}</th>
              <th>合计</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="(factoryName, r) in factories" :key="`qual-r-${r}`">
              <td class="factory-cell">{{ factoryName }}</td>
              <td>次</td>
              <td v-for="c in 12" :key="`qual-c-${r}-${c-1}`"><input type="number" min="0" step="1" v-model.number="qualityIssues[r][c-1]"></td>
              <td class="total-cell">{{ rowSum(qualityIssues[r]) }}</td>
            </tr>
            <tr class="grand-total">
              <td>合计</td>
              <td>次</td>
              <td v-for="c in 12" :key="`qual-gt-${c-1}`">{{ colSum(qualityIssues, c-1) }}</td>
              <td>{{ tableSum(qualityIssues) }}</td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <!-- 产品召回统计 -->
      <fieldset>
        <legend>{{ year }}年产品召回统计 (次)</legend>
        <div class="table-wrapper">
          <table class="resp-table">
            <thead>
            <tr>
              <th>工厂</th>
              <th>单位</th>
              <th v-for="(m, idx) in monthNames" :key="`rec-h-${idx}`">{{ m }}</th>
              <th>合计</th>
              <th>出货总批次</th>
              <th>召回百分比(%)</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="(factoryName, r) in factories" :key="`rec-r-${r}`">
              <td class="factory-cell">{{ factoryName }}</td>
              <td>次</td>
              <td v-for="c in 12" :key="`rec-c-${r}-${c-1}`"><input type="number" min="0" step="1" v-model.number="recalls[r][c-1]"></td>
              <td class="total-cell">{{ rowSum(recalls[r]) }}</td>
              <td><input type="number" min="0" step="1" v-model.number="shipments[r]"></td>
              <td class="total-cell">{{ percent(rowSum(recalls[r]), shipments[r]) }}</td>
            </tr>
            <tr class="grand-total">
              <td>合计</td>
              <td>次</td>
              <td v-for="c in 12" :key="`rec-gt-${c-1}`">{{ colSum(recalls, c-1) }}</td>
              <td>{{ tableSum(recalls) }}</td>
              <td>{{ sumArray(shipments) }}</td>
              <td>{{ percent(tableSum(recalls), sumArray(shipments)) }}</td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <!-- 客户满意度统计 - 总部统一调查 -->
      <fieldset>
        <legend>{{ year }}年客户满意度统计 - 总部统一调查 (%)</legend>
        <div class="table-wrapper">
          <table class="resp-table">
            <thead>
            <tr>
              <th>工厂</th>
              <th>单位</th>
              <th v-for="(m, idx) in monthNames" :key="`csat-h-${idx}`">{{ m }}</th>
              <th>合计</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="(factoryName, r) in factories" :key="`csat-r-${r}`">
              <td class="factory-cell">{{ factoryName }}</td>
              <td>%</td>
              <td v-for="c in 12" :key="`csat-c-${r}-${c-1}`"><input type="number" min="0" max="100" step="0.01" v-model.number="customerSatisfaction[r][c-1]"></td>
              <td class="total-cell">{{ averageRow(customerSatisfaction[r]) }}</td>
            </tr>
            <tr class="grand-total">
              <td>合计</td>
              <td>%</td>
              <td v-for="c in 12" :key="`csat-gt-${c-1}`">{{ averageColumn(customerSatisfaction, c-1) }}</td>
              <td>{{ overallAverage(customerSatisfaction) }}</td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <!-- 网络数据安全事件 -->
      <fieldset>
        <legend>{{ year }}年网络数据安全事件 (次)</legend>
        <div class="table-wrapper">
          <table class="resp-table">
            <thead>
            <tr>
              <th>工厂</th>
              <th>单位</th>
              <th v-for="(m, idx) in monthNames" :key="`cyb-h-${idx}`">{{ m }}</th>
              <th>合计</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="(factoryName, r) in factories" :key="`cyb-r-${r}`">
              <td class="factory-cell">{{ factoryName }}</td>
              <td>次</td>
              <td v-for="c in 12" :key="`cyb-c-${r}-${c-1}`"><input type="number" min="0" step="1" v-model.number="cyberIncidents[r][c-1]"></td>
              <td class="total-cell">{{ rowSum(cyberIncidents[r]) }}</td>
            </tr>
            <tr class="grand-total">
              <td>合计</td>
              <td>次</td>
              <td v-for="c in 12" :key="`cyb-gt-${c-1}`">{{ colSum(cyberIncidents, c-1) }}</td>
              <td>{{ tableSum(cyberIncidents) }}</td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <button type="submit" :disabled="isSubmitting">{{ isSubmitting ? '提交中...' : '提交产品责任数据' }}</button>
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

onMounted(()=>{ selectionStore.initYears(); document.addEventListener('click', selectionStore.handleClickOutside) })
onBeforeUnmount(()=>{ document.removeEventListener('click', selectionStore.handleClickOutside) })

const monthNames = ['1月','2月','3月','4月','5月','6月','7月','8月','9月','10月','11月','12月']
function buildMatrix(rows){ return Array.from({length: rows}, ()=> Array(12).fill(0)) }

// 矩阵
const complaints = reactive(buildMatrix(factories.value.length))
const qualityIssues = reactive(buildMatrix(factories.value.length))
const recalls = reactive(buildMatrix(factories.value.length))
const customerSatisfaction = reactive(buildMatrix(factories.value.length))
const cyberIncidents = reactive(buildMatrix(factories.value.length))

// 行相关单值
const handled = reactive(Array(factories.value.length).fill(0))
const shipments = reactive(Array(factories.value.length).fill(0))

// 工具
const rowSum = (row)=> row.reduce((s,v)=> s + (Number(v)||0), 0)
const colSum = (matrix, c)=> matrix.reduce((s,r)=> s + (Number(r[c])||0), 0)
const tableSum = (matrix)=> matrix.reduce((s,r)=> s + rowSum(r), 0)
const sumArray = (arr)=> arr.reduce((s,v)=> s + (Number(v)||0), 0)
const percent = (num, den)=>{ num=Number(num||0); den=Number(den||0); if(den<=0||num<0) return 0; return ((num/den)*100).toFixed(2) }
const averageRow = (row)=>{ const s=rowSum(row); return (s/12).toFixed(2) }
const averageColumn = (matrix, c)=>{ const s=colSum(matrix,c); return (s/matrix.length).toFixed(2) }
const overallAverage = (matrix)=>{ const s=tableSum(matrix); const denom = matrix.length*12; if(denom<=0) return 0; return (s/denom).toFixed(2) }

async function submitResponsibility(){
  isSubmitting.value = true
  try{
    const payload = {
      year: Number(year.value),
      factories: factories.value,
      complaints,
      handled: [...handled],
      qualityIssues,
      recalls,
      shipments: [...shipments],
      customerSatisfaction,
      cyberIncidents,
      complaintTotals: complaints.map(r=> rowSum(r)),
      qualityIssueTotals: qualityIssues.map(r=> rowSum(r)),
      recallTotals: recalls.map(r=> rowSum(r)),
      cyberIncidentTotals: cyberIncidents.map(r=> rowSum(r)),
      satisfactionRowAvg: customerSatisfaction.map(r=> Number(averageRow(r))),
      satisfactionMonthlyAvg: Array.from({length:12},(_,i)=> Number(averageColumn(customerSatisfaction,i))),
      satisfactionOverallAvg: Number(overallAverage(customerSatisfaction))
    }
    const resp = await axios.post('http://localhost:8000/quantitative/responsibility', payload)
    if(resp.data.status==='success') alert('产品责任数据提交成功!')
  }catch(e){ console.error(e); alert(`提交失败: ${e.response?.data?.detail || e.message}`) }
  finally{ isSubmitting.value = false }
}
</script>

<style scoped>
.table-wrapper{overflow:auto}
.resp-table{width:100%; border-collapse:collapse}
.resp-table th,.resp-table td{border:1px solid #ddd; padding:6px; text-align:center}
.resp-table thead th{position:sticky; top:0; background:#f7f7f7; z-index:1}
.factory-cell{white-space:nowrap; text-align:left}
.total-cell{font-weight:600}
.grand-total td{font-weight:700; background:#fafafa}
.resp-table input{width:100px}
@media (max-width: 768px){.resp-table input{width:80px}}
</style>


