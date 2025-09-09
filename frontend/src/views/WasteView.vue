<template>
  <div class="shared-form">
    <form>
      <!-- 基础信息，与能源统计保持一致 -->
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

      <!-- 废弃物数据部分（样式与能源统计保持一致） -->
      <fieldset class="summary-fieldset">
        <legend>废弃物数据统计</legend>

        <div class="loading" v-if="isLoading">数据加载中...</div>

        <div v-else>
          <!-- 回收料（EPE） -->
          <fieldset>
            <legend>{{ year }}年废弃物统计 - 回收料（EPE）(T)</legend>
            <div class="monthly-grid">
              <div v-for="(_, index) in epe" :key="'epe-'+index" class="month-input">
                <label>{{ getMonthName(index) }}</label>
                <input
                  type="number"
                  v-model.number="epe[index]"
                  :placeholder="`${getMonthName(index)}EPE`"
                  min="0"
                  step="0.01"
                  :readonly="!isEditing"
                  :class="{ 'editable-field': isEditing }"
                  required
                >
              </div>
            </div>
          </fieldset>

          <!-- 回收料（吸塑、纸塑） -->
          <fieldset>
            <legend>{{ year }}年废弃物统计 - 回收料（吸塑、纸塑）(T)</legend>
            <div class="monthly-grid">
              <div v-for="(_, index) in plasticPaper" :key="'pp-'+index" class="month-input">
                <label>{{ getMonthName(index) }}</label>
                <input
                  type="number"
                  v-model.number="plasticPaper[index]"
                  :placeholder="`${getMonthName(index)}吸塑/纸塑`"
                  min="0"
                  step="0.01"
                  :readonly="!isEditing"
                  :class="{ 'editable-field': isEditing }"
                  required
                >
              </div>
            </div>
          </fieldset>

          <!-- 生活&工业垃圾 -->
          <fieldset>
            <legend>{{ year }}年废弃物统计 - 生活&工业垃圾 (T)</legend>
            <div class="monthly-grid">
              <div v-for="(_, index) in domesticIndustrial" :key="'di-'+index" class="month-input">
                <label>{{ getMonthName(index) }}</label>
                <input
                  type="number"
                  v-model.number="domesticIndustrial[index]"
                  :placeholder="`${getMonthName(index)}生活&工业`"
                  min="0"
                  step="0.01"
                  :readonly="!isEditing"
                  :class="{ 'editable-field': isEditing }"
                  required
                >
              </div>
            </div>
          </fieldset>

          <!-- 危废 -->
          <fieldset>
            <legend>{{ year }}年废弃物统计 - 危废 (T)</legend>
            <div class="monthly-grid">
              <div v-for="(_, index) in hazardous" :key="'haz-'+index" class="month-input">
                <label>{{ getMonthName(index) }}</label>
                <input
                  type="number"
                  v-model.number="hazardous[index]"
                  :placeholder="`${getMonthName(index)}危废`"
                  min="0"
                  step="0.01"
                  :readonly="!isEditing"
                  :class="{ 'editable-field': isEditing }"
                  required
                >
              </div>
            </div>
          </fieldset>

          <!-- 废水排放量 -->
          <fieldset>
            <legend>{{ year }}年废水排放量统计 (T)</legend>
            <div class="monthly-grid">
              <div v-for="(_, index) in wastewater" :key="'ww-'+index" class="month-input">
                <label>{{ getMonthName(index) }}</label>
                <input
                  type="number"
                  v-model.number="wastewater[index]"
                  :placeholder="`${getMonthName(index)}废水`"
                  min="0"
                  step="0.01"
                  :readonly="!isEditing"
                  :class="{ 'editable-field': isEditing }"
                  required
                >
              </div>
            </div>
          </fieldset>

          <!-- 汇总（与能源统计合计区块相同结构：form-row + form-group + disabled 计算值） -->
          <fieldset class="summary-fieldset">
            <legend>{{ year }}年废弃物统计 - 汇总</legend>
            <div class="form-row">
              <div class="form-group">
                <label>回收料EPE (T)</label>
                <input type="number" :value="epeTotal" disabled class="calculated-field">
              </div>
              <div class="form-group">
                <label>回收料吸塑/纸塑 (T)</label>
                <input type="number" :value="plasticPaperTotal" disabled class="calculated-field">
              </div>
              <div class="form-group">
                <label>生活&工业垃圾 (T)</label>
                <input type="number" :value="domesticIndustrialTotal" disabled class="calculated-field">
              </div>
              <div class="form-group">
                <label>无害废弃物总量 (T)</label>
                <input type="number" :value="nonHazardousTotal" disabled class="calculated-field">
              </div>
              <div class="form-group">
                <label>有害废弃物总量 (T)</label>
                <input type="number" :value="hazardousTotal" disabled class="calculated-field">
              </div>
              <div class="form-group">
                <label>废弃物总量 (T)</label>
                <input type="number" :value="totalWaste" disabled class="calculated-field">
              </div>
              <div class="form-group">
                <label>可回收废弃物总量 (T)</label>
                <input type="number" :value="recyclableTotal" disabled class="calculated-field">
              </div>
              <div class="form-group">
                <label>需处置废弃物总量 (T)</label>
                <input type="number" :value="disposalRequiredTotal" disabled class="calculated-field">
              </div>
              <div class="form-group">
                <label>废弃物回收率 (%)</label>
                <input type="number" :value="recycleRate" disabled class="calculated-field">
              </div>
              <div class="form-group">
                <label>防护产品废弃物综合利用率 (%)</label>
                <input type="number" v-model.number="protectiveReuseRate" step="0.01"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>营业收入 (万元)</label>
                <input type="number" v-model.number="total_revenue" step="0.01"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>有害废弃物强度 (T/万元)</label>
                <input type="number" :value="hazardousIntensity" disabled class="calculated-field">
              </div>
              <div class="form-group">
                <label>废水排放量 (T)</label>
                <input type="number" :value="wastewaterTotal" disabled class="calculated-field">
              </div>
              <div class="form-group">
                <label>废水排放强度 (T/万元)</label>
                <input type="number" :value="wastewaterIntensity" disabled class="calculated-field">
              </div>
              <div class="form-group">
                <label>排放超标事件 (次)</label>
                <input type="number" v-model.number="exceedEvents" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
            </div>
          </fieldset>
        </div>
      </fieldset>
    </form>
  </div>
