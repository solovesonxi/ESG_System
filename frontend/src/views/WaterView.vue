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

      <!-- 工业用水表格 -->
      <fieldset>
        <legend>{{ year }}年用水量统计 - 工业用水</legend>
        <div class="monthly-grid">
          <div v-for="(_, index) in monthlyWater.industrial" :key="`title-${index}`">
            <label>{{ getMonthName(index) }}</label>
            <input
                type="number"
                v-model.number="monthlyWater.industrial[index]"
                min="0"
                step="1"
                required
            >
          </div>
          <div class="metric-group">
            <label>合计 (T)</label>
            <input type="number" v-model.number="waterData.industrialTotal" disabled>
          </div>
          <div class="metric-group">
            <label>排水量 (T)</label>
            <input type="number" v-model.number="waterData.industrialDrainage" step="1" min="0">
          </div>
          <div class="metric-group">
            <label>耗水量 (T)</label>
            <input type="number" v-model.number="waterData.industrialConsumption" step="1" min="0">
          </div>
          <div class="metric-group">
            <label>循环水用量 (T)</label>
            <input type="number" v-model.number="waterData.industrialRecycled" step="1" min="0">
          </div>

        </div>
      </fieldset>

      <!-- 生活用水表格 -->
      <fieldset>
        <legend>{{ year }}年用水量统计 - 生活用水</legend>
        <div class="water-grid">
          <!-- 月份标题行 -->
          <div class="month-title-row">
            <div class="month-title" v-for="(_, index) in monthlyWater.domestic" :key="`title-${index}`">
              {{ getMonthName(index) }}
            </div>
            <div class="summary-title">合计</div>
          </div>

          <!-- 月度用水量 -->
          <div class="month-input-row">
            <div class="input-cell" v-for="(_, index) in monthlyWater.domestic" :key="`input-${index}`">
              <input
                  type="number"
                  v-model.number="monthlyWater.domestic[index]"
                  min="0"
                  step="1"
                  required
              >
            </div>
            <div class="summary-cell">
              <input type="number" :value="domesticTotal" disabled>
            </div>
          </div>

          <!-- 指标输入区 -->
          <div class="water-metrics">
            <div class="metric-group">
              <label>排水量 (T)</label>
              <input type="number" v-model.number="waterData.domesticDrainage" step="1" min="0">
            </div>
            <div class="metric-group">
              <label>耗水量 (T)</label>
              <input type="number" v-model.number="waterData.domesticConsumption" step="1" min="0">
            </div>
            <div class="metric-group">
              <label>循环水用量 (T)</label>
              <input type="number" v-model.number="waterData.domesticRecycled" step="1" min="0">
            </div>
          </div>
        </div>
      </fieldset>

      <!-- 用水量汇总表格 -->
      <fieldset class="summary-fieldset">
        <legend>{{ year }}年用水量统计 - 汇总</legend>
        <div class="water-grid">
          <!-- 月份标题行 -->
          <div class="month-title-row">
            <div class="month-title" v-for="(_, index) in monthlyWater.total" :key="`title-${index}`">
              {{ getMonthName(index) }}
            </div>
            <div class="summary-title">合计</div>
          </div>

          <!-- 月度用水量（自动计算） -->
          <div class="month-input-row">
            <div class="input-cell" v-for="(_, index) in monthlyWater.total" :key="`total-${index}`">
              <input
                  type="number"
                  :value="monthlyWater.total[index]"
                  disabled
              >
            </div>
            <div class="summary-cell">
              <input type="number" :value="totalIntake" disabled>
            </div>
          </div>

          <!-- 汇总指标 -->
          <div class="water-metrics">
            <div class="metric-group">
              <label>总排水量 (T)</label>
              <input type="number" :value="totalDrainage" disabled>
            </div>
            <div class="metric-group">
              <label>总耗水量 (T)</label>
              <input type="number" :value="totalConsumption" disabled>
            </div>
            <div class="metric-group">
              <label>总循环水用量 (T)</label>
              <input type="number" :value="totalRecycled" disabled>
            </div>
          </div>

          <!-- 计算结果 -->
          <div class="water-results">
            <div class="metric-group">
              <label>用水强度 (T/万元)</label>
              <input type="number" :value="waterIntensity" disabled>
            </div>
            <div class="metric-group">
              <label>水资源回收率 (%)</label>
              <input type="number" :value="waterRecycleRate" disabled>
            </div>
          </div>
        </div>

        <!-- 营业收入输入 -->
        <div class="revenue-input">
          <div class="form-group">
            <label>营业收入 (万元)</label>
            <input type="number" v-model.number="waterData.totalRevenue" step="1" min="0">
          </div>
        </div>
      </fieldset>

      <!-- 中水总量统计表格 -->
      <fieldset>
        <legend>{{ year }}年中水总量统计</legend>
        <div class="water-grid">
          <!-- 月份标题行 -->
          <div class="month-title-row">
            <div class="month-title" v-for="(_, index) in monthlyWater.reclaimed" :key="`title-${index}`">
              {{ getMonthName(index) }}
            </div>
            <div class="summary-title">合计</div>
          </div>

          <!-- 月度中水量 -->
          <div class="month-input-row">
            <div class="input-cell" v-for="(_, index) in monthlyWater.reclaimed" :key="`reclaimed-${index}`">
              <input
                  type="number"
                  v-model.number="monthlyWater.reclaimed[index]"
                  min="0"
                  step="1"
                  required
              >
            </div>
            <div class="summary-cell">
              <input type="number" :value="reclaimedTotal" disabled>
            </div>
          </div>

          <!-- 中水指标 -->
          <div class="water-metrics">
            <div class="metric-group">
              <label>总中水用水量 (T)</label>
              <input type="number" v-model.number="waterData.reclaimedUsage" step="1" min="0">
            </div>
            <div class="metric-group">
              <label>中水用水强度 (T/万元)</label>
              <input type="number" :value="reclaimedIntensity" disabled>
            </div>
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
import {computed, onBeforeUnmount, onMounted, reactive, ref, watch} from 'vue'
import axios from 'axios'
import {useSelectionStore} from '@/stores/selectionStore'

