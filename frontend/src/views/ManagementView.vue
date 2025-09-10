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

      <!-- 管理统计部分 -->
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
import {computed, onBeforeUnmount, onMounted, ref, watch} from 'vue'
import apiClient from '@/utils/axios';
import {useSelectionStore} from "@/stores/selectionStore.js"

const selectionStore = useSelectionStore()
const factory = computed(() => selectionStore.selectedFactory);
const year = computed(() => selectionStore.selectedYear);
const month = computed(() => selectionStore.selectedMonth);
const isEditing = ref(false)
const isLoading = ref(false)

// 表单数据结构（按月存储，1~12月）
const formData = ref({
  nationalGreenFactory: Array(12).fill(0),
  provincialGreenFactory: Array(12).fill(0),
  environmentalPenaltyIntensity: Array(12).fill(0),
  environmentalPenaltyAmount: Array(12).fill(0),
  environmentalViolation: Array(12).fill(0),
})


// 监听工厂和年份变化
watch([factory, year], () => {
  fetchData();
});

onMounted(() => {
  document.addEventListener("click", selectionStore.handleClickOutside);
});
onBeforeUnmount(() => {
  document.removeEventListener("click", selectionStore.handleClickOutside);
});

// 获取数据方法
const fetchData = async () => {
  if (!factory.value || !year.value) {
    resetFormData();
    return;
  }
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
    } else {
      resetFormData();
    }
  } catch (error) {
    if (error.response?.status === 404) {
      resetFormData();
    } else {
      console.error('获取数据失败:', error);
      resetFormData();
    }
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
};

// 提交编辑方法
const submitEdit = async () => {
  try {
    const payload = {
      factory: factory.value,
      year: year.value,
      national_green_factory: formData.value.nationalGreenFactory,
      provincial_green_factory: formData.value.provincialGreenFactory,
      environmental_penalty_intensity: formData.value.environmentalPenaltyIntensity,
      environmental_penalty_amount: formData.value.environmentalPenaltyAmount,
      environmental_violation: formData.value.environmentalViolation
    };
    const response = await apiClient.post('/quantitative/management', payload);
    if (response.data.status === 'success') {
      alert('数据提交成功!');
    }
  } catch (error) {
    console.error('提交失败:', error);
    alert(`提交失败: ${error.response?.data?.detail || error.message}`);
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
