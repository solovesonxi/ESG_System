<template>
  <div class="shared-form">
    <form>
      <BaseInfoSelector @selection-changed="fetchData"/>
      <fieldset class="summary-fieldset">
        <legend>{{ year }}年{{month}}月员工雇佣统计</legend>
        <div class="loading" v-if="isLoading">数据加载中...</div>
        <div v-else>
            <div class="form-row">
              <div class="form-group">
                <label>全职</label>
                <input type="number" v-model.number="formData.fullTime[month - 1]" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>兼职</label>
                <input type="number" v-model.number="formData.partTime[month - 1]" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>男</label>
                <input type="number" v-model.number="formData.male[month - 1]" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>女</label>
                <input type="number" v-model.number="formData.female[month - 1]" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>管理层</label>
                <input type="number" v-model.number="formData.management[month - 1]" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>管理层女</label>
                <input type="number" v-model.number="formData.managementFemale[month - 1]" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>中层</label>
                <input type="number" v-model.number="formData.middle[month - 1]" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>普通</label>
                <input type="number" v-model.number="formData.general[month - 1]" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>大陆</label>
                <input type="number" v-model.number="formData.mainland[month - 1]" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>海外</label>
                <input type="number" v-model.number="formData.overseas[month - 1]" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>博士及以上</label>
                <input type="number" v-model.number="formData.eduPhd[month - 1]" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>硕士</label>
                <input type="number" v-model.number="formData.eduMaster[month - 1]" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>本科</label>
                <input type="number" v-model.number="formData.eduBachelor[month - 1]" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>专科及以下</label>
                <input type="number" v-model.number="formData.eduJunior[month - 1]" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>人均五险一金 (万元)</label>
                <input type="number" v-model.number="formData.avgSocialFund[month - 1]" min="0" step="0.01"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>人均五险一金增加额 (万元)</label>
                <input type="number" v-model.number="formData.incSocialFund[month - 1]" min="0" step="0.01"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>18-30岁</label>
                <input type="number" v-model.number="formData.age18_30[month - 1]" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>31-45岁</label>
                <input type="number" v-model.number="formData.age31_45[month - 1]" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>46-60岁</label>
                <input type="number" v-model.number="formData.age46_60[month - 1]" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>新进员工</label>
                <input type="number" v-model.number="formData.newHires[month - 1]" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>男离职</label>
                <input type="number" v-model.number="formData.quitMale[month - 1]" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>女离职</label>
                <input type="number" v-model.number="formData.quitFemale[month - 1]" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>大陆离职</label>
                <input type="number" v-model.number="formData.quitMainland[month - 1]" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>海外离职</label>
                <input type="number" v-model.number="formData.quitOverseas[month - 1]" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>18-30岁离职</label>
                <input type="number" v-model.number="formData.quit18_30[month - 1]" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>31-45岁离职</label>
                <input type="number" v-model.number="formData.quit31_45[month - 1]" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>46-60岁离职</label>
                <input type="number" v-model.number="formData.quit46_60[month - 1]" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>管理层离职</label>
                <input type="number" v-model.number="formData.quitManagement[month - 1]" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>中层离职</label>
                <input type="number" v-model.number="formData.quitMiddle[month - 1]" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>普通离职</label>
                <input type="number" v-model.number="formData.quitGeneral[month - 1]" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
            </div>
        </div>
      </fieldset>
      <fieldset class="summary-fieldset">
        <legend>{{ year }}年雇佣统计 - 汇总</legend>
        <div class="form-row">
          <div class="form-group">
            <label>员工总数</label>
            <input type="number" :value="totalEmployees" disabled class="calculated-field">
          </div>
          <div class="form-group">
            <label>离职总数</label>
            <input type="number" :value="quitTotal" disabled class="calculated-field">
          </div>
          <div class="form-group">
            <label>总流失率 (%)</label>
            <input type="number" :value="turnoverRate" disabled class="calculated-field">
          </div>
          <div class="form-group">
            <label>男流失率 (%)</label>
            <input type="number" :value="maleTurnoverRate" disabled class="calculated-field">
          </div>
          <div class="form-group">
            <label>女流失率 (%)</label>
            <input type="number" :value="femaleTurnoverRate" disabled class="calculated-field">
          </div>
          <div class="form-group">
            <label>大陆流失率 (%)</label>
            <input type="number" :value="mainlandTurnoverRate" disabled class="calculated-field">
          </div>
          <div class="form-group">
            <label>海外流失率 (%)</label>
            <input type="number" :value="overseasTurnoverRate" disabled class="calculated-field">
          </div>
          <div class="form-group">
            <label>18-30岁流失率 (%)</label>
            <input type="number" :value="age18_30TurnoverRate" disabled class="calculated-field">
          </div>
          <div class="form-group">
            <label>31-45岁流失率 (%)</label>
            <input type="number" :value="age31_45TurnoverRate" disabled class="calculated-field">
          </div>
          <div class="form-group">
            <label>46-60岁流失率 (%)</label>
            <input type="number" :value="age46_60TurnoverRate" disabled class="calculated-field">
          </div>
          <div class="form-group">
            <label>管理层流失率 (%)</label>
            <input type="number" :value="managementTurnoverRate" disabled class="calculated-field">
          </div>
          <div class="form-group">
            <label>中层流失率 (%)</label>
            <input type="number" :value="middleTurnoverRate" disabled class="calculated-field">
          </div>
          <div class="form-group">
            <label>普通流失率 (%)</label>
            <input type="number" :value="generalTurnoverRate" disabled class="calculated-field">
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
import BaseInfoSelector from "@/components/BaseInfoSelector.vue";

