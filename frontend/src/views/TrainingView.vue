<template>
  <div class="shared-form">
    <form>
      <BaseInfoSelector @selection-changed="fetchData"/>
      <fieldset class="summary-fieldset">
        <legend>{{ year }}年{{ month }}月教育与培训数据统计</legend>
        <div class="loading" v-if="isLoading">数据加载中...</div>
        <div v-else>
          <div class="form-row">
            <div class="form-group">
              <label>总人数 (人)</label>
              <input type="number" v-model.number="formData.total" min="0" step="1"
                     :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
            </div>
            <div class="form-group">
              <label>受训人数 (人次)</label>
              <input type="number" v-model.number="formData.trained" min="0" step="1"
                     :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
            </div>
            <div class="form-group">
              <label>男性 (人次)</label>
              <input type="number" v-model.number="formData.male" min="0" step="1"
                     :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
            </div>
            <div class="form-group">
              <label>女性 (人次)</label>
              <input type="number" v-model.number="formData.female" min="0" step="1"
                     :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
            </div>
            <div class="form-group">
              <label>管理层受训 (人次)</label>
              <input type="number" v-model.number="formData.mgmt" min="0" step="1"
                     :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
            </div>
            <div class="form-group">
              <label>中层受训 (人次)</label>
              <input type="number" v-model.number="formData.middle" min="0" step="1"
                     :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
            </div>
            <div class="form-group">
              <label>普通受训 (人次)</label>
              <input type="number" v-model.number="formData.general" min="0" step="1"
                     :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
            </div>
            <div class="form-group">
              <label>培训总学时 (小时)</label>
              <input type="number" v-model.number="formData.hoursTotal" min="0" step="0.1"
                     :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
            </div>
            <div class="form-group">
              <label>男性学时 (小时)</label>
              <input type="number" v-model.number="formData.hoursMale" min="0" step="0.1"
                     :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
            </div>
            <div class="form-group">
              <label>女性学时 (小时)</label>
              <input type="number" v-model.number="formData.hoursFemale" min="0" step="0.1"
                     :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
            </div>
            <div class="form-group">
              <label>管理层学时 (小时)</label>
              <input type="number" v-model.number="formData.hoursMgmt" min="0" step="0.1"
                     :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
            </div>
            <div class="form-group">
              <label>中层学时 (小时)</label>
              <input type="number" v-model.number="formData.hoursMiddle" min="0" step="0.1"
                     :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
            </div>
            <div class="form-group">
              <label>普通学时 (小时)</label>
              <input type="number" v-model.number="formData.hoursGeneral" min="0" step="0.1"
                     :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
            </div>
          </div>
        </div>
      </fieldset>
      <fieldset class="summary-fieldset">
        <legend>{{ year }}年教育与培训统计 - 汇总</legend>
        <div class="loading" v-if="isLoading">数据加载中...</div>
        <div v-else>
          <div class="form-row">

            <div class="form-group">
              <label>培训覆盖率 (%)</label>
              <input type="number" :value="coverageRate" disabled class="calculated-field">
            </div>
            <div class="form-group">
              <label>男性占比 (%)</label>
              <input type="number" :value="maleRate" disabled class="calculated-field">
            </div>
            <div class="form-group">
              <label>女性占比 (%)</label>
              <input type="number" :value="femaleRate" disabled class="calculated-field">
            </div>
            <div class="form-group">
              <label>管理层占比 (%)</label>
              <input type="number" :value="mgmtRate" disabled class="calculated-field">
            </div>
            <div class="form-group">
              <label>中层占比 (%)</label>
              <input type="number" :value="middleRate" disabled class="calculated-field">
            </div>
            <div class="form-group">
              <label>普通占比 (%)</label>
              <input type="number" :value="generalRate" disabled class="calculated-field">
            </div>
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

// —— 与能源统计保持一致的状态 —— //
const selectionStore = useSelectionStore()
const factory = computed(() => selectionStore.selectedFactory)
const year = computed(() => selectionStore.selectedYear);
const month = computed(() => selectionStore.selectedMonth);

