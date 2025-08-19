<template>
  <div class="shared-form">
    <form @submit.prevent="submitSupply">
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
        <legend>{{ year }}年供应商统计</legend>
        <div class="table-wrapper">
          <table class="supply-table">
            <thead>
            <tr>
              <th>工厂</th>
              <th>单位</th>
              <th>华东地区</th>
              <th>华南地区</th>
              <th>其他地区</th>
              <th>合计</th>
              <th>使用环境评价维度筛选的供应商</th>
              <th>使用社会标准筛选的供应商</th>
              <th>当地供应商采购金额(万元)</th>
              <th>采购总金额(万元)</th>
              <th>环境评价维度占比(%)</th>
              <th>社会标准筛选占比(%)</th>
              <th>当地采购比例(%)</th>
              <th>供应商环境处罚次数(次)</th>
              <th>供应商环境处罚总额(万元)</th>
              <th>供应商网络数据安全事件次数(次)</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="(row, i) in rows" :key="`sup-${i}`">
              <td class="factory-cell">{{ factories[i] }}</td>
              <td>个</td>
              <td><input type="number" min="0" step="1" v-model.number="row.east"></td>
              <td><input type="number" min="0" step="1" v-model.number="row.south"></td>
              <td><input type="number" min="0" step="1" v-model.number="row.other"></td>
              <td class="total-cell">{{ totalSuppliers(row) }}</td>
              <td><input type="number" min="0" step="1" v-model.number="row.envScreened"></td>
              <td><input type="number" min="0" step="1" v-model.number="row.socScreened"></td>
              <td><input type="number" min="0" step="0.01" v-model.number="row.localAmount"></td>
              <td><input type="number" min="0" step="0.01" v-model.number="row.totalAmount"></td>
              <td class="total-cell">{{ percent(row.envScreened, totalSuppliers(row)) }}</td>
              <td class="total-cell">{{ percent(row.socScreened, totalSuppliers(row)) }}</td>
              <td class="total-cell">{{ percent(row.localAmount, row.totalAmount) }}</td>
              <td><input type="number" min="0" step="1" v-model.number="row.envPenaltyCount"></td>
              <td><input type="number" min="0" step="0.01" v-model.number="row.envPenaltyAmount"></td>
              <td><input type="number" min="0" step="1" v-model.number="row.cyberIncidents"></td>
            </tr>
            <tr class="grand-total">
              <td>合计</td>
              <td>个</td>
              <td>{{ sumField('east') }}</td>
              <td>{{ sumField('south') }}</td>
              <td>{{ sumField('other') }}</td>
              <td>{{ sumRows(totalSuppliers) }}</td>
              <td>{{ sumField('envScreened') }}</td>
              <td>{{ sumField('socScreened') }}</td>
              <td>{{ sumField('localAmount') }}</td>
              <td>{{ sumField('totalAmount') }}</td>
              <td>{{ percent(sumField('envScreened'), sumRows(totalSuppliers)) }}</td>
              <td>{{ percent(sumField('socScreened'), sumRows(totalSuppliers)) }}</td>
              <td>{{ percent(sumField('localAmount'), sumField('totalAmount')) }}</td>
              <td>{{ sumField('envPenaltyCount') }}</td>
              <td>{{ sumField('envPenaltyAmount') }}</td>
              <td>{{ sumField('cyberIncidents') }}</td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <div style="opacity:.75; font-size:12px; line-height:1.4; margin-top:8px">
        <div>* 当地采购：工厂按大区统计（华南、华东、华中等）。</div>
        <div>* 明确使用环境、社会标准审查的供应商范畴：生产型供应商（核心供应商），剔除行政采购类供应商。</div>
        <div>* 供应商行为准则签订比例（廉洁、环保、冲突矿产）可后续扩展。</div>
      </div>

      <button type="submit" :disabled="isSubmitting">{{ isSubmitting ? '提交中...' : '提交供应链数据' }}</button>
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
    east: 0, south: 0, other: 0,
    envScreened: 0, socScreened: 0,
    localAmount: 0, totalAmount: 0,
    envPenaltyCount: 0, envPenaltyAmount: 0,
    cyberIncidents: 0,
  })
}
const rows = reactive(Array.from({length: factories.value.length}, ()=> makeRow()))

const totalSuppliers = (row)=> Number(row.east||0) + Number(row.south||0) + Number(row.other||0)
const percent = (num, den)=>{
  num = Number(num||0); den = Number(den||0)
  if(den<=0||num<0) return 0
  return ((num/den)*100).toFixed(2)
}
const sumField = (key)=> rows.reduce((s,r)=> s + Number(r[key]||0), 0)
const sumRows = (fn)=> rows.reduce((s,r)=> s + Number(fn(r)||0), 0)

async function submitSupply(){
  isSubmitting.value = true
  try{
    const payload = {
      year: Number(year.value),
      records: rows.map((r, idx)=> ({ factory: factories.value[idx], ...r, totalSuppliers: totalSuppliers(r),
        envRatio: Number(percent(r.envScreened, totalSuppliers(r))),
        socRatio: Number(percent(r.socScreened, totalSuppliers(r))),
        localPurchaseRatio: Number(percent(r.localAmount, r.totalAmount))
      })),
      summary: {
        totals: {
          east: sumField('east'), south: sumField('south'), other: sumField('other'),
          totalSuppliers: sumRows(totalSuppliers),
          envScreened: sumField('envScreened'), socScreened: sumField('socScreened'),
          localAmount: sumField('localAmount'), totalAmount: sumField('totalAmount'),
          envPenaltyCount: sumField('envPenaltyCount'), envPenaltyAmount: sumField('envPenaltyAmount'),
          cyberIncidents: sumField('cyberIncidents'),
        },
        ratios: {
          envRatio: Number(percent(sumField('envScreened'), sumRows(totalSuppliers))),
          socRatio: Number(percent(sumField('socScreened'), sumRows(totalSuppliers))),
          localPurchaseRatio: Number(percent(sumField('localAmount'), sumField('totalAmount'))),
        }
      }
    }
    const resp = await axios.post('http://localhost:8000/submit/supply', payload)
    if(resp.data.status==='success') alert('供应链数据提交成功!')
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
.supply-table{width:100%; border-collapse:collapse}
.supply-table th,.supply-table td{border:1px solid #ddd; padding:6px; text-align:center}
.supply-table thead th{position:sticky; top:0; background:#f7f7f7; z-index:1}
.factory-cell{white-space:nowrap; text-align:left}
.total-cell{font-weight:600}
.grand-total td{font-weight:700; background:#fafafa}
.supply-table input{width:110px}
@media (max-width: 768px){.supply-table input{width:90px}}
</style>


