<template>
  <div class="shared-form">
    <form>
      <BaseInfoSelector @selection-changed="fetchData"/>
      <fieldset class="summary-fieldset">
        <legend>{{ year }}年{{ month }}月知识产权数据统计</legend>
        <div class="loading" v-if="isLoading">数据加载中...</div>
        <div v-else>
          <fieldset>
            <legend></legend>
            <div class="form-row">
              <div class="form-group">
                <label>专利 (件)</label>
                <input type="number" v-model.number="formData.patents[month-1]" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>发明专利 (件)</label>
                <input type="number" v-model.number="formData.invPatents[month-1]" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>发明专利申请数量 (件)</label>
                <input type="number" v-model.number="formData.invApplications[month-1]" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>实用新型专利 (件)</label>
                <input type="number" v-model.number="formData.utilityPatents[month-1]" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>外观设计专利 (件)</label>
                <input type="number" v-model.number="formData.designPatents[month-1]" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>被授权专利 (件)</label>
                <input type="number" v-model.number="formData.grantedPatents[month-1]" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>软件著作权 (件)</label>
                <input type="number" v-model.number="formData.softwareCopyrights[month-1]" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
              <div class="form-group">
                <label>商标注册 (件)</label>
                <input type="number" v-model.number="formData.trademarks[month-1]" min="0" step="1"
                       :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required>
              </div>
            </div>
          </fieldset>

          <!-- 发明专利申请数量 -->
          <fieldset>
            <legend>{{ year }}年知识产权统计 - 汇总</legend>
            <div class="form-row">
              <div class="form-group">
                <label>之前专利累计数</label>
                <input type="number" v-model.number="formData.prevPatents" disabled class="calculated-field">
              </div>
              <div class="form-group">
                <label>专利合计</label>
                <input type="number" :value="patentsTotal" disabled class="calculated-field">
              </div>
              <div class="form-group">
                <label>之前发明专利累计数</label>
                <input type="number" v-model.number="formData.prevInvPatents" disabled class="calculated-field">
              </div>
              <div class="form-group">
                <label>发明专利合计</label>
                <input type="number" :value="invPatentsTotal" disabled class="calculated-field">
              </div>
              <div class="form-group">
                <label>之前发明专利申请累计数</label>
                <input type="number" v-model.number="formData.prevInvApplications" disabled class="calculated-field">
              </div>
              <div class="form-group">
                <label>发明专利申请合计</label>
                <input type="number" :value="invApplicationsTotal" disabled class="calculated-field">
              </div>
              <div class="form-group">
                <label>之前实用新型专利累计数</label>
                <input type="number" v-model.number="formData.prevUtilityPatents" disabled class="calculated-field">
              </div>
              <div class="form-group">
                <label>实用新型专利合计</label>
                <input type="number" :value="utilityPatentsTotal" disabled class="calculated-field">
              </div>
              <div class="form-group">
                <label>之前外观设计专利累计数</label>
                <input type="number" v-model.number="formData.prevDesignPatents" disabled class="calculated-field">
              </div>
              <div class="form-group">
                <label>外观设计专利合计</label>
                <input type="number" :value="designPatentsTotal" disabled class="calculated-field">
              </div>
              <div class="form-group">
                <label>之前被授权专利累计数</label>
                <input type="number" v-model.number="formData.prevGrantedPatents" disabled class="calculated-field">
              </div>
              <div class="form-group">
                <label>被授权专利合计</label>
                <input type="number" :value="grantedPatentsTotal" disabled class="calculated-field">
              </div>
              <div class="form-group">
                <label>之前软件著作权累计数</label>
                <input type="number" v-model.number="formData.prevSoftwareCopyrights" disabled class="calculated-field">
              </div>
              <div class="form-group">
                <label>软件著作权合计</label>
                <input type="number" :value="softwareCopyrightsTotal" disabled class="calculated-field">
              </div>
              <div class="form-group">
                <label>之前商标注册累计数</label>
                <input type="number" v-model.number="formData.prevTrademarks" disabled class="calculated-field">
              </div>
              <div class="form-group">
                <label>商标注册合计</label>
                <input type="number" :value="trademarksTotal" disabled class="calculated-field">
              </div>
            </div>
          </fieldset>
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

// —— 知识产权数据 —— //
const formData = reactive({
  patents: Array(12).fill(0),
  invPatents: Array(12).fill(0),
  invApplications: Array(12).fill(0),
  utilityPatents: Array(12).fill(0),
  designPatents: Array(12).fill(0),
  grantedPatents: Array(12).fill(0),
  softwareCopyrights: Array(12).fill(0),
  trademarks: Array(12).fill(0),
  prevPatents: 0,
  prevInvPatents: 0,
  prevInvApplications: 0,
  prevUtilityPatents: 0,
  prevDesignPatents: 0,
  prevGrantedPatents: 0,
  prevSoftwareCopyrights: 0,
  prevTrademarks: 0
})

