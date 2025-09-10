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
                <div v-for="f in factories" :key="f" class="option" :class="{ 'selected-option': f === factory }"
                     @click="selectionStore.selectFactory(f)">
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
                <div v-for="y in years" :key="y" class="option" :class="{ 'selected-option': y === year }"
                     @click="selectionStore.selectYear(y)">
                  {{ y }}年
                </div>
              </div>
            </div>
          </div>
        </div>
      </fieldset>

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
                <textarea v-else v-model="tempReasons[category][key]" class="reason-input"></textarea>
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
import {computed, onMounted, ref, watch} from 'vue';
import {formatComparison} from '@/router/useEnvData.js';
import {CATEGORY, ENV_QUANT_INDICATORS} from '@/constants/indicators.js';
import apiClient from "@/utils/axios.js";
import {useSelectionStore} from "@/stores/selectionStore.js";

const selectionStore = useSelectionStore()
const factory = computed(() => selectionStore.selectedFactory)
const factories = computed(() => selectionStore.factories)
const year = computed(() => selectionStore.selectedYear)
const years = computed(() => selectionStore.years)

const data = ref({
  material: {}, energy: {}, water: {}, emission: {}, waste: {}, investment: {}, envQuant: {}
});
const isEditing = ref(false);
const tempReasons = ref({})

const startEditing = () => {
  isEditing.value = true;
  tempReasons.value = {};
  Object.entries(data.value).forEach(([category, group]) => {
    if (!tempReasons.value[category]) {
      tempReasons.value[category] = {};
    }
    Object.entries(group).forEach(([key, item]) => {
      tempReasons.value[category][key] = item?.reason || '';
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

watch([factory, year], () => {
  fetchData()
})
const submitEdit = async () => {
  try {
    const playLoad = {
      factory: factory.value,
      year: parseInt(year.value),
      reasonsMap: tempReasons.value
    }
    console.log("初始数据：", data.value)
    console.log("提交原因：", tempReasons.value)
    const response = await apiClient.post(`/analytical/env_quantitative`, playLoad);
    if (response.data.status === 'success') {
      alert('排放数据提交成功!')
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
