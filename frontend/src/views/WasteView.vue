<template>
  <div class="shared-form">
    <form>
      <BaseInfoSelector :review="review" form-type="waste" @selection-changed="fetchData"/>
      <fieldset class="summary-fieldset">
        <legend>{{ year }}年{{ month }}月废弃物数据统计</legend>

        <div class="loading" v-if="isLoading">数据加载中...</div>

        <div class="form-row" v-else>
          <!-- 回收料（EPE） -->
          <div class="form-group">
            <label>回收料（EPE）(T)</label>
            <input
                type="number"
                v-model.number="epe[month - 1]"
                min="0"
                step="0.01"
                :readonly="!isEditing"
                :class="{ 'editable-field': isEditing }"
                required
            >
          </div>

          <!-- 回收料（吸塑、纸塑） -->
          <div class="form-group">
            <label>回收料（吸塑、纸塑）(T)</label>
            <input
                type="number"
                v-model.number="plasticPaper[month - 1]"
                min="0"
                step="0.01"
                :readonly="!isEditing"
                :class="{ 'editable-field': isEditing }"
                required
            >
          </div>

          <!-- 生活&工业垃圾 -->
          <div class="form-group">
            <label>生活&工业垃圾 (T)</label>
            <input
                type="number"
                v-model.number="domesticIndustrial[month - 1]"
                min="0"
                step="0.01"
                :readonly="!isEditing"
                :class="{ 'editable-field': isEditing }"
                required
            >
          </div>

          <!-- 危废 -->
          <div class="form-group">
            <label>危废 (T)</label>
            <input
                type="number"
                v-model.number="hazardous[month - 1]"
                min="0"
                step="0.01"
                :readonly="!isEditing"
                :class="{ 'editable-field': isEditing }"
                required
            >
          </div>

          <!-- 废水排放量 -->
          <div class="form-group">
            <label>废水排放量 (T)</label>
            <input
                type="number"
                v-model.number="wastewater[month - 1]"
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
        <div class="loading" v-if="isLoading">数据加载中...</div>
        <div class="form-row" v-else>
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
            <input type="number" v-model.number="totalRevenue" step="0.01"
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
    </form>
  </div>
</template>

<script setup>
import {computed, onBeforeUnmount, onMounted, reactive, ref} from 'vue'
import {useSelectionStore} from '@/stores/selectionStore'
import apiClient from '@/utils/axios'
import BaseInfoSelector from "@/components/BaseInfoSelector.vue";
import {handleError, showError, showInfo, showSuccess} from "@/utils/toast.js";

// —— 与能源统计保持一致的状态 —— //
const selectionStore = useSelectionStore()
const factory = computed(() => selectionStore.selectedFactory)
const year = computed(() => selectionStore.selectedYear);
const month = computed(() => selectionStore.selectedMonth);

const isEditing = ref(false)
const isLoading = ref(false)
const review = ref({});

// —— 废弃物月度数据（保持字段与原来一致） —— //
const epe = reactive(Array(12).fill(0))
const plasticPaper = reactive(Array(12).fill(0))
const domesticIndustrial = reactive(Array(12).fill(0))
const hazardous = reactive(Array(12).fill(0))
const wastewater = reactive(Array(12).fill(0))

// 汇总输入项（保持字段）
const totalRevenue = ref(0)
const exceedEvents = ref(0)
const protectiveReuseRate = ref(0)

// 汇总与强度计算（保持原逻辑与命名，默认保留两位小数行为）
const rowSum = (arr) => arr.reduce((s, v) => s + (Number(v) || 0), 0).toFixed(2)

// 计算当前月份的值和年度总值
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
  return (totalRevenue.value > 0 && hz > 0)
      ? (hz / totalRevenue.value).toFixed(4)
      : 0
})

const wastewaterIntensity = computed(() => {
  const ww = parseFloat(wastewaterTotal.value)
  return (totalRevenue.value > 0 && ww > 0)
      ? (ww / totalRevenue.value).toFixed(4)
      : 0
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
  isLoading.value = true
  try {
    const response = await apiClient.get('/quantitative/waste', {
      params: {factory: factory.value, year: year.value}
    })
    const data = response?.data?.data
    if (data) {
      // 兼容后端下划线/驼峰
      setArray(epe, data.epe || data?.epe || Array(12).fill(0))
      setArray(plasticPaper, data.plasticPaper || data.plastic_paper || Array(12).fill(0))
      setArray(domesticIndustrial, data.domesticIndustrial || data.domestic_industrial || Array(12).fill(0))
      setArray(hazardous, data.hazardous || data.hazardous_waste || Array(12).fill(0))
      setArray(wastewater, data.wastewater || data.waste_water || Array(12).fill(0))

      totalRevenue.value = toNum(data.totalRevenue)
      protectiveReuseRate.value = toNum(data.protectiveReuseRate || data.protective_reuse_rate)
      exceedEvents.value = toNum(data.exceedEvents || data.exceed_events)
      review.value = response.data.review;
    } else {
      resetFormData()
      showInfo('未找到数据')
    }
  } catch (error) {
    handleError(error);
    resetFormData()
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
  totalRevenue.value = 0
  protectiveReuseRate.value = 0
  exceedEvents.value = 0
  review.value = {status: Array(12).fill("pending"), comment: Array(12).fill('')};
}

const submitEdit = async (ifSubmit) => {
  try {
    const payload = {
      factory: factory.value,
      year: Number(year.value),
      month: month.value,
      epe: [...epe],
      plasticPaper: [...plasticPaper],
      domesticIndustrial: [...domesticIndustrial],
      hazardous: [...hazardous],
      wastewater: [...wastewater],
      nonHazardousTotal: nonHazardousTotal.value,
      recyclableTotal: recyclableTotal.value,
      totalWaste: totalWaste.value,
      disposalRequiredTotal: disposalRequiredTotal.value,
      recycleRate: recycleRate.value,
      totalRevenue: totalRevenue.value,
      protectiveReuseRate: protectiveReuseRate.value,
      exceedEvents: exceedEvents.value,
      hazardousIntensity: hazardousIntensity.value,
      wastewaterIntensity: wastewaterIntensity.value,
      isSubmitted: ifSubmit
    }
    const response = await apiClient.post('/quantitative/waste', payload)
    if (response.data.status === 'success') {
      showSuccess('数据提交成功!')
    } else {
      showError(`数据提交失败: ${response.data.message || '未知错误'}`)
    }
  } catch (error) {
    console.error('提交失败:', error)
    handleError(error);
  } finally {
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