// —— 汇总与计算（保持原逻辑与命名） —— //
const toNum = (v, d = 0) => {
  const n = Number(v)
  return Number.isFinite(n) ? n : d
}

const rowSum = (arr) => arr.reduce((s, v) => s + toNum(v), 0)

const newPatents = computed(() => rowSum(formData.patents))
const patentsTotal = computed(() => newPatents.value + formData.prevPatents)
const invPatentsTotal = computed(() => rowSum(formData.invPatents) + formData.prevInvPatents)
const invApplicationsTotal = computed(() => rowSum(formData.invApplications) + formData.prevInvApplications)
const utilityPatentsTotal = computed(() => rowSum(formData.utilityPatents) + formData.prevUtilityPatents)
const designPatentsTotal = computed(() => rowSum(formData.designPatents) + formData.prevDesignPatents)
const grantedPatentsTotal = computed(() => rowSum(formData.grantedPatents) + formData.prevGrantedPatents)
const softwareCopyrightsTotal = computed(() => rowSum(formData.softwareCopyrights) + formData.prevSoftwareCopyrights)
const trademarksTotal = computed(() => rowSum(formData.trademarks) + formData.prevTrademarks)

onMounted(() => {
  document.addEventListener('click', selectionStore.handleClickOutside)
  // 首次进入拉取一次
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
    const resp = await apiClient.get('/quantitative/ip', {
      params: {factory: factory.value, year: year.value}
    })
    const data = resp?.data?.data
    if (data) {
      setArray(formData.patents, data.patents || Array(12).fill(0))
      setArray(formData.invPatents, data.invPatents || Array(12).fill(0))
      setArray(formData.invApplications, data.invApplications || Array(12).fill(0))
      setArray(formData.utilityPatents, data.utilityPatents || Array(12).fill(0))
      setArray(formData.designPatents, data.designPatents || Array(12).fill(0))
      setArray(formData.grantedPatents, data.grantedPatents || Array(12).fill(0))
      setArray(formData.softwareCopyrights, data.softwareCopyrights || Array(12).fill(0))
      setArray(formData.trademarks, data.trademarks || data.trademarks || Array(12).fill(0))
      formData.prevPatents = toNum(data.prevPatents || data.prev_patents)
      formData.prevInvPatents = toNum(data.prevInvPatents || data.prev_inv_patents)
      formData.prevInvApplications = toNum(data.prevInvApplications || data.prev_inv_applications)
      formData.prevUtilityPatents = toNum(data.prevUtilityPatents || data.prev_utility_patents)
      formData.prevDesignPatents = toNum(data.prevDesignPatents || data.prev_design_patents)
      formData.prevGrantedPatents = toNum(data.prevGrantedPatents || data.prev_granted_patents)
      formData.prevSoftwareCopyrights = toNum(data.prevSoftwareCopyrights || data.prev_software_copyrights)
      formData.prevTrademarks = toNum(data.prevTrademarks || data.prev_trademarks)
    } else {
      resetFormData()
    }
  } catch (err) {
    if (err.response?.status === 404) {
      resetFormData()
    } else {
      console.error('获取知识产权数据失败:', err)
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
  setArray(formData.patents, Array(12).fill(0))
  setArray(formData.invPatents, Array(12).fill(0))
  setArray(formData.invApplications, Array(12).fill(0))
  setArray(formData.utilityPatents, Array(12).fill(0))
  setArray(formData.designPatents, Array(12).fill(0))
  setArray(formData.grantedPatents, Array(12).fill(0))
  setArray(formData.softwareCopyrights, Array(12).fill(0))
  setArray(formData.trademarks, Array(12).fill(0))
  formData.prevPatents = 0
  formData.prevInvApplications = 0
  formData.prevUtilityPatents = 0
  formData.prevDesignPatents = 0
  formData.prevGrantedPatents = 0
  formData.prevSoftwareCopyrights = 0
  formData.prevTrademarks = 0
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
      patents: [...formData.patents],
      invPatents: [...formData.invPatents],
      invApplications: [...formData.invApplications],
      utilityPatents: [...formData.utilityPatents],
      designPatents: [...formData.designPatents],
      grantedPatents: [...formData.grantedPatents],
      softwareCopyrights: [...formData.softwareCopyrights],
      trademarks: [...formData.trademarks],
      newPatents: newPatents.value,
      patentsTotal: patentsTotal.value,
      invPatentsTotal: invPatentsTotal.value,
      invApplicationsTotal: invApplicationsTotal.value,
      utilityPatentsTotal: utilityPatentsTotal.value,
      designPatentsTotal: designPatentsTotal.value,
      grantedPatentsTotal: grantedPatentsTotal.value,
      softwareCopyrightsTotal: softwareCopyrightsTotal.value,
      trademarksTotal: trademarksTotal.value
    }

    const resp = await apiClient.post('/quantitative/ip', payload)
    if (resp.data?.status === 'success') {
      alert('知识产权数据提交成功!')
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
```