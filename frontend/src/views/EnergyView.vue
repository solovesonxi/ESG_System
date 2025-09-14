<template>
  <div class="shared-form">
    <form>
      <BaseInfoSelector @selection-changed="fetchData"/>
      <fieldset class="summary-fieldset">
        <legend>{{ year }}年{{ month }}月能源数据统计</legend>
        <div class="loading" v-if="isLoading">数据加载中...</div>
        <div class="form-row" v-else>
          <!-- 外购电量统计 -->
          <div class="form-group">
            <label>外购电量 (kWh)</label>
            <input
                type="number"
                v-model.number="formData.purchasedPower[month - 1]"
                min="0"
                step="0.01"
                :readonly="!isEditing"
                :class="{ 'editable-field': isEditing }"
                required
            >
          </div>

          <!-- 再生能源电量统计 -->
          <div class="form-group">
            <label>再生能源电量 (kWh)</label>
            <input
                type="number"
                v-model.number="formData.renewableEnergyPower[month - 1]"
                min="0"
                step="0.01"
                :readonly="!isEditing"
                :class="{ 'editable-field': isEditing }"
                required
            >
          </div>

          <!-- 汽油用量统计 -->
          <div class="form-group">
            <label>汽油用量 (T)</label>
            <input
                type="number"
                v-model.number="formData.gasoline[month - 1]"
                min="0"
                step="0.01"
                :readonly="!isEditing"
                :class="{ 'editable-field': isEditing }"
                required
            >
          </div>

          <!-- 柴油用量统计 -->
          <div class="form-group">
            <label>柴油用量 (T)</label>
            <input
                type="number"
                v-model.number="formData.diesel[month - 1]"
                min="0"
                step="0.01"
                :readonly="!isEditing"
                :class="{ 'editable-field': isEditing }"
                required
            >
          </div>

          <!-- 天然气用量统计 -->
          <div class="form-group">
            <label>天然气用量 (T)</label>
            <input
                type="number"
                v-model.number="formData.naturalGas[month - 1]"
                min="0"
                step="0.01"
                :readonly="!isEditing"
                :class="{ 'editable-field': isEditing }"
                required
            >
          </div>

          <!-- 其他能源用量统计 -->
          <div class="form-group">
            <label>其他能源用量 (Tce)</label>
            <input
                type="number"
                v-model.number="formData.otherEnergy[month - 1]"
                min="0"
                step="0.01"
                :readonly="!isEditing"
                :class="{ 'editable-field': isEditing }"
                required
            >
          </div>
          <div class="form-group">
            <label>水用量 (m³)</label>
            <input
                type="number"
                v-model.number="formData.water[month - 1]"
                min="0"
                step="0.01"
                :readonly="!isEditing"
                :class="{ 'editable-field': isEditing }"
                required
            >
          </div>
          <div class="form-group">
            <label>煤炭用量 (T)</label>
            <input
                type="number"
                v-model.number="formData.coal[month - 1]"
                min="0"
                step="0.01"
                :readonly="!isEditing"
                :class="{ 'editable-field': isEditing }"
                required
            >
          </div>
        </div>
      </fieldset>
      <!-- 能源消耗合计 -->
      <fieldset class="summary-fieldset">
        <legend>{{ year }}年能源统计 - 汇总</legend>
        <div class="form-row">

          <div class="form-group">
            <label>电 (Tce)</label>
            <input type="number" :value="powerConsumption" disabled class="calculated-field">
          </div>
          <div class="form-group">
            <label>汽油 (Tce)</label>
            <input type="number" :value="gasolineConsumption" disabled class="calculated-field">
          </div>
          <div class="form-group">
            <label>柴油 (Tce)</label>
            <input type="number" :value="dieselConsumption" disabled class="calculated-field">
          </div>
          <div class="form-group">
            <label>天然气 (Tce)</label>
            <input type="number" :value="naturalGasConsumption" disabled class="calculated-field">
          </div>
          <div class="form-group">
            <label>其他能源 (Tce)</label>
            <input type="number" :value="totalOtherEnergy" disabled class="calculated-field">
          </div>
          <div class="form-group">
            <label>水 (Tce)</label>
            <input type="number" :value="totalWaterConsumption" disabled class="calculated-field">
          </div>
          <div class="form-group">
            <label>合计 (Tce)</label>
            <input type="number" :value="totalEnergyConsumption" disabled class="calculated-field">
          </div>
          <div class="form-group">
            <label>营业额 (万元)</label>
            <input type="number" v-model.number="formData.turnover" step="0.01"
                   :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
          </div>
          <div class="form-group">
            <label>能源消耗强度 (Tce/万元)</label>
            <input type="number" :value="energyConsumptionIntensity" disabled class="calculated-field">
          </div>
        </div>
      </fieldset>
    </form>
  </div>
</template>

<script setup>
import {computed, onBeforeUnmount, onMounted, ref, watch} from 'vue'
import apiClient from '@/utils/axios';

import {useSelectionStore} from "@/stores/selectionStore.js";
import BaseInfoSelector from "@/components/BaseInfoSelector.vue";

const selectionStore = useSelectionStore();
const factory = computed(() => selectionStore.selectedFactory);
const year = computed(() => selectionStore.selectedYear);
const month = computed(() => selectionStore.selectedMonth);
const isEditing = ref(false);
const isLoading = ref(false);


