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

      <!-- 气候变化 -->
      <fieldset class="summary-fieldset" v-if="hasCategoryData('气候变化')">
        <legend>气候变化</legend>
        <div class="form-row">
          <table class="data-table">
            <thead>
            <tr>
              <th>指标</th>
              <th>{{ year - 1 }}年的方针、政策、文件、记录等</th>
              <th>{{ year }}年的方针、政策、文件、记录等</th>
              <th>对比去年</th>
              <th>原因分析</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="(indicatorKey, index) in getCategoryIndicators('气候变化')" :key="index">
              <td>{{ envQualIndicatorNames[indicatorKey] || indicatorKey }}</td>
              <td>{{ envQualData[indicatorKey].lastYear || 'N/A' }}</td>
              <td>
                <span v-if="!isEditing">{{ envQualData[indicatorKey].currentYear || 'N/A' }}</span>
                <textarea v-else v-model="tempCurrentYear[indicatorKey]" class="reason-input"
                          :placeholder="envQualData[indicatorKey]?.currentYear || ''"></textarea>
              </td>
              <td>
                <span v-if="!isEditing">{{ envQualData[indicatorKey].comparison || 'N/A' }}</span>
                <textarea v-else v-model="tempComparisons[indicatorKey]" class="comparison-input"
                          :placeholder="envQualData[indicatorKey]?.comparison || ''"></textarea>
              </td>
              <td>
                <span v-if="!isEditing">{{ envQualData[indicatorKey].reason || 'N/A' }}</span>
                <textarea v-else v-model="tempReasons[indicatorKey]" class="reason-input"
                          :placeholder="envQualData[indicatorKey]?.reason || ''"></textarea>
              </td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <!-- 废弃物 -->
      <fieldset class="summary-fieldset" v-if="hasCategoryData('废弃物')">
        <legend>废弃物</legend>
        <div class="form-row">
          <table class="data-table">
            <thead>
            <tr>
              <th>指标</th>
              <th>{{ year - 1 }}年的方针、政策、文件、记录等</th>
              <th>{{ year }}年的方针、政策、文件、记录等</th>
              <th>对比去年</th>
              <th>原因分析</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="(indicatorKey, index) in getCategoryIndicators('废弃物')" :key="index">
              <td>{{ envQualIndicatorNames[indicatorKey] || indicatorKey }}</td>
              <td>{{ envQualData[indicatorKey].lastYear || 'N/A' }}</td>
              <td>
                <span v-if="!isEditing">{{ envQualData[indicatorKey].currentYear || 'N/A' }}</span>
                <textarea v-else v-model="tempCurrentYear[indicatorKey]" class="reason-input"
                          :placeholder="envQualData[indicatorKey]?.currentYear || ''"></textarea>
              </td>
              <td>
                <span v-if="!isEditing">{{ envQualData[indicatorKey].comparison || 'N/A' }}</span>
                <textarea v-else v-model="tempComparisons[indicatorKey]" class="comparison-input"
                          :placeholder="envQualData[indicatorKey]?.comparison || ''"></textarea>
              </td>
              <td>
                <span v-if="!isEditing">{{ envQualData[indicatorKey].reason || 'N/A' }}</span>
                <textarea v-else v-model="tempReasons[indicatorKey]" class="reason-input"
                          :placeholder="envQualData[indicatorKey]?.reason || ''"></textarea>
              </td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <!-- 水资源 -->
      <fieldset class="summary-fieldset" v-if="hasCategoryData('水资源')">
        <legend>水资源</legend>
        <div class="form-row">
          <table class="data-table">
            <thead>
            <tr>
              <th>指标</th>
              <th>{{ year - 1 }}年的方针、政策、文件、记录等</th>
              <th>{{ year }}年的方针、政策、文件、记录等</th>
              <th>对比去年</th>
              <th>原因分析</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="(indicatorKey, index) in getCategoryIndicators('水资源')" :key="index">
              <td>{{ envQualIndicatorNames[indicatorKey] || indicatorKey }}</td>
              <td>{{ envQualData[indicatorKey].lastYear || 'N/A' }}</td>
              <td>
                <span v-if="!isEditing">{{ envQualData[indicatorKey].currentYear || 'N/A' }}</span>
                <textarea v-else v-model="tempCurrentYear[indicatorKey]" class="reason-input"
                          :placeholder="envQualData[indicatorKey]?.currentYear || ''"></textarea>
              </td>
              <td>
                <span v-if="!isEditing">{{ envQualData[indicatorKey].comparison || 'N/A' }}</span>
                <textarea v-else v-model="tempComparisons[indicatorKey]" class="comparison-input"
                          :placeholder="envQualData[indicatorKey]?.comparison || ''"></textarea>
              </td>
              <td>
                <span v-if="!isEditing">{{ envQualData[indicatorKey].reason || 'N/A' }}</span>
                <textarea v-else v-model="tempReasons[indicatorKey]" class="reason-input"
                          :placeholder="envQualData[indicatorKey]?.reason || ''"></textarea>
              </td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <!-- 环境机遇 -->
      <fieldset class="summary-fieldset" v-if="hasCategoryData('环境机遇')">
        <legend>环境机遇</legend>
        <div class="form-row">
          <table class="data-table">
            <thead>
            <tr>
              <th>指标</th>
              <th>{{ year - 1 }}年的方针、政策、文件、记录等</th>
              <th>{{ year }}年的方针、政策、文件、记录等</th>
              <th>对比去年</th>
              <th>原因分析</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="(indicatorKey, index) in getCategoryIndicators('环境机遇')" :key="index">
              <td>{{ envQualIndicatorNames[indicatorKey] || indicatorKey }}</td>
              <td>{{ envQualData[indicatorKey].lastYear || 'N/A' }}</td>
              <td>
                <span v-if="!isEditing">{{ envQualData[indicatorKey].currentYear || 'N/A' }}</span>
                <textarea v-else v-model="tempCurrentYear[indicatorKey]" class="reason-input"
                          :placeholder="envQualData[indicatorKey]?.currentYear || ''"></textarea>
              </td>
              <td>
                <span v-if="!isEditing">{{ envQualData[indicatorKey].comparison || 'N/A' }}</span>
                <textarea v-else v-model="tempComparisons[indicatorKey]" class="comparison-input"
                          :placeholder="envQualData[indicatorKey]?.comparison || ''"></textarea>
              </td>
              <td>
                <span v-if="!isEditing">{{ envQualData[indicatorKey].reason || 'N/A' }}</span>
                <textarea v-else v-model="tempReasons[indicatorKey]" class="reason-input"
                          :placeholder="envQualData[indicatorKey]?.reason || ''"></textarea>
              </td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <!-- 生物多样性保护 -->
      <fieldset class="summary-fieldset" v-if="hasCategoryData('生物多样性保护')">
        <legend>生物多样性保护</legend>
        <div class="form-row">
          <table class="data-table">
            <thead>
            <tr>
              <th>指标</th>
              <th>{{ year - 1 }}年的方针、政策、文件、记录等</th>
              <th>{{ year }}年的方针、政策、文件、记录等</th>
              <th>对比去年</th>
              <th>原因分析</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="(indicatorKey, index) in getCategoryIndicators('生物多样性保护')" :key="index">
              <td>{{ envQualIndicatorNames[indicatorKey] || indicatorKey }}</td>
              <td>{{ envQualData[indicatorKey].lastYear || 'N/A' }}</td>
              <td>
                <span v-if="!isEditing">{{ envQualData[indicatorKey].currentYear || 'N/A' }}</span>
                <textarea v-else v-model="tempCurrentYear[indicatorKey]" class="reason-input"
                          :placeholder="envQualData[indicatorKey]?.currentYear || ''"></textarea>
              </td>
              <td>
                <span v-if="!isEditing">{{ envQualData[indicatorKey].comparison || 'N/A' }}</span>
                <textarea v-else v-model="tempComparisons[indicatorKey]" class="comparison-input"
                          :placeholder="envQualData[indicatorKey]?.comparison || ''"></textarea>
              </td>
              <td>
                <span v-if="!isEditing">{{ envQualData[indicatorKey].reason || 'N/A' }}</span>
                <textarea v-else v-model="tempReasons[indicatorKey]" class="reason-input"
                          :placeholder="envQualData[indicatorKey]?.reason || ''"></textarea>
              </td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <!-- 环境事故管理 -->
      <fieldset class="summary-fieldset" v-if="hasCategoryData('环境事故管理')">
        <legend>环境事故管理</legend>
        <div class="form-row">
          <table class="data-table">
            <thead>
            <tr>
              <th>指标</th>
              <th>{{ year - 1 }}年的方针、政策、文件、记录等</th>
              <th>{{ year }}年的方针、政策、文件、记录等</th>
              <th>对比去年</th>
              <th>原因分析</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="(indicatorKey, index) in getCategoryIndicators('环境事故管理')" :key="index">
              <td>{{ envQualIndicatorNames[indicatorKey] || indicatorKey }}</td>
              <td>{{ envQualData[indicatorKey].lastYear || 'N/A' }}</td>
              <td>
                <span v-if="!isEditing">{{ envQualData[indicatorKey].currentYear || 'N/A' }}</span>
                <textarea v-else v-model="tempCurrentYear[indicatorKey]" class="reason-input"
                          :placeholder="envQualData[indicatorKey]?.currentYear || ''"></textarea>
              </td>
              <td>
                <span v-if="!isEditing">{{ envQualData[indicatorKey].comparison || 'N/A' }}</span>
                <textarea v-else v-model="tempComparisons[indicatorKey]" class="comparison-input"
                          :placeholder="envQualData[indicatorKey]?.comparison || ''"></textarea>
              </td>
              <td>
                <span v-if="!isEditing">{{ envQualData[indicatorKey].reason || 'N/A' }}</span>
                <textarea v-else v-model="tempReasons[indicatorKey]" class="reason-input"
                          :placeholder="envQualData[indicatorKey]?.reason || ''"></textarea>
              </td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <!-- 环境管理 -->
      <fieldset class="summary-fieldset" v-if="hasCategoryData('环境管理')">
        <legend>环境管理</legend>
        <div class="form-row">
          <table class="data-table">
            <thead>
            <tr>
              <th>指标</th>
              <th>{{ year - 1 }}年的方针、政策、文件、记录等</th>
              <th>{{ year }}年的方针、政策、文件、记录等</th>
              <th>对比去年</th>
              <th>原因分析</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="(indicatorKey, index) in getCategoryIndicators('环境管理')" :key="index">
              <td>{{ envQualIndicatorNames[indicatorKey] || indicatorKey }}</td>
              <td>{{ envQualData[indicatorKey].lastYear || 'N/A' }}</td>
              <td>
                <span v-if="!isEditing">{{ envQualData[indicatorKey].currentYear || 'N/A' }}</span>
                <textarea v-else v-model="tempCurrentYear[indicatorKey]" class="reason-input"
                          :placeholder="envQualData[indicatorKey]?.currentYear || ''"></textarea>
              </td>
              <td>
                <span v-if="!isEditing">{{ envQualData[indicatorKey].comparison || 'N/A' }}</span>
                <textarea v-else v-model="tempComparisons[indicatorKey]" class="comparison-input"
                          :placeholder="envQualData[indicatorKey]?.comparison || ''"></textarea>
              </td>
              <td>
                <span v-if="!isEditing">{{ envQualData[indicatorKey].reason || 'N/A' }}</span>
                <textarea v-else v-model="tempReasons[indicatorKey]" class="reason-input"
                          :placeholder="envQualData[indicatorKey]?.reason || ''"></textarea>
              </td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <!-- 物料消耗 -->
      <fieldset class="summary-fieldset" v-if="hasCategoryData('物料消耗')">
        <legend>物料消耗</legend>
        <div class="form-row">
          <table class="data-table">
            <thead>
            <tr>
              <th>指标</th>
              <th>{{ year - 1 }}年的方针、政策、文件、记录等</th>
              <th>{{ year }}年的方针、政策、文件、记录等</th>
              <th>对比去年</th>
              <th>原因分析</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="(indicatorKey, index) in getCategoryIndicators('物料消耗')" :key="index">
              <td>{{ envQualIndicatorNames[indicatorKey] || indicatorKey }}</td>
              <td>{{ envQualData[indicatorKey].lastYear || 'N/A' }}</td>
              <td>
                <span v-if="!isEditing">{{ envQualData[indicatorKey].currentYear || 'N/A' }}</span>
                <textarea v-else v-model="tempCurrentYear[indicatorKey]" class="reason-input"
                          :placeholder="envQualData[indicatorKey]?.currentYear || ''"></textarea>
              </td>
              <td>
                <span v-if="!isEditing">{{ envQualData[indicatorKey].comparison || 'N/A' }}</span>
                <textarea v-else v-model="tempComparisons[indicatorKey]" class="comparison-input"
                          :placeholder="envQualData[indicatorKey]?.comparison || ''"></textarea>
              </td>
              <td>
                <span v-if="!isEditing">{{ envQualData[indicatorKey].reason || 'N/A' }}</span>
                <textarea v-else v-model="tempReasons[indicatorKey]" class="reason-input"
                          :placeholder="envQualData[indicatorKey]?.reason || ''"></textarea>
              </td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <!-- 能源消耗 -->
      <fieldset class="summary-fieldset" v-if="hasCategoryData('能源消耗')">
        <legend>能源消耗</legend>
        <div class="form-row">
          <table class="data-table">
            <thead>
            <tr>
              <th>指标</th>
              <th>{{ year - 1 }}年的方针、政策、文件、记录等</th>
              <th>{{ year }}年的方针、政策、文件、记录等</th>
              <th>对比去年</th>
              <th>原因分析</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="(indicatorKey, index) in getCategoryIndicators('能源消耗')" :key="index">
              <td>{{ envQualIndicatorNames[indicatorKey] || indicatorKey }}</td>
              <td>{{ envQualData[indicatorKey].lastYear || 'N/A' }}</td>
              <td>
                <span v-if="!isEditing">{{ envQualData[indicatorKey].currentYear || 'N/A' }}</span>
                <textarea v-else v-model="tempCurrentYear[indicatorKey]" class="reason-input"
                          :placeholder="envQualData[indicatorKey]?.currentYear || ''"></textarea>
              </td>
              <td>
                <span v-if="!isEditing">{{ envQualData[indicatorKey].comparison || 'N/A' }}</span>
                <textarea v-else v-model="tempComparisons[indicatorKey]" class="comparison-input"
                          :placeholder="envQualData[indicatorKey]?.comparison || ''"></textarea>
              </td>
              <td>
                <span v-if="!isEditing">{{ envQualData[indicatorKey].reason || 'N/A' }}</span>
                <textarea v-else v-model="tempReasons[indicatorKey]" class="reason-input"
                          :placeholder="envQualData[indicatorKey]?.reason || ''"></textarea>
              </td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <!-- 碳排放 -->
      <fieldset class="summary-fieldset" v-if="hasCategoryData('碳排放')">
        <legend>碳排放</legend>
        <div class="form-row">
          <table class="data-table">
            <thead>
            <tr>
              <th>指标</th>
              <th>{{ year - 1 }}年的方针、政策、文件、记录等</th>
              <th>{{ year }}年的方针、政策、文件、记录等</th>
              <th>对比去年</th>
              <th>原因分析</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="(indicatorKey, index) in getCategoryIndicators('碳排放')" :key="index">
              <td>{{ envQualIndicatorNames[indicatorKey] || indicatorKey }}</td>
              <td>{{ envQualData[indicatorKey].lastYear || 'N/A' }}</td>
              <td>
                <span v-if="!isEditing">{{ envQualData[indicatorKey].currentYear || 'N/A' }}</span>
                <textarea v-else v-model="tempCurrentYear[indicatorKey]" class="reason-input"
                          :placeholder="envQualData[indicatorKey]?.currentYear || ''"></textarea>
              </td>
              <td>
                <span v-if="!isEditing">{{ envQualData[indicatorKey].comparison || 'N/A' }}</span>
                <textarea v-else v-model="tempComparisons[indicatorKey]" class="comparison-input"
                          :placeholder="envQualData[indicatorKey]?.comparison || ''"></textarea>
              </td>
              <td>
                <span v-if="!isEditing">{{ envQualData[indicatorKey].reason || 'N/A' }}</span>
                <textarea v-else v-model="tempReasons[indicatorKey]" class="reason-input"
                          :placeholder="envQualData[indicatorKey]?.reason || ''"></textarea>
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
import {computed, onMounted, ref, watch} from 'vue';
import axios from 'axios';
import {useSelectionStore} from "@/stores/selectionStore.js";