// —— 与能源统计保持一致的状态 —— //
const selectionStore = useSelectionStore()
const factory = computed(() => selectionStore.selectedFactory)
const year = computed(() => selectionStore.selectedYear);
const month = computed(() => selectionStore.selectedMonth);

const isEditing = ref(false)
const isLoading = ref(false)

// —— 员工雇佣数据 —— //
const formData = reactive({
  fullTime: Array(12).fill(0),
  partTime: Array(12).fill(0),
  male: Array(12).fill(0),
  female: Array(12).fill(0),
  management: Array(12).fill(0),
  managementFemale: Array(12).fill(0),
  middle: Array(12).fill(0),
  general: Array(12).fill(0),
  mainland: Array(12).fill(0),
  overseas: Array(12).fill(0),
  eduPhd: Array(12).fill(0),
  eduMaster: Array(12).fill(0),
  eduBachelor: Array(12).fill(0),
  eduJunior: Array(12).fill(0),
  avgSocialFund: Array(12).fill(0),
  incSocialFund: Array(12).fill(0),
  age18_30: Array(12).fill(0),
  age31_45: Array(12).fill(0),
  age46_60: Array(12).fill(0),
  newHires: Array(12).fill(0),
  quitMale: Array(12).fill(0),
  quitFemale: Array(12).fill(0),
  quitMainland: Array(12).fill(0),
  quitOverseas: Array(12).fill(0),
  quit18_30: Array(12).fill(0),
  quit31_45: Array(12).fill(0),
  quit46_60: Array(12).fill(0),
  quitManagement: Array(12).fill(0),
  quitMiddle: Array(12).fill(0),
  quitGeneral: Array(12).fill(0)
})


const totalEmployees = computed(() => {
  let sum = 0
  for (let i = 0; i < 12; i++) {
    const monthTotal = formData.fullTime[i] + formData.partTime[i]
    if (monthTotal > 0) {
      sum = monthTotal
    }
  }
  return sum
})

const quitTotal = computed(() => {
  let yearTotal = 0
  for (let i = 0; i < 12; i++) {
    yearTotal += formData.quitMale[i] + formData.quitFemale[i]
  }
  return yearTotal
})

const calculateRate = (numerator, denominator) => {
  const num = numerator
  const denom = denominator
  return denom > 0 ? ((num / denom) * 100).toFixed(2) : 0
}