// 表单数据结构
const formData = ref({
  purchasedPower: Array(12).fill(0),
  renewableEnergyPower: Array(12).fill(0),
  gasoline: Array(12).fill(0),
  diesel: Array(12).fill(0),
  naturalGas: Array(12).fill(0),
  otherEnergy: Array(12).fill(0),
  water: Array(12).fill(0),
  coal: Array(12).fill(0),
  turnover: 0
});

// 计算各种能源的年度合计值
const totalPurchasedPower = computed(() => formData.value.purchasedPower.reduce((sum, power) => sum + power, 0));
const totalRenewablePower = computed(() => formData.value.renewableEnergyPower.reduce((sum, energy) => sum + energy, 0));
const totalGasoline = computed(() => formData.value.gasoline.reduce((sum, amount) => sum + amount, 0));
const totalDiesel = computed(() => formData.value.diesel.reduce((sum, amount) => sum + amount, 0));
const totalNaturalGas = computed(() => formData.value.naturalGas.reduce((sum, amount) => sum + amount, 0));
const totalOtherEnergy = computed(() => formData.value.otherEnergy.reduce((sum, amount) => sum + amount, 0));
const  totalWater = computed(() => formData.value.water.reduce((sum, amount) => sum + amount, 0));
const totalCoal = computed(() => formData.value.coal.reduce((sum, amount) => sum + amount, 0));
// 计算各种能源的消耗量 (Tce)
const powerConsumption = computed(() => Number(((totalPurchasedPower.value + totalRenewablePower.value) * 0.1229 / 1000).toFixed(2)));
const gasolineConsumption = computed(() => Number((totalGasoline.value * 1.4717).toFixed(2)));
const dieselConsumption = computed(() => Number((totalDiesel.value * 1.4571).toFixed(2)));
const naturalGasConsumption = computed(() => Number((totalNaturalGas.value * 0.75 / 1000 * 1.33).toFixed(2)));

// 水的年度总消耗（Tce）
const totalWaterConsumption = computed(() => {
  return Number((totalWater.value * 0.2571 / 1000).toFixed(2));
});

// 煤炭的年度总消耗（Tce，煤炭本身已是Tce单位）
const totalCoalConsumption = computed(() => {
  return Number((totalCoal.value).toFixed(2));
});
const totalEnergyConsumption = computed(() =>
    Number((totalWaterConsumption.value + totalCoalConsumption.value + powerConsumption.value +
        gasolineConsumption.value + dieselConsumption.value + naturalGasConsumption.value +
        totalOtherEnergy.value).toFixed(2)));
const energyConsumptionIntensity = computed(() => {
  if (formData.value.turnover <= 0) return 0;
  return Number((totalEnergyConsumption.value / formData.value.turnover).toFixed(2));
});

onMounted(() => {
  document.addEventListener("click", selectionStore.handleClickOutside);
});
onBeforeUnmount(() => {
  document.removeEventListener("click", selectionStore.handleClickOutside);
});

// 获取数据方法
const fetchData = async () => {
  isLoading.value = true;
  try {
    const response = await apiClient.get(`/quantitative/energy`, {
      params: {factory: factory.value, year: year.value}
    });
    console.log(response.data);
    if (response.data && response.data.data) {
      const data = response.data.data;
      formData.value = {
        purchasedPower: data.purchased_power || Array(12).fill(0),
        renewableEnergyPower: data.renewable_power || Array(12).fill(0),
        gasoline: data.gasoline || Array(12).fill(0),
        diesel: data.diesel || Array(12).fill(0),
        naturalGas: data.natural_gas || Array(12).fill(0),
        otherEnergy: data.other_energy || Array(12).fill(0),
        water: data.water || 0,
        coal: data.coal || 0,
        turnover: data.turnover || 0
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
    purchasedPower: Array(12).fill(0),
    renewableEnergyPower: Array(12).fill(0),
    gasoline: Array(12).fill(0),
    diesel: Array(12).fill(0),
    naturalGas: Array(12).fill(0),
    otherEnergy: Array(12).fill(0),
    water: Array(12).fill(0),
    coal: Array(12).fill(0),
    turnover: 0
  };
};

// 提交编辑方法
const submitEdit = async (ifSubmit) => {
  try {
    const payload = {
      factory: factory.value,
      year: year.value,
      month: month.value,
      purchasedPower: formData.value.purchasedPower,
      renewableEnergyPower: formData.value.renewableEnergyPower,
      gasoline: formData.value.gasoline,
      diesel: formData.value.diesel,
      naturalGas: formData.value.naturalGas,
      otherEnergy: formData.value.otherEnergy,
      water: formData.value.water,
      coal: formData.value.coal,
      totalEnergyConsumption: totalEnergyConsumption.value,
      turnover: formData.value.turnover,
      energyConsumptionIntensity: energyConsumptionIntensity.value,
      isSubmitted: ifSubmit
    };
    const response = await apiClient.post('/quantitative/energy', payload);
    if (response.data.status === 'success') {
      alert('数据提交成功!')
    }else {
      alert(`数据提交失败: ${response.data.message || '未知错误'}`)
    }
  } catch (error) {
    console.error('提交失败:', error);
    alert(`提交失败: ${error.response?.data?.detail || error.message}`);
  } finally {
    console.log('提交完成，即将刷新');
    isEditing.value = false;
    await fetchData();
  }
};

// 暴露方法给父组件
defineExpose({
  startEditing: () => isEditing.value = true,
  cancelEditing: () => {
    isEditing.value = false;
    fetchData();
  },
  submitEdit,
  fetchData
});
</script>
