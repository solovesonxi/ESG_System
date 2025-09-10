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
              <div class="options" v-show="selectionStore.showFactoryDropdown" :style="{ maxHeight: '200px', overflowY: 'auto' }">
                <div v-for="f in factories" :key="f" class="option" :class="{ 'selected-option': f === factory }" @click="selectionStore.selectFactory(f)">
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
                <div v-for="y in years" :key="y" class="option" :class="{ 'selected-option': y === year }" @click="selectionStore.selectYear(y)">
                  {{ y }}年
                </div>
              </div>
            </div>
          </div>
        </div>
      </fieldset>

      <fieldset class="summary-fieldset" v-for="(indicators, category) in otherData" :key="category">
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
                  <td>{{ formatValue(item.lastYear) || ''}}</td>
                  <td>{{ formatValue(item.currentYear) || ''}}</td>
                  <td>{{ formatComparison(item.comparison) || ''}}</td>
                  <td>
                    <span v-if="!isEditing">{{ item.reason || '' }}</span>
                    <textarea v-else v-model="tempReasons[key]" class="reason-input" :placeholder="item.reason || ''"></textarea>
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
import {computed, onMounted, ref, watch} from 'vue'
import apiClient from '@/utils/axios';
import {useSelectionStore} from "@/stores/selectionStore.js"

const selectionStore = useSelectionStore()
const factory = computed(() => selectionStore.selectedFactory)
const factories = computed(() => selectionStore.factories)
const year = computed(() => selectionStore.selectedYear)
const years = computed(() => selectionStore.years)

const otherData = ref({})
const isEditing = ref(false)
const tempReasons = ref({})

const indicatorNames = {
  // 供应链管理
  supply_total_suppliers: '供应商总数',
  supply_env_screened: '使用环境评价维度筛选的新供应商',
  supply_soc_screened: '使用社会标准筛选的新供应商',
  supply_env_assessment_count: '开展环境影响评估的供应商数量',
  supply_soc_assessment_count: '开展社会影响评估的供应商数量',
  supply_env_penalty_count: '供应商环境处罚次数',
  supply_env_penalty_amount: '供应商环境处罚总额',
  supply_cyber_incidents: '供应商网络数据安全事件',
  supply_local_amount: '向当地供应商支出的采购金额',
  supply_total_amount: '采购总金额',
  supply_local_purchase_ratio: '向当地供应商采购的支出比例',

  // 产品责任
  product_complaints_total: '客户投诉总数',
  product_complaints_handled: '有效处理件数',
  product_complaints_handle_rate: '客户投诉有效处理率',
  product_customer_satisfaction: '客户满意度结果',
  product_recall_count: '发生产品召回的次数',
  product_recall_percent: '产品召回百分比',
  product_product_quality_issues: '产品安全质量问题',
  product_cyber_incidents: '网络数据安全事件',

  // 知识产权保护
  ipr_patents_total: '累计获得专利数量',
  ipr_invention_total: '累计发明专利数量',
  ipr_invention_applications: '发明专利申请数量',
  ipr_utility_model_total: '累计实用新型专利数量',
  ipr_design_total: '累计外观设计专利数量',
  ipr_authorized_total: '累计被授权专利数',
  ipr_new_patents_year: '本年新增专利数量',
  ipr_software_copyright_total: '累计软件著作权数量',
  ipr_trademarks_total: '累计商标注册数量',

  // 社区参与
  community_charity_donations: '公益慈善捐赠总额/对外捐赠总额',
  community_community_investment: '社区发展投入金额',

  // 志愿活动
  volunteer_volunteer_participants: '志愿者活动参与人次',
  volunteer_volunteer_hours: '志愿者服务总时长'
}

const fetchData = async () => {
  try {
    const res = await apiClient.get('/analytical/social_quantitative_other', {
      params: { factory: factory.value, year: year.value }
    })
    otherData.value = res.data
    console.log(otherData.value)
  } catch (e) {
    console.error(e)
    alert(`获取社会定量-其他数据失败: ${e.response?.data?.detail || e.message}`)
  }
}

const formatComparison = (value) => {
  if (value === null || value === undefined) return ''
  return `${value > 0 ? '+' : ''}${value}%`
}

const formatValue = (v) => {
  if (v === null || v === undefined) return ''
  return v
}

onMounted(() => {
  document.addEventListener('click', selectionStore.handleClickOutside)
  fetchData()
})

watch([factory, year], () => {
  fetchData()
})

const startEditing = () => {
  isEditing.value = true
  tempReasons.value = {}
  Object.values(otherData.value).forEach(group => {
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
    await apiClient.post('/analytical/social_quantitative_other', {
      factory: factory.value,
      year: parseInt(year.value),
      reasons: reasonsMap
    })
    alert('原因提交成功！')
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
