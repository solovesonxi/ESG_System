<template>
  <div class="shared-form">
    <form @submit.prevent="submitEmployment">
      <!-- 基础信息部分保持不变 -->
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
                <div v-for="f in factories" :key="f"
                     class="option"
                     :class="{ 'selected-option': f === factory }"
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
                <div v-for="y in years" :key="y"
                     class="option"
                     :class="{ 'selected-option': y === year }"
                     @click="selectionStore.selectYear(y)">
                  {{ y }}年
                </div>
              </div>
            </div>
          </div>
        </div>
      </fieldset>

      <!-- 雇佣数据表格 - 已去除工厂列 -->
      <fieldset>
        <legend>{{ year }}年员工雇佣统计</legend>
        <div class="table-wrapper">
          <table class="employment-table">
            <thead>
            <tr>
              <th>员工总数</th>
              <th>全职</th>
              <th>兼职</th>
              <th>男</th>
              <th>女</th>
              <th>管理层</th>
              <th>管理层女</th>
              <th>中层</th>
              <th>普通</th>
              <th>大陆</th>
              <th>海外</th>
              <th>博士+</th>
              <th>硕士</th>
              <th>本科</th>
              <th>专科及以下</th>
              <th>人均五险一金</th>
              <th>人均五险一金增加额</th>
              <th>18-30</th>
              <th>31-45</th>
              <th>46-60</th>
              <th>新进</th>
              <th>离职总数</th>
              <th>男离职</th>
              <th>女离职</th>
              <th>大陆离职</th>
              <th>海外离职</th>
              <th>18-30离</th>
              <th>31-45离</th>
              <th>46-60离</th>
              <th>管理层离</th>
              <th>中层离</th>
              <th>普通离</th>
              <th>总流失率%</th>
              <th>男流失率%</th>
              <th>女流失率%</th>
              <th>大陆流失率%</th>
              <th>海外流失率%</th>
              <th>18-30流失率%</th>
              <th>31-45流失率%</th>
              <th>46-60流失率%</th>
              <th>管理层流失率%</th>
              <th>中层流失率%</th>
              <th>普通流失率%</th>
            </tr>
            </thead>
            <tbody>
            <tr>
              <!-- 计算字段 -->
              <td class="total-cell">{{ totalEmployees }}</td>

              <!-- 输入字段 -->
              <td><input type="number" min="0" step="1" v-model.number="formData.fullTime"></td>
              <td><input type="number" min="0" step="1" v-model.number="formData.partTime"></td>
              <td><input type="number" min="0" step="1" v-model.number="formData.male"></td>
              <td><input type="number" min="0" step="1" v-model.number="formData.female"></td>
              <td><input type="number" min="0" step="1" v-model.number="formData.management"></td>
              <td><input type="number" min="0" step="1" v-model.number="formData.managementFemale"></td>
              <td><input type="number" min="0" step="1" v-model.number="formData.middle"></td>
              <td><input type="number" min="0" step="1" v-model.number="formData.general"></td>
              <td><input type="number" min=" 0" step="1" v-model.number="formData.mainland"></td>
              <td><input type="number" min="0" step="1" v-model.number="formData.overseas"></td>
              <td><input type="number" min="0" step="1" v-model.number="formData.eduPhd"></td>
              <td><input type="number" min="0" step="1" v-model.number="formData.eduMaster"></td>
              <td><input type="number" min="0" step="1" v-model.number="formData.eduBachelor"></td>
              <td><input type="number" min="0" step="1" v-model.number="formData.eduJunior"></td>
              <td><input type="number" min="0" step="0.01" v-model.number="formData.avgSocialFund"></td>
              <td><input type="number" min="0" step="0.01" v-model.number="formData.incSocialFund"></td>
              <td><input type="number" min="0" step="1" v-model.number="formData.age18_30"></td>
              <td><input type="number" min="0" step="1" v-model.number="formData.age31_45"></td>
              <td><input type="number" min="0" step="1" v-model.number="formData.age46_60"></td>
              <td><input type="number" min="0" step="1" v-model.number="formData.newHires"></td>

              <!-- 计算字段 -->
              <td class="total-cell">{{ quitTotal }}</td>

              <!-- 输入字段 -->
              <td><input type="number" min="0" step="1" v-model.number="formData.quitMale"></td>
              <td><input type="number" min="0" step="1" v-model.number="formData.quitFemale"></td>
              <td><input type="number" min="0" step="1" v-model.number="formData.quitMainland"></td>
              <td><input type="number" min="0" step="1" v-model.number="formData.quitOverseas"></td>
              <td><input type="number" min="0" step="1" v-model.number="formData.quit18_30"></td>
              <td><input type="number" min="0" step="1" v-model.number="formData.quit31_45"></td>
              <td><input type="number" min="0" step="1" v-model.number="formData.quit46_60"></td>
              <td><input type="number" min="0" step="1" v-model.number="formData.quitManagement"></td>
              <td><input type="number" min="0" step="1" v-model.number="formData.quitMiddle"></td>
              <td><input type="number" min="0" step="1" v-model.number="formData.quitGeneral"></td>

              <!-- 流失率计算属性 -->
              <td class="total-cell">{{ turnoverRate }}%</td>
              <td class="total-cell">{{ maleTurnoverRate }}%</td>
              <td class="total-cell">{{ femaleTurnoverRate }}%</td>
              <td class="total-cell">{{ mainlandTurnoverRate }}%</td>
              <td class="total-cell">{{ overseasTurnoverRate }}%</td>
              <td class="total-cell">{{ age18_30TurnoverRate }}%</td>
              <td class="total-cell">{{ age31_45TurnoverRate }}%</td>
              <td class="total-cell">{{ age46_60TurnoverRate }}%</td>
              <td class="total-cell">{{ managementTurnoverRate }}%</td>
              <td class="total-cell">{{ middleTurnoverRate }}%</td>
              <td class="total-cell">{{ generalTurnoverRate }}%</td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <button type="submit" :disabled="isSubmitting">
        {{ isSubmitting ? '提交中...' : '提交雇佣数据' }}
      </button>
    </form>
  </div>
