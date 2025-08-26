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

      <!-- 数据展示部分 -->
      <fieldset class="summary-fieldset">
        <legend>物料</legend>
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
            <tr v-for="(indicatorKey, index) in Object.keys(materialData)" :key="index">
              <td>{{ materialIndicatorNames[indicatorKey] || indicatorKey }}</td>
              <td>{{ materialData[indicatorKey].lastYear || 'N/A' }}</td>
              <td>{{ materialData[indicatorKey].currentYear }}</td>
              <td>{{ formatComparison(materialData[indicatorKey].comparison) }}</td>
              <td>
                <span v-if="!isEditing">{{ materialData[indicatorKey].reason || 'N/A' }}</span>
                <textarea v-else v-model="tempMaterialReasons[indicatorKey]" class="reason-input"
                          :placeholder="materialData[indicatorKey]?.reason || ''"></textarea>
              </td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <fieldset class="summary-fieldset">
        <legend>能源</legend>
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
            <tr v-for="(indicatorKey, index) in Object.keys(energyData)" :key="index">
              <td>{{ energyIndicatorNames[indicatorKey] || indicatorKey }}</td>
              <td>{{ energyData[indicatorKey].lastYear || 'N/A' }}</td>
              <td>{{ energyData[indicatorKey].currentYear }}</td>
              <td>{{ formatComparison(energyData[indicatorKey].comparison) }}</td>
              <td>
                <span v-if="!isEditing">{{ energyData[indicatorKey].reason || 'N/A' }}</span>
                <textarea v-else v-model="tempEnergyReasons[indicatorKey]" class="reason-input"
                          :placeholder="energyData[indicatorKey]?.reason || ''"></textarea>
              </td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <fieldset class="summary-fieldset">
        <legend>水资源</legend>
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
            <tr v-for="(indicatorKey, index) in Object.keys(waterData)" :key="index">
              <td>{{ waterIndicatorNames[indicatorKey] || indicatorKey }}</td>
              <td>{{ waterData[indicatorKey].lastYear || 'N/A' }}</td>
              <td>{{ waterData[indicatorKey].currentYear }}</td>
              <td>{{ formatComparison(waterData[indicatorKey].comparison) }}</td>
              <td>
                <span v-if="!isEditing">{{ waterData[indicatorKey].reason || 'N/A' }}</span>
                <textarea v-else v-model="tempWaterReasons[indicatorKey]" class="reason-input"
                          :placeholder="waterData[indicatorKey]?.reason || ''"></textarea>
              </td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <fieldset class="summary-fieldset">
        <legend>排放</legend>
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
            <tr v-for="(indicatorKey, index) in Object.keys(emissionData)" :key="index">
              <td>{{ emissionIndicatorNames[indicatorKey] || indicatorKey }}</td>
              <td>{{ emissionData[indicatorKey].lastYear || 'N/A' }}</td>
              <td>{{ emissionData[indicatorKey].currentYear }}</td>
              <td>{{ formatComparison(emissionData[indicatorKey].comparison) }}</td>
              <td>
                <span v-if="!isEditing">{{ emissionData[indicatorKey].reason || 'N/A' }}</span>
                <textarea v-else v-model="tempEmissionReasons[indicatorKey]" class="reason-input"
                          :placeholder="emissionData[indicatorKey]?.reason || ''"></textarea>
              </td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <fieldset class="summary-fieldset">
        <legend>废弃物</legend>
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
            <tr v-for="(indicatorKey, index) in Object.keys(wasteData)" :key="index">
              <td>{{ wasteIndicatorNames[indicatorKey] || indicatorKey }}</td>
              <td>{{ wasteData[indicatorKey].lastYear || 'N/A' }}</td>
              <td>{{ wasteData[indicatorKey].currentYear }}</td>
              <td>{{ formatComparison(wasteData[indicatorKey].comparison) }}</td>
              <td>
                <span v-if="!isEditing">{{ wasteData[indicatorKey].reason || 'N/A' }}</span>
                <textarea v-else v-model="tempWasteReasons[indicatorKey]" class="reason-input"
                          :placeholder="wasteData[indicatorKey]?.reason || ''"></textarea>
              </td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <fieldset class="summary-fieldset">
        <legend>资金投入</legend>
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
            <tr v-for="(indicatorKey, index) in Object.keys(investmentData)" :key="index">
              <td>{{ investmentIndicatorNames[indicatorKey] || indicatorKey }}</td>
              <td>{{ investmentData[indicatorKey].lastYear || 'N/A' }}</td>
              <td>{{ investmentData[indicatorKey].currentYear || 'N/A'  }}</td>
              <td>{{ formatComparison(investmentData[indicatorKey].comparison) }}</td>
              <td>
                <span v-if="!isEditing">{{ investmentData[indicatorKey].reason || 'N/A' }}</span>
                <textarea v-else v-model="tempInvestmentReasons[indicatorKey]" class="reason-input"
                          :placeholder="investmentData[indicatorKey]?.reason || ''"></textarea>
              </td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <fieldset class="summary-fieldset">
        <legend>环境管理</legend>
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
            <tr v-for="(indicatorKey, index) in Object.keys(envQuantData)" :key="index">
              <td>{{ envQuantIndicatorNames[indicatorKey] || indicatorKey }}</td>
              <td>{{ envQuantData[indicatorKey].lastYear || 'N/A' }}</td>
              <td>{{ envQuantData[indicatorKey].currentYear || 'N/A'  }}</td>
              <td>{{ formatComparison(envQuantData[indicatorKey].comparison) }}</td>
              <td>
                <span v-if="!isEditing">{{ envQuantData[indicatorKey].reason || 'N/A' }}</span>
                <textarea v-else v-model="tempEnvQuantReasons[indicatorKey]" class="reason-input"
                          :placeholder="envQuantData[indicatorKey]?.reason || ''"></textarea>
              </td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <div class="edit-controls" @click="!isEditing && startEditing()">
        <button v-if="!isEditing" class="edit-button">✏️</button>
        <div v-else class="edit-actions">
          <button @click.stop="cancelEditing" class="cancel-button">取消</button>
          <button @click.stop="submitReasons" class="submit-button">提交</button>
        </div>
      </div>
    </form>
  </div>
