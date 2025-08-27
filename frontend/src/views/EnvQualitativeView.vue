<template>
  <div class="shared-form">
    <form>
      <BaseInfoSelector />

      <!-- 动态生成分类表格 -->
      <QualitativeDataTable
          v-for="category in Object.keys(INDICATOR_CATEGORIES)"
          :key="category"
          :title="category"
          :data="getCategoryData(category)"
          :indicators="INDICATOR_CATEGORIES[category]"
          :indicator-names="ENV_QUAL_INDICATORS"
          :is-editing="isEditing"
          :year="year"
          @update:temp-current-year="updateTempCurrentYear($event, category)"
          @update:temp-comparisons="updateTempComparisons($event, category)"
          @update:temp-reasons="updateTempReasons($event, category)"
      />
    </form>
  </div>
</template>

<script setup>
import {ref} from 'vue';
import BaseInfoSelector from '@/components/BaseInfoSelector.vue';
import QualitativeDataTable from '@/components/QualitativeDataTable.vue';
import { useQualData } from '@/api/useEnvData';
import { ENV_QUAL_INDICATORS, INDICATOR_CATEGORIES } from '@/api/indicators';
import {fetchQualData, postQualData} from '@/api/envData';

// 使用组合函数获取数据
const { data: envQualData, factory, year } = useQualData();

// 本地编辑状态和方法
const isEditing = ref(false);

const startEditing = () => {
  isEditing.value = true;
  tempCurrentYear.value = {};
  tempComparisons.value = {};
  tempReasons.value = {};

  Object.keys(envQualData.value).forEach(key => {
    tempCurrentYear.value[key] = envQualData.value[key]?.currentYear || '';
    tempComparisons.value[key] = envQualData.value[key]?.comparison || '';
    tempReasons.value[key] = envQualData.value[key]?.reason || '';
  });
};

const cancelEditing = () => {
  isEditing.value = false;
  tempCurrentYear.value = {};
  tempComparisons.value = {};
  tempReasons.value = {};
};

const submitEdit = async () => {
  try {
    await submitData();
  } catch (error) {
    console.error('提交失败:', error);
  }
};

defineExpose({
  startEditing,
  cancelEditing,
  submitEdit,
});

// 临时数据
const tempCurrentYear = ref({});
const tempComparisons = ref({});
const tempReasons = ref({});

// 按分类提取数据
const getCategoryData = (category) => {
  const result = {};
  INDICATOR_CATEGORIES[category].forEach(indicator => {
    if (envQualData.value[indicator]) {
      result[indicator] = envQualData.value[indicator];
    }
  });
  return result;
};

// 更新临时数据
const updateTempCurrentYear = (newData, category) => {
  const indicators = INDICATOR_CATEGORIES[category];
  indicators.forEach(indicator => {
    if (newData[indicator] !== undefined) {
      tempCurrentYear.value[indicator] = newData[indicator];
    }
  });
};

const updateTempComparisons = (newData, category) => {
  const indicators = INDICATOR_CATEGORIES[category];
  indicators.forEach(indicator => {
    if (newData[indicator] !== undefined) {
      tempComparisons.value[indicator] = newData[indicator];
    }
  });
};

const updateTempReasons = (newData, category) => {
  const indicators = INDICATOR_CATEGORIES[category];
  indicators.forEach(indicator => {
    if (newData[indicator] !== undefined) {
      tempReasons.value[indicator] = newData[indicator];
    }
  });
};

// 提交数据
const submitData = async () => {
  try {
    const payload = {
      factory: factory.value,
      year: parseInt(year.value),
      envQualData: {}
    };

    Object.keys(envQualData.value).forEach(key => {
      payload.envQualData[key] = {
        currentYear: tempCurrentYear.value[key] || '',
        comparison: tempComparisons.value[key] || '',
        reason: tempReasons.value[key] || ''
      };
    });

    await postQualData(payload);

    // 更新前端显示
    Object.keys(envQualData.value).forEach(key => {
      if (envQualData.value[key]) {
        envQualData.value[key].currentYear = tempCurrentYear.value[key];
        envQualData.value[key].comparison = tempComparisons.value[key];
        envQualData.value[key].reason = tempReasons.value[key];
      }
    });

    isEditing.value = false;
    alert('数据提交成功！');
    await fetchQualData(factory.value, year.value);
  } catch (error) {
    console.error('提交数据失败:', error);
    alert(`提交数据失败: ${error.response?.data?.detail || error.message}`);
  }
};
</script>

