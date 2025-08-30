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

      <!-- 工业用水表格 -->
      <fieldset>
        <legend>{{ year }}年用水量统计 - 工业用水 (T)</legend>
        <div class="monthly-grid">
          <div v-for="(_, index) in monthlyWater.industrial" :key="`title-${index}`">
            <label>{{ getMonthName(index) }}</label>
            <input
                type="number"
                v-model.number="monthlyWater.industrial[index]"
                :placeholder="`${getMonthName(index)}工业用水量`"
                min="0"
                step="1"
                :readonly="!isEditing"
                :class="{ 'editable-field': isEditing }"
                required
            >
          </div>
          <div>
            <label>排水量</label>
            <input type="number" v-model.number="waterData.industrialDrainage" step="1" min="0"
                :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
          </div>
          <div>
            <label>耗水量</label>
            <input type="number" v-model.number="waterData.industrialConsumption" step="1" min="0"
                :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
          </div>
          <div>
            <label>循环水用量</label>
            <input type="number" v-model.number="waterData.industrialRecycled" step="1" min="0"
                :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
          </div>
          <div>
            <label>合计</label>
            <input type="number" :value="industrialTotal" disabled class="calculated-field">
          </div>
        </div>
      </fieldset>

      <!-- 生活用水表格 -->
      <fieldset>
        <legend>{{ year }}年用水量统计 - 生活用水 (T)</legend>
        <div class="monthly-grid">
          <div v-for="(_, index) in monthlyWater.domestic" :key="`title-${index}`">
            <label>{{ getMonthName(index) }}</label>
            <input
                type="number"
                v-model.number="monthlyWater.domestic[index]"
                :placeholder="`${getMonthName(index)}生活用水量`"
                min="0"
                step="1"
                :readonly="!isEditing"
                :class="{ 'editable-field': isEditing }"
                required
            >
          </div>
          <div>
            <label>排水量</label>
            <input type="number" v-model.number="waterData.domesticDrainage" step="1" min="0"
                :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
          </div>
          <div>
            <label>耗水量</label>
            <input type="number" v-model.number="waterData.domesticConsumption" step="1" min="0"
                :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
          </div>
          <div>
            <label>循环水用量</label>
            <input type="number" v-model.number="waterData.domesticRecycled" step="1" min="0"
                :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
          </div>
          <div>
            <label>合计</label>
            <input type="number" :value="domesticTotal" disabled class="calculated-field">
          </div>
        </div>
      </fieldset>

      <!-- 中水总量统计表格 -->
      <fieldset>
        <legend>{{ year }}年中水总量统计</legend>
        <div class="monthly-grid">
          <div class="month-title" v-for="(_, index) in monthlyWater.reclaimed" :key="`title-${index}`">
            <label>{{ getMonthName(index) }} (T)</label>
            <input
                type="number"
                v-model.number="monthlyWater.reclaimed[index]"
                :placeholder="`${getMonthName(index)}再生水用量`"
                min="0"
                step="1"
                :readonly="!isEditing"
                :class="{ 'editable-field': isEditing }"
                required
            >
          </div>
          <div class="form-group">
            <label>营业收入 (万元)</label>
            <input type="number" v-model.number="waterData.totalRevenue" step="1" min="0"
                   :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
          </div>
          <div>
            <label>总中水用水量 (T)</label>
            <input type="number" :value="reclaimedTotal" disabled class="calculated-field">
          </div>

          <div>
            <label>中水用水强度 (T/万元)</label>
            <input type="number" :value="reclaimedIntensity" disabled class="calculated-field">
          </div>
        </div>
      </fieldset>

      <!-- 用水量汇总表格 -->
      <fieldset class="summary-fieldset">
        <legend>{{ year }}年用水量统计 - 汇总</legend>
        <div class="monthly-grid">
          <div v-for="(_, index) in monthlyWater.total" :key="`title-${index}`">
            <label>{{ getMonthName(index) }} (T)</label>
            <input
                type="number"
                v-model.number="monthlyWater.total[index]"
                min="0" disabled class="calculated-field"
            >
          </div>
          <div>
            <label>合计 (T)</label>
            <input type="number" :value="totalIntake" disabled class="calculated-field">
          </div>
          <div>
            <label>总排水量 (T)</label>
            <input type="number" :value="totalDrainage" disabled class="calculated-field">
          </div>
          <div>
            <label>总耗水量 (T)</label>
            <input type="number" :value="totalConsumption" disabled class="calculated-field">
          </div>
          <div>
            <label>总循环水用量 (T)</label>
            <input type="number" :value="totalRecycled" disabled class="calculated-field">
          </div>
          <div>
            <label>用水强度 (T/万元)</label>
            <input type="number" :value="waterIntensity" disabled class="calculated-field">
          </div>
          <div>
            <label>水资源回收率 (%)</label>
            <input type="number" :value="waterRecycleRate" disabled class="calculated-field">
          </div>

        </div>
      </fieldset>
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
const isEditing = ref(false);
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
  reclaimed: Array(12).fill(0),      // 中水月度用量
  total: Array(12).fill(0)         // 总用水量月度值（自动计算）
});

