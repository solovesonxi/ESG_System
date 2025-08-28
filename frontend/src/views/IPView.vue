<template>
  <div class="shared-form">
    <form @submit.prevent="submitIP">
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

      <!-- 通用渲染函数式表格组件化不做，直接重复块，保证可读性 -->

      <!-- 发明专利 -->
      <fieldset>
        <legend>{{ year }}年知识产权统计 - 发明专利 (件)</legend>
        <div class="table-wrapper">
          <table class="ip-table">
            <thead>
            <tr>
              <th>工厂</th>
              <th>单位</th>
              <th v-for="(m, idx) in monthNames" :key="`inv-h-${idx}`">{{ m }}</th>
              <th>合计</th>
              <th>之前累计数</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="(factoryName, r) in factories" :key="`inv-r-${r}`">
              <td class="factory-cell">{{ factoryName }}</td>
              <td>件</td>
              <td v-for="c in 12" :key="`inv-c-${r}-${c-1}`"><input type="number" min="0" step="1" v-model.number="invPatents[r][c-1]"></td>
              <td class="total-cell">{{ rowSum(invPatents[r]) }}</td>
              <td><input type="number" min="0" step="1" v-model.number="prevInvPatents[r]"></td>
            </tr>
            <tr class="grand-total">
              <td>合计</td>
              <td>件</td>
              <td v-for="c in 12" :key="`inv-gt-${c-1}`">{{ colSum(invPatents, c-1) }}</td>
              <td>{{ tableSum(invPatents) }}</td>
              <td>{{ sumArray(prevInvPatents) }}</td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <!-- 发明专利申请数量 -->
      <fieldset>
        <legend>{{ year }}年知识产权统计 - 发明专利申请数量 (件)</legend>
        <div class="table-wrapper">
          <table class="ip-table">
            <thead>
            <tr>
              <th>工厂</th>
              <th>单位</th>
              <th v-for="(m, idx) in monthNames" :key="`app-h-${idx}`">{{ m }}</th>
              <th>合计</th>
              <th>之前累计数</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="(factoryName, r) in factories" :key="`app-r-${r}`">
              <td class="factory-cell">{{ factoryName }}</td>
              <td>件</td>
              <td v-for="c in 12" :key="`app-c-${r}-${c-1}`"><input type="number" min="0" step="1" v-model.number="invApplications[r][c-1]"></td>
              <td class="total-cell">{{ rowSum(invApplications[r]) }}</td>
              <td><input type="number" min="0" step="1" v-model.number="prevInvApplications[r]"></td>
            </tr>
            <tr class="grand-total">
              <td>合计</td>
              <td>件</td>
              <td v-for="c in 12" :key="`app-gt-${c-1}`">{{ colSum(invApplications, c-1) }}</td>
              <td>{{ tableSum(invApplications) }}</td>
              <td>{{ sumArray(prevInvApplications) }}</td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <!-- 实用新型专利 -->
      <fieldset>
        <legend>{{ year }}年知识产权统计 - 实用新型专利 (件)</legend>
        <div class="table-wrapper">
          <table class="ip-table">
            <thead>
            <tr>
              <th>工厂</th>
              <th>单位</th>
              <th v-for="(m, idx) in monthNames" :key="`util-h-${idx}`">{{ m }}</th>
              <th>合计</th>
              <th>之前累计数</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="(factoryName, r) in factories" :key="`util-r-${r}`">
              <td class="factory-cell">{{ factoryName }}</td>
              <td>件</td>
              <td v-for="c in 12" :key="`util-c-${r}-${c-1}`"><input type="number" min="0" step="1" v-model.number="utilityPatents[r][c-1]"></td>
              <td class="total-cell">{{ rowSum(utilityPatents[r]) }}</td>
              <td><input type="number" min="0" step="1" v-model.number="prevUtilityPatents[r]"></td>
            </tr>
            <tr class="grand-total">
              <td>合计</td>
              <td>件</td>
              <td v-for="c in 12" :key="`util-gt-${c-1}`">{{ colSum(utilityPatents, c-1) }}</td>
              <td>{{ tableSum(utilityPatents) }}</td>
              <td>{{ sumArray(prevUtilityPatents) }}</td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <!-- 外观设计专利 -->
      <fieldset>
        <legend>{{ year }}年知识产权统计 - 外观设计专利 (件)</legend>
        <div class="table-wrapper">
          <table class="ip-table">
            <thead>
            <tr>
              <th>工厂</th>
              <th>单位</th>
              <th v-for="(m, idx) in monthNames" :key="`des-h-${idx}`">{{ m }}</th>
              <th>合计</th>
              <th>之前累计数</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="(factoryName, r) in factories" :key="`des-r-${r}`">
              <td class="factory-cell">{{ factoryName }}</td>
              <td>件</td>
              <td v-for="c in 12" :key="`des-c-${r}-${c-1}`"><input type="number" min="0" step="1" v-model.number="designPatents[r][c-1]"></td>
              <td class="total-cell">{{ rowSum(designPatents[r]) }}</td>
              <td><input type="number" min="0" step="1" v-model.number="prevDesignPatents[r]"></td>
            </tr>
            <tr class="grand-total">
              <td>合计</td>
              <td>件</td>
              <td v-for="c in 12" :key="`des-gt-${c-1}`">{{ colSum(designPatents, c-1) }}</td>
              <td>{{ tableSum(designPatents) }}</td>
              <td>{{ sumArray(prevDesignPatents) }}</td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <!-- 被授权专利 -->
      <fieldset>
        <legend>{{ year }}年知识产权统计 - 被授权专利 (件)</legend>
        <div class="table-wrapper">
          <table class="ip-table">
            <thead>
            <tr>
              <th>工厂</th>
              <th>单位</th>
              <th v-for="(m, idx) in monthNames" :key="`grant-h-${idx}`">{{ m }}</th>
              <th>合计</th>
              <th>之前累计数</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="(factoryName, r) in factories" :key="`grant-r-${r}`">
              <td class="factory-cell">{{ factoryName }}</td>
              <td>件</td>
              <td v-for="c in 12" :key="`grant-c-${r}-${c-1}`"><input type="number" min="0" step="1" v-model.number="grantedPatents[r][c-1]"></td>
              <td class="total-cell">{{ rowSum(grantedPatents[r]) }}</td>
              <td><input type="number" min="0" step="1" v-model.number="prevGrantedPatents[r]"></td>
            </tr>
            <tr class="grand-total">
              <td>合计</td>
              <td>件</td>
              <td v-for="c in 12" :key="`grant-gt-${c-1}`">{{ colSum(grantedPatents, c-1) }}</td>
              <td>{{ tableSum(grantedPatents) }}</td>
              <td>{{ sumArray(prevGrantedPatents) }}</td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <!-- 软件著作权 -->
      <fieldset>
        <legend>{{ year }}年知识产权统计 - 软件著作权 (件)</legend>
        <div class="table-wrapper">
          <table class="ip-table">
            <thead>
            <tr>
              <th>工厂</th>
              <th>单位</th>
              <th v-for="(m, idx) in monthNames" :key="`soft-h-${idx}`">{{ m }}</th>
              <th>合计</th>
              <th>之前累计数</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="(factoryName, r) in factories" :key="`soft-r-${r}`">
              <td class="factory-cell">{{ factoryName }}</td>
              <td>件</td>
              <td v-for="c in 12" :key="`soft-c-${r}-${c-1}`"><input type="number" min="0" step="1" v-model.number="softwareCopyrights[r][c-1]"></td>
              <td class="total-cell">{{ rowSum(softwareCopyrights[r]) }}</td>
              <td><input type="number" min="0" step="1" v-model.number="prevSoftwareCopyrights[r]"></td>
            </tr>
            <tr class="grand-total">
              <td>合计</td>
              <td>件</td>
              <td v-for="c in 12" :key="`soft-gt-${c-1}`">{{ colSum(softwareCopyrights, c-1) }}</td>
              <td>{{ tableSum(softwareCopyrights) }}</td>
              <td>{{ sumArray(prevSoftwareCopyrights) }}</td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <!-- 商标注册 -->
      <fieldset>
        <legend>{{ year }}年知识产权统计 - 商标注册 (件)</legend>
        <div class="table-wrapper">
          <table class="ip-table">
            <thead>
            <tr>
              <th>工厂</th>
              <th>单位</th>
              <th v-for="(m, idx) in monthNames" :key="`tm-h-${idx}`">{{ m }}</th>
              <th>合计</th>
              <th>之前累计数</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="(factoryName, r) in factories" :key="`tm-r-${r}`">
              <td class="factory-cell">{{ factoryName }}</td>
              <td>件</td>
              <td v-for="c in 12" :key="`tm-c-${r}-${c-1}`"><input type="number" min="0" step="1" v-model.number="trademarks[r][c-1]"></td>
              <td class="total-cell">{{ rowSum(trademarks[r]) }}</td>
              <td><input type="number" min="0" step="1" v-model.number="prevTrademarks[r]"></td>
            </tr>
            <tr class="grand-total">
              <td>合计</td>
              <td>件</td>
              <td v-for="c in 12" :key="`tm-gt-${c-1}`">{{ colSum(trademarks, c-1) }}</td>
              <td>{{ tableSum(trademarks) }}</td>
              <td>{{ sumArray(prevTrademarks) }}</td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <button type="submit" :disabled="isSubmitting">{{ isSubmitting ? '提交中...' : '提交知识产权数据' }}</button>
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
function buildMatrix(rows){ return Array.from({length: rows}, ()=> Array(12).fill(0)) }

