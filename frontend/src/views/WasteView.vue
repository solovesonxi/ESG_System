<template>
  <div class="shared-form">
    <form @submit.prevent="submitForm">
      <!-- 基础信息 -->
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
              <th v-for="(m, idx) in monthNames" :key="`epe-h-${idx}`">{{ m }}</th>
              <th>合计</th>
            </tr>
            </thead>
            <tbody>
            <tr>
              <td v-for="c in 12" :key="`epe-c-${c-1}`">
                <input type="number" min="0" step="0.01" v-model.number="epe[c-1]">
              </td>
              <td class="total-cell">{{ rowSum(epe) }}</td>
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
              <th v-for="(m, idx) in monthNames" :key="`pp-h-${idx}`">{{ m }}</th>
              <th>合计</th>
            </tr>
            </thead>
            <tbody>
            <tr>
              <td v-for="c in 12" :key="`pp-c-${c-1}`">
                <input type="number" min="0" step="0.01" v-model.number="plasticPaper[c-1]">
              </td>
              <td class="total-cell">{{ rowSum(plasticPaper) }}</td>
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
              <th v-for="(m, idx) in monthNames" :key="`lig-h-${idx}`">{{ m }}</th>
              <th>合计</th>
            </tr>
            </thead>
            <tbody>
            <tr>
              <td v-for="c in 12" :key="`lig-c-${c-1}`">
                <input type="number" min="0" step="0.01" v-model.number="domesticIndustrial[c-1]">
              </td>
              <td class="total-cell">{{ rowSum(domesticIndustrial) }}</td>
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
              <th v-for="(m, idx) in monthNames" :key="`haz-h-${idx}`">{{ m }}</th>
              <th>合计</th>
            </tr>
            </thead>
            <tbody>
            <tr>
              <td v-for="c in 12" :key="`haz-c-${c-1}`">
                <input type="number" min="0" step="0.01" v-model.number="hazardous[c-1]">
              </td>
              <td class="total-cell">{{ rowSum(hazardous) }}</td>
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
              <th v-for="(m, idx) in monthNames" :key="`ww-h-${idx}`">{{ m }}</th>
              <th>合计</th>
            </tr>
            </thead>
            <tbody>
            <tr>
              <td v-for="c in 12" :key="`ww-c-${c-1}`">
                <input type="number" min="0" step="0.01" v-model.number="wastewater[c-1]">
              </td>
              <td class="total-cell">{{ rowSum(wastewater) }}</td>
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
            <tr>
              <td>{{ epeTotal }}</td>
              <td>{{ plasticPaperTotal }}</td>
              <td>{{ domesticIndustrialTotal }}</td>
              <td>{{ nonHazardousTotal }}</td>
              <td>{{ hazardousTotal }}</td>
              <td>{{ totalWaste }}</td>
              <td>{{ recyclableTotal }}</td>
              <td>{{ disposalRequiredTotal }}</td>
              <td>{{ recycleRate }}</td>
              <td>
                <input type="number" min="0" step="0.01" v-model.number="protectiveReuseRate">
              </td>
              <td>
                <input type="number" min="0" step="0.01" v-model.number="total_revenue">
              </td>
              <td>{{ hazardousIntensity }}</td>
              <td>{{ wastewaterTotal }}</td>
              <td>{{ wastewaterIntensity }}</td>
              <td>
                <input type="number" min="0" step="1" v-model.number="exceedEvents">
              </td>
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
import {useSelectionStore} from '@/stores/selectionStore'
import apiClient from "@/utils/axios.js";

const selectionStore = useSelectionStore()
const factory = computed(() => selectionStore.selectedFactory)
const factories = computed(() => selectionStore.factories)
const year = computed(() => selectionStore.selectedYear)
const years = computed(() => selectionStore.years)
const isSubmitting = ref(false)

onMounted(() => {
  document.addEventListener('click', selectionStore.handleClickOutside)
})

onBeforeUnmount(() => {
  document.removeEventListener('click', selectionStore.handleClickOutside)
})

const monthNames = [
  '1月','2月','3月','4月','5月','6月','7月','8月','9月','10月','11月','12月'
]

// 初始化数据 - 只存储当前工厂的数据
const epe = reactive(Array(12).fill(0))
const plasticPaper = reactive(Array(12).fill(0))
const domesticIndustrial = reactive(Array(12).fill(0))
const hazardous = reactive(Array(12).fill(0))
const wastewater = reactive(Array(12).fill(0))