const turnoverRate = computed(() => calculateRate(quitTotal.value, totalEmployees.value + quitTotal.value))
const maleTurnoverRate = computed(() => calculateRate(formData.quitMale, formData.male))
const femaleTurnoverRate = computed(() => calculateRate(formData.quitFemale, formData.female))
const mainlandTurnoverRate = computed(() => calculateRate(formData.quitMainland, formData.mainland))
const overseasTurnoverRate = computed(() => calculateRate(formData.quitOverseas, formData.overseas))
const age18_30TurnoverRate = computed(() => calculateRate(formData.quit18_30, formData.age18_30))
const age31_45TurnoverRate = computed(() => calculateRate(formData.quit31_45, formData.age31_45))
const age46_60TurnoverRate = computed(() => calculateRate(formData.quit46_60, formData.age46_60))
const managementTurnoverRate = computed(() => calculateRate(formData.quitManagement, formData.management))
const middleTurnoverRate = computed(() => calculateRate(formData.quitMiddle, formData.middle))
const generalTurnoverRate = computed(() => calculateRate(formData.quitGeneral, formData.general))

onMounted(() => {
  document.addEventListener('click', selectionStore.handleClickOutside)
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
    const resp = await apiClient.get('/quantitative/employment', {
      params: {factory: factory.value, year: year.value}
    })
    const data = resp?.data?.data
    if (data) {
      // 处理数组数据，统一驼峰命名，默认值为12个月的0值数组
      formData.fullTime = data.fullTime || Array(12).fill(0)
      formData.partTime = data.partTime || Array(12).fill(0)
      formData.male = data.male || Array(12).fill(0)
      formData.female = data.female || Array(12).fill(0)
      formData.management = data.management || Array(12).fill(0)
      formData.managementFemale = data.managementFemale || Array(12).fill(0)
      formData.middle = data.middle || Array(12).fill(0)
      formData.general = data.general || Array(12).fill(0)
      formData.mainland = data.mainland || Array(12).fill(0)
      formData.overseas = data.overseas || Array(12).fill(0)
      formData.eduPhd = data.eduPhd || Array(12).fill(0)
      formData.eduMaster = data.eduMaster || Array(12).fill(0)
      formData.eduBachelor = data.eduBachelor || Array(12).fill(0)
      formData.eduJunior = data.eduJunior || Array(12).fill(0)
      formData.avgSocialFund = data.avgSocialFund || Array(12).fill(0)
      formData.incSocialFund = data.incSocialFund || Array(12).fill(0)
      formData.age18_30 = data.age18_30 || Array(12).fill(0)
      formData.age31_45 = data.age31_45 || Array(12).fill(0)
      formData.age46_60 = data.age46_60 || Array(12).fill(0)
      formData.newHires = data.newHires || Array(12).fill(0)
      formData.quitMale = data.quitMale || Array(12).fill(0)
      formData.quitFemale = data.quitFemale || Array(12).fill(0)
      formData.quitMainland = data.quitMainland || Array(12).fill(0)
      formData.quitOverseas = data.quitOverseas || Array(12).fill(0)
      formData.quit18_30 = data.quit18_30 || Array(12).fill(0)
      formData.quit31_45 = data.quit31_45 || Array(12).fill(0)
      formData.quit46_60 = data.quit46_60 || Array(12).fill(0)
      formData.quitManagement = data.quitManagement || Array(12).fill(0)
      formData.quitMiddle = data.quitMiddle || Array(12).fill(0)
      formData.quitGeneral = data.quitGeneral || Array(12).fill(0)

      console.log("原始数据:", data)
      console.log('获取员工雇佣数据成功:', formData)
    } else {
      resetFormData()
    }
  } catch (err) {
    if (err.response?.status === 404) {
      resetFormData()
    } else {
      console.error('获取员工雇佣数据失败:', err)
      resetFormData()
    }
  } finally {
    isLoading.value = false
  }
}

