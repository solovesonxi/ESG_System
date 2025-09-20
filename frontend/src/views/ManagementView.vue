<template>
  <div class="shared-form">
    <form>
      <BaseInfoSelector :review="review" form-type="management" @selection-changed="fetchData"/>
      <fieldset class="summary-fieldset">
        <legend>{{ year }}年{{ month }}月管理数据统计</legend>
        <div class="loading" v-if="isLoading">数据加载中...</div>
        <div class="form-row" v-else>
          <div class="form-group">
            <label>国家级绿色工厂 (个)</label>
            <input
                type="number"
                v-model.number="formData.nationalGreenFactory[month - 1]"
                min="0"
                step="1"
                :readonly="!isEditing"
                :class="{ 'editable-field': isEditing }"
                required
            >
          </div>
          <div class="form-group">
            <label>省级绿色工厂 (个)</label>
            <input
                type="number"
                v-model.number="formData.provincialGreenFactory[month - 1]"
                min="0"
                step="1"
                :readonly="!isEditing"
                :class="{ 'editable-field': isEditing }"
                required
            >
          </div>
          <div class="form-group">
            <label>环境处罚强度 (%)</label>
            <input
                type="number"
                v-model.number="formData.environmentalPenaltyIntensity[month - 1]"
                min="0"
                step="0.1"
                :readonly="!isEditing"
                :class="{ 'editable-field': isEditing }"
                required
            >
          </div>
          <div class="form-group">
            <label>环境处罚额 (万元)</label>
            <input
                type="number"
                v-model.number="formData.environmentalPenaltyAmount[month - 1]"
                min="0"
                step="0.1"
                :readonly="!isEditing"
                :class="{ 'editable-field': isEditing }"
                required
            >
          </div>
          <div class="form-group">
            <label>环境违规 (次)</label>
            <input
                type="number"
                v-model.number="formData.environmentalViolation[month - 1]"
                min="0"
                step="1"
                :readonly="!isEditing"
                :class="{ 'editable-field': isEditing }"
                required
            >
          </div>
        </div>
      </fieldset>
    </form>
  </div>
</template>

<script setup>
import {computed, onBeforeUnmount, onMounted, ref} from 'vue'
import apiClient from '@/utils/axios';
import {useSelectionStore} from "@/stores/selectionStore.js"
import BaseInfoSelector from "@/components/BaseInfoSelector.vue";
import {handleError, showError, showInfo, showSuccess} from "@/utils/toast.js";

const selectionStore = useSelectionStore()
const factory = computed(() => selectionStore.selectedFactory);
const year = computed(() => selectionStore.selectedYear);
const month = computed(() => selectionStore.selectedMonth);
const isEditing = ref(false)
const isLoading = ref(false)
const review = ref({});

// 表单数据结构（按月存储，1~12月）
const formData = ref({
  nationalGreenFactory: Array(12).fill(0),
  provincialGreenFactory: Array(12).fill(0),
  environmentalPenaltyIntensity: Array(12).fill(0),
  environmentalPenaltyAmount: Array(12).fill(0),
  environmentalViolation: Array(12).fill(0),
})
onMounted(() => {
  document.addEventListener("click", selectionStore.handleClickOutside);
});
onBeforeUnmount(() => {
  document.removeEventListener("click", selectionStore.handleClickOutside);
});

// 获取数据方法
const fetchData = async () => {
  isLoading.value = true;
  try {
    const response = await apiClient.get(`/quantitative/management`, {
      params: {factory: factory.value, year: year.value}
    });
    if (response.data && response.data.data) {
      const data = response.data.data;
      formData.value = {
        nationalGreenFactory: data.national_green_factory || Array(12).fill(0),
        provincialGreenFactory: data.provincial_green_factory || Array(12).fill(0),
        environmentalPenaltyIntensity: data.environmental_penalty_intensity || Array(12).fill(0),
        environmentalPenaltyAmount: data.environmental_penalty_amount || Array(12).fill(0),
        environmentalViolation: data.environmental_violation || Array(12).fill(0),
      };
      review.value = response.data.review;
    } else {
      resetFormData();
      showInfo('未找到数据')
    }
  } catch (error) {
    handleError(error);
    resetFormData();
  } finally {
    isLoading.value = false;
  }
};

// 重置表单数据
const resetFormData = () => {
  formData.value = {
    nationalGreenFactory: Array(12).fill(0),
    provincialGreenFactory: Array(12).fill(0),
    environmentalPenaltyIntensity: Array(12).fill(0),
    environmentalPenaltyAmount: Array(12).fill(0),
    environmentalViolation: Array(12).fill(0),
  };
  review.value = {
    id: Array(12).fill(-1), is_submitted: Array(12).fill(false), status1: Array(12).fill("pending"), comment1: Array(12).fill(''),
    status2: Array(12).fill("pending"), comment22: Array(12).fill('')
  };
};

// 提交编辑方法
const submitEdit = async (ifSubmit) => {
  try {
    const payload = {
      factory: factory.value,
      year: year.value,
      month: month.value,
      nationalGreenFactory: formData.value.nationalGreenFactory,
      provincialGreenFactory: formData.value.provincialGreenFactory,
      environmentalPenaltyIntensity: formData.value.environmentalPenaltyIntensity,
      environmentalPenaltyAmount: formData.value.environmentalPenaltyAmount,
      environmentalViolation: formData.value.environmentalViolation,
      isSubmitted: ifSubmit
    };
    const response = await apiClient.post('/quantitative/management', payload);
    if (response.data.status === 'success') {
      showSuccess('数据提交成功!')
    } else {
      showError(`数据提交失败: ${response.data.message || '未知错误'}`)
    }
  } catch (error) {
    console.error('提交失败:', error);
    handleError(error);
  } finally {
    isEditing.value = false;
    await fetchData();
  }
};
defineExpose({
  startEditing: () => isEditing.value = true,
  cancelEditing: () => {
    isEditing.value = false
    fetchData()
  },
  submitEdit,
  fetchData
})
</script>