// 七类矩阵
const invPatents = reactive(buildMatrix(factories.value.length))
const invApplications = reactive(buildMatrix(factories.value.length))
const utilityPatents = reactive(buildMatrix(factories.value.length))
const designPatents = reactive(buildMatrix(factories.value.length))
const grantedPatents = reactive(buildMatrix(factories.value.length))
const softwareCopyrights = reactive(buildMatrix(factories.value.length))
const trademarks = reactive(buildMatrix(factories.value.length))

// 之前累计数
const prevInvPatents = reactive(Array(factories.value.length).fill(0))
const prevInvApplications = reactive(Array(factories.value.length).fill(0))
const prevUtilityPatents = reactive(Array(factories.value.length).fill(0))
const prevDesignPatents = reactive(Array(factories.value.length).fill(0))
const prevGrantedPatents = reactive(Array(factories.value.length).fill(0))
const prevSoftwareCopyrights = reactive(Array(factories.value.length).fill(0))
const prevTrademarks = reactive(Array(factories.value.length).fill(0))

// 计算工具
const rowSum = (row)=> row.reduce((s,v)=> s + (Number(v)||0), 0)
const colSum = (matrix, c)=> matrix.reduce((s,r)=> s + (Number(r[c])||0), 0)
const tableSum = (matrix)=> matrix.reduce((s,r)=> s + rowSum(r), 0)
const sumArray = (arr)=> arr.reduce((s,v)=> s + (Number(v)||0), 0)

