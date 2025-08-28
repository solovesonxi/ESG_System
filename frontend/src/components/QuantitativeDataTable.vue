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
          <td class="indicator-name">{{ indicatorNames[indicatorKey] || indicatorKey }}</td>
          <td class="readonly-cell">{{ data[indicatorKey].lastYear || '' }}</td>
          <td><span>{{ data[indicatorKey].currentYear || '' }}</span></td>
          <td><span>{{ formatComparison(data[indicatorKey].comparison) }}</span></td>
          <td>
            <span v-if="!isEditing" class="readonly-cell">{{ data[indicatorKey].reason || '' }}</span>
            <input v-else v-model="tempReasons[indicatorKey]"
                   :placeholder="data[indicatorKey]?.reason || ''" class="editable-field" >
          </td>
        </tr>
        </tbody>
      </table>
    </div>
  </fieldset>
</template>

<script setup>
import {ref, watch} from 'vue';
import {formatComparison} from '@/api/useEnvData.js';

const props = defineProps({
  title: String,
  data: Object,
  indicatorNames: Object,
  isEditing: Boolean,
  year: Number
});

const emit = defineEmits(['update:tempReasons']);

const tempReasons = ref({});

watch(() => props.isEditing, (newVal) => {
  if (newVal) {
    // 初始化临时数据
    tempReasons.value = {};
    Object.keys(props.data).forEach(key => {
      tempReasons.value[key] = props.data[key]?.reason || '';
    });
  } else {
    tempReasons.value = {};
  }
});

watch(tempReasons, (newVal) => {
  emit('update:tempReasons', newVal);
}, {deep: true});
</script>