<template>
  <div class="shared-form">
    <form>
      <BaseInfoSelector :review="review" form-type="env_qual" @selection-changed="fetchData"/>
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
              <td>{{ ENV_QUAL_INDICATORS[category][key] || key }}</td>
              <td>{{ item.lastYear || '' }}</td>
              <td>
                <span v-if="!isEditing">{{ item.currentYear || '' }}</span>
                <textarea v-else v-model="tempEdits[category][key].currentYear" class="reason-input"></textarea>
              </td>
              <td>
                <span v-if="!isEditing">{{ item.comparison || '' }}</span>
                <textarea v-else v-model="tempEdits[category][key].comparison" class="reason-input"></textarea>
              </td>
              <td>
                <span v-if="!isEditing">{{ item.reason || '' }}</span>
                <textarea v-else v-model="tempEdits[category][key].reason" class="reason-input"></textarea>
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

import {CATEGORY, ENV_QUAL_INDICATORS} from '@/constants/indicators.js';
import {useSelectionStore} from "@/stores/selectionStore.js";
import apiClient from "@/utils/axios.js";
import BaseInfoSelector from "@/components/BaseInfoSelector.vue";
import {handleError, showError, showInfo, showSuccess} from "@/utils/toast.js";

const selectionStore = useSelectionStore()
const factory = computed(() => selectionStore.selectedFactory)
const year = computed(() => selectionStore.selectedYear)

const data = ref({});
const isEditing = ref(false);
const tempEdits = ref({})
const review = ref({});

const fetchData = async () => {
  try {
    const response = await apiClient.get('/analytical/env_qualitative', {
      params: {
        factory: factory.value,
        year: year.value
      }
    })
    if (response.data && response.data.data){
      data.value = response.data.data
      review.value = response.data.review;
    }else {
      review.value = {status: 'pending', comment: ''};
      showInfo('未找到数据')
    }
  } catch (error) {
    console.error(error)
    handleError(error);
  }
}
onMounted(() => {
  document.addEventListener('click', selectionStore.handleClickOutside)
})

const startEditing = () => {
  isEditing.value = true;
  const draft = {}
  Object.entries(data.value).forEach(([category, indicators]) => {
    draft[category] = {}
    Object.entries(indicators).forEach(([key, item]) => {
      draft[category][key] = {
        lastYear: item.lastYear || '',
        currentYear: item.currentYear || '',
        comparison: item.comparison || '',
        reason: item.reason || ''
      }
    })
  })
  tempEdits.value = draft
};

const cancelEditing = () => {
  isEditing.value = false;
  tempEdits.value = {}
};


const submitEdit = async (ifSubmit) => {
  try {
    console.log("初始数据：", data.value)
    console.log("提交原因：", tempEdits.value)
    const response = await apiClient.post(`/analytical/env_qualitative`, {
      factory: factory.value,
      year: parseInt(year.value),
      data: tempEdits.value,
      isSubmitted: ifSubmit
    });
    if (response.data.status === 'success') {
      showSuccess('数据提交成功!')
    }else {
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

defineExpose({
  startEditing,
  cancelEditing,
  submitEdit,
  fetchData
});
</script>