// 汇总输入项
const total_revenue = ref(0)
const exceedEvents = ref(0)
const protectiveReuseRate = ref(0)

// 工具函数
const rowSum = (arr) => arr.reduce((s, v) => s + (Number(v) || 0), 0).toFixed(2)

// 计算各类废弃物总量
const epeTotal = computed(() => rowSum(epe))
const plasticPaperTotal = computed(() => rowSum(plasticPaper))
const domesticIndustrialTotal = computed(() => rowSum(domesticIndustrial))
const hazardousTotal = computed(() => rowSum(hazardous))
const wastewaterTotal = computed(() => rowSum(wastewater))

// 计算汇总指标
const nonHazardousTotal = computed(() => {
  return (parseFloat(epeTotal.value) +
      parseFloat(plasticPaperTotal.value) +
      parseFloat(domesticIndustrialTotal.value)).toFixed(2)
})

const recyclableTotal = computed(() => {
  return (parseFloat(epeTotal.value) +
      parseFloat(plasticPaperTotal.value)).toFixed(2)
})

const totalWaste = computed(() => {
  return (parseFloat(nonHazardousTotal.value) +
      parseFloat(hazardousTotal.value)).toFixed(2)
})

const disposalRequiredTotal = computed(() => {
  return (parseFloat(domesticIndustrialTotal.value) +
      parseFloat(hazardousTotal.value)).toFixed(2)
})

const recycleRate = computed(() => {
  if (parseFloat(totalWaste.value) > 0) {
    return ((parseFloat(recyclableTotal.value) / parseFloat(totalWaste.value)) * 100).toFixed(2)
  }
  return 0
})

const hazardousIntensity = computed(() => {
  if (total_revenue.value > 0 && parseFloat(hazardousTotal.value) > 0) {
    return (parseFloat(hazardousTotal.value) / total_revenue.value).toFixed(4)
  }
  return 0
})

const wastewaterIntensity = computed(() => {
  if (total_revenue.value > 0 && parseFloat(wastewaterTotal.value) > 0) {
    return (parseFloat(wastewaterTotal.value) / total_revenue.value).toFixed(4)
  }
  return 0
})

async function submitForm(){
  isSubmitting.value = true
  try{
    const payload = {
      factory: factory.value,
      year: Number(year.value),
      epe: [...epe],
      plasticPaper: [...plasticPaper],
      domesticIndustrial: [...domesticIndustrial],
      hazardous: [...hazardous],
      wastewater: [...wastewater],
      epeTotal: epeTotal.value,
      plasticPaperTotal: plasticPaperTotal.value,
      domesticIndustrialTotal: domesticIndustrialTotal.value,
      hazardousTotal: hazardousTotal.value,
      wastewaterTotal: wastewaterTotal.value,
      nonHazardousTotal: nonHazardousTotal.value,
      recyclableTotal: recyclableTotal.value,
      totalWaste: totalWaste.value,
      disposalRequiredTotal: disposalRequiredTotal.value,
      recycleRate: recycleRate.value,
      total_revenue: total_revenue.value,
      protectiveReuseRate: protectiveReuseRate.value,
      exceedEvents: exceedEvents.value,
      hazardousIntensity: hazardousIntensity.value,
      wastewaterIntensity: wastewaterIntensity.value
    }

    const resp = await apiClient.post('/quantitative/waste', payload)
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
</script>

<style scoped>
.table-wrapper {
  overflow: auto;
}

.waste-table {
  width: 100%;
  border-collapse: collapse;
}

.waste-table th, .waste-table td {
  border: 1px solid #ddd;
  padding: 8px;
  text-align: center;
}

.waste-table thead th {
  position: sticky;
  top: 0;
  background: #f7f7f7;
  z-index: 1;
}

.total-cell {
  font-weight: 600;
  background-color: #f5f5f5;
}

.summary-fieldset .waste-table td {
  min-width: 100px;
}

.waste-table input {
  width: 80px;
  padding: 4px;
  text-align: center;
}

@media (max-width: 768px) {
  .table-wrapper {
    overflow-x: auto;
  }

  .waste-table {
    font-size: 12px;
  }

  .waste-table th, .waste-table td {
    padding: 6px;
  }

  .waste-table input {
    width: 60px;
    padding: 2px;
  }
}
</style>