</template>

<script setup>
import {computed, onMounted, ref} from 'vue';
import axios from 'axios';
import {useSelectionStore} from "@/stores/selectionStore.js";

const selectionStore = useSelectionStore();
const factory = computed(() => selectionStore.selectedFactory);
const factories = computed(() => selectionStore.factories);
const year = computed(() => selectionStore.selectedYear);
const years = computed(() => selectionStore.years);

const isEditing = ref(false)
const materialData = ref({})
const energyData = ref({})
const waterData = ref({})
const emissionData = ref({})
const wasteData = ref({})
const investmentData = ref({})
const envQuantData = ref({})
const tempMaterialReasons = ref({})
const tempEnergyReasons = ref({})
const tempWaterReasons = ref({})
const tempEmissionReasons = ref({})
const tempWasteReasons = ref({})
const tempInvestmentReasons = ref({})
const tempEnvQuantReasons = ref({})

// 物料指标名称映射
const materialIndicatorNames = {
  "renewable_input": "可再生进料量 （吨）",
  "non_renewable_input": "不可再生进料量 （吨）",
  "renewable_output": "可再生出料量 （吨）",
  "non_renewable_output": "不可再生出料量 （吨）",
  "material_consumption": "物料消耗量 （吨）",
  "wood_fiber": "木纤维 （吨）",
  "aluminum": "铝 （吨）",
  "packaging_material": "包装材料 （吨）",
  "paper_consumption": "纸张消耗 （吨）",
  "packaging_intensity": "包装消耗强度 （吨/万元）",
  "paper_intensity": "纸张消耗强度 （吨/万元）",
  "total_input": "进料总量 （吨）",
  "total_output": "出料总量 （吨）",
  "renewable_input_ratio": "可再生进料占比 （%）",
  "renewable_output_ratio": "可再生出料占比 （%）"
}

// 能源指标名称映射
const energyIndicatorNames = {
  "total_purchased_power": "外购电量 （千瓦时）",
  "total_renewable_power": "再生能源电量 （千瓦时）",
  "coal_consumption": "煤炭使用量 （吨标准煤）",
  "total_gasoline": "汽油用量 （吨）",
  "total_diesel": "柴油用量 （吨）",
  "total_natural_gas": "天然气用量 （吨）",
  "total_other_energy": "其他能源消耗量 （吨标准煤）",
  "total_energy_consumption": "综合能耗 （吨标准煤）",
  "energy_consumption_intensity": "能源消耗强度 （吨标准煤/万元）"
}

// 水资源指标名称映射
const waterIndicatorNames = {
  "industrial_total": "取水量（工业） （吨）",
  "domestic_total": "取水量（生活） （吨）",
  "total_intake": "取水总量 （吨）",
  "water_intensity": "用水强度 （吨/万元）",
  "total_drainage": "排水量 （吨）",
  "total_consumption": "耗水量 （吨）",
  "total_recycled": "循环水量 （吨）",
  "water_recycle_rate": "水资源回收利用率 （%）",
  "reclaimed_intensity": "中水用水强度 （吨/万元）",
  "reclaimed_total": "中水用水量 （吨）"
}

