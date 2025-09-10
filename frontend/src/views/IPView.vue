```vue
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
              <div class="options" v-show="selectionStore.showFactoryDropdown"
                   :style="{ maxHeight: '200px', overflowY: 'auto' }">
                <div
                    v-for="f in selectionStore.factories"
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
                    v-for="y in selectionStore.years"
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
          <div class="form-group">
            <label>统计月份</label>
            <div class="custom-select">
              <div class="selected" @click="selectionStore.toggleMonthDropdown">
                {{ month }}月
                <i class="arrow" :class="{ 'up': selectionStore.showMonthDropdown }"></i>
              </div>
              <div class="options" v-show="selectionStore.showMonthDropdown">
                <div
                    v-for="m in selectionStore.months"
                    :key="m"
                    class="option"
                    :class="{ 'selected-option': m === month }"
                    @click="selectionStore.selectMonth(m)"
                >
                  {{ m }}月
                </div>
              </div>
            </div>
          </div>
        </div>
      </fieldset>

      <!-- 知识产权数据部分（样式与能源统计保持一致） -->
      <fieldset class="summary-fieldset">
        <legend>知识产权数据统计</legend>

        <div class="loading" v-if="isLoading">数据加载中...</div>

        <div v-else>
          <!-- 发明专利 -->
          <fieldset>
            <legend>{{ year }}年知识产权统计 - 发明专利 (件)</legend>
            <div class="monthly-grid">
              <div v-for="(_, index) in formData.invPatents" :key="'inv-'+index" class="month-input">
                <label>{{ getMonthName(index) }}</label>
                <input
                  type="number"
                  v-model.number="formData.invPatents[index]"
                  :placeholder="`${getMonthName(index)}发明专利`"
                  min="0"
                  step="1"
                  :readonly="!isEditing"
                  :class="{ 'editable-field': isEditing }"
                  required
                >
              </div>
              <div class="month-input">
                <label>之前累计数</label>
                <input
                  type="number"
                  v-model.number="formData.prevInvPatents"
                  placeholder="之前累计数"
                  min="0"
                  step="1"
                  :readonly="!isEditing"
                  :class="{ 'editable-field': isEditing }"
                  required
                >
              </div>
              <div class="month-input">
                <label>合计</label>
                <input type="number" :value="invPatentsTotal" disabled class="calculated-field">
              </div>
            </div>
          </fieldset>

          <!-- 发明专利申请数量 -->
          <fieldset>
            <legend>{{ year }}年知识产权统计 - 发明专利申请数量 (件)</legend>
            <div class="monthly-grid">
              <div v-for="(_, index) in formData.invApplications" :key="'app-'+index" class="month-input">
                <label>{{ getMonthName(index) }}</label>
                <input
                  type="number"
                  v-model.number="formData.invApplications[index]"
                  :placeholder="`${getMonthName(index)}发明专利申请`"
                  min="0"
                  step="1"
                  :readonly="!isEditing"
                  :class="{ 'editable-field': isEditing }"
                  required
                >
              </div>
              <div class="month-input">
                <label>之前累计数</label>
                <input
                  type="number"
                  v-model.number="formData.prevInvApplications"
                  placeholder="之前累计数"
                  min="0"
                  step="1"
                  :readonly="!isEditing"
                  :class="{ 'editable-field': isEditing }"
                  required
                >
              </div>
              <div class="month-input">
                <label>合计</label>
                <input type="number" :value="invApplicationsTotal" disabled class="calculated-field">
              </div>
            </div>
          </fieldset>

          <!-- 实用新型专利 -->
          <fieldset>
            <legend>{{ year }}年知识产权统计 - 实用新型专利 (件)</legend>
            <div class="monthly-grid">
              <div v-for="(_, index) in formData.utilityPatents" :key="'util-'+index" class="month-input">
                <label>{{ getMonthName(index) }}</label>
                <input
                  type="number"
                  v-model.number="formData.utilityPatents[index]"
                  :placeholder="`${getMonthName(index)}实用新型专利`"
                  min="0"
                  step="1"
                  :readonly="!isEditing"
                  :class="{ 'editable-field': isEditing }"
                  required
                >
              </div>
              <div class="month-input">
                <label>之前累计数</label>
                <input
                  type="number"
                  v-model.number="formData.prevUtilityPatents"
                  placeholder="之前累计数"
                  min="0"
                  step="1"
                  :readonly="!isEditing"
                  :class="{ 'editable-field': isEditing }"
                  required
                >
              </div>
              <div class="month-input">
                <label>合计</label>
                <input type="number" :value="utilityPatentsTotal" disabled class="calculated-field">
              </div>
            </div>
          </fieldset>

          <!-- 外观设计专利 -->
          <fieldset>
            <legend>{{ year }}年知识产权统计 - 外观设计专利 (件)</legend>
            <div class="monthly-grid">
              <div v-for="(_, index) in formData.designPatents" :key="'des-'+index" class="month-input">
                <label>{{ getMonthName(index) }}</label>
                <input
                  type="number"
                  v-model.number="formData.designPatents[index]"
                  :placeholder="`${getMonthName(index)}外观设计专利`"
                  min="0"
                  step="1"
                  :readonly="!isEditing"
                  :class="{ 'editable-field': isEditing }"
                  required
                >
              </div>
              <div class="month-input">
                <label>之前累计数</label>
                <input
                  type="number"
                  v-model.number="formData.prevDesignPatents"
                  placeholder="之前累计数"
                  min="0"
                  step="1"
                  :readonly="!isEditing"
                  :class="{ 'editable-field': isEditing }"
                  required
                >
              </div>
              <div class="month-input">
                <label>合计</label>
                <input type="number" :value="designPatentsTotal" disabled class="calculated-field">
              </div>
            </div>
          </fieldset>

          <!-- 被授权专利 -->
          <fieldset>
            <legend>{{ year }}年知识产权统计 - 被授权专利 (件)</legend>
            <div class="monthly-grid">
              <div v-for="(_, index) in formData.grantedPatents" :key="'grant-'+index" class="month-input">
                <label>{{ getMonthName(index) }}</label>
                <input
                  type="number"
                  v-model.number="formData.grantedPatents[index]"
                  :placeholder="`${getMonthName(index)}被授权专利`"
                  min="0"
                  step="1"
                  :readonly="!isEditing"
                  :class="{ 'editable-field': isEditing }"
                  required
                >
              </div>
              <div class="month-input">
                <label>之前累计数</label>
                <input
                  type="number"
                  v-model.number="formData.prevGrantedPatents"
                  placeholder="之前累计数"
                  min="0"
                  step="1"
                  :readonly="!isEditing"
                  :class="{ 'editable-field': isEditing }"
                  required
                >
              </div>
              <div class="month-input">
                <label>合计</label>
                <input type="number" :value="grantedPatentsTotal" disabled class="calculated-field">
              </div>
            </div>
          </fieldset>

          <!-- 软件著作权 -->
          <fieldset>
            <legend>{{ year }}年知识产权统计 - 软件著作权 (件)</legend>
            <div class="monthly-grid">
              <div v-for="(_, index) in formData.softwareCopyrights" :key="'soft-'+index" class="month-input">
                <label>{{ getMonthName(index) }}</label>
                <input
                  type="number"
                  v-model.number="formData.softwareCopyrights[index]"
                  :placeholder="`${getMonthName(index)}软件著作权`"
                  min="0"
                  step="1"
                  :readonly="!isEditing"
                  :class="{ 'editable-field': isEditing }"
                  required
                >
              </div>
              <div class="month-input">
                <label>之前累计数</label>
                <input
                  type="number"
                  v-model.number="formData.prevSoftwareCopyrights"
                  placeholder="之前累计数"
                  min="0"
                  step="1"
                  :readonly="!isEditing"
                  :class="{ 'editable-field': isEditing }"
                  required
                >
              </div>
              <div class="month-input">
                <label>合计</label>
                <input type="number" :value="softwareCopyrightsTotal" disabled class="calculated-field">
              </div>
            </div>
          </fieldset>

          <!-- 商标注册 -->
          <fieldset>
            <legend>{{ year }}年知识产权统计 - 商标注册 (件)</legend>
            <div class="monthly-grid">
              <div v-for="(_, index) in formData.trademarks" :key="'tm-'+index" class="month-input">
                <label>{{ getMonthName(index) }}</label>
                <input
                  type="number"
                  v-model.number="formData.trademarks[index]"
                  :placeholder="`${getMonthName(index)}商标注册`"
                  min="0"
                  step="1"
                  :readonly="!isEditing"
                  :class="{ 'editable-field': isEditing }"
                  required
                >
              </div>
              <div class="month-input">
                <label>之前累计数</label>
                <input
                  type="number"
                  v-model.number="formData.prevTrademarks"
                  placeholder="之前累计数"
                  min="0"
                  step="1"
                  :readonly="!isEditing"
                  :class="{ 'editable-field': isEditing }"
                  required
                >
              </div>
              <div class="month-input">
                <label>合计</label>
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
import { computed, onBeforeUnmount, onMounted, reactive, ref, watch } from 'vue'
import { useSelectionStore } from '@/stores/selectionStore'
import apiClient from '@/utils/axios'

// —— 与能源统计保持一致的状态 —— //
const selectionStore = useSelectionStore()
const factory = computed(() => selectionStore.selectedFactory)
const year = computed(() => selectionStore.selectedYear);
const month = computed(() => selectionStore.selectedMonth);

const isEditing = ref(false)
const isLoading = ref(false)

// 月份名称映射 & 工具函数（与能源一致）
const monthNames = ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月']
const getMonthName = (index) => monthNames[index]

// —— 知识产权数据 —— //
const formData = reactive({
  invPatents: Array(12).fill(0),
  invApplications: Array(12).fill(0),
  utilityPatents: Array(12).fill(0),
  designPatents: Array(12).fill(0),
  grantedPatents: Array(12).fill(0),
  softwareCopyrights: Array(12).fill(0),
  trademarks: Array(12).fill(0),
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

const invPatentsTotal = computed(() => rowSum(formData.invPatents))
const invApplicationsTotal = computed(() => rowSum(formData.invApplications))
const utilityPatentsTotal = computed(() => rowSum(formData.utilityPatents))
const designPatentsTotal = computed(() => rowSum(formData.designPatents))
const grantedPatentsTotal = computed(() => rowSum(formData.grantedPatents))
const softwareCopyrightsTotal = computed(() => rowSum(formData.softwareCopyrights))
const trademarksTotal = computed(() => rowSum(formData.trademarks))

// —— 与能源统计保持一致：监听工厂/年份变化并拉取数据 —— //
watch([factory, year], () => {
  fetchData()
})

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
      params: { factory: factory.value, year: year.value }
    })
    const data = resp?.data?.data
    if (data) {
      // 兼容后端下划线/驼峰
      setArray(formData.invPatents, data.invPatents || data.inv_patents || Array(12).fill(0))
      setArray(formData.invApplications, data.invApplications || data.inv_applications || Array(12).fill(0))
      setArray(formData.utilityPatents, data.utilityPatents || data.utility_patents || Array(12).fill(0))
      setArray(formData.designPatents, data.designPatents || data.design_patents || Array(12).fill(0))
      setArray(formData.grantedPatents, data.grantedPatents || data.granted_patents || Array(12).fill(0))
      setArray(formData.softwareCopyrights, data.softwareCopyrights || data.software_copyrights || Array(12).fill(0))
      setArray(formData.trademarks, data.trademarks || data.trademarks || Array(12).fill(0))

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
  setArray(formData.invPatents, Array(12).fill(0))
  setArray(formData.invApplications, Array(12).fill(0))
  setArray(formData.utilityPatents, Array(12).fill(0))
  setArray(formData.designPatents, Array(12).fill(0))
  setArray(formData.grantedPatents, Array(12).fill(0))
  setArray(formData.softwareCopyrights, Array(12).fill(0))
  setArray(formData.trademarks, Array(12).fill(0))
  formData.prevInvPatents = 0
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
      invPatents: [...formData.invPatents],
      invApplications: [...formData.invApplications],
      utilityPatents: [...formData.utilityPatents],
      designPatents: [...formData.designPatents],
      grantedPatents: [...formData.grantedPatents],
      softwareCopyrights: [...formData.softwareCopyrights],
      trademarks: [...formData.trademarks],
      prevInvPatents: formData.prevInvPatents,
      prevInvApplications: formData.prevInvApplications,
      prevUtilityPatents: formData.prevUtilityPatents,
      prevDesignPatents: formData.prevDesignPatents,
      prevGrantedPatents: formData.prevGrantedPatents,
      prevSoftwareCopyrights: formData.prevSoftwareCopyrights,
      prevTrademarks: formData.prevTrademarks,
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