const selectionStore = useSelectionStore();
const factory = computed(() => selectionStore.selectedFactory);
const factories = computed(() => selectionStore.factories);
const year = computed(() => selectionStore.selectedYear);
const years = computed(() => selectionStore.years);

const isEditing = ref(false);
const envQualData = ref({});
const tempCurrentYear = ref({});
const tempComparisons = ref({});
const tempReasons = ref({});

// 环境定性指标名称映射
const envQualIndicatorNames = {
  // 气候变化部分
  "board_supervision": "董事会监管",
  "management_responsibility": "管理层职责",
  "environment_strategy": "环境战略",
  "risk_opportunity_identification": "风险与机遇识别以及应对措施",
  "climate_risk_disclosure": "气候风险应对披露",
  "risk_matrix": "（物理风险、转型风险、短期风险、长期风险）",
  "risk_impact": "风险影响",
  "resilience": "能力韧性",
  "risk_process": "（识别、评估风险流程）",
  "risk_management_process": "管理风险流程",
  "business_strategy": "纳入业务策略",
  "ghg_reduction_target": "温室气体排放物减排目标",
  "ghg_reduction_rate": "温室气体减排目标达成率（%）",
  "ghg_reduction_action": "温室气体排放物减排行动",
  "carbon_capture_target": "碳捕捉计划目标",
  "carbon_capture_rate": "碳捕捉计划目标达成率（%）",

  // 废弃物部分
  "waste_reduction_target": "废弃物减排目标",
  "waste_reduction_action": "废弃物减排行动",

  // 水资源部分
  "annual_water_use_target": "年度用水量目标",
  "annual_water_use_target_rate": "年度用水量目标达成率（%）",
  "annual_reclaimed_water_use_target": "年度中水使用量目标",
  "annual_reclaimed_water_use_target_rate": "年度中水使用量目标达成率（%）",
  "water_saving_target": "节水目标/水资源减排目标",
  "water_saving_target_rate": "水资源减排目标达成率（%）",
  "water_management_policy": "水资源管理政策",
  "water_risk_management": "水资源风险管理",
  "water_saving_action": "节水行动",

  // 环境机遇部分
  "clean_technology_strategy": "清洁技术战略",
  "clean_technology_practice": "清洁技术实践",

  // 生物多样性保护部分
  "biodiversity_impact": "生物多样性影响",
  "ecological_restoration": "生态修复",

  // 环境事故管理部分
  "environmental_accident": "环境事故",
  "environmental_penalty": "环境处罚",

  // 环境管理部分
  "environmental_management_system": "环境管理体系认证与披露",
  "environmental_resource_policy": "环境/资源使用政策",
  "environmental_emergency_plan": "环境应急预案办法",
  "green_office": "绿色办公",
  "green_factory_policy": "绿色工厂政策以及目标计划",
  "environmental_committee": "环保委员会或工作组的设置",
  "key_pollution_unit": "列入重点排污单位",
  "waste_product_recycling": "废旧产品回收项目",
  "hazardous_waste_emission_target": "有害废弃物排放总量目标",
  "hazardous_waste_emission_target_rate": "有害废弃物排放总量目标达成率（%）",
  "sustainable_product_certification": "可持续产品认证与信披",

  // 物料消耗部分
  "material_reduction_target": "减少物料消耗目标",
  "annual_packaging_material_target": "年度包装材料消耗目标",
  "annual_packaging_material_target_rate": "年度包装材料消耗目标达成率（%）",
  "packaging_material_reduction_target": "包装材料资源降低目标",
  "packaging_material_reduction_target_rate": "包装材料资源降低目标达成率（%）",
  "product_lifecycle_management": "产品生命周期管理",
  "annual_office_paper_target": "年度办公用纸消耗量目标",
  "annual_office_paper_target_rate": "年度办公用纸消耗量目标达成率（%）",
  "chemical_management": "化学品管理",
  "chemical_inventory": "化学品清单",

  // 能源消耗部分
  "energy_reduction_target": "减少能源消耗目标",
  "renewable_energy_target": "可再生能源目标",
  "renewable_energy_use_development": "可再生能源利用及开发",
  "energy_saving_action_results": "能源节约行动与成果",
  "energy_management_system": "能源管理体系认证与信披",

  // 碳排放部分
  "product_carbon_footprint": "产品碳足迹",
  "product_carbon_footprint_plan": "产品碳足迹计划及执行情况说明",
  "carbon_neutrality_target_year": "碳中和目标年份",
  "carbon_neutrality_plan": "碳中和计划",
  "carbon_neutrality_target_scheme": "碳中和目标指标方案",
  "carbon_neutrality_plan_rate": "碳中和计划达成率（%）",
  "carbon_reduction_target": "碳减排目标",
  "joined_sbti": "是否加入科学碳目标SBTi",
  "cdp_disclosure": "CDP收据披露及说明",
  "carbon_inventory_disclosure": "碳盘查数据披露",
  "carbon_inventory_report_verification": "碳盘查报告验证",
  "greenhouse_gas_verification_system": "是否有温室气体核查体系"
};

