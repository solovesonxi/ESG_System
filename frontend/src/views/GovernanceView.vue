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

      <fieldset class="summary-fieldset">
        <legend>管治定性</legend>
        <div class="form-row">
          <table class="data-table">
            <thead>
              <tr>
                <th>大类</th>
                <th>指标</th>
                <th>指标释义</th>
                <th>来源</th>
                <th>今年的方针、政策、文件、记录等</th>
                <th>去年的方针、政策、文件、记录等</th>
                <th>对比去年</th>
                <th>原因分析</th>
              </tr>
            </thead>
            <tbody>
              <template v-for="(indicators, category) in qualData" :key="category">
                <tr v-for="(item, key, index) in indicators" :key="key">
                  <td v-if="index === 0" :rowspan="Object.keys(indicators).length">{{ category }}</td>
                  <td>{{ key }}</td>
                  <td>{{ item.explanation || 'N/A' }}</td>
                  <td>{{ item.source || 'N/A' }}</td>
                  <td>{{ item.currentText || 'N/A' }}</td>
                  <td>{{ item.lastText || 'N/A' }}</td>
                  <td>{{ item.comparisonText || 'N/A' }}</td>
                  <td>{{ item.reason || 'N/A' }}</td>
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
import { computed, onMounted, ref, watch } from 'vue'
import apiClient from '@/utils/axios';

import { useSelectionStore } from '@/stores/selectionStore.js'

const selectionStore = useSelectionStore()
const factory = computed(() => selectionStore.selectedFactory)
const factories = computed(() => selectionStore.factories)
const year = computed(() => selectionStore.selectedYear)
const years = computed(() => selectionStore.years)

const qualData = ref({})

const fetchQualData = async () => {
  try {
    const res = await apiClient.get('/analytical/env_quantitative', {
      params: { factory: factory.value, year: year.value }
    })
    qualData.value = res.data || {}
  } catch (e) {
    console.error(e)
    alert(`获取管治定性数据失败: ${e.response?.data?.detail || e.message}`)
  }
}

onMounted(() => {
  document.addEventListener('click', selectionStore.handleClickOutside)
  fetchQualData()
})

watch([factory, year], () => {
  fetchQualData()
})
</script>

<style scoped>
.shared-form {
  padding: 20px;
}

.form-row {
  display: flex;
  gap: 20px;
  margin-bottom: 20px;
}

.form-group {
  flex: 1;
}

.custom-select {
  position: relative;
  width: 100%;
}

.selected {
  padding: 10px;
  border: 1px solid #ccc;
  border-radius: 4px;
  cursor: pointer;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.arrow {
  border: solid #000;
  border-width: 0 2px 2px 0;
  display: inline-block;
  padding: 3px;
  transform: rotate(45deg);
}

.arrow.up {
  transform: rotate(-135deg);
}

.options {
  position: absolute;
  top: 100%;
  left: 0;
  right: 0;
  border: 1px solid #ccc;
  border-radius: 4px;
  background: #fff;
  z-index: 10;
  max-height: 200px;
  overflow-y: auto;
}

.option {
  padding: 10px;
  cursor: pointer;
}

.option:hover {
  background: #f0f0f0;
}

.selected-option {
  background: #e0e0e0;
}

.summary-fieldset {
  margin-top: 20px;
}

.data-table {
  width: 100%;
  border-collapse: collapse;
}

.data-table th,
.data-table td {
  border: 1px solid #ddd;
  padding: 8px;
  text-align: left;
}

.data-table th {
  background-color: #f2f2f2;
}
</style>