watch([() => monthlyWater.industrial, () => monthlyWater.domestic], () => {
  for (let i = 0; i < 12; i++) {
    monthlyWater.total[i] = monthlyWater.industrial[i] + monthlyWater.domestic[i];
  }
}, {deep: true});

// 年度指标数据
const waterData = reactive({
  // 工业用水指标
  industrialDrainage: 0,         // 工业排水量
  industrialConsumption: 0,       // 工业耗水量
  industrialRecycled: 0,          // 工业循环水用量

  // 生活用水指标
  domesticDrainage: 0,            // 生活排水量
  domesticConsumption: 0,         // 生活耗水量
  domesticRecycled: 0,            // 生活循环水用量

  totalRevenue: 0,                // 营业收入
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
    return (totalIntake.value / waterData.totalRevenue);
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
  if (waterData.totalRevenue > 0 && reclaimedTotal.value > 0) {
    return (reclaimedTotal.value / waterData.totalRevenue).toFixed(2);
  }
  return 0;
});


// 获取数据方法
const fetchData = async () => {
  if (!factory.value || !year.value) {
    resetFormData();
    return;
  }
  try {
    const response = await axios.get(`http://localhost:8000/quantitative/water`, {
      params: { factory: factory.value, year: year.value }
    });
    if (response.data && response.data.data) {
      const data = response.data.data;
      monthlyWater.industrial = data.industrial || Array(12).fill(0);
      monthlyWater.domestic = data.domestic || Array(12).fill(0);
      monthlyWater.reclaimed = data.reclaimed || Array(12).fill(0);
      monthlyWater.total = data.total || Array(12).fill(0);
      waterData.industrialDrainage = data.industrialDrainage || 0;
      waterData.industrialConsumption = data.industrialConsumption || 0;
      waterData.industrialRecycled = data.industrialRecycled || 0;
      waterData.domesticDrainage = data.domesticDrainage || 0;
      waterData.domesticConsumption = data.domesticConsumption || 0;
      waterData.domesticRecycled = data.domesticRecycled || 0;
      waterData.totalRevenue = data.totalRevenue || 0;
    } else {
      resetFormData();
    }
  } catch (error) {
    if (error.response?.status === 404) {
      resetFormData();
    } else {
      console.error('获取数据失败:', error);
    }
  }
};

// 重置表单数据
const resetFormData = () => {
  monthlyWater.industrial = Array(12).fill(0);
  monthlyWater.domestic = Array(12).fill(0);
  monthlyWater.reclaimed = Array(12).fill(0);
  monthlyWater.total = Array(12).fill(0);
  waterData.industrialDrainage = 0;
  waterData.industrialConsumption = 0;
  waterData.industrialRecycled = 0;
  waterData.domesticDrainage = 0;
  waterData.domesticConsumption = 0;
  waterData.domesticRecycled = 0;
  waterData.totalRevenue = 0;
};

// 提交表单
async function submitEdit() {
  try {
    const payload = {
      factory: factory.value,
      year: year.value,
      // 月度数据
      industrial: [...monthlyWater.industrial],
      domestic: [...monthlyWater.domestic],
      reclaimed: [...monthlyWater.reclaimed],
      total: [...monthlyWater.total],
      // 工业用水指标
      industrialTotal: industrialTotal.value,
      industrialDrainage: waterData.industrialDrainage,
      industrialConsumption: waterData.industrialConsumption,
      industrialRecycled: waterData.industrialRecycled,
      // 生活用水指标
      domesticTotal: domesticTotal.value,
      domesticDrainage: waterData.domesticDrainage,
      domesticConsumption: waterData.domesticConsumption,
      domesticRecycled: waterData.domesticRecycled,

      // 中水指标
      reclaimedTotal: reclaimedTotal.value,
      totalRevenue: waterData.totalRevenue,
      reclaimedIntensity: reclaimedIntensity.value,

      totalIntake: totalIntake.value,
      totalDrainage: totalDrainage.value,
      totalConsumption: totalConsumption.value,
      totalRecycled: totalRecycled.value,
      waterIntensity: waterIntensity.value,
      waterRecycleRate: waterRecycleRate.value
    };
    const response = await axios.post('http://localhost:8000/quantitative/water', payload);
    if (response.data.status === 'success') {
      alert('水资源数据提交成功!');
    }
  } catch (error) {
    console.error('提交失败:', error);
    alert(`提交失败: ${error.response?.data?.detail || error.message}`);
  } finally {
    console.log('提交完成，即将刷新');
    isEditing.value = false;
    await fetchData();
  }
}


// 监听工厂和年份变化
watch([factory, year], () => {
  fetchData();
});

onMounted(() => {
  selectionStore.initYears();
  document.addEventListener('click', selectionStore.handleClickOutside);
  fetchData();
});

onBeforeUnmount(() => {
  document.removeEventListener('click', selectionStore.handleClickOutside);
});

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