async function submitIP(){
  isSubmitting.value = true
  try{
    const payload = {
      year: Number(year.value),
      factories: factories.value,
      invPatents,
      invApplications,
      utilityPatents,
      designPatents,
      grantedPatents,
      softwareCopyrights,
      trademarks,
      prevInvPatents: [...prevInvPatents],
      prevInvApplications: [...prevInvApplications],
      prevUtilityPatents: [...prevUtilityPatents],
      prevDesignPatents: [...prevDesignPatents],
      prevGrantedPatents: [...prevGrantedPatents],
      prevSoftwareCopyrights: [...prevSoftwareCopyrights],
      prevTrademarks: [...prevTrademarks],
      totals: {
        invPatents: tableSum(invPatents),
        invApplications: tableSum(invApplications),
        utilityPatents: tableSum(utilityPatents),
        designPatents: tableSum(designPatents),
        grantedPatents: tableSum(grantedPatents),
        softwareCopyrights: tableSum(softwareCopyrights),
        trademarks: tableSum(trademarks),
        prevInvPatents: sumArray(prevInvPatents),
        prevInvApplications: sumArray(prevInvApplications),
        prevUtilityPatents: sumArray(prevUtilityPatents),
        prevDesignPatents: sumArray(prevDesignPatents),
        prevGrantedPatents: sumArray(prevGrantedPatents),
        prevSoftwareCopyrights: sumArray(prevSoftwareCopyrights),
        prevTrademarks: sumArray(prevTrademarks)
      }
    }
    const resp = await axios.post('http://localhost:8000/quantitative/ip', payload)
    if(resp.data.status==='success') alert('知识产权数据提交成功!')
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
.ip-table{width:100%; border-collapse:collapse}
.ip-table th,.ip-table td{border:1px solid #ddd; padding:6px; text-align:center}
.ip-table thead th{position:sticky; top:0; background:#f7f7f7; z-index:1}
.factory-cell{white-space:nowrap; text-align:left}
.total-cell{font-weight:600}
.grand-total td{font-weight:700; background:#fafafa}
.ip-table input{width:90px}
@media (max-width: 768px){.ip-table input{width:80px}}
</style>


