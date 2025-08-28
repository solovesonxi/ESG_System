<template>
  <div class="shared-form">
    <form @submit.prevent="submitSupply">
      <!-- 基础信息保持不变 -->
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

      <!-- 供应商表格 - 已去除工厂和单位列 -->
      <fieldset>
        <legend>{{ year }}年供应商统计</legend>
        <div class="table-wrapper">
          <table class="supply-table">
            <thead>
            <tr>
              <th>华东地区</th>
              <th>华南地区</th>
              <th>其他地区</th>
              <th>合计</th>
              <th>环境筛选供应商</th>
              <th>社会标准供应商</th>
              <th>当地采购金额(万元)</th>
              <th>采购总金额(万元)</th>
              <th>环境维度占比(%)</th>
              <th>社会标准占比(%)</th>
              <th>当地采购比例(%)</th>
              <th>环境处罚次数(次)</th>
              <th>环境处罚金额(万元)</th>
              <th>数据安全事件(次)</th>
            </tr>
            </thead>
            <tbody>
            <tr>
              <!-- 供应商地区分布 -->
              <td><input type="number" min="0" step="1" v-model.number="formData.east"></td>
              <td><input type="number" min="0" step="1" v-model.number="formData.south"></td>
              <td><input type="number" min="0" step="1" v-model.number="formData.other"></td>
              <td class="total-cell">{{ totalSuppliers }}</td>

              <!-- 供应商筛选 -->
              <td><input type="number" min="0" step="1" v-model.number="formData.envScreened"></td>
              <td><input type="number" min="0" step="1" v-model.number="formData.socScreened"></td>

              <!-- 采购金额 -->
              <td><input type="number" min="0" step="0.01" v-model.number="formData.localAmount"></td>
              <td><input type="number" min="0" step="0.01" v-model.number="formData.totalAmount"></td>

              <!-- 计算指标 -->
              <td class="total-cell">{{ envRatio }}%</td>
              <td class="total-cell">{{ socRatio }}%</td>
              <td class="total-cell">{{ localPurchaseRatio }}%</td>

              <!-- 供应商问题 -->
              <td><input type="number" min="0" step="1" v-model.number="formData.envPenaltyCount"></td>
              <td><input type="number" min="0" step="0.01" v-model.number="formData.envPenaltyAmount"></td>
              <td><input type="number" min="0" step="1" v-model.number="formData.cyberIncidents"></td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <div style="opacity:.75; font-size:12px; line-height:1.4; margin-top:8px">
        <div>* 当地采购：工厂按大区统计（华南、华东、华中等）。</div>
        <div>* 明确使用环境、社会标准审查的供应商范畴：生产型供应商（核心供应商），剔除行政采购类供应商。</div>
        <div>* 供应商行为准则签订比例（廉洁、环保、冲突矿产）可后续扩展。</div>
      </div>

      <button type="submit" :disabled="isSubmitting">
        {{ isSubmitting ? '提交中...' : '提交供应链数据' }}
      </button>
    </form>
  </div>
</template>

<script setup>
import { computed, reactive, ref } from 'vue'
import axios from 'axios'
import { useSelectionStore } from '@/stores/selectionStore'

const selectionStore = useSelectionStore()
const factory = computed(() => selectionStore.selectedFactory)
const factories = computed(() => selectionStore.factories)
const year = computed(() => selectionStore.selectedYear)
const years = computed(() => selectionStore.years)
const isSubmitting = ref(false)

// 表单数据模型
const formData = reactive({
  east: 0,
  south: 0,
  other: 0,
  envScreened: 0,
  socScreened: 0,
  localAmount: 0,
  totalAmount: 0,
  envPenaltyCount: 0,
  envPenaltyAmount: 0,
  cyberIncidents: 0
})

// 计算属性
const totalSuppliers = computed(() => formData.east + formData.south + formData.other)
const envRatio = computed(() => calculatePercent(formData.envScreened, totalSuppliers.value))
const socRatio = computed(() => calculatePercent(formData.socScreened, totalSuppliers.value))
const localPurchaseRatio = computed(() => calculatePercent(formData.localAmount, formData.totalAmount))

// 计算百分比函数
const calculatePercent = (numerator, denominator) => {
  if (denominator <= 0) return 0
  return ((numerator / denominator) * 100).toFixed(2)
}

// 提交数据
const submitSupply = async () => {
  if (!factory.value) {
    alert('请选择工厂名称')
    return
  }

  isSubmitting.value = true
  try {
    const payload = {
      factory: factory.value,
      year: Number(year.value),
      ...formData,
      totalSuppliers: totalSuppliers.value,
      envRatio: envRatio.value,
      socRatio: socRatio.value,
      localPurchaseRatio: localPurchaseRatio.value
    }

    const response = await axios.post('http://localhost:8000/quantitative/supply', payload)

    if (response.data.status === 'success') {
      alert('供应链数据提交成功!')
      // 重置表单
      Object.keys(formData).forEach(key => {
        formData[key] = 0
      })
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
.table-wrapper{overflow:auto}
.supply-table{width:100%; border-collapse:collapse}
.supply-table th,.supply-table td{border:1px solid #ddd; padding:6px; text-align:center}
.supply-table thead th{position:sticky; top:0; background:#f7f7f7; z-index:1}

.total-cell{font-weight:600}
.grand-total td{font-weight:700; background:#fafafa}
.supply-table input{width:110px}
@media (max-width: 768px){.supply-table input{width:90px}}
</style>