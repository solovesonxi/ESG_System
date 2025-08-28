<template>
  <div class="shared-form">
    <form @submit.prevent="submitForm">
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
              <div class="options" v-show="selectionStore.showFactoryDropdown" :style="{ maxHeight: '200px', overflowY: 'auto' }">
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


      <!-- 外购电量统计 -->
      <fieldset>
        <legend>{{ year }}年外购电量统计 (kWh)</legend>
        <div class="monthly-grid">
          <div v-for="(month, index) in purchasedPower" :key="index" class="month-input">
            <label>{{ getMonthName(index) }}</label>
            <input
                type="number"
                v-model.number="purchasedPower[index]"
                :placeholder="`${getMonthName(index)}电量`"
                min="0"
                step="1"
                required
            >
          </div>
        </div>
      </fieldset>

      <!-- 再生能源电量统计 -->
      <fieldset>
        <legend>{{ year }}年再生能源电量统计 (kWh)</legend>
        <div class="monthly-grid">
          <div v-for="(month, index) in renewableEnergyPower" :key="index" class="month-input">
            <label>{{ getMonthName(index) }}</label>
            <input
                type="number"
                v-model.number="renewableEnergyPower[index]"
                :placeholder="`${getMonthName(index)}再生能源电量`"
                min="0"
                step="1"
                required
            >
          </div>
        </div>
      </fieldset>

      <!-- 汽油用量统计 -->
      <fieldset>
        <legend>{{ year }}年汽油用量统计 (T)</legend>
        <div class="monthly-grid">
          <div v-for="(month, index) in gasoline" :key="index" class="month-input">
            <label>{{ getMonthName(index) }}</label>
            <input
                type="number"
                v-model.number="gasoline[index]"
                :placeholder="`${getMonthName(index)}汽油用量`"
                min="0"
                step="1"
                required
            >
          </div>
        </div>
      </fieldset>

      <!-- 柴油用量统计 -->
      <fieldset>
        <legend>{{ year }}年柴油用量统计 (T)</legend>
        <div class="monthly-grid">
          <div v-for="(month, index) in diesel" :key="index" class="month-input">
            <label>{{ getMonthName(index) }}</label>
            <input
                type="number"
                v-model.number="diesel[index]"
                :placeholder="`${getMonthName(index)}柴油用量`"
                min="0"
                step="1"
                required
            >
          </div>
        </div>
      </fieldset>

      <!-- 天然气用量统计 -->
      <fieldset>
        <legend>{{ year }}年天然气用量统计 (m³)</legend>
        <div class="monthly-grid">
          <div v-for="(month, index) in naturalGas" :key="index" class="month-input">
            <label>{{ getMonthName(index) }}</label>
            <input
                type="number"
                v-model.number="naturalGas[index]"
                :placeholder="`${getMonthName(index)}天然气用量`"
                min="0"
                step="1"
                required
            >
          </div>
        </div>
      </fieldset>

      <!-- 其他能源用量统计 -->
      <fieldset>
        <legend>{{ year }}年其他能源用量统计 (Tce)</legend>
        <div class="monthly-grid">
          <div v-for="(month, index) in otherEnergy" :key="index" class="month-input">
            <label>{{ getMonthName(index) }}</label>
            <input
                type="number"
                v-model.number="otherEnergy[index]"
                :placeholder="`${getMonthName(index)}其他能源用量`"
                min="0"
                step="1"
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
            <input type="number" v-model.number="waterConsumption" step="1" required>
          </div>
          <div class="form-group">
            <label>煤炭 (Tce)</label>
            <input type="number" v-model.number="coalConsumption" step="1" required>
          </div>
          <div class="form-group">
            <label>电 (Tce)</label>
            <input type="number" :value="powerConsumption" disabled>
          </div>
          <div class="form-group">
            <label>汽油 (Tce)</label>
            <input type="number" :value="gasolineConsumption" disabled>
          </div>
          <div class="form-group">
            <label>柴油 (Tce)</label>
            <input type="number" :value="dieselConsumption" disabled>
          </div>
          <div class="form-group">
            <label>天然气 (Tce)</label>
            <input type="number" :value="naturalGasConsumption" disabled>
          </div>
          <div class="form-group">
            <label>其他能源 (Tce)</label>
            <input type="number" :value="totalOtherEnergy" disabled>
          </div>
          <div class="form-group">
            <label>合计 (Tce)</label>
            <input type="number" :value="totalEnergyConsumption" disabled>
          </div>
          <div class="form-group">
            <label>营业额 (万元)</label>
            <input type="number" v-model.number="turnover" step="1" required>
          </div>
          <div class="form-group">
            <label>能源消耗强度 (Tce/万元)</label>
            <input type="number" :value="energyConsumptionIntensity" disabled>
          </div>
        </div>
      </fieldset>

      <button type="submit" :disabled="isSubmitting">
        {{ isSubmitting ? '提交中...' : '提交数据' }}
      </button>
    </form>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, onBeforeUnmount, computed } from 'vue'
