<template>
  <div class="shared-form">
    <form @submit.prevent="submitResponsibility">
      <!-- 基础信息 -->
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
              <div
                class="options"
                v-show="selectionStore.showFactoryDropdown"
                :style="{ maxHeight: '200px', overflowY: 'auto' }"
              >
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

      <!-- 客户投诉统计 -->
      <fieldset>
        <legend>{{ year }}年客户投诉统计 (件)</legend>
        <div class="table-wrapper">
          <table class="resp-table">
            <thead>
              <tr>
                <th>单位</th>
                <th v-for="(m, idx) in monthNames" :key="`cmp-h-${idx}`">{{ m }}</th>
                <th>合计</th>
                <th>有效处理件数</th>
                <th>有效处理率(%)</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>件</td>
                <td v-for="c in 12" :key="`cmp-c-${c-1}`">
                  <input type="number" min="0" step="1" v-model.number="complaints[currentFactoryIndex][c-1]" />
                </td>
                <td class="total-cell">{{ rowSum(complaints[currentFactoryIndex]) }}</td>
                <td>
                  <input type="number" min="0" step="1" v-model.number="handled[currentFactoryIndex]" />
                </td>
                <td class="total-cell">
                  {{ percent(handled[currentFactoryIndex], rowSum(complaints[currentFactoryIndex])) }}
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <!-- 产品安全质量问题 -->
      <fieldset>
        <legend>{{ year }}年产品安全质量问题 (次)</legend>
        <div class="table-wrapper">
          <table class="resp-table">
            <thead>
              <tr>
                <th>单位</th>
                <th v-for="(m, idx) in monthNames" :key="`qual-h-${idx}`">{{ m }}</th>
                <th>合计</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>次</td>
                <td v-for="c in 12" :key="`qual-c-${c-1}`">
                  <input type="number" min="0" step="1" v-model.number="qualityIssues[currentFactoryIndex][c-1]" />
                </td>
                <td class="total-cell">{{ rowSum(qualityIssues[currentFactoryIndex]) }}</td>
              </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <!-- 产品召回统计 -->
      <fieldset>
        <legend>{{ year }}年产品召回统计 (次)</legend>
        <div class="table-wrapper">
          <table class="resp-table">
            <thead>
              <tr>
                <th>单位</th>
                <th v-for="(m, idx) in monthNames" :key="`rec-h-${idx}`">{{ m }}</th>
                <th>合计</th>
                <th>出货总批次</th>
                <th>召回百分比(%)</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>次</td>
                <td v-for="c in 12" :key="`rec-c-${c-1}`">
                  <input type="number" min="0" step="1" v-model.number="recalls[currentFactoryIndex][c-1]" />
                </td>
                <td class="total-cell">{{ rowSum(recalls[currentFactoryIndex]) }}</td>
                <td>
                  <input type="number" min="0" step="1" v-model.number="shipments[currentFactoryIndex]" />
                </td>
                <td class="total-cell">
                  {{ percent(rowSum(recalls[currentFactoryIndex]), shipments[currentFactoryIndex]) }}
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <!-- 客户满意度统计 -->
      <fieldset>
        <legend>{{ year }}年客户满意度统计 - 总部统一调查 (%)</legend>
        <div class="table-wrapper">
          <table class="resp-table">
            <thead>
              <tr>
                <th>单位</th>
                <th v-for="(m, idx) in monthNames" :key="`csat-h-${idx}`">{{ m }}</th>
                <th>合计</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>%</td>
                <td v-for="c in 12" :key="`csat-c-${c-1}`">
                  <input type="number" min="0" max="100" step="0.01"
                    v-model.number="customerSatisfaction[currentFactoryIndex][c-1]" />
                </td>
                <td class="total-cell">{{ averageRow(customerSatisfaction[currentFactoryIndex]) }}</td>
              </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <!-- 网络数据安全事件 -->
      <fieldset>
        <legend>{{ year }}年网络数据安全事件 (次)</legend>
        <div class="table-wrapper">
          <table class="resp-table">
            <thead>
              <tr>
                <th>单位</th>
                <th v-for="(m, idx) in monthNames" :key="`cyb-h-${idx}`">{{ m }}</th>
                <th>合计</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>次</td>
                <td v-for="c in 12" :key="`cyb-c-${c-1}`">
                  <input type="number" min="0" step="1" v-model.number="cyberIncidents[currentFactoryIndex][c-1]" />
                </td>
                <td class="total-cell">{{ rowSum(cyberIncidents[currentFactoryIndex]) }}</td>
              </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <button type="submit" :disabled="isSubmitting">{{ isSubmitting ? '提交中...' : '提交产品责任数据' }}</button>
    </form>
  </div>
</template>

<script setup>
import { computed, onBeforeUnmount, onMounted, reactive, ref } from 'vue'
import axios from 'axios'
import { useSelectionStore } from '@/stores/selectionStore'

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

const monthNames = ['1月','2月','3月','4月','5月','6月','7月','8月','9月','10月','11月','12月']
function buildMatrix(rows) { return Array.from({ length: rows }, () => Array(12).fill(0)) }

const complaints = reactive(buildMatrix(factories.value.length))
const qualityIssues = reactive(buildMatrix(factories.value.length))
const recalls = reactive(buildMatrix(factories.value.length))
const customerSatisfaction = reactive(buildMatrix(factories.value.length))
const cyberIncidents = reactive(buildMatrix(factories.value.length))

const handled = reactive(Array(factories.value.length).fill(0))
const shipments = reactive(Array(factories.value.length).fill(0))

// 当前工厂索引
const currentFactoryIndex = computed(() => factories.value.indexOf(factory.value))

// 工具函数
const rowSum = (row) => row.reduce((s, v) => s + (Number(v) || 0), 0)
const percent = (num, den) => {
  num = Number(num || 0)
  den = Number(den || 0)
  if (den <= 0 || num < 0) return 0
  return ((num / den) * 100).toFixed(2)
}
const averageRow = (row) => { const s = rowSum(row); return (s / 12).toFixed(2) }

async function submitResponsibility() {
  isSubmitting.value = true
  try {
    const payload = {
      year: Number(year.value),
      factories: factories.value,
      complaints,
      handled: [...handled],
      qualityIssues,
      recalls,
      shipments: [...shipments],
      customerSatisfaction,
      cyberIncidents,
    }
    const resp = await axios.post('http://localhost:8000/quantitative/responsibility', payload)
    if (resp.data.status === 'success') alert('产品责任数据提交成功!')
  } catch (e) {
    console.error(e)
    alert(`提交失败: ${e.response?.data?.detail || e.message}`)
  } finally {
    isSubmitting.value = false
  }
}
</script>

<style scoped>
.table-wrapper {
  overflow-x: auto;
  width: 100%;
  box-sizing: border-box;
  margin-bottom: 20px;
}

.resp-table {
  width: 100%;
  min-width: 800px;
  border-collapse: collapse;
  table-layout: fixed;
}

.resp-table th, .resp-table td {
  border: 1px solid #ddd;
  padding: 6px;
  text-align: center;
  word-break: break-word;
}

.resp-table thead th {
  position: sticky;
  top: 0;
  background: #f7f7f7;
  z-index: 1;
}

.total-cell {
  font-weight: 600;
}

.resp-table input {
  width: 100%;
  box-sizing: border-box;
}

@media (max-width: 768px) {
  .resp-table {
    min-width: 600px;
  }
}
</style>
