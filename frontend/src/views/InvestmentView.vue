<template>
  <div class="shared-form">
    <form>
      <BaseInfoSelector :review="review" form-type="investment" @selection-changed="fetchData"/>
      <fieldset class="summary-fieldset">
        <legend>{{ year }}年{{ month }}月资金投入数据统计</legend>
        <div class="loading" v-if="isLoading">数据加载中...</div>
        <div class="form-row" v-else>
          <div class="form-group">
            <label>环保投入（万元）</label>
            <input
                type="number"
                v-model.number="envInvest[month - 1]"
                min="0"
                step="0.01"
                :readonly="!isEditing"
                :class="{ 'editable-field': isEditing }"
                required
            >
          </div>

          <div class="form-group">
            <label>清洁技术投入（万元）</label>
            <input
                type="number"
                v-model.number="cleanTechInvest[month - 1]"
                min="0"
                step="0.01"
                :readonly="!isEditing"
                :class="{ 'editable-field': isEditing }"
                required
            >
          </div>

          <div class="form-group">
            <label>气候投入（万元）</label>
            <input
                type="number"
                v-model.number="climateInvest[month - 1]"
                min="0"
                step="0.01"
                :readonly="!isEditing"
                :class="{ 'editable-field': isEditing }"
                required
            >
          </div>

          <div class="form-group">
            <label>绿色收入（万元）</label>
            <input
                type="number"
                v-model.number="greenIncome[month - 1]"
                min="0"
                step="0.01"
                :readonly="!isEditing"
                :class="{ 'editable-field': isEditing }"
                required
            >
          </div>
        </div>
      </fieldset>
      <fieldset class="summary-fieldset">
        <legend>{{ year }}年资金投入统计 - 汇总</legend>
        <div class="form-row">
          <div class="form-group">
            <label>环保投入 (万元)</label>
            <input type="number" :value="envInvestTotal" disabled class="calculated-field">
          </div>
          <div class="form-group">
            <label>清洁技术投入 (万元)</label>
            <input type="number" :value="cleanTechInvestTotal" disabled class="calculated-field">
          </div>
          <div class="form-group">
            <label>气候投入 (万元)</label>
            <input type="number" :value="climateInvestTotal" disabled class="calculated-field">
          </div>
          <div class="form-group">
            <label>总投入 (万元)</label>
            <input type="number" :value="totalInvestment" disabled class="calculated-field">
          </div>
          <div class="form-group">
            <label>绿色收入 (万元)</label>
            <input type="number" :value="greenIncomeTotal" disabled class="calculated-field">
          </div>
          <div class="form-group">
            <label>营业收入 (万元)</label>
            <input type="number" v-model.number="total_revenue" step="0.01"
                   :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
          </div>
          <div class="form-group">
            <label>环保投入强度 (%)</label>
            <input type="number" :value="envInvestIntensity" disabled class="calculated-field">
          </div>
          <div class="form-group">
            <label>绿色收入占比 (%)</label>
            <input type="number" :value="greenIncomeRatio" disabled class="calculated-field">
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
import {showError, showInfo, showSuccess, handleError} from "@/utils/toast.js";

// —— 与能源统计保持一致的状态 —— //
const selectionStore = useSelectionStore()
const factory = computed(() => selectionStore.selectedFactory)
const year = computed(() => selectionStore.selectedYear);
const month = computed(() => selectionStore.selectedMonth);

const isEditing = ref(false)
const isLoading = ref(false)
const review = ref({});


// —— 资金投入月度数据（保持字段与原来一致） —— //
const envInvest = reactive(Array(12).fill(0))
const cleanTechInvest = reactive(Array(12).fill(0))
const climateInvest = reactive(Array(12).fill(0))
const greenIncome = reactive(Array(12).fill(0))

// 汇总输入项（保持字段）
const total_revenue = ref(0)

// 汇总与强度计算（保持原逻辑与命名，默认保留两位小数行为）
const rowSum = (arr) => arr.reduce((s, v) => s + (Number(v) || 0), 0).toFixed(2)

const envInvestTotal = computed(() => rowSum(envInvest))
const cleanTechInvestTotal = computed(() => rowSum(cleanTechInvest))
const climateInvestTotal = computed(() => rowSum(climateInvest))
const greenIncomeTotal = computed(() => rowSum(greenIncome))

const totalInvestment = computed(() => (
    (parseFloat(envInvestTotal.value) +
        parseFloat(cleanTechInvestTotal.value) +
        parseFloat(climateInvestTotal.value)).toFixed(2)
))

const envInvestIntensity = computed(() => {
  const env = parseFloat(envInvestTotal.value)
  return (total_revenue.value > 0 && env > 0)
      ? ((env / total_revenue.value) * 100).toFixed(2)
      : 0
})

const greenIncomeRatio = computed(() => {
  const gi = parseFloat(greenIncomeTotal.value)
  return (total_revenue.value > 0 && gi > 0)
      ? ((gi / total_revenue.value) * 100).toFixed(2)
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
    const response = await apiClient.get('/quantitative/investment', {
      params: {factory: factory.value, year: year.value}
    })
    const data = response?.data?.data
    if (data) {
      // 兼容后端下划线/驼峰
      setArray(envInvest, data.envInvest || data.env_invest || Array(12).fill(0))
      setArray(cleanTechInvest, data.cleanTechInvest || data.clean_tech_invest || Array(12).fill(0))
      setArray(climateInvest, data.climateInvest || data.climate_invest || Array(12).fill(0))
      setArray(greenIncome, data.greenIncome || data.green_income || Array(12).fill(0))
      total_revenue.value = toNum(data.totalRevenue || data.total_revenue)
      review.value = response.data.review;
    } else {
      resetFormData()
      showInfo("未找到数据")
    }
  } catch (error) {
      handleError(error);
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
  setArray(envInvest, Array(12).fill(0))
  setArray(cleanTechInvest, Array(12).fill(0))
  setArray(climateInvest, Array(12).fill(0))
  setArray(greenIncome, Array(12).fill(0))
  total_revenue.value = 0
  review.value = {
    id: Array(12).fill(-1), is_submitted: Array(12).fill(false), status1: Array(12).fill("pending"), comment1: Array(12).fill(''),
    status2: Array(12).fill("pending"), comment22: Array(12).fill('')
  };
}

// —— 提交编辑（保持原字段，不改动内容，只改样式） —— //
const submitEdit = async (ifSubmit) => {
  try {
    const payload = {
      factory: factory.value,
      year: Number(year.value),
      month: month.value,
      envInvest: [...envInvest],
      cleanTechInvest: [...cleanTechInvest],
      climateInvest: [...climateInvest],
      greenIncome: [...greenIncome],
      totalInvestment: totalInvestment.value,
      totalRevenue: total_revenue.value,
      envInvestIntensity: envInvestIntensity.value,
      greenIncomeRatio: greenIncomeRatio.value,
      isSubmitted: ifSubmit
    }
    const response = await apiClient.post('/quantitative/investment', payload)
    if (response.data.status === 'success') {
      showSuccess('数据提交成功!')
    }else {
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