</template>

<script setup>
import { computed, onBeforeUnmount, onMounted, reactive, ref, watch } from 'vue'
import { useSelectionStore } from '@/stores/selectionStore'
import apiClient from '@/utils/axios'

// —— 与能源统计保持一致的状态 —— //
const selectionStore = useSelectionStore()
const factory = computed(() => selectionStore.selectedFactory)
const factories = computed(() => selectionStore.factories)
const year = computed(() => selectionStore.selectedYear)
const years = computed(() => selectionStore.years)

const isEditing = ref(false)
const isLoading = ref(false)

// 月份名称映射 & 工具函数（与能源一致）
const monthNames = ['1月','2月','3月','4月','5月','6月','7月','8月','9月','10月','11月','12月']
const getMonthName = (index) => monthNames[index]

// —— 废弃物月度数据（保持字段与原来一致） —— //
const epe = reactive(Array(12).fill(0))
const plasticPaper = reactive(Array(12).fill(0))
const domesticIndustrial = reactive(Array(12).fill(0))
const hazardous = reactive(Array(12).fill(0))
const wastewater = reactive(Array(12).fill(0))

// 汇总输入项（保持字段）
const total_revenue = ref(0)
const exceedEvents = ref(0)
const protectiveReuseRate = ref(0)

// 汇总与强度计算（保持原逻辑与命名，默认保留两位小数行为）
const rowSum = (arr) => arr.reduce((s, v) => s + (Number(v) || 0), 0).toFixed(2)

const epeTotal = computed(() => rowSum(epe))
const plasticPaperTotal = computed(() => rowSum(plasticPaper))
const domesticIndustrialTotal = computed(() => rowSum(domesticIndustrial))
const hazardousTotal = computed(() => rowSum(hazardous))
const wastewaterTotal = computed(() => rowSum(wastewater))

const nonHazardousTotal = computed(() => (
  (parseFloat(epeTotal.value) +
   parseFloat(plasticPaperTotal.value) +
   parseFloat(domesticIndustrialTotal.value)).toFixed(2)
))

const recyclableTotal = computed(() => (
  (parseFloat(epeTotal.value) +
   parseFloat(plasticPaperTotal.value)).toFixed(2)
))