// 指标分类映射
const indicatorCategories = {
  "气候变化": [
    "board_supervision", "management_responsibility", "environment_strategy",
    "risk_opportunity_identification", "climate_risk_disclosure", "risk_matrix",
    "risk_impact", "resilience", "risk_process", "risk_management_process",
    "business_strategy", "ghg_reduction_target", "ghg_reduction_rate",
    "ghg_reduction_action", "carbon_capture_target", "carbon_capture_rate"
  ],
  "废弃物": [
    "waste_reduction_target", "waste_reduction_action"
  ],
  "水资源": [
    "annual_water_use_target", "annual_water_use_target_rate",
    "annual_reclaimed_water_use_target", "annual_reclaimed_water_use_target_rate",
    "water_saving_target", "water_saving_target_rate", "water_management_policy",
    "water_risk_management", "water_saving_action"
  ],
  "环境机遇": [
    "clean_technology_strategy", "clean_technology_practice"
  ],
  "生物多样性保护": [
    "biodiversity_impact", "ecological_restoration"
  ],
  "环境事故管理": [
    "environmental_accident", "environmental_penalty"
  ],
  "环境管理": [
    "environmental_management_system", "environmental_resource_policy",
    "environmental_emergency_plan", "green_office", "green_factory_policy",
    "environmental_committee", "key_pollution_unit", "waste_product_recycling",
    "hazardous_waste_emission_target", "hazardous_waste_emission_target_rate",
    "sustainable_product_certification"
  ],
  "物料消耗": [
    "material_reduction_target", "annual_packaging_material_target",
    "annual_packaging_material_target_rate", "packaging_material_reduction_target",
    "packaging_material_reduction_target_rate", "product_lifecycle_management",
    "annual_office_paper_target", "annual_office_paper_target_rate",
    "chemical_management", "chemical_inventory"
  ],
  "能源消耗": [
    "energy_reduction_target", "renewable_energy_target",
    "renewable_energy_use_development", "energy_saving_action_results",
    "energy_management_system"
  ],
  "碳排放": [
    "product_carbon_footprint", "product_carbon_footprint_plan",
    "carbon_neutrality_target_year", "carbon_neutrality_plan",
    "carbon_neutrality_target_scheme", "carbon_neutrality_plan_rate",
    "carbon_reduction_target", "joined_sbti", "cdp_disclosure",
    "carbon_inventory_disclosure", "carbon_inventory_report_verification",
    "greenhouse_gas_verification_system"
  ]
};

