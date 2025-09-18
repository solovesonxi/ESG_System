<template>
  <div class="shared-form">
    <form>
      <BaseInfoSelector :review="review" form-type="env_quant" @selection-changed="fetchData"/>
      <fieldset class="summary-fieldset" v-for="(indicators, category) in data" :key="category">
        <legend>{{ CATEGORY[category] }}</legend>
        <div class="form-row">
          <table class="data-table">
            <thead>
            <tr>
              <th>指标</th>
              <th>上一年 ({{ year - 1 }})</th>
              <th>当前年 ({{ year }})</th>
              <th>对比上期 (%)</th>
              <th>原因分析</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="(item, key) in indicators" :key="key">
              <td>{{ ENV_QUANT_INDICATORS[category][key] || key }}</td>
              <td>{{ item.lastYear || '' }}</td>
              <td>{{ item.currentYear || '' }}</td>
              <td>{{ item.comparison || '' }}</td>
              <td>
                <span v-if="!isEditing">{{ item.reason || '' }}</span>
                <textarea v-else v-model="tempReasons[key]" class="reason-input"></textarea>
              </td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>
    </form>
  </div>
</template>

<script setup>
import {computed, onMounted, ref} from 'vue';
import apiClient from "@/utils/axios.js";
import {useSelectionStore} from "@/stores/selectionStore.js";
import BaseInfoSelector from "@/components/BaseInfoSelector.vue";
import {showError, showInfo, showSuccess, handleError} from "@/utils/toast.js";
import {CATEGORY, ENV_QUANT_INDICATORS} from "@/constants/indicators.js";

const selectionStore = useSelectionStore()
const factory = computed(() => selectionStore.selectedFactory)
const year = computed(() => selectionStore.selectedYear)

const isEditing = ref(false);
const tempReasons = ref({})
const review = ref({});

const data = ref({
  material: {}, energy: {}, water: {}, emission: {}, waste: {}, investment: {}, envQuant: {}
});

const startEditing = () => {
  isEditing.value = true;
  tempReasons.value = {};
  Object.values(data.value).forEach(group => {
    Object.entries(group).forEach(([key, item]) => {
      tempReasons.value[key] = item?.reason || ''
    })
  })
};

const cancelEditing = () => {
  isEditing.value = false;
  tempReasons.value = {}
};

// 在现有fetchData基础上简单添加审核数据获取
const fetchData = async () => {
  try {
    const response = await apiClient.get('/analytical/env_quantitative', {
      params: {
        factory: factory.value,
        year: year.value
      }
    })
    if (response.data && response.data.data) {
      data.value = response.data.data
      review.value = response.data.review;
      console.log('获取环境定量数据成功:', data.value)
    } else {
      resetData()
      showInfo('未找到数据')
    }
  } catch (error) {
    handleError(error);
  }
}

const resetData = () => {
  data.value = {
    material: {}, energy: {}, water: {}, emission: {}, waste: {}, investment: {}, envQuant: {}
  }
  review.value = {status: 'pending', comment: ''};
}

const submitEdit = async (ifSubmit) => {
  try {
    const reasonsMap = {}
    Object.entries(tempReasons.value).forEach(([indicator, reason]) => {
      if (reason && reason.trim() !== '') reasonsMap[indicator] = reason
    })
    const response = await apiClient.post(`/analytical/env_quantitative`, {
      factory: factory.value,
      year: parseInt(year.value),
      reasons: tempReasons.value,
      isSubmitted: ifSubmit
    });
    if (response.data.status === 'success') {
      showSuccess('数据提交成功!')
    } else {
      showError(`数据提交失败: ${response.data.message || '未知错误'}`)
    }
  } catch (error) {
    console.error('提交原因分析失败:', error);
    handleError(error);
  } finally {
    console.log('提交完成，即将刷新');
    isEditing.value = false;
    await fetchData();
  }
};

onMounted(() => {
  document.addEventListener('click', selectionStore.handleClickOutside)
  fetchData()
})

defineExpose({
  startEditing,
  cancelEditing,
  submitEdit,
  fetchData
});
</script>
