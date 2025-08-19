<template>
  <div class="shared-form">
    <form @submit.prevent="submitEmployment">
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
        <legend>{{ year }}年员工雇佣统计 — 总部统计</legend>
        <div class="table-wrapper">
          <table class="employment-table">
            <thead>
            <tr>
              <th>工厂</th>
              <th>员工总数</th>
              <th>全职</th>
              <th>兼职</th>
              <th>男</th>
              <th>女</th>
              <th>管理层</th>
              <th>管理层女</th>
              <th>中层</th>
              <th>普通</th>
              <th>大陆</th>
              <th>海外</th>
              <th>博士+</th>
              <th>硕士</th>
              <th>本科</th>
              <th>专科及以下</th>
              <th>人均五险一金</th>
              <th>人均五险一金增加额</th>
              <th>18-30</th>
              <th>31-45</th>
              <th>46-60</th>
              <th>新进</th>
              <th>离职总数</th>
              <th>男离职</th>
              <th>女离职</th>
              <th>大陆离职</th>
              <th>海外离职</th>
              <th>18-30离</th>
              <th>31-45离</th>
              <th>46-60离</th>
              <th>管理层离</th>
              <th>中层离</th>
              <th>普通离</th>
              <th>总流失率%</th>
              <th>男流失率%</th>
              <th>女流失率%</th>
              <th>大陆流失率%</th>
              <th>海外流失率%</th>
              <th>18-30流失率%</th>
              <th>31-45流失率%</th>
              <th>46-60流失率%</th>
              <th>管理层流失率%</th>
              <th>中层流失率%</th>
              <th>普通流失率%</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="(row, i) in rows" :key="`emp-${i}`">
              <td class="factory-cell">{{ factories[i] }}</td>
              <td class="total-cell">{{ totalEmployees(row) }}</td>
              <td><input type="number" min="0" step="1" v-model.number="row.fullTime"></td>
              <td><input type="number" min="0" step="1" v-model.number="row.partTime"></td>
              <td><input type="number" min="0" step="1" v-model.number="row.male"></td>
              <td><input type="number" min="0" step="1" v-model.number="row.female"></td>
              <td><input type="number" min="0" step="1" v-model.number="row.management"></td>
              <td><input type="number" min="0" step="1" v-model.number="row.managementFemale"></td>
              <td><input type="number" min="0" step="1" v-model.number="row.middle"></td>
              <td><input type="number" min="0" step="1" v-model.number="row.general"></td>
              <td><input type="number" min="0" step="1" v-model.number="row.mainland"></td>
              <td><input type="number" min="0" step="1" v-model.number="row.overseas"></td>
              <td><input type="number" min="0" step="1" v-model.number="row.eduPhd"></td>
              <td><input type="number" min="0" step="1" v-model.number="row.eduMaster"></td>
              <td><input type="number" min="0" step="1" v-model.number="row.eduBachelor"></td>
              <td><input type="number" min="0" step="1" v-model.number="row.eduJunior"></td>
              <td><input type="number" min="0" step="0.01" v-model.number="row.avgSocialFund"></td>
              <td><input type="number" min="0" step="0.01" v-model.number="row.incSocialFund"></td>
              <td><input type="number" min="0" step="1" v-model.number="row.age18_30"></td>
              <td><input type="number" min="0" step="1" v-model.number="row.age31_45"></td>
              <td><input type="number" min="0" step="1" v-model.number="row.age46_60"></td>
              <td><input type="number" min="0" step="1" v-model.number="row.newHires"></td>
              <td class="total-cell">{{ quitTotal(row) }}</td>
              <td><input type="number" min="0" step="1" v-model.number="row.quitMale"></td>
              <td><input type="number" min="0" step="1" v-model.number="row.quitFemale"></td>
              <td><input type="number" min="0" step="1" v-model.number="row.quitMainland"></td>
              <td><input type="number" min="0" step="1" v-model.number="row.quitOverseas"></td>
              <td><input type="number" min="0" step="1" v-model.number="row.quit18_30"></td>
              <td><input type="number" min="0" step="1" v-model.number="row.quit31_45"></td>
              <td><input type="number" min="0" step="1" v-model.number="row.quit46_60"></td>
              <td><input type="number" min="0" step="1" v-model.number="row.quitManagement"></td>
              <td><input type="number" min="0" step="1" v-model.number="row.quitMiddle"></td>
              <td><input type="number" min="0" step="1" v-model.number="row.quitGeneral"></td>
              <td class="total-cell">{{ rate(quitTotal(row), totalEmployees(row)) }}</td>
              <td class="total-cell">{{ rate(row.quitMale, row.male) }}</td>
              <td class="total-cell">{{ rate(row.quitFemale, row.female) }}</td>
              <td class="total-cell">{{ rate(row.quitMainland, row.mainland) }}</td>
              <td class="total-cell">{{ rate(row.quitOverseas, row.overseas) }}</td>
              <td class="total-cell">{{ rate(row.quit18_30, row.age18_30) }}</td>
              <td class="total-cell">{{ rate(row.quit31_45, row.age31_45) }}</td>
              <td class="total-cell">{{ rate(row.quit46_60, row.age46_60) }}</td>
              <td class="total-cell">{{ rate(row.quitManagement, row.management) }}</td>
              <td class="total-cell">{{ rate(row.quitMiddle, row.middle) }}</td>
              <td class="total-cell">{{ rate(row.quitGeneral, row.general) }}</td>
            </tr>
            <tr class="grand-total">
              <td>合计</td>
              <td>{{ sumRows(totalEmployees) }}</td>
              <td>{{ sumField('fullTime') }}</td>
              <td>{{ sumField('partTime') }}</td>
              <td>{{ sumField('male') }}</td>
              <td>{{ sumField('female') }}</td>
              <td>{{ sumField('management') }}</td>
              <td>{{ sumField('managementFemale') }}</td>
              <td>{{ sumField('middle') }}</td>
              <td>{{ sumField('general') }}</td>
              <td>{{ sumField('mainland') }}</td>
              <td>{{ sumField('overseas') }}</td>
              <td>{{ sumField('eduPhd') }}</td>
              <td>{{ sumField('eduMaster') }}</td>
              <td>{{ sumField('eduBachelor') }}</td>
              <td>{{ sumField('eduJunior') }}</td>
              <td>-</td>
              <td>-</td>
              <td>{{ sumField('age18_30') }}</td>
              <td>{{ sumField('age31_45') }}</td>
              <td>{{ sumField('age46_60') }}</td>
              <td>{{ sumField('newHires') }}</td>
              <td>{{ sumRows(quitTotal) }}</td>
              <td>{{ sumField('quitMale') }}</td>
              <td>{{ sumField('quitFemale') }}</td>
              <td>{{ sumField('quitMainland') }}</td>
              <td>{{ sumField('quitOverseas') }}</td>
              <td>{{ sumField('quit18_30') }}</td>
              <td>{{ sumField('quit31_45') }}</td>
              <td>{{ sumField('quit46_60') }}</td>
              <td>{{ sumField('quitManagement') }}</td>
              <td>{{ sumField('quitMiddle') }}</td>
              <td>{{ sumField('quitGeneral') }}</td>
              <td>{{ rate(sumRows(quitTotal), sumRows(totalEmployees)) }}</td>
              <td>{{ rate(sumField('quitMale'), sumField('male')) }}</td>
              <td>{{ rate(sumField('quitFemale'), sumField('female')) }}</td>
              <td>{{ rate(sumField('quitMainland'), sumField('mainland')) }}</td>
              <td>{{ rate(sumField('quitOverseas'), sumField('overseas')) }}</td>
              <td>{{ rate(sumField('quit18_30'), sumField('age18_30')) }}</td>
              <td>{{ rate(sumField('quit31_45'), sumField('age31_45')) }}</td>
              <td>{{ rate(sumField('quit46_60'), sumField('age46_60')) }}</td>
              <td>{{ rate(sumField('quitManagement'), sumField('management')) }}</td>
              <td>{{ rate(sumField('quitMiddle'), sumField('middle')) }}</td>
              <td>{{ rate(sumField('quitGeneral'), sumField('general')) }}</td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <button type="submit" :disabled="isSubmitting">{{ isSubmitting ? '提交中...' : '提交雇佣数据' }}</button>
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

