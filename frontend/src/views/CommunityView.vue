<template>
  <div class="shared-form">
    <form>
      <BaseInfoSelector :review="review" form-type="community" @selection-changed="fetchData"/>
      <fieldset class="summary-fieldset">
        <legend>{{ year }}年{{ month }}月社区参与与志愿活动数据统计</legend>
        <div class="loading" v-if="isLoading">数据加载中...</div>
        <div v-else class="form-row">
          <div class="form-group">
            <label>慈善捐款 (万元)</label>
            <input type="number" v-model.number="formData.charityDonations[month-1]" min="0" step="0.01"
                   :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
          </div>
          <div class="form-group">
            <label>社区发展投入 (万元)</label>
            <input type="number" v-model.number="formData.communityInvestment[month-1]" min="0" step="0.01"
                   :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
          </div>
          <div class="form-group">
            <label>志愿者参与 (人次)</label>
            <input type="number" v-model.number="formData.volunteerParticipants[month-1]" min="0" step="1"
                   :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
          </div>
          <div class="form-group">
            <label>志愿者服务 (小时)</label>
            <input type="number" v-model.number="formData.volunteerHours[month-1]" min="0" step="0.01"
                   :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
          </div>
        </div>
      </fieldset>
      <fieldset class="summary-fieldset">
        <div class="loading" v-if="isLoading">数据加载中...</div>
        <div v-else class="form-row">
          <div class="form-group">
            <label>慈善捐款合计</label>
            <input type="number" :value="charityDonationsTotal" disabled class="calculated-field">
          </div>
          <div class="form-group">
            <label>社区发展投入合计</label>
            <input type="number" :value="communityInvestmentTotal" disabled class="calculated-field">
          </div>
          <div class="form-group">
            <label>志愿者参与合计</label>
            <input type="number" :value="volunteerParticipantsTotal" disabled class="calculated-field">
          </div>
          <div class="form-group">
            <label>志愿者服务合计</label>
            <input type="number" :value="volunteerHoursTotal" disabled class="calculated-field">
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
import {handleError, showError, showSuccess} from "@/utils/toast.js";

// —— 与能源统计保持一致的状态 —— //
const selectionStore = useSelectionStore()
const factory = computed(() => selectionStore.selectedFactory)
const year = computed(() => selectionStore.selectedYear);
const month = computed(() => selectionStore.selectedMonth);

const isEditing = ref(false)
const isLoading = ref(false)

// 审核状态数据
const review = ref({});

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

const charityDonationsTotal = computed(() => rowSum(formData.charityDonations).toFixed(2))
const communityInvestmentTotal = computed(() => rowSum(formData.communityInvestment).toFixed(2))
const volunteerParticipantsTotal = computed(() => rowSum(formData.volunteerParticipants).toFixed(0))
const volunteerHoursTotal = computed(() => rowSum(formData.volunteerHours).toFixed(2))

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
    const response = await apiClient.get('/quantitative/community', {
      params: {factory: factory.value, year: year.value}
    })
    const data = response?.data?.data
    if (data) {
      // 兼容后端下划线/驼峰
      setArray(formData.charityDonations, data.charityDonations || data.charity_donations || Array(12).fill(0))
      setArray(formData.communityInvestment, data.communityInvestment || data.community_investment || Array(12).fill(0))
      setArray(formData.volunteerParticipants, data.volunteerParticipants || data.volunteer_participants || Array(12).fill(0))
      setArray(formData.volunteerHours, data.volunteerHours || data.volunteer_hours || Array(12).fill(0))
      review.value = response.data.review;
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
  review.value = {status: Array(12).fill("pending"), comment: Array(12).fill('')};
}

// —— 提交编辑（保持原字段，不改动内容，只改样式） —— //
const submitEdit = async (ifSubmit) => {
  try {
    const payload = {
      factory: factory.value,
      year: Number(year.value),
      month: month.value,
      charityDonations: [...formData.charityDonations],
      communityInvestment: [...formData.communityInvestment],
      volunteerParticipants: [...formData.volunteerParticipants],
      volunteerHours: [...formData.volunteerHours],
      charityDonationsTotal: charityDonationsTotal.value,
      communityInvestmentTotal: communityInvestmentTotal.value,
      volunteerParticipantsTotal: volunteerParticipantsTotal.value,
      volunteerHoursTotal: volunteerHoursTotal.value,
      isSubmitted: ifSubmit
    }
    const response = await apiClient.post('/quantitative/community', payload)
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