</template>

<script setup>
import {computed, onBeforeUnmount, onMounted, reactive, ref} from 'vue'
import axios from 'axios'
import {useSelectionStore} from '@/stores/selectionStore'

const selectionStore = useSelectionStore()
const factory = computed(() => selectionStore.selectedFactory)
const factories = computed(() => selectionStore.factories)
const year = computed(() => selectionStore.selectedYear)
const years = computed(() => selectionStore.years)
const isSubmitting = ref(false)

onMounted(() => {
  selectionStore.initYears()
  document.addEventListener('click', selectionStore.handleClickOutside)
})

onBeforeUnmount(() => {
  document.removeEventListener('click', selectionStore.handleClickOutside)
})

// 表单数据模型（所有字段独立定义）
const formData = reactive({
  // 员工构成数据
  fullTime: 0,
  partTime: 0,
  male: 0,
  female: 0,
  management: 0,
  managementFemale: 0,
  middle: 0,
  general: 0,
  mainland: 0,
  overseas: 0,
  eduPhd: 0,
  eduMaster: 0,
  eduBachelor: 0,
  eduJunior: 0,

  // 五险一金数据
  avgSocialFund: 0,
  incSocialFund: 0,

  // 年龄分布
  age18_30: 0,
  age31_45: 0,
  age46_60: 0,

  // 新员工与离职数据
  newHires: 0,
  quitMale: 0,
  quitFemale: 0,
  quitMainland: 0,
  quitOverseas: 0,
  quit18_30: 0,
  quit31_45: 0,
  quit46_60: 0,
  quitManagement: 0,
  quitMiddle: 0,
  quitGeneral: 0
})

// 计算属性
const totalEmployees = computed(() => formData.fullTime + formData.partTime)
const quitTotal = computed(() => formData.quitMale + formData.quitFemale)

// 流失率计算函数
const calculateRate = (numerator, denominator) => {
  if (denominator <= 0) return 0
  return ((numerator / denominator) * 100).toFixed(2)
}

