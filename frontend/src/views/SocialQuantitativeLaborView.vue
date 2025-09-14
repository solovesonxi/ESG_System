<template>
  <div class="shared-form">
    <form>
      <BaseInfoSelector @selection-changed="fetchData"/>
      <fieldset class="summary-fieldset" v-for="(indicators, category) in laborData" :key="category">
        <legend>{{ category }}</legend>
        <div class="form-row">
          <table class="data-table">
            <thead>
            <tr>
              <th>指标</th>
              <th>上一年 ({{ year - 1 }})</th>
              <th>当前年 ({{ year }})</th>
              <th>对比上期 (%)</th>
              <th>原因分析</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="(item, key) in indicators" :key="key">
              <td>{{ indicatorNames[key] || key }}</td>
              <td>{{ formatValue(item.lastYear) || '' }}</td>
              <td>{{ formatValue(item.currentYear) || '' }}</td>
              <td>{{ formatComparison(item.comparison) || '' }}</td>
              <td>
                <span v-if="!isEditing">{{ item.reason || '' }}</span>
                <textarea v-else v-model="tempReasons[key]" class="reason-input"></textarea>
              </td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>
    </form>
  </div>
</template>

<script setup>
import {computed, onMounted, ref} from 'vue'
import apiClient from '@/utils/axios';
import {useSelectionStore} from "@/stores/selectionStore.js"
import BaseInfoSelector from "@/components/BaseInfoSelector.vue";

const selectionStore = useSelectionStore()
const factory = computed(() => selectionStore.selectedFactory)
const year = computed(() => selectionStore.selectedYear)

const laborData = ref({})
const isEditing = ref(false)
const tempReasons = ref({})

const indicatorNames = {
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

const fetchData = async () => {
  try {
    const res = await apiClient.get('/analytical/social_quantitative_labor', {
      params: {
        factory: factory.value,
        year: year.value
      }
    })
    laborData.value = {...res.data} // 使用展开运算符确保响应式更新
    console.log('Fetched data:', laborData.value)
    console.log('labor data (raw):', JSON.parse(JSON.stringify(laborData.value)));
  } catch (e) {
    console.error(e)
    alert(`获取劳动定量数据失败: ${e.response?.data?.detail || e.message}`)
  }
}

const formatComparison = (value) => {
  if (value === null || value === undefined) return '';
  if (typeof value === 'string') return value;
  return `${value > 0 ? '+' : ''}${value}%`;
}

const formatValue = (v) => {
  if (v === null || v === undefined) return ''
  return v
}

onMounted(() => {
  document.addEventListener('click', selectionStore.handleClickOutside)
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

const submitEdit = async (ifSubmit) => {
  try {
    const reasonsMap = {}
    Object.entries(tempReasons.value).forEach(([indicator, reason]) => {
      if (reason && reason.trim() !== '') reasonsMap[indicator] = reason
    })
    const response = await apiClient.post('/analytical/social_quantitative_labor', {
      factory: factory.value,
      year: parseInt(year.value),
      reasons: reasonsMap,
      isSubmitted: ifSubmit
    })
    if (response.data.status === 'success') {
      alert('数据提交成功!')
    } else {
      alert(`数据提交失败: ${response.data.message || '未知错误'}`)
    }
  } catch (e) {
    console.error(e)
    alert(`提交原因失败: ${e.response?.data?.detail || e.message}`)
  } finally {
    console.log('提交完成，即将刷新');
    isEditing.value = false;
    await fetchData();
  }
}
defineExpose({
  startEditing,
  cancelEditing,
  submitEdit,
  fetchData
});
</script>
