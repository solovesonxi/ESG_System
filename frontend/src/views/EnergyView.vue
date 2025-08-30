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
                <div
                    v-for="f in factories"
                    :key="f"
                    class="option"
                    :class="{ 'selected-option': f === factory }"
                    @click="selectionStore.selectFactory(f)"
                >
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
                <div
                    v-for="y in years"
                    :key="y"
                    class="option"
                    :class="{ 'selected-option': y === year }"
                    @click="selectionStore.selectYear(y)"
                >
                  {{ y }}年
                </div>
              </div>
            </div>
          </div>
        </div>
      </fieldset>

      <!-- 能源数据部分 -->
      <fieldset class="summary-fieldset">
        <legend>能源数据统计</legend>
        <div class="loading" v-if="isLoading">数据加载中...</div>
        <div>
          <!-- 外购电量统计 -->
          <fieldset>
            <legend>{{ year }}年外购电量统计 (kWh)</legend>
            <div class="monthly-grid">
              <div v-for="(_, index) in formData.purchasedPower" :key="index" class="month-input">
                <label>{{ getMonthName(index) }}</label>
                <input
                    type="number"
                    v-model.number="formData.purchasedPower[index]"
                    :placeholder="`${getMonthName(index)}电量`"
                    min="0"
                    step="1"
                    :readonly="!isEditing"
                    :class="{ 'editable-field': isEditing }"
                    required
                >
              </div>
            </div>
          </fieldset>

          <!-- 再生能源电量统计 -->
          <fieldset>
            <legend>{{ year }}年再生能源电量统计 (kWh)</legend>
            <div class="monthly-grid">
              <div v-for="(_, index) in formData.renewableEnergyPower" :key="index" class="month-input">
                <label>{{ getMonthName(index) }}</label>
                <input
                    type="number"
                    v-model.number="formData.renewableEnergyPower[index]"
                    :placeholder="`${getMonthName(index)}再生能源电量`"
                    min="0"
                    step="1"
                    :readonly="!isEditing"
                    :class="{ 'editable-field': isEditing }"
                    required
                >
              </div>
            </div>
          </fieldset>

          <!-- 汽油用量统计 -->
          <fieldset>
            <legend>{{ year }}年汽油用量统计 (T)</legend>
            <div class="monthly-grid">
              <div v-for="(_, index) in formData.gasoline" :key="index" class="month-input">
                <label>{{ getMonthName(index) }}</label>
                <input
                    type="number"
                    v-model.number="formData.gasoline[index]"
                    :placeholder="`${getMonthName(index)}汽油用量`"
                    min="0"
                    step="1"
                    :readonly="!isEditing"
                    :class="{ 'editable-field': isEditing }"
                    required
                >
              </div>
            </div>
          </fieldset>

          <!-- 柴油用量统计 -->
          <fieldset>
            <legend>{{ year }}年柴油用量统计 (T)</legend>
            <div class="monthly-grid">
              <div v-for="(_, index) in formData.diesel" :key="index" class="month-input">
                <label>{{ getMonthName(index) }}</label>
                <input
                    type="number"
                    v-model.number="formData.diesel[index]"
                    :placeholder="`${getMonthName(index)}柴油用量`"
                    min="0"
                    step="1"
                    :readonly="!isEditing"
                    :class="{ 'editable-field': isEditing }"
                    required
                >
              </div>
            </div>
          </fieldset>

          <!-- 天然气用量统计 -->
          <fieldset>
            <legend>{{ year }}年天然气用量统计 (m³)</legend>
            <div class="monthly-grid">
              <div v-for="(_, index) in formData.naturalGas" :key="index" class="month-input">
                <label>{{ getMonthName(index) }}</label>
                <input
                    type="number"
                    v-model.number="formData.naturalGas[index]"
                    :placeholder="`${getMonthName(index)}天然气用量`"
                    min="0"
                    step="1"
                    :readonly="!isEditing"
                    :class="{ 'editable-field': isEditing }"
                    required
                >
              </div>
            </div>
          </fieldset>

          <!-- 其他能源用量统计 -->
          <fieldset>
            <legend>{{ year }}年其他能源用量统计 (Tce)</legend>
            <div class="monthly-grid">
              <div v-for="(_, index) in formData.otherEnergy" :key="index" class="month-input">
                <label>{{ getMonthName(index) }}</label>
                <input
                    type="number"
                    v-model.number="formData.otherEnergy[index]"
                    :placeholder="`${getMonthName(index)}其他能源用量`"
                    min="0"
                    step="1"
                    :readonly="!isEditing"
                    :class="{ 'editable-field': isEditing }"
                    required
                >
              </div>
            </div>
          </fieldset>

          <!-- 能源消耗合计 -->
          <fieldset class="summary-fieldset">
            <legend>{{ year }}年综合能耗合计</legend>
            <div class="form-row">
              <div class="form-group">
                <label>水 (Tce)</label>
                <input type="number" v-model.number="formData.waterConsumption" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>煤炭 (Tce)</label>
                <input type="number" v-model.number="formData.coalConsumption" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
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
                <label>合计 (Tce)</label>
                <input type="number" :value="totalEnergyConsumption" disabled class="calculated-field">
              </div>
              <div class="form-group">
                <label>营业额 (万元)</label>
                <input type="number" v-model.number="formData.turnover" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>能源消耗强度 (Tce/万元)</label>
                <input type="number" :value="energyConsumptionIntensity" disabled class="calculated-field">
              </div>
            </div>
          </fieldset>
        </div>
      </fieldset>
    </form>
  </div>
