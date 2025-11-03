<template>
  <div class="shared-form">
    <form>
      <BaseInfoSelector :review="review" :isYear="false" :isSummary="false" @selection-changed="fetchData"/>
      <div v-if="isLoading" class="loading">数据加载中...</div>
      <template v-else>
        <fieldset v-for="(s, si) in sets" :key="si" class="summary-fieldset">
          <legend>{{ year }}年{{ month }}月{{ s.set }}</legend>
          <div class="form-row">
            <div v-for="(f, fi) in s.fields" :key="fi" class="form-group">
              <label>{{ f.name_zh }}（{{ f.unit }}）</label>
              <input
                  type="number"
                  :step="f.step"
                  v-model.number="f.value[month - 1]"
                  :readonly="!isEditing"
                  :class="{ 'editable-field': isEditing }"
                  required
              >
            </div>
          </div>
        </fieldset>
      </template>
    </form>
  </div>
</template>

<script setup lang="js">
import {computed, onBeforeUnmount, onMounted, ref} from 'vue'
import apiClient from '@/utils/axios';
import {useSelectionStore} from "@/stores/selectionStore.js"
import BaseInfoSelector from "@/components/BaseInfoSelector.vue";
import {handleError, showError, showInfo, showSuccess} from "@/utils/toast.js";

const selectionStore = useSelectionStore()
const category = computed(() => selectionStore.selectedCategoryMonthly);
const factory = computed(() => selectionStore.selectedFactory);
const year = computed(() => selectionStore.selectedYear);
const month = computed(() => selectionStore.selectedMonth);
const isEditing = ref(false)
const isLoading = ref(false)

// 后端返回的动态集合
const sets = ref([])
const review = ref({});


// 将单个字段值规范化为长度为 12 的数组（不做数值计算，仅结构化）
function normalizeFieldValue(val) {
  if (Array.isArray(val)) {
    const arr = val.slice(0, 12)
    while (arr.length < 12) arr.push(0)
    return arr.map(v => (v === null || v === undefined) ? 0 : Number(v))
  }
  if (val === null || val === undefined) return Array(12).fill(0)
  return Array(12).fill(Number(val))
}

function normalizeSets(rawSets) {
  return (rawSets || []).map(s => ({
    set: s.set,
    fields: (s.fields || []).map(f => ({
      name_en: f.name_en,
      name_zh: f.name_zh,
      unit: f.unit,
      value: normalizeFieldValue(f.value),
      step: f.step || 1
    }))
  }))
}

onMounted(() => {
  document.addEventListener("click", selectionStore.handleClickOutside);
});

onBeforeUnmount(() => {
  document.removeEventListener("click", selectionStore.handleClickOutside);
});


const resetFormData = () => {
  sets.value = []
  review.value = {
    id: Array(12).fill(-1),
    is_submitted: Array(12).fill(false),
    status1: Array(12).fill("pending"),
    comment1: Array(12).fill(''),
    status2: Array(12).fill("pending"),
    comment22: Array(12).fill('')
  }
}

// 获取数据并直接使用后端结构
const fetchData = async () => {
  isLoading.value = true
  try {
    resetFormData()
    // console.log("请求参数：", category.value.id, factory.value, year.value)
    const response = await apiClient.get(`/month`, {
      params: {
        category_id: category.value.id,
        factory: factory.value,
        year: year.value
      }
    })
    if (response.data && response.data.sets) {
      sets.value = normalizeSets(response.data.sets || [])
      review.value = response.data.review
      console.log("月度结果：", category.value, factory.value, year.value, response.data)
    } else {
      showInfo("未找到数据")
    }
  } catch (error) {
    handleError(error)
  } finally {
    isLoading.value = false
  }
}

// 提交：把所有字段名和值（数组）直接传给后端，不做计算
const submitEdit = async (ifSubmit) => {
  try {
    const payload = {
      category_id: category.value.id,
      factory: factory.value,
      year: year.value,
      month: month.value,
      sets: sets.value,
      isSubmitted: ifSubmit
    }
    // console.log("提交参数：", payload)
    const response = await apiClient.post('/month', payload);
    const operation = ifSubmit ? '提交' : '保存';
    if (response.data && response.data.status === 'success') {
      showSuccess('数据' + operation + '成功!')
    } else {
      showError('数据' + operation + '失败: ' + (response.data.message || '未知错误'))
    }
  } catch (error) {
    handleError(error)
  } finally {
    isEditing.value = false
    await fetchData()
  }
}

// 暴露方法给父组件
defineExpose({
  startEditing: () => isEditing.value = true,
  cancelEditing: () => {
    isEditing.value = false
    fetchData()
  },
  submitEdit,
  fetchData
})
</script>
