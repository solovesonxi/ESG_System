<template>
  <div class="shared-form">
    <form>
      <BaseInfoSelector :review="review" form-type="ohs" @selection-changed="fetchData"/>
      <fieldset class="summary-fieldset">
        <legend>{{ year }}年{{ month }}月职业健康安全数据统计</legend>
        <div class="loading" v-if="isLoading">数据加载中...</div>
        <div v-else>
          <div class="form-row">
            <div class="form-group">
              <label>培训次数 (次)</label>
              <input type="number" v-model.number="formData.trainingCount[month - 1]" min="0" step="1"
                     :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
            </div>
            <div class="form-group">
              <label>培训参与人次 (人次)</label>
              <input type="number"
                     v-model.number="formData.trainingParticipants[month - 1]" min="0" step="1" :readonly="!isEditing"
                     :class="{ 'editable-field': isEditing }" required>
            </div>
            <div class="form-group">
              <label>培训学时 (小时)</label>
              <input type="number" v-model.number="formData.trainingHours[month - 1]" min="0" step="0.1"
                     :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
            </div>
            <div class="form-group">
              <label>工伤数量 (次)</label>
              <input type="number" v-model.number="formData.injuryCount[month-1]" min="0" step="1"
                     :readonly="!isEditing"
                     :class="{ 'editable-field': isEditing }" required>
            </div>
            <div class="form-group">
              <label>安全事故数量 (次)</label>
              <input type="number" v-model.number="formData.incidentCount[month-1]" min="0" step="1"
                     :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
            </div>
            <div class="form-group">
              <label>工亡人数 (人)</label>
              <input type="number" v-model.number="formData.fatalityCount[month-1]" min="0" step="1"
                     :readonly="!isEditing"
                     :class="{ 'editable-field': isEditing }" required>
            </div>
            <div class="form-group">
              <label>工伤损失工作日数 (天)</label>
              <input type="number" v-model.number="formData.lostWorkdays[month-1]" min="0" step="1"
                     :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
            </div>
            <div class="form-group">
              <label>安全生产投入 (万元)</label>
              <input type="number" v-model.number="formData.safetyInvestment[month-1]" min="0" step="0.01"
                     :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
            </div>
            <div class="form-group">
              <label>专职安全管理人员 (人)</label>
              <input type="number" v-model.number="formData.safetyManagers" min="0" step="1"
                     :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
            </div>
            <div class="form-group">
              <label>员工体检人数 (人)</label>
              <input type="number" v-model.number="formData.medicalChecks" min="0" step="1"
                     :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
            </div>
            <div class="form-group">
              <label>员工体检覆盖率 (%)</label>
              <input type="number" v-model.number="formData.coverageRate" min="0" step="0.01"
                     :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
            </div>
            <div class="form-group">
              <label>安全应急演练次数 (次)</label>
              <input type="number" v-model.number="formData.emergencyDrills" min="0" step="1"
                     :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
            </div>
            <div class="form-group">
              <label>安全检查排查隐患数 (个)</label>
              <input type="number" v-model.number="formData.hazardsFound" min="0" step="1"
                     :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
            </div>
            <div class="form-group">
              <label>职业病体检人数 (人)</label>
              <input type="number" v-model.number="formData.occupationalChecks" min="0" step="1"
                     :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
            </div>
          </div>
        </div>
      </fieldset>
      <!-- 汇总（与能源统计合计区块相同结构：form-row + form-group + disabled 计算值） -->
      <fieldset class="summary-fieldset">
        <legend>{{ year }}年职业健康安全统计 - 汇总</legend>
        <div class="form-row">
          <div class="form-group">
            <label>培训次数合计 (次)</label>
            <input type="number" :value="trainingCountTotal" disabled class="calculated-field">
          </div>
          <div class="form-group">
            <label>培训参与人次合计 (人次)</label>
            <input type="number" :value="trainingParticipantsTotal" disabled class="calculated-field">
          </div>
          <div class="form-group">
            <label>培训学时合计 (小时)</label>
            <input type="number" :value="trainingHoursTotal" disabled class="calculated-field">
          </div>
          <div class="form-group">
            <label>工伤数量合计 (次)</label>
            <input type="number" :value="injuryCountTotal" disabled class="calculated-field">
          </div>
          <div class="form-group">
            <label>安全事故数量合计 (次)</label>
            <input type="number" :value="incidentCountTotal" disabled class="calculated-field">
          </div>
          <div class="form-group">
            <label>工亡人数合计 (人)</label>
            <input type="number" :value="fatalityCountTotal" disabled class="calculated-field">
          </div>
          <div class="form-group">
            <label>工伤损失工作日数合计 (天)</label>
            <input type="number" :value="lostWorkdaysTotal" disabled class="calculated-field">
          </div>
          <div class="form-group">
            <label>安全生产投入合计 (万元)</label>
            <input type="number" :value="safetyInvestmentTotal" disabled class="calculated-field">
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

// —— 职业健康安全数据 —— //
const formData = reactive({
  trainingCount: Array(12).fill(0),
  trainingParticipants: Array(12).fill(0),
  trainingHours: Array(12).fill(0),
  injuryCount: Array(12).fill(0),
  incidentCount: Array(12).fill(0),
  fatalityCount: Array(12).fill(0),
  lostWorkdays: Array(12).fill(0),
  safetyInvestment: Array(12).fill(0),
  safetyManagers: 0,
  medicalChecks: 0,
  coverageRate: 0,
  emergencyDrills: 0,
  hazardsFound: 0,
  occupationalChecks: 0
})

