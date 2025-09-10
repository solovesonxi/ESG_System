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

      <fieldset class="summary-fieldset" v-for="(indicators, category) in qualData" :key="category">
        <legend>{{ category }}</legend>
        <div class="form-row">
          <table class="data-table">
            <thead>
            <tr>
              <th>指标</th>
              <th>去年的方针、政策、文件、记录等</th>
              <th>今年的方针、政策、文件、记录等</th>
              <th>对比去年</th>
              <th>原因分析</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="(item, key) in indicators" :key="key">
              <td>{{ key }}</td>
              <td>
                <div v-if="!isEditing">{{ item.lastText || '' }}</div>
                <textarea v-else v-model="tempEdits[category][key].lastText" class="reason-input" :placeholder="item.lastText || ''"></textarea>
              </td>
              <td>
                <div v-if="!isEditing">{{ item.currentText || '' }}</div>
                <textarea v-else v-model="tempEdits[category][key].currentText" class="reason-input" :placeholder="item.currentText || ''"></textarea>
              </td>
              <td>
                <div v-if="!isEditing">{{ item.comparisonText || '' }}</div>
                <textarea v-else v-model="tempEdits[category][key].comparisonText" class="reason-input" :placeholder="item.comparisonText || ''"></textarea>
              </td>
              <td>
                <div v-if="!isEditing">{{ item.reason || '' }}</div>
                <textarea v-else v-model="tempEdits[category][key].reason" class="reason-input" :placeholder="item.reason || ''"></textarea>
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

const qualData = ref({})
const isEditing = ref(false)
const tempEdits = ref({})

const fetchData = async () => {
  try {
    const res = await apiClient.get('/analytical/social_qualitative_other', {
      params: { factory: factory.value, year: year.value }
    })
    qualData.value = res.data
  } catch (e) {
    console.error(e)
    alert(`获取其他定性数据失败: ${e.response?.data?.detail || e.message}`)
  }
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
  const draft = {}
  Object.entries(qualData.value).forEach(([category, indicators]) => {
    draft[category] = {}
    Object.entries(indicators).forEach(([key, item]) => {
      draft[category][key] = {
        currentText: item.currentText || '',
        lastText: item.lastText || '',
        comparisonText: item.comparisonText || '',
        reason: item.reason || ''
      }
    })
  })
  tempEdits.value = draft
}

const cancelEditing = () => {
  isEditing.value = false
  tempEdits.value = {}
}

const submitEdit = async () => {
  try {
    await apiClient.post('/analytical/social_qualitative_other', {
      factory: factory.value,
      year: parseInt(year.value),
      data: tempEdits.value
    })
    alert('保存成功！')
  } catch (e) {
    console.error(e)
    alert(`保存失败: ${e.response?.data?.detail || e.message}`)
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