</template>

<script setup>
import {computed, onBeforeUnmount, onMounted, ref, watch} from 'vue'
import axios from 'axios'
import {useSelectionStore} from "@/stores/selectionStore.js";

const selectionStore = useSelectionStore();
const factory = computed(() => selectionStore.selectedFactory);
const factories = computed(() => selectionStore.factories);
const year = computed(() => selectionStore.selectedYear);
const years = computed(() => selectionStore.years);
const isEditing = ref(false);
const isLoading = ref(false);

// 月份名称映射
const monthNames = [
  '1月', '2月', '3月', '4月', '5月', '6月',
  '7月', '8月', '9月', '10月', '11月', '12月'
];

// 获取月份名称
const getMonthName = (index) => {
  return monthNames[index];
};

// 表单数据结构
const formData = ref({
  purchasedPower: Array(12).fill(0),
  renewableEnergyPower: Array(12).fill(0),
  gasoline: Array(12).fill(0),
  diesel: Array(12).fill(0),
  naturalGas: Array(12).fill(0),
  otherEnergy: Array(12).fill(0),
  waterConsumption: 0,
  coalConsumption: 0,
  turnover: 0
});

// 计算各种能源的年度合计值
const totalPurchasedPower = computed(() => formData.value.purchasedPower.reduce((sum, power) => sum + power, 0));
const totalRenewablePower = computed(() => formData.value.renewableEnergyPower.reduce((sum, energy) => sum + energy, 0));
const totalGasoline = computed(() => formData.value.gasoline.reduce((sum, amount) => sum + amount, 0));
const totalDiesel = computed(() => formData.value.diesel.reduce((sum, amount) => sum + amount, 0));
const totalNaturalGas = computed(() => formData.value.naturalGas.reduce((sum, amount) => sum + amount, 0));
const totalOtherEnergy = computed(() => formData.value.otherEnergy.reduce((sum, amount) => sum + amount, 0));

// 计算各种能源的消耗量 (Tce)
const powerConsumption = computed(() => (totalPurchasedPower.value + totalRenewablePower.value) * 0.1229 / 1000);
const gasolineConsumption = computed(() => totalGasoline.value * 1.4717);
const dieselConsumption = computed(() => totalDiesel.value * 1.4571);
const naturalGasConsumption = computed(() => totalNaturalGas.value * 1.33 / 1000);
const totalEnergyConsumption = computed(() =>
    formData.value.waterConsumption +
    formData.value.coalConsumption +
    powerConsumption.value +
    gasolineConsumption.value +
    dieselConsumption.value +
    naturalGasConsumption.value +
    totalOtherEnergy.value
);
const energyConsumptionIntensity = computed(() => {
  if (formData.value.turnover <= 0) return 0;
  return totalEnergyConsumption.value / formData.value.turnover;
});

// 监听工厂和年份变化
watch([factory, year], () => {
  fetchData();
});

onMounted(() => {
  selectionStore.initYears();
  document.addEventListener("click", selectionStore.handleClickOutside);
});
onBeforeUnmount(() => {
  document.removeEventListener("click", selectionStore.handleClickOutside);
});

// 获取数据方法
const fetchData = async () => {
  if (!factory.value || !year.value) {
    resetFormData();
    return;
  }
  isLoading.value = true;
  try {
    const response = await axios.get(`http://localhost:8000/quantitative/energy`, {
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
        waterConsumption: data.water_consumption || 0,
        coalConsumption: data.coal_consumption || 0,
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
    waterConsumption: 0,
    coalConsumption: 0,
    turnover: 0
  };
};

// 提交编辑方法
const submitEdit = async () => {
  try {
    // 准备提交的数据，确保字段名与后端一致
    const payload = {
      factory: factory.value,
      year: year.value,
      purchasedPower: formData.value.purchasedPower,
      renewableEnergyPower: formData.value.renewableEnergyPower,
      gasoline: formData.value.gasoline,
      diesel: formData.value.diesel,
      naturalGas: formData.value.naturalGas,
      otherEnergy: formData.value.otherEnergy,
      totalPurchasedPower: totalPurchasedPower.value,
      totalRenewablePower: totalRenewablePower.value,
      totalGasoline: totalGasoline.value,
      totalDiesel: totalDiesel.value,
      totalNaturalGas: totalNaturalGas.value,
      totalOtherEnergy: totalOtherEnergy.value,
      waterConsumption: formData.value.waterConsumption,
      coalConsumption: formData.value.coalConsumption,
      powerConsumption: powerConsumption.value,
      gasolineConsumption: gasolineConsumption.value,
      dieselConsumption: dieselConsumption.value,
      naturalGasConsumption: naturalGasConsumption.value,
      totalEnergyConsumption: totalEnergyConsumption.value,
      turnover: formData.value.turnover,
      energyConsumptionIntensity: energyConsumptionIntensity.value
    };
    const response = await axios.post('http://localhost:8000/quantitative/energy', payload);
    if (response.data.status === 'success') {
      alert('数据提交成功!');
    }
  } catch (error) {
    console.error('提交失败:', error);
    alert(`提交失败: ${error.response?.data?.detail || error.message}`);
  }finally {
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