// —— 汇总与计算（保持原逻辑与命名，默认保留两位小数行为） —— //
const toNum = (v, d = 0) => {
  const n = Number(v)
  return Number.isFinite(n) ? n : d
}

const rowSum = (arr) => arr.reduce((s, v) => s + (Number(v) || 0), 0).toFixed(2)

const trainingCountTotal = computed(() => rowSum(formData.trainingCount))
const trainingParticipantsTotal = computed(() => rowSum(formData.trainingParticipants))
const trainingHoursTotal = computed(() => rowSum(formData.trainingHours))
const injuryCountTotal = computed(() => rowSum(formData.injuryCount))
const incidentCountTotal = computed(() => rowSum(formData.incidentCount))
const fatalityCountTotal = computed(() => rowSum(formData.fatalityCount))
const lostWorkdaysTotal = computed(() => rowSum(formData.lostWorkdays))
const safetyInvestmentTotal = computed(() => rowSum(formData.safetyInvestment))

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
    const response = await apiClient.get('/quantitative/ohs', {
      params: {factory: factory.value, year: year.value}
    })
    const data = response?.data?.data
    if (data) {
      // 兼容后端下划线/驼峰
      setArray(formData.trainingCount, data.trainingCount || data.training_count || Array(12).fill(0))
      setArray(formData.trainingParticipants, data.trainingParticipants || data.training_participants || Array(12).fill(0))
      setArray(formData.trainingHours, data.trainingHours || data.training_hours || Array(12).fill(0))
      setArray(formData.injuryCount, data.injuryCount || data.injury_count || Array(12).fill(0))
      setArray(formData.incidentCount, data.incidentCount || data.incident_count || Array(12).fill(0))
      setArray(formData.fatalityCount, data.fatalityCount || data.fatality_count || Array(12).fill(0))
      setArray(formData.lostWorkdays, data.lostWorkdays || data.lost_workdays || Array(12).fill(0))
      setArray(formData.safetyInvestment, data.safetyInvestment || data.safety_investment || Array(12).fill(0))
      formData.safetyManagers = toNum(data.safetyManagers || data.safety_managers)
      formData.medicalChecks = toNum(data.medicalChecks || data.medical_checks)
      formData.coverageRate = toNum(data.coverageRate || data.coverage_rate)
      formData.emergencyDrills = toNum(data.emergencyDrills || data.emergency_drills)
      formData.hazardsFound = toNum(data.hazardsFound || data.hazards_found)
      formData.occupationalChecks = toNum(data.occupationalChecks || data.occupational_checks)
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

const setArray = (reactiveArr, sourceArr) => {
  for (let i = 0; i < 12; i++) reactiveArr[i] = toNum(sourceArr?.[i] ?? 0)
}

// —— 重置（与能源一致的重置思路） —— //
const resetFormData = () => {
  setArray(formData.trainingCount, Array(12).fill(0))
  setArray(formData.trainingParticipants, Array(12).fill(0))
  setArray(formData.trainingHours, Array(12).fill(0))
  setArray(formData.injuryCount, Array(12).fill(0))
  setArray(formData.incidentCount, Array(12).fill(0))
  setArray(formData.fatalityCount, Array(12).fill(0))
  setArray(formData.lostWorkdays, Array(12).fill(0))
  setArray(formData.safetyInvestment, Array(12).fill(0))
  formData.safetyManagers = 0
  formData.medicalChecks = 0
  formData.coverageRate = 0
  formData.emergencyDrills = 0
  formData.hazardsFound = 0
  formData.occupationalChecks = 0
  review.value = {
    id: Array(12).fill(-1), is_submitted: Array(12).fill(false), status1: Array(12).fill("pending"), comment1: Array(12).fill(''),
    status2: Array(12).fill("pending"), comment22: Array(12).fill('')
  };
}


const submitEdit = async (ifSubmit) => {
  try {
    const payload = {
      factory: factory.value,
      year: Number(year.value),
      month: month.value,
      trainingCount: [...formData.trainingCount],
      trainingParticipants: [...formData.trainingParticipants],
      trainingHours: [...formData.trainingHours],
      injuryCount: [...formData.injuryCount],
      incidentCount: [...formData.incidentCount],
      fatalityCount: [...formData.fatalityCount],
      lostWorkdays: [...formData.lostWorkdays],
      safetyInvestment: [...formData.safetyInvestment],
      safetyManagers: formData.safetyManagers,
      medicalChecks: formData.medicalChecks,
      coverageRate: formData.coverageRate,
      emergencyDrills: formData.emergencyDrills,
      hazardsFound: formData.hazardsFound,
      occupationalChecks: formData.occupationalChecks,
      trainingCountTotal: trainingCountTotal.value,
      trainingParticipantsTotal: trainingParticipantsTotal.value,
      trainingHoursTotal: trainingHoursTotal.value,
      injuryCountTotal: injuryCountTotal.value,
      incidentCountTotal: incidentCountTotal.value,
      fatalityCountTotal: fatalityCountTotal.value,
      lostWorkdaysTotal: lostWorkdaysTotal.value,
      safetyInvestmentTotal: safetyInvestmentTotal.value,
      isSubmitted: ifSubmit
    }
    const response = await apiClient.post('/quantitative/ohs', payload)
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
```