const selectionStore = useSelectionStore();
const factory = computed(() => selectionStore.selectedFactory);
const factories = computed(() => selectionStore.factories);
const year = computed(() => selectionStore.selectedYear);
const years = computed(() => selectionStore.years);
const isSubmitting = ref(false);
// 月份名称
const monthNames = [
  '1月', '2月', '3月', '4月', '5月', '6月',
  '7月', '8月', '9月', '10月', '11月', '12月'
];

// 获取月份名称
const getMonthName = (index) => monthNames[index];

// 初始化数据
const monthlyWater = reactive({
  industrial: Array(12).fill(0),    // 工业用水月度取水量
  domestic: Array(12).fill(0),      // 生活用水月度取水量
  total: Array(12).fill(0),         // 总用水量月度值（自动计算）
  reclaimed: Array(12).fill(0)      // 中水月度用量
});

// 自动更新总用水量月度数据
watch([() => monthlyWater.industrial, () => monthlyWater.domestic], () => {
  for (let i = 0; i < 12; i++) {
    monthlyWater.total[i] = monthlyWater.industrial[i] + monthlyWater.domestic[i];
  }
}, {deep: true});

// 年度指标数据
const waterData = reactive({
  // 工业用水指标
  industrialTotal: 0,         // 工业总量
  industrialDrainage: 0,         // 工业排水量
  industrialConsumption: 0,       // 工业耗水量
  industrialRecycled: 0,          // 工业循环水用量

  // 生活用水指标
  domesticTotal: 0,            // 生活总量
  domesticDrainage: 0,            // 生活排水量
  domesticConsumption: 0,         // 生活耗水量
  domesticRecycled: 0,            // 生活循环水用量

  // 经济指标
  totalRevenue: 0,                // 营业收入

  // 中水指标
  reclaimedUsage: 0               // 总中水用水量
});

