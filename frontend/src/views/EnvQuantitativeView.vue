<template>
  <div class="shared-form">
    <form>
      <BaseInfoSelector @selection-changed="fetchData"/>
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
import {CATEGORY, ENV_QUANT_INDICATORS} from '@/constants/indicators.js';
import apiClient from "@/utils/axios.js";
import {useSelectionStore} from "@/stores/selectionStore.js";
import BaseInfoSelector from "@/components/BaseInfoSelector.vue";

const selectionStore = useSelectionStore()
const factory = computed(() => selectionStore.selectedFactory)
const year = computed(() => selectionStore.selectedYear)

const data = ref({
  material: {}, energy: {}, water: {}, emission: {}, waste: {}, investment: {}, envQuant: {}
});
const isEditing = ref(false);
const tempReasons = ref({})

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

const fetchData = async () => {
  try {
    const res = await apiClient.get('/analytical/env_quantitative', {
      params: {
        factory: factory.value,
        year: year.value
      }
    })
    data.value = res.data
    console.log(res.data)
  } catch (e) {
    console.error(e)
    alert(`获取劳动定量数据失败: ${e.response?.data?.detail || e.message}`)
  }
}
onMounted(() => {
  document.addEventListener('click', selectionStore.handleClickOutside)
  fetchData()
})

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
      alert('数据提交成功!')
    }else {
      alert(`数据提交失败: ${response.data.message || '未知错误'}`)
    }
  } catch (error) {
    console.error('提交原因分析失败:', error);
    alert(`提交原因分析失败: ${error.response?.data?.detail || error.message}`);
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