// 排放指标名称映射
const emissionIndicatorNames = {
  "category_one": "温室气体直接排放量（范围一） （吨二氧化碳当量）",
  "category_two": "温室气体直接排放量（范围二） （吨二氧化碳当量）",
  "category_three_total": "价值链上下游各项活动的间接排放数据（范围三） （吨二氧化碳当量）",
  "total_emission": "温室气体排放总量 （吨二氧化碳当量）",
  "emission_intensity": "温室气体排放强度 （吨二氧化碳当量/万元） （吨二氧化碳当量）",
  "voc": "挥发性有机物（VOC） （吨）",
  "nmhc": "碳氢化合物（非甲烷总烃） （吨）",
  "benzene": "苯类（苯、甲苯、二甲苯） （吨）",
  "particulate": "颗粒物（吨）",
  "nox_sox_other": "氮氧化物、硫氧化物及其他气体排放 （吨）"
}

// 废弃物指标名称映射
const wasteIndicatorNames = {
  "hazardous_total": "危险废弃物总量 （吨）",
  "hazardous_intensity": "危险废弃物强度 （吨/万元）",
  "epe_total": "电子废弃物 （吨）",
  "plastic_paper_total": "塑料和纸张废弃物 （吨）",
  "domestic_industrial_total": "生活和工业废弃物 （吨）",
  "recyclable_total": "可回收废弃物总量 （吨）",
  "non_hazardous_total": "非危险废弃物总量 （吨）",
  "total_waste": "废弃物总量 （吨）",
  "recycle_rate": "回收率 （%）",
  "protective_reuse_rate": "保护性再利用率 （%）",
  "disposal_required_total": "需处置废弃物总量 （吨）",
  "wastewater_total": "废水总量 （吨）",
  "wastewater_intensity": "废水强度 （吨/万元）",
  "exceed_events": "超标事件 （次）"
}

// 资金投入指标名称映射
const investmentIndicatorNames = {
  "env_invest_total": "环保总投入 （万元）",
  "env_invest_intensity": "环保投入强度 （%）",
  "green_income_ratio": "绿色收入占比 （%）",
  "climate_invest_total": "气候相关投入 （万元）",
  "clean_tech_invest_total": "清洁技术投入 （万元）"
}

// 环境管理指标名称映射
const envQuantIndicatorNames = {
  "national_green_factory": "国家级绿色工厂 （个）",
  "provincial_green_factory": "省级绿色工厂 （个）",
  "env_penalty_intensity": "环境处罚强度 （%）",
  "env_penalty_amount": "环境处罚额 （万元）",
  "env_violations": "环境违规 （次）"
}


// 获取董事会数据
const fetchBoardData = async () => {
  try {
    const response = await axios.get('http://localhost:8000/api/envquant', {
      params: {
        factory: factory.value,
        year: year.value
      }
    });
    materialData.value = response.data.material || {};
    energyData.value = response.data.energy || {};
    waterData.value = response.data.water || {};
    emissionData.value = response.data.emission || {};
    wasteData.value = response.data.waste || {};
    investmentData.value = response.data.investment || {};
    envQuantData.value = response.data.envQuant || {};
  } catch (error) {
    console.error('获取数据失败:', error);
    alert(`获取数据失败: ${error.response?.data?.detail || error.message}`);
  }
};

// 格式化对比值
const formatComparison = (value) => {
  if (value === null || value === undefined) return 'N/A';
  return `${value > 0 ? '+' : ''}${value}%`;
};

// 初始化
onMounted(() => {
  selectionStore.initYears();
  document.addEventListener('click', selectionStore.handleClickOutside);
  fetchBoardData();
});

// 进入编辑模式
const startEditing = () => {
  isEditing.value = true
  tempMaterialReasons.value = {};
  tempEnergyReasons.value = {};
  tempWaterReasons.value = {};
  tempEmissionReasons.value = {};
  tempWasteReasons.value = {};
  tempInvestmentReasons.value = {};
  tempEnvQuantReasons.value = {};
  Object.keys(materialData.value).forEach(key => {
    tempMaterialReasons.value[key] = materialData.value[key]?.reason || ''
  })
  Object.keys(energyData.value).forEach(key => {
    tempEnergyReasons.value[key] = energyData.value[key]?.reason || ''
  })
  Object.keys(waterData.value).forEach(key => {
    tempWaterReasons.value[key] = waterData.value[key]?.reason || '';
  });
  Object.keys(emissionData.value).forEach(key => {
    tempEmissionReasons.value[key] = emissionData.value[key]?.reason || '';
  });
  Object.keys(wasteData.value).forEach(key => {
    tempWasteReasons.value[key] = wasteData.value[key]?.reason || '';
  });
  Object.keys(investmentData.value).forEach(key => {
    tempInvestmentReasons.value[key] = investmentData.value[key]?.reason || '';
  });
  Object.keys(envQuantData.value).forEach(key => {
    tempEnvQuantReasons.value[key] = envQuantData.value[key]?.reason || '';
  });
}

