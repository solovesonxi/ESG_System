<template>
  <div class="shared-form">
    <form @submit.prevent="submitTraining">
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
        <legend>{{ year }}年教育和培训统计 — 总部统计</legend>
        <div class="table-wrapper">
          <table class="training-table">
            <thead>
            <tr>
              <th>工厂</th>
              <th>总人数(人)</th>
              <th>受训人数(人次)</th>
              <th>培训覆盖率(%)</th>
              <th>男性(人次)</th>
              <th>女性(人次)</th>
              <th>男性占比(%)</th>
              <th>女性占比(%)</th>
              <th>管理层受训(人次)</th>
              <th>中层受训(人次)</th>
              <th>普通受训(人次)</th>
              <th>管理层占比(%)</th>
              <th>中层占比(%)</th>
              <th>普通占比(%)</th>
              <th>培训总学时(小时)</th>
              <th>男性学时(小时)</th>
              <th>女性学时(小时)</th>
              <th>管理层学时(小时)</th>
              <th>中层学时(小时)</th>
              <th>普通学时(小时)</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="(row, i) in rows" :key="`tr-${i}`">
              <td class="factory-cell">{{ factories[i] }}</td>
              <td><input type="number" min="0" step="1" v-model.number="row.total"></td>
              <td><input type="number" min="0" step="1" v-model.number="row.trained"></td>
              <td class="total-cell">{{ percent(row.trained, row.total) }}</td>
              <td><input type="number" min="0" step="1" v-model.number="row.male"></td>
              <td><input type="number" min="0" step="1" v-model.number="row.female"></td>
              <td class="total-cell">{{ percent(row.male, row.trained) }}</td>
              <td class="total-cell">{{ percent(row.female, row.trained) }}</td>
              <td><input type="number" min="0" step="1" v-model.number="row.mgmt"></td>
              <td><input type="number" min="0" step="1" v-model.number="row.middle"></td>
              <td><input type="number" min="0" step="1" v-model.number="row.general"></td>
              <td class="total-cell">{{ percent(row.mgmt, row.trained) }}</td>
              <td class="total-cell">{{ percent(row.middle, row.trained) }}</td>
              <td class="total-cell">{{ percent(row.general, row.trained) }}</td>
              <td><input type="number" min="0" step="0.1" v-model.number="row.hoursTotal"></td>
              <td><input type="number" min="0" step="0.1" v-model.number="row.hoursMale"></td>
              <td><input type="number" min="0" step="0.1" v-model.number="row.hoursFemale"></td>
              <td><input type="number" min="0" step="0.1" v-model.number="row.hoursMgmt"></td>
              <td><input type="number" min="0" step="0.1" v-model.number="row.hoursMiddle"></td>
              <td><input type="number" min="0" step="0.1" v-model.number="row.hoursGeneral"></td>
            </tr>
            <tr class="grand-total">
              <td>合计</td>
              <td>{{ sumField('total') }}</td>
              <td>{{ sumField('trained') }}</td>
              <td>{{ percent(sumField('trained'), sumField('total')) }}</td>
              <td>{{ sumField('male') }}</td>
              <td>{{ sumField('female') }}</td>
              <td>{{ percent(sumField('male'), sumField('trained')) }}</td>
              <td>{{ percent(sumField('female'), sumField('trained')) }}</td>
              <td>{{ sumField('mgmt') }}</td>
              <td>{{ sumField('middle') }}</td>
              <td>{{ sumField('general') }}</td>
              <td>{{ percent(sumField('mgmt'), sumField('trained')) }}</td>
              <td>{{ percent(sumField('middle'), sumField('trained')) }}</td>
              <td>{{ percent(sumField('general'), sumField('trained')) }}</td>
              <td>{{ sumField('hoursTotal') }}</td>
              <td>{{ sumField('hoursMale') }}</td>
              <td>{{ sumField('hoursFemale') }}</td>
              <td>{{ sumField('hoursMgmt') }}</td>
              <td>{{ sumField('hoursMiddle') }}</td>
              <td>{{ sumField('hoursGeneral') }}</td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <button type="submit" :disabled="isSubmitting">{{ isSubmitting ? '提交中...' : '提交教育与培训数据' }}</button>
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
    total: 0, trained: 0,
    male: 0, female: 0,
    mgmt: 0, middle: 0, general: 0,
    hoursTotal: 0, hoursMale: 0, hoursFemale: 0, hoursMgmt: 0, hoursMiddle: 0, hoursGeneral: 0,
  })
}
const rows = reactive(Array.from({length: factories.value.length}, ()=> makeRow()))

const percent = (num, den)=>{
  num = Number(num||0); den = Number(den||0)
  if(den<=0||num<0) return 0
  return ((num/den)*100).toFixed(2)
}
const sumField = (key)=> rows.reduce((s,r)=> s + Number(r[key]||0), 0)

async function submitTraining(){
  isSubmitting.value = true
  try{
    const payload = {
      year: Number(year.value),
      records: rows.map((r, idx)=> ({ factory: factories.value[idx], ...r })),
      summary: {
        totals: {
          total: sumField('total'), trained: sumField('trained'),
          male: sumField('male'), female: sumField('female'),
          mgmt: sumField('mgmt'), middle: sumField('middle'), general: sumField('general'),
          hoursTotal: sumField('hoursTotal'), hoursMale: sumField('hoursMale'), hoursFemale: sumField('hoursFemale'),
          hoursMgmt: sumField('hoursMgmt'), hoursMiddle: sumField('hoursMiddle'), hoursGeneral: sumField('hoursGeneral'),
        },
        rates: {
          coverage: percent(sumField('trained'), sumField('total')),
          male: percent(sumField('male'), sumField('trained')),
          female: percent(sumField('female'), sumField('trained')),
          mgmt: percent(sumField('mgmt'), sumField('trained')),
          middle: percent(sumField('middle'), sumField('trained')),
          general: percent(sumField('general'), sumField('trained')),
        }
      }
    }
    const resp = await axios.post('http://localhost:8000/submit/training', payload)
    if(resp.data.status==='success') alert('教育与培训数据提交成功!')
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
.training-table{width:100%; border-collapse:collapse}
.training-table th,.training-table td{border:1px solid #ddd; padding:6px; text-align:center}
.training-table thead th{position:sticky; top:0; background:#f7f7f7; z-index:1}
.factory-cell{white-space:nowrap; text-align:left}
.total-cell{font-weight:600}
.grand-total td{font-weight:700; background:#fafafa}
.training-table input{width:110px}
@media (max-width: 768px){.training-table input{width:90px}}
</style>