// —— 重置（与能源一致的重置思路） —— //
const resetFormData = () => {
  formData.fullTime = Array(12).fill(0)
  formData.partTime = Array(12).fill(0)
  formData.male = Array(12).fill(0)
  formData.female = Array(12).fill(0)
  formData.management = Array(12).fill(0)
  formData.managementFemale = Array(12).fill(0)
  formData.middle = Array(12).fill(0)
  formData.general = Array(12).fill(0)
  formData.mainland = Array(12).fill(0)
  formData.overseas = Array(12).fill(0)
  formData.eduPhd = Array(12).fill(0)
  formData.eduMaster = Array(12).fill(0)
  formData.eduBachelor = Array(12).fill(0)
  formData.eduJunior = Array(12).fill(0)
  formData.avgSocialFund = Array(12).fill(0)
  formData.incSocialFund = Array(12).fill(0)
  formData.age18_30 = Array(12).fill(0)
  formData.age31_45 = Array(12).fill(0)
  formData.age46_60 = Array(12).fill(0)
  formData.newHires = Array(12).fill(0)
  formData.quitMale = Array(12).fill(0)
  formData.quitFemale = Array(12).fill(0)
  formData.quitMainland = Array(12).fill(0)
  formData.quitOverseas = Array(12).fill(0)
  formData.quit18_30 = Array(12).fill(0)
  formData.quit31_45 = Array(12).fill(0)
  formData.quit46_60 = Array(12).fill(0)
  formData.quitManagement = Array(12).fill(0)
  formData.quitMiddle = Array(12).fill(0)
  formData.quitGeneral = Array(12).fill(0)
}

// —— 提交编辑（保持原字段，不改动内容，只改样式） —— //
const submitEdit = async () => {
  if (!factory.value) {
    alert('请选择工厂名称')
    return
  }
  try {
    const payload = {
      factory: factory.value,
      year: Number(year.value),
      fullTime: formData.fullTime,
      partTime: formData.partTime,
      male: formData.male,
      female: formData.female,
      management: formData.management,
      managementFemale: formData.managementFemale,
      middle: formData.middle,
      general: formData.general,
      mainland: formData.mainland,
      overseas: formData.overseas,
      eduPhd: formData.eduPhd,
      eduMaster: formData.eduMaster,
      eduBachelor: formData.eduBachelor,
      eduJunior: formData.eduJunior,
      avgSocialFund: formData.avgSocialFund,
      incSocialFund: formData.incSocialFund,
      age18_30: formData.age18_30,
      age31_45: formData.age31_45,
      age46_60: formData.age46_60,
      newHires: formData.newHires,
      quitMale: formData.quitMale,
      quitFemale: formData.quitFemale,
      quitMainland: formData.quitMainland,
      quitOverseas: formData.quitOverseas,
      quit18_30: formData.quit18_30,
      quit31_45: formData.quit31_45,
      quit46_60: formData.quit46_60,
      quitManagement: formData.quitManagement,
      quitMiddle: formData.quitMiddle,
      quitGeneral: formData.quitGeneral,
      totalEmployees: totalEmployees.value,
      quitTotal: quitTotal.value,
      turnoverRate: turnoverRate.value,
      maleTurnoverRate: maleTurnoverRate.value,
      femaleTurnoverRate: femaleTurnoverRate.value,
      mainlandTurnoverRate: mainlandTurnoverRate.value,
      overseasTurnoverRate: overseasTurnoverRate.value,
      age18_30TurnoverRate: age18_30TurnoverRate.value,
      age31_45TurnoverRate: age31_45TurnoverRate.value,
      age46_60TurnoverRate: age46_60TurnoverRate.value,
      managementTurnoverRate: managementTurnoverRate.value,
      middleTurnoverRate: middleTurnoverRate.value,
      generalTurnoverRate: generalTurnoverRate.value
    }

    const resp = await apiClient.post('/quantitative/employment', payload)
    if (resp.data?.status === 'success') {
      alert('员工雇佣数据提交成功!')
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
```