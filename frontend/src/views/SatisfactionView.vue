<template>
  <div class="shared-form">
    <form @submit.prevent="submitSatisfaction">
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

      <fieldset>
        <legend>{{ year }}年员工满意度调查统计 (%)</legend>
        <div class="table-wrapper">
          <table class="satis-table">
            <thead>
            <tr>
              <th>工厂</th>
              <th>单位</th>
              <th v-for="(m, idx) in monthNames" :key="`sat-h-${idx}`">{{ m }}</th>
              <th>平均(%)</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="(factoryName, r) in factories" :key="`sat-r-${r}`">
              <td class="factory-cell">{{ factoryName }}</td>
              <td>%</td>
              <td v-for="c in 12" :key="`sat-c-${r}-${c-1}`">
                <input type="number" min="0" max="100" step="0.01" v-model.number="satisfaction[r][c-1]">
              </td>
              <td class="total-cell">{{ rowAverage(satisfaction[r]) }}</td>
            </tr>
            <tr class="grand-total">
              <td>合计</td>
              <td>%</td>
              <td v-for="c in 12" :key="`sat-avg-${c-1}`">{{ columnAverage(satisfaction, c-1) }}</td>
              <td>{{ overallAverage }}</td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <button type="submit" :disabled="isSubmitting">{{ isSubmitting ? '提交中...' : '提交满意度数据' }}</button>
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

const satisfaction = reactive(buildMatrix(factories.value.length))

const rowAverage = (row)=>{
  const vals = row.map(v=> Number(v||0))
  const sum = vals.reduce((s,v)=> s+v, 0)
  return (sum/12).toFixed(2)
}
const columnAverage = (matrix, col)=>{
  const sum = matrix.reduce((s,r)=> s + Number(r[col]||0), 0)
  return (sum / matrix.length).toFixed(2)
}
const overallAverage = computed(()=>{
  const sum = satisfaction.reduce((acc,row)=> acc + row.reduce((s,v)=> s + Number(v||0), 0), 0)
  const denom = satisfaction.length * 12
  if(denom<=0) return 0
  return (sum/denom).toFixed(2)
})

async function submitSatisfaction(){
  isSubmitting.value = true
  try{
    const payload = {
      year: Number(year.value),
      factories: factories.value,
      satisfaction,
      rowAverages: satisfaction.map(r=> Number(rowAverage(r))),
      monthlyAverages: Array.from({length:12}, (_,i)=> Number(columnAverage(satisfaction, i))),
      overallAverage: Number(overallAverage.value)
    }
    const resp = await axios.post('http://localhost:8000/submit/satisfaction', payload)
    if(resp.data.status==='success') alert('满意度数据提交成功!')
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
.satis-table{width:100%; border-collapse:collapse}
.satis-table th,.satis-table td{border:1px solid #ddd; padding:6px; text-align:center}
.satis-table thead th{position:sticky; top:0; background:#f7f7f7; z-index:1}
.factory-cell{white-space:nowrap; text-align:left}
.total-cell{font-weight:600}
.grand-total td{font-weight:700; background:#fafafa}
.satis-table input{width:90px}
@media (max-width: 768px){.satis-table input{width:80px}}
</style>


