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
                <div v-for="f in factories" :key="f" class="option" :class="{ 'selected-option': f === factory }"
                     @click="selectionStore.selectFactory(f)">
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
                <div v-for="y in years" :key="y" class="option" :class="{ 'selected-option': y === year }"
                     @click="selectionStore.selectYear(y)">
                  {{ y }}年
                </div>
              </div>
            </div>
          </div>
        </div>
      </fieldset>

      <fieldset class="summary-fieldset">
        <legend>雇佣/培训/安全/满意度</legend>
        <div class="form-row">
          <table class="data-table">
            <thead>
            <tr>
              <th>大类</th>
              <th>指标</th>
              <th>当前年 ({{ year }})</th>
              <th>上一年 ({{ year - 1 }})</th>
              <th>对比上期 (%)</th>
              <th>原因分析</th>
            </tr>
            </thead>
            <tbody>
            <template v-for="(indicators, category) in laborData" :key="category">
              <tr v-for="(item, key, index) in indicators" :key="key">
                <td v-if="index === 0" :rowspan="Object.keys(indicators).length">{{ category }}</td>
                <td>{{ indicatorNames[key] || key }}</td>
                <td>{{ formatValue(item.currentYear) }}</td>
                <td>{{ formatValue(item.lastYear) }}</td>
                <td>{{ formatComparison(item.comparison) }}</td>
                <td>
                  <span v-if="!isEditing">{{ item.reason || 'N/A' }}</span>
                  <textarea v-else v-model="tempReasons[key]" class="reason-input"
                            :placeholder="item.reason || ''"></textarea>
                </td>
              </tr>
            </template>
            </tbody>
          </table>

        </div>
      </fieldset>
    </form>
  </div>

</template>

<script setup>
import {computed, onMounted, ref, watch} from 'vue'
import apiClient from '@/utils/axios';
import {useSelectionStore} from "@/stores/selectionStore.js"

const selectionStore = useSelectionStore()
const factory = computed(() => selectionStore.selectedFactory)
const factories = computed(() => selectionStore.factories)
const year = computed(() => selectionStore.selectedYear)
const years = computed(() => selectionStore.years)

const laborData = ref({})
const isEditing = ref(false)
const tempReasons = ref({})

