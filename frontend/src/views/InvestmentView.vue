<template>
  <div class="shared-form">
    <form>
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
              <div class="options" v-show="selectionStore.showFactoryDropdown"
                   :style="{ maxHeight: '200px', overflowY: 'auto' }">
                <div
                    v-for="f in selectionStore.factories"
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
                    v-for="y in selectionStore.years"
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
          <div class="form-group">
            <label>统计月份</label>
            <div class="custom-select">
              <div class="selected" @click="selectionStore.toggleMonthDropdown">
                {{ month }}月
                <i class="arrow" :class="{ 'up': selectionStore.showMonthDropdown }"></i>
              </div>
              <div class="options" v-show="selectionStore.showMonthDropdown">
                <div
                    v-for="m in selectionStore.months"
                    :key="m"
                    class="option"
                    :class="{ 'selected-option': m === month }"
                    @click="selectionStore.selectMonth(m)"
                >
                  {{ m }}月
                </div>
              </div>
            </div>
          </div>
        </div>
      </fieldset>

      <!-- 资金投入数据部分（样式与能源统计保持一致） -->
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
import {computed, onBeforeUnmount, onMounted, reactive, ref, watch} from 'vue'
import {useSelectionStore} from '@/stores/selectionStore'
import apiClient from '@/utils/axios'

// —— 与能源统计保持一致的状态 —— //
const selectionStore = useSelectionStore()
const factory = computed(() => selectionStore.selectedFactory)
const year = computed(() => selectionStore.selectedYear);
const month = computed(() => selectionStore.selectedMonth);

const isEditing = ref(false)
const isLoading = ref(false)

// 月份名称映射 & 工具函数（与能源一致）
const monthNames = ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月']
const getMonthName = (index) => monthNames[index]

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
    const resp = await apiClient.get('/quantitative/investment', {
      params: {factory: factory.value, year: year.value}
    })
    const data = resp?.data?.data
    if (data) {
      // 兼容后端下划线/驼峰
      setArray(envInvest, data.envInvest || data.env_invest || Array(12).fill(0))
      setArray(cleanTechInvest, data.cleanTechInvest || data.clean_tech_invest || Array(12).fill(0))
      setArray(climateInvest, data.climateInvest || data.climate_invest || Array(12).fill(0))
      setArray(greenIncome, data.greenIncome || data.green_income || Array(12).fill(0))
      total_revenue.value = toNum(data.totalRevenue || data.total_revenue)
    } else {
      resetFormData()
    }
  } catch (err) {
    if (err.response?.status === 404) {
      resetFormData()
    } else {
      console.error('获取资金投入数据失败:', err)
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
  setArray(envInvest, Array(12).fill(0))
  setArray(cleanTechInvest, Array(12).fill(0))
  setArray(climateInvest, Array(12).fill(0))
  setArray(greenIncome, Array(12).fill(0))
  total_revenue.value = 0
}

// —— 提交编辑（保持原字段，不改动内容，只改样式） —— //
const submitEdit = async () => {
  try {
    const payload = {
      factory: factory.value,
      year: Number(year.value),
      envInvest: [...envInvest],
      cleanTechInvest: [...cleanTechInvest],
      climateInvest: [...climateInvest],
      greenIncome: [...greenIncome],
      totalInvestment: totalInvestment.value,
      totalRevenue: total_revenue.value,
      envInvestIntensity: envInvestIntensity.value,
      greenIncomeRatio: greenIncomeRatio.value
    }

    const resp = await apiClient.post('/quantitative/investment', payload)
    if (resp.data?.status === 'success') {
      alert('资金投入数据提交成功!')
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