<template>
  <div class="shared-form">
    <form @submit.prevent="submitCommunity">
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

      <!-- 慈善捐款（元） -->
      <fieldset>
        <legend>{{ year }}年社区参与统计 - 慈善捐款 (元)</legend>
        <div class="table-wrapper">
          <table class="community-table">
            <thead>
            <tr>
              <th>工厂</th>
              <th>单位</th>
              <th v-for="(m, idx) in monthNames" :key="`cd-h-${idx}`">{{ m }}</th>
              <th>合计</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="(factoryName, r) in factories" :key="`cd-r-${r}`">
              <td class="factory-cell">{{ factoryName }}</td>
              <td>元</td>
              <td v-for="c in 12" :key="`cd-c-${r}-${c-1}`"><input type="number" min="0" step="0.01" v-model.number="charityDonations[r][c-1]"></td>
              <td class="total-cell">{{ rowSum(charityDonations[r]) }}</td>
            </tr>
            <tr class="grand-total">
              <td>合计</td>
              <td>元</td>
              <td v-for="c in 12" :key="`cd-gt-${c-1}`">{{ colSum(charityDonations, c-1) }}</td>
              <td>{{ tableSum(charityDonations) }}</td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <!-- 社区发展投入（元） -->
      <fieldset>
        <legend>{{ year }}年社区参与统计 - 社区发展投入 (元)</legend>
        <div class="table-wrapper">
          <table class="community-table">
            <thead>
            <tr>
              <th>工厂</th>
              <th>单位</th>
              <th v-for="(m, idx) in monthNames" :key="`ci-h-${idx}`">{{ m }}</th>
              <th>合计</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="(factoryName, r) in factories" :key="`ci-r-${r}`">
              <td class="factory-cell">{{ factoryName }}</td>
              <td>元</td>
              <td v-for="c in 12" :key="`ci-c-${r}-${c-1}`"><input type="number" min="0" step="0.01" v-model.number="communityInvestment[r][c-1]"></td>
              <td class="total-cell">{{ rowSum(communityInvestment[r]) }}</td>
            </tr>
            <tr class="grand-total">
              <td>合计</td>
              <td>元</td>
              <td v-for="c in 12" :key="`ci-gt-${c-1}`">{{ colSum(communityInvestment, c-1) }}</td>
              <td>{{ tableSum(communityInvestment) }}</td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <!-- 志愿者参与（人次） -->
      <fieldset>
        <legend>{{ year }}年社区参与统计 - 志愿者参与 (人次)</legend>
        <div class="table-wrapper">
          <table class="community-table">
            <thead>
            <tr>
              <th>工厂</th>
              <th>单位</th>
              <th v-for="(m, idx) in monthNames" :key="`vp-h-${idx}`">{{ m }}</th>
              <th>合计</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="(factoryName, r) in factories" :key="`vp-r-${r}`">
              <td class="factory-cell">{{ factoryName }}</td>
              <td>人次</td>
              <td v-for="c in 12" :key="`vp-c-${r}-${c-1}`"><input type="number" min="0" step="1" v-model.number="volunteerParticipants[r][c-1]"></td>
              <td class="total-cell">{{ rowSum(volunteerParticipants[r]) }}</td>
            </tr>
            <tr class="grand-total">
              <td>合计</td>
              <td>人次</td>
              <td v-for="c in 12" :key="`vp-gt-${c-1}`">{{ colSum(volunteerParticipants, c-1) }}</td>
              <td>{{ tableSum(volunteerParticipants) }}</td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <!-- 志愿者服务（小时） -->
      <fieldset>
        <legend>{{ year }}年社区参与统计 - 志愿者服务 (小时)</legend>
        <div class="table-wrapper">
          <table class="community-table">
            <thead>
            <tr>
              <th>工厂</th>
              <th>单位</th>
              <th v-for="(m, idx) in monthNames" :key="`vh-h-${idx}`">{{ m }}</th>
              <th>合计</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="(factoryName, r) in factories" :key="`vh-r-${r}`">
              <td class="factory-cell">{{ factoryName }}</td>
              <td>小时</td>
              <td v-for="c in 12" :key="`vh-c-${r}-${c-1}`"><input type="number" min="0" step="0.1" v-model.number="volunteerHours[r][c-1]"></td>
              <td class="total-cell">{{ rowSum(volunteerHours[r]) }}</td>
            </tr>
            <tr class="grand-total">
              <td>合计</td>
              <td>小时</td>
              <td v-for="c in 12" :key="`vh-gt-${c-1}`">{{ colSum(volunteerHours, c-1) }}</td>
              <td>{{ tableSum(volunteerHours) }}</td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <button type="submit" :disabled="isSubmitting">{{ isSubmitting ? '提交中...' : '提交社区参与数据' }}</button>
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

const charityDonations = reactive(buildMatrix(factories.value.length))
const communityInvestment = reactive(buildMatrix(factories.value.length))
const volunteerParticipants = reactive(buildMatrix(factories.value.length))
const volunteerHours = reactive(buildMatrix(factories.value.length))

const notes = ref('')

const rowSum = (row)=> row.reduce((s,v)=> s + (Number(v)||0), 0)
const colSum = (matrix, c)=> matrix.reduce((s,r)=> s + (Number(r[c])||0), 0)
const tableSum = (matrix)=> matrix.reduce((s,r)=> s + rowSum(r), 0)

async function submitCommunity(){
  isSubmitting.value = true
  try{
    const payload = {
      year: Number(year.value),
      factories: factories.value,
      charityDonations,
      communityInvestment,
      volunteerParticipants,
      volunteerHours,
      charityDonationsTotals: charityDonations.map(r=> rowSum(r)),
      communityInvestmentTotals: communityInvestment.map(r=> rowSum(r)),
      volunteerParticipantsTotals: volunteerParticipants.map(r=> rowSum(r)),
      volunteerHoursTotals: volunteerHours.map(r=> rowSum(r)),
      notes: notes.value || null
    }
    const resp = await axios.post('http://localhost:8000/submit/community', payload)
    if(resp.data.status==='success') alert('社区参与数据提交成功!')
  }catch(e){ console.error(e); alert(`提交失败: ${e.response?.data?.detail || e.message}`) }
  finally{ isSubmitting.value = false }
}
</script>

<style scoped>
.table-wrapper{overflow:auto}
.community-table{width:100%; border-collapse:collapse}
.community-table th,.community-table td{border:1px solid #ddd; padding:6px; text-align:center}
.community-table thead th{position:sticky; top:0; background:#f7f7f7; z-index:1}
.factory-cell{white-space:nowrap; text-align:left}
.total-cell{font-weight:600}
.grand-total td{font-weight:700; background:#fafafa}
.community-table input{width:100px}
.note{margin-top:6px; font-size:12px; color:#666}
@media (max-width: 768px){.community-table input{width:80px}}
</style>