const totalWaste = computed(() => (
  (parseFloat(nonHazardousTotal.value) +
   parseFloat(hazardousTotal.value)).toFixed(2)
))

const disposalRequiredTotal = computed(() => (
  (parseFloat(domesticIndustrialTotal.value) +
   parseFloat(hazardousTotal.value)).toFixed(2)
))

const recycleRate = computed(() => {
  const tw = parseFloat(totalWaste.value)
  const rc = parseFloat(recyclableTotal.value)
  return tw > 0 ? ((rc / tw) * 100).toFixed(2) : 0
})

const hazardousIntensity = computed(() => {
  const hz = parseFloat(hazardousTotal.value)
  return (total_revenue.value > 0 && hz > 0)
    ? (hz / total_revenue.value).toFixed(4)
    : 0
})

const wastewaterIntensity = computed(() => {
  const ww = parseFloat(wastewaterTotal.value)
  return (total_revenue.value > 0 && ww > 0)
    ? (ww / total_revenue.value).toFixed(4)
    : 0
})

// —— 与能源统计保持一致：监听工厂/年份变化并拉取数据 —— //
watch([factory, year], () => {
  fetchData()
})

onMounted(() => {
  document.addEventListener('click', selectionStore.handleClickOutside)
  // 首次进入拉取一次
  fetchData()
})

onBeforeUnmount(() => {
  document.removeEventListener('click', selectionStore.handleClickOutside)
})

// —— 获取数据（与能源统计风格相同） —— //
const fetchData = async () => {
  if (!factory.value || !year.value) {
    resetFormData()
    return
  }
  isLoading.value = true
  try {
    const resp = await apiClient.get('/quantitative/waste', {
      params: { factory: factory.value, year: year.value }
    })
    const data = resp?.data?.data
    if (data) {
      // 兼容后端下划线/驼峰
      setArray(epe, data.epe || data?.epe || Array(12).fill(0))
      setArray(plasticPaper, data.plasticPaper || data.plastic_paper || Array(12).fill(0))
      setArray(domesticIndustrial, data.domesticIndustrial || data.domestic_industrial || Array(12).fill(0))
      setArray(hazardous, data.hazardous || data.hazardous_waste || Array(12).fill(0))
      setArray(wastewater, data.wastewater || data.waste_water || Array(12).fill(0))

      total_revenue.value = toNum(data.total_revenue)
      protectiveReuseRate.value = toNum(data.protectiveReuseRate || data.protective_reuse_rate)
      exceedEvents.value = toNum(data.exceedEvents || data.exceed_events)
    } else {
      resetFormData()
    }
  } catch (err) {
    if (err.response?.status === 404) {
      resetFormData()
    } else {
      console.error('获取废弃物数据失败:', err)
      resetFormData()
    }
  } finally {
    isLoading.value = false
  }
}

const toNum = (v, d = 0) => {
  const n = Number(v)
  return Number.isFinite(n) ? n : d
}

const setArray = (reactiveArr, sourceArr) => {
  for (let i = 0; i < 12; i++) reactiveArr[i] = toNum(sourceArr?.[i] ?? 0)
}

// —— 重置（与能源一致的重置思路） —— //
const resetFormData = () => {
  setArray(epe, Array(12).fill(0))
  setArray(plasticPaper, Array(12).fill(0))
  setArray(domesticIndustrial, Array(12).fill(0))
  setArray(hazardous, Array(12).fill(0))
  setArray(wastewater, Array(12).fill(0))
  total_revenue.value = 0
  protectiveReuseRate.value = 0
  exceedEvents.value = 0
}

// —— 提交编辑（保持原字段，不改动内容，只改样式） —— //
const submitEdit = async () => {
  try {
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
    if (resp.data?.status === 'success') {
      alert('废弃物数据提交成功!')
    }
  } catch (err) {
    console.error('提交失败:', err)
    alert(`提交失败: ${err.response?.data?.detail || err.message}`)
  } finally {
    // 与能源一致：提交后退出编辑并刷新
    isEditing.value = false
    await fetchData()
  }
}

// —— 暴露方法，与能源统计完全一致 —— //
defineExpose({
  startEditing: () => (isEditing.value = true),
  cancelEditing: () => {
    isEditing.value = false
    fetchData()
  },
  submitEdit,
  fetchData
})
</script>
