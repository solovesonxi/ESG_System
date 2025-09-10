```vue
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

      <!-- 社区参与数据部分（样式与能源统计保持一致） -->
      <fieldset class="summary-fieldset">
        <legend>社区参与数据统计</legend>

        <div class="loading" v-if="isLoading">数据加载中...</div>

        <div v-else>
          <!-- 慈善捐款 -->
          <fieldset>
            <legend>{{ year }}年社区参与统计 - 慈善捐款 (元)</legend>
            <div class="monthly-grid">
              <div v-for="(_, index) in formData.charityDonations" :key="'cd-'+index" class="month-input">
                <label>{{ getMonthName(index) }}</label>
                <input
                  type="number"
                  v-model.number="formData.charityDonations[index]"
                  :placeholder="`${getMonthName(index)}慈善捐款`"
                  min="0"
                  step="1"
                  :readonly="!isEditing"
                  :class="{ 'editable-field': isEditing }"
                  required
                >
              </div>
              <div class="month-input">
                <label>合计</label>
                <input type="number" :value="charityDonationsTotal" disabled class="calculated-field">
              </div>
            </div>
          </fieldset>

          <!-- 社区发展投入 -->
          <fieldset>
            <legend>{{ year }}年社区参与统计 - 社区发展投入 (元)</legend>
            <div class="monthly-grid">
              <div v-for="(_, index) in formData.communityInvestment" :key="'ci-'+index" class="month-input">
                <label>{{ getMonthName(index) }}</label>
                <input
                  type="number"
                  v-model.number="formData.communityInvestment[index]"
                  :placeholder="`${getMonthName(index)}社区发展投入`"
                  min="0"
                  step="1"
                  :readonly="!isEditing"
                  :class="{ 'editable-field': isEditing }"
                  required
                >
              </div>
              <div class="month-input">
                <label>合计</label>
                <input type="number" :value="communityInvestmentTotal" disabled class="calculated-field">
              </div>
            </div>
          </fieldset>

          <!-- 志愿者参与 -->
          <fieldset>
            <legend>{{ year }}年社区参与统计 - 志愿者参与 (人次)</legend>
            <div class="monthly-grid">
              <div v-for="(_, index) in formData.volunteerParticipants" :key="'vp-'+index" class="month-input">
                <label>{{ getMonthName(index) }}</label>
                <input
                  type="number"
                  v-model.number="formData.volunteerParticipants[index]"
                  :placeholder="`${getMonthName(index)}志愿者参与`"
                  min="0"
                  step="1"
                  :readonly="!isEditing"
                  :class="{ 'editable-field': isEditing }"
                  required
                >
              </div>
              <div class="month-input">
                <label>合计</label>
                <input type="number" :value="volunteerParticipantsTotal" disabled class="calculated-field">
              </div>
            </div>
          </fieldset>

          <!-- 志愿者服务 -->
          <fieldset>
            <legend>{{ year }}年社区参与统计 - 志愿者服务 (小时)</legend>
            <div class="monthly-grid">
              <div v-for="(_, index) in formData.volunteerHours" :key="'vh-'+index" class="month-input">
                <label>{{ getMonthName(index) }}</label>
                <input
                  type="number"
                  v-model.number="formData.volunteerHours[index]"
                  :placeholder="`${getMonthName(index)}志愿者服务`"
                  min="0"
                  step="0.1"
                  :readonly="!isEditing"
                  :class="{ 'editable-field': isEditing }"
                  required
                >
              </div>
              <div class="month-input">
                <label>合计</label>
                <input type="number" :value="volunteerHoursTotal" disabled class="calculated-field">
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
const year = computed(() => selectionStore.selectedYear);
const month = computed(() => selectionStore.selectedMonth);

const isEditing = ref(false)
const isLoading = ref(false)

// 月份名称映射 & 工具函数（与能源一致）
const monthNames = ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月']
const getMonthName = (index) => monthNames[index]

// —— 社区参与数据 —— //
const formData = reactive({
  charityDonations: Array(12).fill(0),
  communityInvestment: Array(12).fill(0),
  volunteerParticipants: Array(12).fill(0),
  volunteerHours: Array(12).fill(0)
})

// —— 汇总与计算（保持原逻辑与命名） —— //
const toNum = (v, d = 0) => {
  const n = Number(v)
  return Number.isFinite(n) ? n : d
}

const rowSum = (arr) => arr.reduce((s, v) => s + toNum(v), 0)

const charityDonationsTotal = computed(() => rowSum(formData.charityDonations))
const communityInvestmentTotal = computed(() => rowSum(formData.communityInvestment))
const volunteerParticipantsTotal = computed(() => rowSum(formData.volunteerParticipants))
const volunteerHoursTotal = computed(() => rowSum(formData.volunteerHours))

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
    const resp = await apiClient.get('/quantitative/community', {
      params: { factory: factory.value, year: year.value }
    })
    const data = resp?.data?.data
    if (data) {
      // 兼容后端下划线/驼峰
      setArray(formData.charityDonations, data.charityDonations || data.charity_donations || Array(12).fill(0))
      setArray(formData.communityInvestment, data.communityInvestment || data.community_investment || Array(12).fill(0))
      setArray(formData.volunteerParticipants, data.volunteerParticipants || data.volunteer_participants || Array(12).fill(0))
      setArray(formData.volunteerHours, data.volunteerHours || data.volunteer_hours || Array(12).fill(0))
    } else {
      resetFormData()
    }
  } catch (err) {
    if (err.response?.status === 404) {
      resetFormData()
    } else {
      console.error('获取社区参与数据失败:', err)
      resetFormData()
    }
  } finally {
    isLoading.value = false
  }
}

const setArray = (reactiveArr, sourceArr) => {
  for (let i = 0; i < 12; i++) reactiveArr[i] = toNum(sourceArr?.[i] ?? 0)
}

// —— 重置（与能源一致的重置思路） —— //
const resetFormData = () => {
  setArray(formData.charityDonations, Array(12).fill(0))
  setArray(formData.communityInvestment, Array(12).fill(0))
  setArray(formData.volunteerParticipants, Array(12).fill(0))
  setArray(formData.volunteerHours, Array(12).fill(0))
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
      charityDonations: [...formData.charityDonations],
      communityInvestment: [...formData.communityInvestment],
      volunteerParticipants: [...formData.volunteerParticipants],
      volunteerHours: [...formData.volunteerHours],
      charityDonationsTotal: charityDonationsTotal.value,
      communityInvestmentTotal: communityInvestmentTotal.value,
      volunteerParticipantsTotal: volunteerParticipantsTotal.value,
      volunteerHoursTotal: volunteerHoursTotal.value
    }

    const resp = await apiClient.post('/quantitative/community', payload)
    if (resp.data?.status === 'success') {
      alert('社区参与数据提交成功!')
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