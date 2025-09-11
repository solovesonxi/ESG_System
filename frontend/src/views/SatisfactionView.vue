<template>
  <div class="shared-form">
    <form>
      <BaseInfoSelector @selection-changed="fetchData"/>
      <fieldset class="summary-fieldset">
        <legend>{{ year }}年{{ month }}月员工满意度调查统计</legend>
        <div class="loading" v-if="isLoading">数据加载中...</div>
        <div class="form-row" v-else>
          <div class="form-group">
            <label>员工满意度 （%）</label>
            <input type="number" v-model.number="formData.satisfaction[month-1]" min="0" max="100" step="0.01"
                   :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
          </div>
        </div>
      </fieldset>
      <fieldset class="summary-fieldset">
        <legend>{{ year }}年员工满意度统计 - 汇总</legend>
        <div class="loading" v-if="isLoading">数据加载中...</div>
        <div class="form-row" v-else>
          <div class="form-group">
            <label>年平均员工满意度 （%）</label>
            <input type="number" v-model.number="annualAverage" min="0" max="100" step="0.01" disabled>
          </div>
        </div>
      </fieldset>
    </form>
  </div>
</template>

<script setup>
import {computed, onBeforeUnmount, onMounted, reactive, ref} from 'vue'
import {useSelectionStore} from '@/stores/selectionStore'
import apiClient from '@/utils/axios'
import BaseInfoSelector from "@/components/BaseInfoSelector.vue";

// —— 与能源统计保持一致的状态 —— //
const selectionStore = useSelectionStore()
const factory = computed(() => selectionStore.selectedFactory)
const year = computed(() => selectionStore.selectedYear);
const month = computed(() => selectionStore.selectedMonth);

const isEditing = ref(false)
const isLoading = ref(false)

// —— 满意度数据 —— //
const formData = reactive({
  satisfaction: Array(12).fill(null)
})

const toNum = (v, d = null) => {
  if (v === null) return null;
  const n = Number(v);
  return Number.isFinite(n) ? n : d;
}

const annualAverage = computed(() => {
  const validMonths = formData.satisfaction.filter(v => v > 0);
  if (validMonths.length === 0) return null;
  const sum = validMonths.reduce((total, value) => total + toNum(value), 0);
  return (sum / validMonths.length).toFixed(2);
})

onMounted(() => {
  document.addEventListener('click', selectionStore.handleClickOutside)
  fetchData()
})

onBeforeUnmount(() => {
  document.removeEventListener('click', selectionStore.handleClickOutside)
})

// —— 获取数据（与能源统计风格相同） —— //
const fetchData = async () => {
  if (!factory.value || !year.value) {
    resetFormData()
    return
  }
  isLoading.value = true
  try {
    const resp = await apiClient.get('/quantitative/satisfaction', {
      params: {factory: factory.value, year: year.value}
    })
    const data = resp?.data?.data
    if (data) {
      // 兼容后端下划线/驼峰
      setArray(formData.satisfaction, data.satisfaction || Array(12).fill(0))
    } else {
      resetFormData()
    }
  } catch (err) {
    if (err.response?.status === 404) {
      resetFormData()
    } else {
      console.error('获取满意度数据失败:', err)
      resetFormData()
    }
  } finally {
    isLoading.value = false
  }
}

const setArray = (reactiveArr, sourceArr) => {
  for (let i = 0; i < 12; i++) reactiveArr[i] = toNum(sourceArr?.[i] ?? 0)
}

// —— 重置（与能源一致的重置思路） —— //
const resetFormData = () => {
  setArray(formData.satisfaction, Array(12).fill(0))
}

// —— 提交编辑（保持原字段，不改动内容，只改样式） —— //
const submitEdit = async () => {
  if (!factory.value) {
    alert('请选择工厂名称')
    return
  }
  try {
    const payload = {
      factory: factory.value,
      year: Number(year.value),
      satisfaction: [...formData.satisfaction],
      annualAverage: annualAverage.value
    }

    const resp = await apiClient.post('/quantitative/satisfaction', payload)
    if (resp.data?.status === 'success') {
      alert('满意度数据提交成功!')
    }
  } catch (err) {
    console.error('提交失败:', err)
    alert(`提交失败: ${err.response?.data?.detail || err.message}`)
  } finally {
    // 与能源一致：提交后退出编辑并刷新
    isEditing.value = false
    await fetchData()
  }
}

// —— 暴露方法，与能源统计完全一致 —— //
defineExpose({
  startEditing: () => (isEditing.value = true),
  cancelEditing: () => {
    isEditing.value = false
    fetchData()
  },
  submitEdit,
  fetchData
})
</script>