// 15种流失率计算属性
const turnoverRate = computed(() => calculateRate(quitTotal.value, totalEmployees.value))
const maleTurnoverRate = computed(() => calculateRate(formData.quitMale, formData.male))
const femaleTurnoverRate = computed(() => calculateRate(formData.quitFemale, formData.female))
const mainlandTurnoverRate = computed(() => calculateRate(formData.quitMainland, formData.mainland))
const overseasTurnoverRate = computed(() => calculateRate(formData.quitOverseas, formData.overseas))
const age18_30TurnoverRate = computed(() => calculateRate(formData.quit18_30, formData.age18_30))
const age31_45TurnoverRate = computed(() => calculateRate(formData.quit31_45, formData.age31_45))
const age46_60TurnoverRate = computed(() => calculateRate(formData.quit46_60, formData.age46_60))
const managementTurnoverRate = computed(() => calculateRate(formData.quitManagement, formData.management))
const middleTurnoverRate = computed(() => calculateRate(formData.quitMiddle, formData.middle))
const generalTurnoverRate = computed(() => calculateRate(formData.quitGeneral, formData.general))

// 提交雇佣数据
const submitEmployment = async () => {
  if (!factory.value) {
    alert('请选择工厂名称')
    return
  }

  isSubmitting.value = true
  try {
    // 准备提交数据 - 所有字段独立
    const payload = {
      factory: factory.value,
      year: Number(year.value),

      // 员工构成数据
      fullTime: formData.fullTime,
      partTime: formData.partTime,
      male: formData.male,
      female: formData.female,
      management: formData.management,
      managementFemale: formData.managementFemale,
      middle: formData.middle,
      general: formData.general,
      mainland: formData.mainland,
      overseas: formData.overseas,
      eduPhd: formData.eduPhd,
      eduMaster: formData.eduMaster,
      eduBachelor: formData.eduBachelor,
      eduJunior: formData.eduJunior,

      // 五险一金数据
      avgSocialFund: formData.avgSocialFund,
      incSocialFund: formData.incSocialFund,

      // 年龄分布
      age18_30: formData.age18_30,
      age31_45: formData.age31_45,
      age46_60: formData.age46_60,

      // 新员工与离职数据
      newHires: formData.newHires,
      quitMale: formData.quitMale,
      quitFemale: formData.quitFemale,
      quitMainland: formData.quitMainland,
      quitOverseas: formData.quitOverseas,
      quit18_30: formData.quit18_30,
      quit31_45: formData.quit31_45,
      quit46_60: formData.quit46_60,
      quitManagement: formData.quitManagement,
      quitMiddle: formData.quitMiddle,
      quitGeneral: formData.quitGeneral,

      // 计算指标
      totalEmployees: totalEmployees.value,
      quitTotal: quitTotal.value,
      turnoverRate: turnoverRate.value,
      maleTurnoverRate: maleTurnoverRate.value,
      femaleTurnoverRate: femaleTurnoverRate.value,
      mainlandTurnoverRate: mainlandTurnoverRate.value,
      overseasTurnoverRate: overseasTurnoverRate.value,
      age18_30TurnoverRate: age18_30TurnoverRate.value,
      age31_45TurnoverRate: age31_45TurnoverRate.value,
      age46_60TurnoverRate: age46_60TurnoverRate.value,
      managementTurnoverRate: managementTurnoverRate.value,
      middleTurnoverRate: middleTurnoverRate.value,
      generalTurnoverRate: generalTurnoverRate.value
    }

    const response = await axios.post('http://localhost:8000/quantitative/employment', payload)

    if (response.data.status === 'success') {
      alert('雇佣数据提交成功!')
    }
  } catch (error) {
    console.error('提交失败:', error)
    alert(`提交失败: ${error.response?.data?.detail || error.message}`)
  } finally {
    isSubmitting.value = false
  }
}
</script>

<style scoped>
/* 样式保持不变 */
.table-wrapper {
  overflow: auto
}

.employment-table {
  width: 100%;
  border-collapse: collapse
}

.employment-table th, .employment-table td {
  border: 1px solid #ddd;
  padding: 6px;
  text-align: center
}

.employment-table thead th {
  position: sticky;
  top: 0;
  background: #f7f7f7;
  z-index: 1
}

.total-cell {
  font-weight: 600
}

.employment-table input {
  width: 90px
}

@media (max-width: 768px) {
  .employment-table input {
    width: 70px
  }
}
</style>