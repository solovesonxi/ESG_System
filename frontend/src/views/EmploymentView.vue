```vue
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

      <!-- 员工雇佣数据部分（样式与能源统计保持一致） -->
      <fieldset class="summary-fieldset">
        <legend>员工雇佣数据统计</legend>

        <div class="loading" v-if="isLoading">数据加载中...</div>

        <div v-else>
          <!-- 员工雇佣统计 -->
          <fieldset>
            <legend>{{ year }}年员工雇佣统计</legend>
            <div class="form-row">
              <div class="form-group">
                <label>员工总数</label>
                <input type="number" :value="totalEmployees" disabled class="calculated-field">
              </div>
              <div class="form-group">
                <label>全职</label>
                <input type="number" v-model.number="formData.fullTime" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>兼职</label>
                <input type="number" v-model.number="formData.partTime" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>男</label>
                <input type="number" v-model.number="formData.male" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>女</label>
                <input type="number" v-model.number="formData.female" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>管理层</label>
                <input type="number" v-model.number="formData.management" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>管理层女</label>
                <input type="number" v-model.number="formData.managementFemale" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>中层</label>
                <input type="number" v-model.number="formData.middle" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>普通</label>
                <input type="number" v-model.number="formData.general" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>大陆</label>
                <input type="number" v-model.number="formData.mainland" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>海外</label>
                <input type="number" v-model.number="formData.overseas" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>博士及以上</label>
                <input type="number" v-model.number="formData.eduPhd" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>硕士</label>
                <input type="number" v-model.number="formData.eduMaster" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>本科</label>
                <input type="number" v-model.number="formData.eduBachelor" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>专科及以下</label>
                <input type="number" v-model.number="formData.eduJunior" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>人均五险一金 (万元)</label>
                <input type="number" v-model.number="formData.avgSocialFund" min="0" step="0.01"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>人均五险一金增加额 (万元)</label>
                <input type="number" v-model.number="formData.incSocialFund" min="0" step="0.01"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>18-30岁</label>
                <input type="number" v-model.number="formData.age18_30" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>31-45岁</label>
                <input type="number" v-model.number="formData.age31_45" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>46-60岁</label>
                <input type="number" v-model.number="formData.age46_60" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>新进员工</label>
                <input type="number" v-model.number="formData.newHires" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>离职总数</label>
                <input type="number" :value="quitTotal" disabled class="calculated-field">
              </div>
              <div class="form-group">
                <label>男离职</label>
                <input type="number" v-model.number="formData.quitMale" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>女离职</label>
                <input type="number" v-model.number="formData.quitFemale" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>大陆离职</label>
                <input type="number" v-model.number="formData.quitMainland" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>海外离职</label>
                <input type="number" v-model.number="formData.quitOverseas" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>18-30岁离职</label>
                <input type="number" v-model.number="formData.quit18_30" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>31-45岁离职</label>
                <input type="number" v-model.number="formData.quit31_45" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>46-60岁离职</label>
                <input type="number" v-model.number="formData.quit46_60" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>管理层离职</label>
                <input type="number" v-model.number="formData.quitManagement" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>中层离职</label>
                <input type="number" v-model.number="formData.quitMiddle" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>普通离职</label>
                <input type="number" v-model.number="formData.quitGeneral" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
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

// —— 员工雇佣数据 —— //
const formData = reactive({
  fullTime: 0,
  partTime: 0,
  male: 0,
  female: 0,
  management: 0,
  managementFemale: 0,
  middle: 0,
  general: 0,
  mainland: 0,
  overseas: 0,
  eduPhd: 0,
  eduMaster: 0,
  eduBachelor: 0,
  eduJunior: 0,
  avgSocialFund: 0,
  incSocialFund: 0,
  age18_30: 0,
  age31_45: 0,
  age46_60: 0,
  newHires: 0,
  quitMale: 0,
  quitFemale: 0,
  quitMainland: 0,
  quitOverseas: 0,
  quit18_30: 0,
  quit31_45: 0,
  quit46_60: 0,
  quitManagement: 0,
  quitMiddle: 0,
  quitGeneral: 0
})

// 汇总与强度计算（保持原逻辑与命名，默认保留两位小数行为）
const toNum = (v, d = 0) => {
  const n = Number(v)
  return Number.isFinite(n) ? n : d
}

const totalEmployees = computed(() => toNum(formData.fullTime) + toNum(formData.partTime))
const quitTotal = computed(() => toNum(formData.quitMale) + toNum(formData.quitFemale))

const calculateRate = (numerator, denominator) => {
  const num = toNum(numerator)
  const denom = toNum(denominator)
  return denom > 0 ? ((num / denom) * 100).toFixed(2) : 0
}

const turnoverRate = computed(() => calculateRate(quitTotal.value, totalEmployees.value))
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
    const resp = await apiClient.get('/quantitative/employment', {
      params: { factory: factory.value, year: year.value }
    })
    const data = resp?.data?.data
    if (data) {
      // 兼容后端下划线/驼峰
      formData.fullTime = toNum(data.fullTime || data.full_time)
      formData.partTime = toNum(data.partTime || data.part_time)
      formData.male = toNum(data.male)
      formData.female = toNum(data.female)
      formData.management = toNum(data.management)
      formData.managementFemale = toNum(data.managementFemale || data.management_female)
      formData.middle = toNum(data.middle)
      formData.general = toNum(data.general)
      formData.mainland = toNum(data.mainland)
      formData.overseas = toNum(data.overseas)
      formData.eduPhd = toNum(data.eduPhd || data.edu_phd)
      formData.eduMaster = toNum(data.eduMaster || data.edu_master)
      formData.eduBachelor = toNum(data.eduBachelor || data.edu_bachelor)
      formData.eduJunior = toNum(data.eduJunior || data.edu_junior)
      formData.avgSocialFund = toNum(data.avgSocialFund || data.avg_social_fund)
      formData.incSocialFund = toNum(data.incSocialFund || data.inc_social_fund)
      formData.age18_30 = toNum(data.age18_30 || data.age18_30)
      formData.age31_45 = toNum(data.age31_45 || data.age31_45)
      formData.age46_60 = toNum(data.age46_60 || data.age46_60)
      formData.newHires = toNum(data.newHires || data.new_hires)
      formData.quitMale = toNum(data.quitMale || data.quit_male)
      formData.quitFemale = toNum(data.quitFemale || data.quit_female)
      formData.quitMainland = toNum(data.quitMainland || data.quit_mainland)
      formData.quitOverseas = toNum(data.quitOverseas || data.quit_overseas)
      formData.quit18_30 = toNum(data.quit18_30 || data.quit_18_30)
      formData.quit31_45 = toNum(data.quit31_45 || data.quit_31_45)
      formData.quit46_60 = toNum(data.quit46_60 || data.quit_46_60)
      formData.quitManagement = toNum(data.quitManagement || data.quit_management)
      formData.quitMiddle = toNum(data.quitMiddle || data.quit_middle)
      formData.quitGeneral = toNum(data.quitGeneral || data.quit_general)
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
  formData.fullTime = 0
  formData.partTime = 0
  formData.male = 0
  formData.female = 0
  formData.management = 0
  formData.managementFemale = 0
  formData.middle = 0
  formData.general = 0
  formData.mainland = 0
  formData.overseas = 0
  formData.eduPhd = 0
  formData.eduMaster = 0
  formData.eduBachelor = 0
  formData.eduJunior = 0
  formData.avgSocialFund = 0
  formData.incSocialFund = 0
  formData.age18_30 = 0
  formData.age31_45 = 0
  formData.age46_60 = 0
  formData.newHires = 0
  formData.quitMale = 0
  formData.quitFemale = 0
  formData.quitMainland = 0
  formData.quitOverseas = 0
  formData.quit18_30 = 0
  formData.quit31_45 = 0
  formData.quit46_60 = 0
  formData.quitManagement = 0
  formData.quitMiddle = 0
  formData.quitGeneral = 0
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