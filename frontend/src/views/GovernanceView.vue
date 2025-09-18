<template>
  <div class="shared-form" @selection-changed="fetchData">
    <form>
      <BaseInfoSelector :review="review" form-type="governance" @selection-changed="fetchData"/>
      <fieldset class="summary-fieldset" v-for="(indicators, category) in qualData" :key="category">
        <legend>{{ category }}</legend>
        <div class="form-row">
          <table class="data-table">
            <thead>
            <tr>
              <th>指标</th>
              <th>去年的方针、政策、文件、记录等</th>
              <th>今年的方针、政策、文件、记录等</th>
              <th>对比去年</th>
              <th>原因分析</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="(item, key) in indicators" :key="key">
              <td>{{ key }}</td>
              <td>{{ item.lastText || '' }}</td>
              <td>
                <div v-if="!isEditing">{{ item.currentText || '' }}</div>
                <textarea v-else v-model="tempEdits[category][key].currentText" class="reason-input"
                          :placeholder="item.currentText || ''"></textarea>
              </td>
              <td>
                <div v-if="!isEditing">{{ item.comparisonText || '' }}</div>
                <textarea v-else v-model="tempEdits[category][key].comparisonText" class="reason-input"
                          :placeholder="item.comparisonText || ''"></textarea>
              </td>
              <td>
                <div v-if="!isEditing">{{ item.reason || '' }}</div>
                <textarea v-else v-model="tempEdits[category][key].reason" class="reason-input"
                          :placeholder="item.reason || ''"></textarea>
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
import {computed, onMounted, ref} from 'vue'
import apiClient from '@/utils/axios';
import {useSelectionStore} from "@/stores/selectionStore.js"
import BaseInfoSelector from "@/components/BaseInfoSelector.vue";
import {showError, showInfo, showSuccess, handleError} from "@/utils/toast.js";

const selectionStore = useSelectionStore()
const factory = computed(() => selectionStore.selectedFactory)
const year = computed(() => selectionStore.selectedYear)

const qualData = ref({})
const isEditing = ref(false)
const tempEdits = ref({})
const review = ref({});

const fetchData = async () => {
  try {
    const response = await apiClient.get('/analytical/governance', {
      params: {factory: factory.value, year: year.value}
    })
    if (response.data && response.data.data){
      qualData.value = response.data.data;
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
  isEditing.value = true
  // 深拷贝结构并初始化
  const draft = {}
  Object.entries(qualData.value).forEach(([category, indicators]) => {
    draft[category] = {}
    Object.entries(indicators).forEach(([key, item]) => {
      draft[category][key] = {
        currentText: item.currentText || '',
        lastText: item.lastText || '',
        comparisonText: item.comparisonText || '',
        reason: item.reason || ''
      }
    })
  })
  tempEdits.value = draft
}

const cancelEditing = () => {
  isEditing.value = false
  tempEdits.value = {}
}

const submitEdit = async (ifSubmit) => {
  // 深层过滤 tempEdits，移除所有 currentText、comparisonText、reason 都为空的字段
  const filteredData = {};
  Object.entries(tempEdits.value).forEach(([category, indicators]) => {
    const filteredIndicators = {};
    Object.entries(indicators).forEach(([key, item]) => {
      const hasValue = [item.currentText, item.comparisonText, item.reason].some(v => v && v.trim() !== '');
      if (hasValue) {
        filteredIndicators[key] = item;
      }
    });
    if (Object.keys(filteredIndicators).length > 0) {
      filteredData[category] = filteredIndicators;
    }
  });
  try {
    const response = await apiClient.post('/analytical/governance', {
      factory: factory.value,
      year: parseInt(year.value),
      data: filteredData,
      isSubmitted: ifSubmit
    })
    if (response.data.status === 'success') {
      showSuccess('数据提交成功!')
    } else {
      showError(`数据提交失败: ${response.data.message || '未知错误'}`)
    }
  } catch (error) {
    console.error(error)
    handleError(error);
  } finally {
    console.log('提交完成，即将刷新');
    isEditing.value = false;
    await fetchData();
  }
}
defineExpose({
  startEditing,
  cancelEditing,
  submitEdit,
  fetchData
});
</script>