function makeRow(){
  return reactive({
    fullTime: 0, partTime: 0,
    male: 0, female: 0,
    management: 0, managementFemale: 0, middle: 0, general: 0,
    mainland: 0, overseas: 0,
    eduPhd: 0, eduMaster: 0, eduBachelor: 0, eduJunior: 0,
    avgSocialFund: 0, incSocialFund: 0,
    age18_30: 0, age31_45: 0, age46_60: 0,
    newHires: 0,
    quitMale: 0, quitFemale: 0,
    quitMainland: 0, quitOverseas: 0,
    quit18_30: 0, quit31_45: 0, quit46_60: 0,
    quitManagement: 0, quitMiddle: 0, quitGeneral: 0,
  })
}

const rows = reactive(Array.from({length: factories.value.length}, ()=> makeRow()))

const totalEmployees = (row)=> Number(row.fullTime||0) + Number(row.partTime||0)
const quitTotal = (row)=> Number(row.quitMale||0) + Number(row.quitFemale||0)
const rate = (num, den)=> {
  num = Number(num||0); den = Number(den||0)
  if(den<=0||num<0) return 0
  return ((num/den)*100).toFixed(2)
}

const sumField = (key)=> rows.reduce((s,r)=> s + Number(r[key]||0), 0)
const sumRows = (fn)=> rows.reduce((s,r)=> s + Number(fn(r)||0), 0)

