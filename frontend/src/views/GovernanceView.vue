<template>
  <div class="shared-form">
    <form>
      <BaseInfoSelector @selection-changed="fetchData"/>
      <fieldset class="summary-fieldset">
        <legend>治理定性</legend>
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
                <td>{{ item.explanation || '' }}</td>
                <td>{{ item.source || '' }}</td>
                <td>{{ item.currentText || '' }}</td>
                <td>{{ item.lastText || '' }}</td>
                <td>{{ item.comparisonText || '' }}</td>
                <td>{{ item.reason || '' }}</td>
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
import {computed, onMounted, ref} from 'vue'
import apiClient from '@/utils/axios';

import {useSelectionStore} from '@/stores/selectionStore.js'
import BaseInfoSelector from "@/components/BaseInfoSelector.vue";

const selectionStore = useSelectionStore()
const factory = computed(() => selectionStore.selectedFactory)
const year = computed(() => selectionStore.selectedYear)

const qualData = ref({})

const fetchData = async () => {
  try {
    const res = await apiClient.get('/analytical/governance', {
      params: {factory: factory.value, year: year.value}
    })
    qualData.value = res.data || {}
  } catch (e) {
    console.error(e)
    alert(`获取治理定性数据失败: ${e.response?.data?.detail || e.message}`)
  }
}

onMounted(() => {
  document.addEventListener('click', selectionStore.handleClickOutside)
  fetchData()
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