// 取消编辑
const cancelEditing = () => {
  isEditing.value = false
  tempMaterialReasons.value = {}
  tempEnergyReasons.value = {}
  tempWaterReasons.value = {}
  tempEmissionReasons.value = {}
  tempWasteReasons.value = {}
  tempInvestmentReasons.value = {}
  tempEnvQuantReasons.value = {}
}

const submitReasons = async () => {
  try {
    const materialReasons = Object.keys(materialIndicatorNames).map(key => tempMaterialReasons.value[key] || '');
    const energyReasons = Object.keys(energyIndicatorNames).map(key => tempEnergyReasons.value[key] || '');
    const waterReasons = Object.keys(waterIndicatorNames).map(key => tempWaterReasons.value[key] || '');
    const emissionReasons = Object.keys(emissionIndicatorNames).map(key => tempEmissionReasons.value[key] || '');
    const wasteReasons = Object.keys(wasteIndicatorNames).map(key => tempWasteReasons.value[key] || '');
    const investmentReasons = Object.keys(investmentIndicatorNames).map(key => tempInvestmentReasons.value[key] || '');
    const envQuantReasons = Object.keys(envQuantIndicatorNames).map(key => tempEnvQuantReasons.value[key] || '');
    console.log(materialReasons, energyReasons, waterReasons, emissionReasons, wasteReasons, investmentReasons, envQuantReasons);
    await axios.post('http://localhost:8000/api/envquant/reasons', {
      factory: factory.value,
      year: parseInt(year.value),
      materialReasons: materialReasons,
      energyReasons: energyReasons,
      waterReasons: waterReasons,
      emissionReasons: emissionReasons,
      wasteReasons: wasteReasons,
      investmentReasons: investmentReasons,
      envQuantReasons: envQuantReasons
    });

    // 更新前端显示
    Object.keys(materialIndicatorNames).forEach((key, index) => {
      if (materialData.value[key]) {
        materialData.value[key].reason = materialReasons[index];
      }
    });
    Object.keys(energyIndicatorNames).forEach((key, index) => {
      if (energyData.value[key]) {
        energyData.value[key].reason = energyReasons[index];
      }
    });
    Object.keys(waterIndicatorNames).forEach((key, index) => {
      if (waterData.value[key]) {
        waterData.value[key].reason = waterReasons[index];
      }
    });
    Object.keys(emissionIndicatorNames).forEach((key, index) => {
      if (emissionData.value[key]) {
        emissionData.value[key].reason = emissionReasons[index];
      }
    });
    Object.keys(wasteIndicatorNames).forEach((key, index) => {
      if (wasteData.value[key]) {
        wasteData.value[key].reason = wasteReasons[index];
      }
    });
    Object.keys(investmentIndicatorNames).forEach((key, index) => {
      if (investmentData.value[key]) {
        investmentData.value[key].reason = investmentReasons[index];
      }
    });
    Object.keys(envQuantIndicatorNames).forEach((key, index) => {
      if (envQuantData.value[key]) {
        envQuantData.value[key].reason = envQuantReasons[index];
      }
    });
    isEditing.value = false;
    alert('原因分析提交成功！');
  } catch (error) {
    console.error('提交原因分析失败:', error);
    alert(`提交原因分析失败: ${error.response?.data?.detail || error.message}`);
  }
}
</script>

<style scoped>
.data-table {
  width: 100%;
  border-collapse: collapse;
  margin-bottom: 20px;
}

.data-table th, .data-table td {
  border: 1px solid #ddd;
  padding: 8px;
  text-align: left;
}

.data-table th {
  background-color: #f2f2f2;
}

.reason-input {
  width: 100%;
  min-height: 60px;
}

.edit-controls {
  position: fixed;
  right: 20px;
  top: 200px;
  z-index: 1000;
  background: rgba(44, 62, 80, 0.6);
  padding: 8px 8px;
  border-radius: 24px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 8px;
  color: white;
  font-size: 16px;
  cursor: pointer;
}

.edit-controls::before {
  content: '编辑';
  opacity: 0;
  transform: translateY(-10px);
  transition: all 0.3s;
  order: -1;
  font-size: 18px;
}

.edit-controls:hover::before {
  opacity: 1;
  transform: translateY(0);
}

.edit-button, .cancel-button, .submit-button {
  padding: 8px 12px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 16px;
  transition: all 0.2s;
}

.edit-button {
  background-color: transparent;
  font-size: 25px;
}

.edit-button:hover {
  background-color: transparent;
}

.cancel-button {
  background-color: #f44336;
  color: white;
}

.cancel-button:hover {
  background-color: #d32f2f;
}

.submit-button {
  background-color: #2196F3;
  color: white;
}

.submit-button:hover {
  background-color: #1976d2;
}


</style>