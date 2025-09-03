<template>
  <div class="shared-form">
    <form>
      <BaseInfoSelector/>

      <QuantitativeDataTable
          title="物料"
          :data="materialData"
          :indicator-names="MATERIAL_INDICATORS"
          :is-editing="isEditing"
          :year="year"
          @update:temp-reasons="tempMaterialReasons = $event"
      />

      <QuantitativeDataTable
          title="能源"
          :data="energyData"
          :indicator-names="ENERGY_INDICATORS"
          :is-editing="isEditing"
          :year="year"
          @update:temp-reasons="tempEnergyReasons = $event"
      />

      <QuantitativeDataTable
          title="水资源"
          :data="waterData"
          :indicator-names="WATER_INDICATORS"
          :is-editing="isEditing"
          :year="year"
          @update:temp-reasons="tempWaterReasons = $event"
      />

      <QuantitativeDataTable
          title="排放"
          :data="emissionData"
          :indicator-names="EMISSION_INDICATORS"
          :is-editing="isEditing"
          :year="year"
          @update:temp-reasons="tempEmissionReasons = $event"
      />

      <QuantitativeDataTable
          title="废弃物"
          :data="wasteData"
          :indicator-names="WASTE_INDICATORS"
          :is-editing="isEditing"
          :year="year"
          @update:temp-reasons="tempWasteReasons = $event"
      />

      <QuantitativeDataTable
          title="资金投入"
          :data="investmentData"
          :indicator-names="INVESTMENT_INDICATORS"
          :is-editing="isEditing"
          :year="year"
          @update:temp-reasons="tempInvestmentReasons = $event"
      />

      <QuantitativeDataTable
          title="环境管理"
          :data="envQuantData"
          :indicator-names="ENV_QUANT_INDICATORS"
          :is-editing="isEditing"
          :year="year"
          @update:temp-reasons="tempEnvQuantReasons = $event"
      />
    </form>
  </div>
</template>

<script setup>
import {computed, ref} from 'vue';
import BaseInfoSelector from '@/components/BaseInfoSelector.vue';
import QuantitativeDataTable from '@/components/QuantitativeDataTable.vue';
import {formatComparison, useQuantData} from '@/router/useEnvData.js';
import {
  EMISSION_INDICATORS,
  ENERGY_INDICATORS,
  ENV_QUANT_INDICATORS,
  INVESTMENT_INDICATORS,
  MATERIAL_INDICATORS,
  WASTE_INDICATORS,
  WATER_INDICATORS
} from '@/router/indicators.js';
import {fetchQuantData, postQuantReasons} from '@/router/envData.js';

// 使用组合函数获取数据
const {data, factory, year} = useQuantData();

// 计算各个数据部分
const materialData = computed(() => data.value.material || {});
const energyData = computed(() => data.value.energy || {});
const waterData = computed(() => data.value.water || {});
const emissionData = computed(() => data.value.emission || {});
const wasteData = computed(() => data.value.waste || {});
const investmentData = computed(() => data.value.investment || {});
const envQuantData = computed(() => data.value.envQuant || {});

// 本地编辑状态和方法
const isEditing = ref(false);

const startEditing = () => {
  isEditing.value = true;
};

const cancelEditing = () => {
  isEditing.value = false;
  // 重置所有临时原因数据
  tempMaterialReasons.value = {};
  tempEnergyReasons.value = {};
  tempWaterReasons.value = {};
  tempEmissionReasons.value = {};
  tempWasteReasons.value = {};
  tempInvestmentReasons.value = {};
  tempEnvQuantReasons.value = {};
};

const submitEdit = async () => {
  try {
    await submitReasons();
  } catch (error) {
    console.error('提交失败:', error);
  }
};

defineExpose({
  startEditing,
  cancelEditing,
  submitEdit,
  formatComparison
});

// 临时原因数据
const tempMaterialReasons = ref({});
const tempEnergyReasons = ref({});
const tempWaterReasons = ref({});
const tempEmissionReasons = ref({});
const tempWasteReasons = ref({});
const tempInvestmentReasons = ref({});
const tempEnvQuantReasons = ref({});

// 提交原因分析
const submitReasons = async () => {
  try {
    // 准备提交数据
    const materialReasons = Object.keys(MATERIAL_INDICATORS).map(
        key => tempMaterialReasons.value[key] || ''
    );

    const energyReasons = Object.keys(ENERGY_INDICATORS).map(
        key => tempEnergyReasons.value[key] || ''
    );

    const waterReasons = Object.keys(WATER_INDICATORS).map(
        key => tempWaterReasons.value[key] || ''
    );

    const emissionReasons = Object.keys(EMISSION_INDICATORS).map(
        key => tempEmissionReasons.value[key] || ''
    );

    const wasteReasons = Object.keys(WASTE_INDICATORS).map(
        key => tempWasteReasons.value[key] || ''
    );

    const investmentReasons = Object.keys(INVESTMENT_INDICATORS).map(
        key => tempInvestmentReasons.value[key] || ''
    );

    const envQuantReasons = Object.keys(ENV_QUANT_INDICATORS).map(
        key => tempEnvQuantReasons.value[key] || ''
    );

    // 提交数据
    await postQuantReasons({
      factory: factory.value,
      year: parseInt(year.value),
      materialReasons,
      energyReasons,
      waterReasons,
      emissionReasons,
      wasteReasons,
      investmentReasons,
      envQuantReasons
    });

    // 更新前端显示
    Object.keys(tempMaterialReasons.value).forEach(key => {
      if (materialData.value[key]) {
        materialData.value[key].reason = tempMaterialReasons.value[key];
      }
    });

    Object.keys(tempEnergyReasons.value).forEach(key => {
      if (energyData.value[key]) {
        energyData.value[key].reason = tempEnergyReasons.value[key];
      }
    });

    Object.keys(tempWaterReasons.value).forEach(key => {
      if (waterData.value[key]) {
        waterData.value[key].reason = tempWaterReasons.value[key];
      }
    });

    Object.keys(tempEmissionReasons.value).forEach(key => {
      if (emissionData.value[key]) {
        emissionData.value[key].reason = tempEmissionReasons.value[key];
      }
    });

    Object.keys(tempWasteReasons.value).forEach(key => {
      if (wasteData.value[key]) {
        wasteData.value[key].reason = tempWasteReasons.value[key];
      }
    });

    Object.keys(tempInvestmentReasons.value).forEach(key => {
      if (investmentData.value[key]) {
        investmentData.value[key].reason = tempInvestmentReasons.value[key];
      }
    });

    Object.keys(tempEnvQuantReasons.value).forEach(key => {
      if (envQuantData.value[key]) {
        envQuantData.value[key].reason = tempEnvQuantReasons.value[key];
      }
    });
    alert('原因分析提交成功！');
  } catch (error) {
    console.error('提交原因分析失败:', error);
    alert(`提交原因分析失败: ${error.response?.data?.detail || error.message}`);
  } finally {
    console.log('提交完成，即将刷新');
    isEditing.value = false;
    await fetchQuantData(factory.value, year.value);
  }
};

</script>
