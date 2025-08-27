<!-- QualitativeDataTable.vue -->
<template>
  <fieldset class="summary-fieldset">
    <legend>{{ title }}</legend>
    <div class="form-row">
      <table class="data-table">
        <thead>
        <tr>
          <th>指标</th>
          <th>上期 ({{ year - 1 }})</th>
          <th>当期 ({{ year }})</th>
          <th>对比上期 (%)</th>
          <th>原因分析</th>
        </tr>
        </thead>
        <tbody>
        <tr v-for="(indicatorKey, index) in Object.keys(data)" :key="index">
          <td>{{ indicatorNames[indicatorKey] || indicatorKey }}</td>
          <td>{{ data[indicatorKey].lastYear || '' }}</td>
          <td>
            <span v-if="!isEditing">{{ data[indicatorKey].currentYear || '' }}</span>
            <input v-else v-model="tempCurrentYear[indicatorKey]"
                   :placeholder="data[indicatorKey]?.currentYear || ''" />
          </td>
          <td>
            <span v-if="!isEditing">{{ formatComparison(data[indicatorKey].comparison) }}</span>
            <input v-else v-model="tempComparisons[indicatorKey]"
                   :placeholder="data[indicatorKey]?.comparison || ''" />
          </td>
          <td>
            <span v-if="!isEditing">{{ data[indicatorKey].reason || '' }}</span>
            <input v-else v-model="tempReasons[indicatorKey]"
                      :placeholder="data[indicatorKey]?.reason || ''">
          </td>
        </tr>
        </tbody>
      </table>
    </div>
  </fieldset>
</template>

<script setup>
import { ref, watch } from 'vue';
import { formatComparison } from '@/api/useEnvData.js';

const props = defineProps({
  title: String,
  data: Object,
  indicatorNames: Object,
  isEditing: Boolean,
  year: Number
});

const emit = defineEmits(['update:tempReasons', 'update:tempCurrentYear', 'update:tempComparisons']);

const tempReasons = ref({});
const tempCurrentYear = ref({});
const tempComparisons = ref({});

watch(() => props.isEditing, (newVal) => {
  if (newVal) {
    // 初始化临时数据
    tempReasons.value = {};
    tempCurrentYear.value = {};
    tempComparisons.value = {};
    Object.keys(props.data).forEach(key => {
      tempReasons.value[key] = props.data[key]?.reason || '';
      tempCurrentYear.value[key] = props.data[key]?.currentYear || '';
      tempComparisons.value[key] = props.data[key]?.comparison || '';
    });
  } else {
    tempReasons.value = {};
    tempCurrentYear.value = {};
    tempComparisons.value = {};
  }
});

watch(tempReasons, (newVal) => {
  emit('update:tempReasons', newVal);
}, { deep: true });

watch(tempCurrentYear, (newVal) => {
  emit('update:tempCurrentYear', newVal);
}, { deep: true });

watch(tempComparisons, (newVal) => {
  emit('update:tempComparisons', newVal);
}, { deep: true });
</script>