// 检查分类是否有数据
const hasCategoryData = (category) => {
  const indicators = indicatorCategories[category];
  return indicators.some(indicator => envQualData.value[indicator]);
};

// 获取分类下的指标
const getCategoryIndicators = (category) => {
  const indicators = indicatorCategories[category];
  return indicators.filter(indicator => envQualData.value[indicator]);
};

// 获取数据
const fetchBoardData = async () => {
  try {
    const response = await axios.get('http://localhost:8000/api/envqual', {
      params: {
        factory: factory.value,
        year: year.value
      }
    });
    envQualData.value = response.data || {};
    console.log('获取数据成功:', response.data);
  } catch (error) {
    console.error('获取数据失败:', error);
    alert(`获取数据失败: ${error.response?.data?.detail || error.message}`);
  }
};

// 初始化
onMounted(() => {
  selectionStore.initYears();
  document.addEventListener('click', selectionStore.handleClickOutside);
  fetchBoardData();
});

// 监听工厂和年份变化
watch([factory, year], ([newFactory, newYear], [oldFactory, oldYear]) => {
  if (newFactory !== oldFactory || newYear !== oldYear) {
    if (isEditing.value) {
      cancelEditing();
    }
    if (!isEditing.value) {
      fetchBoardData();
    }
  }
});

// 进入编辑模式
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

// 取消编辑
const cancelEditing = () => {
  isEditing.value = false;
  tempCurrentYear.value = {};
  tempComparisons.value = {};
  tempReasons.value = {};
};

// 提交原因分析
const submitReasons = async () => {
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

    console.log('提交的数据:', payload.envQualData);
    await axios.post('http://localhost:8000/api/envqual/data', payload);

    // 更新前端显示
    Object.keys(envQualData.value).forEach(key => {
      if (envQualData.value[key]) {
        envQualData.value[key].currentYear = tempCurrentYear.value[key];
        envQualData.value[key].comparison = tempComparisons.value[key];
        envQualData.value[key].reason = tempReasons.value[key];
      }
    });

    isEditing.value = false;
    alert('原因分析提交成功！');
    // 提交后不重新获取数据，保留当前选择

  } catch (error) {
    console.error('提交原因分析失败:', error);
    alert(`提交原因分析失败: ${error.response?.data?.detail || error.message}`);
  }
};
</script>