const indicatorNames = {
  // 雇佣
  employment_total_employees: '员工总数（人）',
  employment_full_time: '全职（人）',
  employment_part_time: '兼职（人）',
  employment_gender_male: '男性（人）',
  employment_gender_female: '女性（人）',
  employment_category_management: '管理层（人）',
  employment_category_middle: '中层（人）',
  employment_category_general: '一般员工（人）',
  employment_mgmt_female_rate: '管理层女性占比（%）',
  employment_region_mainland: '中国大陆（人）',
  employment_region_overseas: '海外（人）',
  employment_age18_30: '18-30岁（人）',
  employment_age31_45: '31-45岁（人）',
  employment_age46_60: '46-60岁（人）',
  employment_quit_total: '离职总人数',
  employment_new_hires: '新进员工',
  employment_avg_social_fund: '五险一金-人均缴纳（元）',
  employment_inc_social_fund: '五险一金-同比增长（%）',
  employment_edu_phd: '博士（人）',
  employment_edu_master: '硕士（人）',
  employment_edu_bachelor: '本科（人）',
  employment_edu_junior: '大专及以下（人）',
  employment_turnover_rate: '员工总流失率（%）',
  employment_male_turnover_rate: '男性流失率（%）',
  employment_female_turnover_rate: '女性流失率（%）',
  employment_mainland_turnover_rate: '大陆地区流失率（%）',
  employment_overseas_turnover_rate: '海外地区流失率（%）',
  employment_age18_30_turnover_rate: '18-30岁流失率（%）',
  employment_age31_45_turnover_rate: '31-45岁流失率（%）',
  employment_age46_60_turnover_rate: '46-60岁流失率（%）',
  employment_management_turnover_rate: '管理层流失率（%）',
  employment_middle_turnover_rate: '中层流失率（%）',
  employment_general_turnover_rate: '一般员工流失率（%）',

  // 教育与培训
  training_total: '受训总人数',
  training_coverage_rate: '公司培训覆盖率（%）',
  training_male: '受训-男性（人次）',
  training_female: '受训-女性（人次）',
  training_mgmt: '受训-管理层（人次）',
  training_middle: '受训-中层（人次）',
  training_general: '受训-一般（人次）',
  training_male_rate: '受训-男性占比（%）',
  training_female_rate: '受训-女性占比（%）',
  training_mgmt_rate: '受训-管理层占比（%）',
  training_middle_rate: '受训-中层占比（%）',
  training_general_rate: '受训-一般占比（%）',
  training_hours_total: '培训总学时(未分类统计)',
  training_avg_hours_per_person: '人均受训学时',
  training_avg_hours_male: '平均受训时数-男性',
  training_avg_hours_female: '平均受训时数-女性',
  training_avg_hours_mgmt: '平均受训时数-管理层',
  training_avg_hours_middle: '平均受训时数-中层',
  training_avg_hours_general: '平均受训时数-一般',

  // 职业健康与安全
  ohs_training_count_total: '员工安全培训次数',
  ohs_training_participants_total: '员工安全培训参与人次',
  ohs_training_hours_total: '员工安全培训学时',
  ohs_avg_training_hours_per_person: '人均受训学时',
  ohs_injury_count_total: '工伤数量',
  ohs_incident_count_total: '安全事故',
  ohs_fatality_count_total: '工亡人数',
  ohs_fatality_rate: '因工死亡率（%）',
  ohs_lost_workdays_total: '因工伤损失工作日数',
  ohs_safety_investment_total: '安全生产投入',
  ohs_safety_managers: '专职安全管理人员员工数',
  ohs_medical_checks: '员工体检人数',
  ohs_coverage_rate: '员工体检参与率（%）',
  ohs_emergency_drills: '安全应急演练次数',
  ohs_hazards_found: '安全检查排查隐患数量',
  ohs_occupational_checks: '职业病危害岗位体检率',

  // 员工满意度
  satisfaction_annual_average: '员工满意度'
}

const fetchLaborData = async () => {
  try {
    const res = await apiClient.get('/analytical/social_quantitative_labor', {params: {factory: factory.value, year: year.value}})
    laborData.value = res.data
  } catch (e) {
    console.error(e)
    alert(`获取劳动定量数据失败: ${e.response?.data?.detail || e.message}`)
  }
}

const formatComparison = (value) => {
  if (value === null || value === undefined) return 'N/A'
  return `${value > 0 ? '+' : ''}${value}%`
}

const formatValue = (v) => {
  if (v === null || v === undefined) return 'N/A'
  return v
}

onMounted(() => {
  document.addEventListener('click', selectionStore.handleClickOutside)
  fetchLaborData()
})

watch([factory, year], () => {
  fetchLaborData()
})

const startEditing = () => {
  isEditing.value = true
  tempReasons.value = {}
  Object.values(laborData.value).forEach(group => {
    Object.entries(group).forEach(([key, item]) => {
      tempReasons.value[key] = item?.reason || ''
    })
  })
}

const cancelEditing = () => {
  isEditing.value = false
  tempReasons.value = {}
}

const submitEdit = async () => {
  try {
    const reasonsMap = {}
    Object.entries(tempReasons.value).forEach(([indicator, reason]) => {
      if (reason && reason.trim() !== '') reasonsMap[indicator] = reason
    })
    await apiClient.post('/analytical/social_quantitative_labor', {
      factory: factory.value,
      year: parseInt(year.value),
      reasons: reasonsMap
    })
    // 本地同步
    Object.values(laborData.value).forEach(group => {
      Object.entries(group).forEach(([key, item]) => {
        if (reasonsMap[key] !== undefined) item.reason = reasonsMap[key]
      })
    })
    isEditing.value = false
    alert('原因提交成功！')
  } catch (e) {
    console.error(e)
    alert(`提交原因失败: ${e.response?.data?.detail || e.message}`)
  }
}
defineExpose({
  startEditing,
  cancelEditing,
  submitEdit,
});
</script>