import axios from 'axios'
import { useSelectionStore } from "@/stores/selectionStore.js";

const selectionStore = useSelectionStore();
const factory = computed(() => selectionStore.selectedFactory);
const factories = computed(() => selectionStore.factories);
const year = computed(() => selectionStore.selectedYear);
const years = computed(() => selectionStore.years);
const isSubmitting = ref(false);

// 初始化年份列表
onMounted(() => {
  selectionStore.initYears();
  document.addEventListener('click', selectionStore.handleClickOutside);
});

onBeforeUnmount(() => {
  document.removeEventListener('click', selectionStore.handleClickOutside);
});


// 各种能源的数据
const purchasedPower = reactive(Array(12).fill(0)); // 外购电量 (kWh)
const renewableEnergyPower = reactive(Array(12).fill(0)); // 再生能源电量 (kWh)
const gasoline = reactive(Array(12).fill(0)); // 汽油 (T)
const diesel = reactive(Array(12).fill(0)); // 柴油 (T)
const naturalGas = reactive(Array(12).fill(0)); // 天然气 (m³)
const otherEnergy = reactive(Array(12).fill(0)); // 其他能源 (Tce)

// 月份名称映射
const monthNames = [
  '1月', '2月', '3月', '4月', '5月', '6月',
  '7月', '8月', '9月', '10月', '11月', '12月'
];

// 获取月份名称
const getMonthName = (index) => {
  return monthNames[index];
};

// 计算各种能源的年度合计值
const totalPurchasedPower = computed(() => purchasedPower.reduce((sum, power) => sum + power, 0));
const totalRenewablePower = computed(() => renewableEnergyPower.reduce((sum, energy) => sum + energy, 0));
const totalGasoline = computed(() => gasoline.reduce((sum, amount) => sum + amount, 0));
const totalDiesel = computed(() => diesel.reduce((sum, amount) => sum + amount, 0));
const totalNaturalGas = computed(() => naturalGas.reduce((sum, amount) => sum + amount, 0));
const totalOtherEnergy = computed(() => otherEnergy.reduce((sum, amount) => sum + amount, 0));

const waterConsumption = ref(0);
const coalConsumption = ref(0);
const powerConsumption = computed(()=>(totalPurchasedPower.value+totalRenewablePower.value) * 0.1229 / 1000);
const gasolineConsumption = computed(()=>totalGasoline.value * 1.4717);
const dieselConsumption = computed(()=>totalDiesel.value * 1.4571);
const naturalGasConsumption = computed(()=>totalNaturalGas.value * 1.33 / 1000);
const totalEnergyConsumption = computed(() => waterConsumption.value +coalConsumption.value+ powerConsumption.value + gasolineConsumption.value +
    dieselConsumption.value + naturalGasConsumption.value + totalOtherEnergy.value);
const turnover = ref(0);
const energyConsumptionIntensity = computed(() => {
  if (turnover.value <= 0) return 0;
  return totalEnergyConsumption.value / turnover.value;
});


// 提交表单
async function submitForm() {
  isSubmitting.value = true;
  try {
    const payload = {
      factory: factory.value,
      year: year.value,
      purchasedPower: [...purchasedPower],
      renewableEnergyPower: [...renewableEnergyPower],
      gasoline: [...gasoline],
      diesel: [...diesel],
      naturalGas: [...naturalGas],
      otherEnergy: [...otherEnergy],

      totalPurchasedPower: totalPurchasedPower.value,
      totalRenewablePower: totalRenewablePower.value,
      totalGasoline: totalGasoline.value,
      totalDiesel: totalDiesel.value,
      totalNaturalGas: totalNaturalGas.value,
      totalOtherEnergy: totalOtherEnergy.value,

      waterConsumption: waterConsumption.value,
      coalConsumption: coalConsumption.value,
      powerConsumption: powerConsumption.value,
      gasolineConsumption: gasolineConsumption.value,
      dieselConsumption: dieselConsumption.value,
      naturalGasConsumption: naturalGasConsumption.value,
      totalEnergyConsumption: totalEnergyConsumption.value,
      turnover: turnover.value,
      energyConsumptionIntensity: energyConsumptionIntensity.value,
    };

    const response = await axios.post('http://localhost:8000/quantitative/energy', payload);

    if (response.data.status === 'success') {
      alert('能源数据提交成功!');
    }
  } catch (error) {
    console.error('提交失败:', error);
    alert(`提交失败: ${error.response?.data?.detail || error.message}`);
  } finally {
    isSubmitting.value = false;
  }
}
</script>