async function submitEmployment(){
  isSubmitting.value = true
  try{
    const payload = {
      year: Number(year.value),
      records: rows.map((r, idx)=> ({ factory: factories.value[idx], ...r, totalEmployees: totalEmployees(r), quitTotal: quitTotal(r) })),
      summary: {
        totals: {
          totalEmployees: sumRows(totalEmployees),
          fullTime: sumField('fullTime'), partTime: sumField('partTime'),
          male: sumField('male'), female: sumField('female'),
          management: sumField('management'), managementFemale: sumField('managementFemale'), middle: sumField('middle'), general: sumField('general'),
          mainland: sumField('mainland'), overseas: sumField('overseas'),
          eduPhd: sumField('eduPhd'), eduMaster: sumField('eduMaster'), eduBachelor: sumField('eduBachelor'), eduJunior: sumField('eduJunior'),
          age18_30: sumField('age18_30'), age31_45: sumField('age31_45'), age46_60: sumField('age46_60'),
          newHires: sumField('newHires'), quitTotal: sumRows(quitTotal),
          quitMale: sumField('quitMale'), quitFemale: sumField('quitFemale'),
          quitMainland: sumField('quitMainland'), quitOverseas: sumField('quitOverseas'),
          quit18_30: sumField('quit18_30'), quit31_45: sumField('quit31_45'), quit46_60: sumField('quit46_60'),
          quitManagement: sumField('quitManagement'), quitMiddle: sumField('quitMiddle'), quitGeneral: sumField('quitGeneral'),
        },
        rates: {
          turnover: rate(sumRows(quitTotal), sumRows(totalEmployees)),
          male: rate(sumField('quitMale'), sumField('male')),
          female: rate(sumField('quitFemale'), sumField('female')),
          mainland: rate(sumField('quitMainland'), sumField('mainland')),
          overseas: rate(sumField('quitOverseas'), sumField('overseas')),
          age18_30: rate(sumField('quit18_30'), sumField('age18_30')),
          age31_45: rate(sumField('quit31_45'), sumField('age31_45')),
          age46_60: rate(sumField('quit46_60'), sumField('age46_60')),
          management: rate(sumField('quitManagement'), sumField('management')),
          middle: rate(sumField('quitMiddle'), sumField('middle')),
          general: rate(sumField('quitGeneral'), sumField('general')),
        }
      }
    }
    const resp = await axios.post('http://localhost:8000/submit/employment', payload)
    if(resp.data.status==='success') alert('雇佣数据提交成功!')
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
.employment-table{width:100%; border-collapse:collapse}
.employment-table th,.employment-table td{border:1px solid #ddd; padding:6px; text-align:center}
.employment-table thead th{position:sticky; top:0; background:#f7f7f7; z-index:1}
.factory-cell{white-space:nowrap; text-align:left}
.total-cell{font-weight:600}
.grand-total td{font-weight:700; background:#fafafa}
.employment-table input{width:90px}
@media (max-width: 768px){.employment-table input{width:70px}}
</style>