// 计算工业用水合计
const industrialTotal = computed(() => {
  return monthlyWater.industrial.reduce((sum, val) => sum + val, 0);
});

// 计算生活用水合计
const domesticTotal = computed(() => {
  return monthlyWater.domestic.reduce((sum, val) => sum + val, 0);
});

// 计算总取水量
const totalIntake = computed(() => {
  return industrialTotal.value + domesticTotal.value;
});

// 计算中水取水量合计
const reclaimedTotal = computed(() => {
  return monthlyWater.reclaimed.reduce((sum, val) => sum + val, 0);
});

// 计算总排水量
const totalDrainage = computed(() => {
  return waterData.industrialDrainage + waterData.domesticDrainage;
});

// 计算总耗水量
const totalConsumption = computed(() => {
  return waterData.industrialConsumption + waterData.domesticConsumption;
});

// 计算总循环水量
const totalRecycled = computed(() => {
  return waterData.industrialRecycled + waterData.domesticRecycled;
});

// 计算用水强度
const waterIntensity = computed(() => {
  if (waterData.totalRevenue > 0 && totalIntake.value > 0) {
    return (totalIntake.value / waterData.totalRevenue).toFixed(2);
  }
  return 0;
});

// 计算水资源回收率
const waterRecycleRate = computed(() => {
  if (totalIntake.value > 0 && totalRecycled.value > 0) {
    return ((totalRecycled.value / totalIntake.value) * 100).toFixed(2);
  }
  return 0;
});

// 计算中水用水强度
const reclaimedIntensity = computed(() => {
  if (waterData.totalRevenue > 0 && waterData.reclaimedUsage > 0) {
    return (waterData.reclaimedUsage / waterData.totalRevenue).toFixed(2);
  }
  return 0;
});

// 下拉框处理方法


// 提交表单
async function submitForm() {
  isSubmitting.value = true;
  try {
    const payload = {
      factory: factory.value,
      year: year.value,
      // 月度数据
      industrial: [...monthlyWater.industrial],
      domestic: [...monthlyWater.domestic],
      reclaimed: [...monthlyWater.reclaimed],
      // 工业用水指标
      industrialDrainage: waterData.industrialDrainage,
      industrialConsumption: waterData.industrialConsumption,
      industrialRecycled: waterData.industrialRecycled,
      // 生活用水指标
      domesticDrainage: waterData.domesticDrainage,
      domesticConsumption: waterData.domesticConsumption,
      domesticRecycled: waterData.domesticRecycled,
      // 经济指标
      totalRevenue: waterData.totalRevenue,
      // 中水指标
      reclaimedUsage: waterData.reclaimedUsage,
      // 自动计算的指标
      industrialTotal: industrialTotal.value,
      domesticTotal: domesticTotal.value,
      totalIntake: totalIntake.value,
      reclaimedTotal: reclaimedTotal.value,
      waterIntensity: waterIntensity.value,
      waterRecycleRate: waterRecycleRate.value,
      reclaimedIntensity: reclaimedIntensity.value
    };

    const response = await axios.post('http://localhost:8000/submit/water', payload);

    if (response.data.status === 'success') {
      alert('水资源数据提交成功!');
    }
  } catch (error) {
    console.error('提交失败:', error);
    alert(`提交失败: ${error.response?.data?.detail || error.message}`);
  } finally {
    isSubmitting.value = false;
  }
}

onMounted(() => {
  selectionStore.initYears();
  document.addEventListener('click', selectionStore.handleClickOutside);
});

onBeforeUnmount(() => {
  document.removeEventListener('click', selectionStore.handleClickOutside);
});
</script>