const isEditing = ref(false)
const isLoading = ref(false)

// —— 教育与培训数据 —— //
const formData = reactive({
  total: 0,
  trained: 0,
  male: 0,
  female: 0,
  mgmt: 0,
  middle: 0,
  general: 0,
  hoursTotal: 0,
  hoursMale: 0,
  hoursFemale: 0,
  hoursMgmt: 0,
  hoursMiddle: 0,
  hoursGeneral: 0
})

// —— 计算属性（保持原逻辑与命名，默认保留两位小数行为） —— //
const toNum = (v, d = 0) => {
  const n = Number(v)
  return Number.isFinite(n) ? n : d
}

const calculateRate = (numerator, denominator) => {
  const num = toNum(numerator)
  const denom = toNum(denominator)
  return denom > 0 ? ((num / denom) * 100).toFixed(2) : 0
}

const coverageRate = computed(() => calculateRate(formData.trained, formData.total))
const maleRate = computed(() => calculateRate(formData.male, formData.trained))
const femaleRate = computed(() => calculateRate(formData.female, formData.trained))
const mgmtRate = computed(() => calculateRate(formData.mgmt, formData.trained))
const middleRate = computed(() => calculateRate(formData.middle, formData.trained))
const generalRate = computed(() => calculateRate(formData.general, formData.trained))

// —— 与能源统计保持一致：监听工厂/年份变化并拉取数据 —— //


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
    const resp = await apiClient.get('/quantitative/training', {
      params: {factory: factory.value, year: year.value}
    })
    const data = resp?.data?.data
    if (data) {
      // 兼容后端下划线/驼峰
      formData.total = toNum(data.total)
      formData.trained = toNum(data.trained)
      formData.male = toNum(data.male)
      formData.female = toNum(data.female)
      formData.mgmt = toNum(data.mgmt || data.management)
      formData.middle = toNum(data.middle)
      formData.general = toNum(data.general)
      formData.hoursTotal = toNum(data.hoursTotal || data.hours_total)
      formData.hoursMale = toNum(data.hoursMale || data.hours_male)
      formData.hoursFemale = toNum(data.hoursFemale || data.hours_female)
      formData.hoursMgmt = toNum(data.hoursMgmt || data.hours_management)
      formData.hoursMiddle = toNum(data.hoursMiddle || data.hours_middle)
      formData.hoursGeneral = toNum(data.hoursGeneral || data.hours_general)
    } else {
      resetFormData()
    }
  } catch (err) {
    if (err.response?.status === 404) {
      resetFormData()
    } else {
      console.error('获取教育与培训数据失败:', err)
      resetFormData()
    }
  } finally {
    isLoading.value = false
  }
}

// —— 重置（与能源一致的重置思路） —— //
const resetFormData = () => {
  formData.total = 0
  formData.trained = 0
  formData.male = 0
  formData.female = 0
  formData.mgmt = 0
  formData.middle = 0
  formData.general = 0
  formData.hoursTotal = 0
  formData.hoursMale = 0
  formData.hoursFemale = 0
  formData.hoursMgmt = 0
  formData.hoursMiddle = 0
  formData.hoursGeneral = 0
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
      total: formData.total,
      trained: formData.trained,
      male: formData.male,
      female: formData.female,
      mgmt: formData.mgmt,
      middle: formData.middle,
      general: formData.general,
      hoursTotal: formData.hoursTotal,
      hoursMale: formData.hoursMale,
      hoursFemale: formData.hoursFemale,
      hoursMgmt: formData.hoursMgmt,
      hoursMiddle: formData.hoursMiddle,
      hoursGeneral: formData.hoursGeneral,
      coverageRate: coverageRate.value,
      maleRate: maleRate.value,
      femaleRate: femaleRate.value,
      mgmtRate: mgmtRate.value,
      middleRate: middleRate.value,
      generalRate: generalRate.value
    }

    const resp = await apiClient.post('/quantitative/training', payload)
    if (resp.data?.status === 'success') {
      alert('教育与培训数据提交成功!')
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