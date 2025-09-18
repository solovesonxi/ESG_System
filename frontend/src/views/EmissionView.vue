<template>
  <div class="shared-form">
    <form>
      <BaseInfoSelector :review="review" form-type="emission" @selection-changed="fetchData"/>
      <fieldset class="summary-fieldset">
        <legend>{{ year }}年{{ month }}月温室气体盘查统计 (吨CO2e)</legend>
        <div class="form-row">
          <div class="form-group">
            <label>范畴一 (类别一)</label>
            <input type="number" v-model.number="emissionData.categoryOne" step="1" min="0" :readonly="!isEditing"
                   :class="{ 'editable-field': isEditing }">
          </div>
          <div class="form-group">
            <label>范畴二 (类别二)</label>
            <input type="number" v-model.number="emissionData.categoryTwo" step="1" min="0" :readonly="!isEditing"
                   :class="{ 'editable-field': isEditing }">
          </div>
          <div class="form-group">
            <label>范畴三 (类别三)</label>
            <input type="number" v-model.number="emissionData.categoryThree" step="1" min="0" :readonly="!isEditing"
                   :class="{ 'editable-field': isEditing }">
          </div>
          <div class="form-group">
            <label>范畴三 (类别四)</label>
            <input type="number" v-model.number="emissionData.categoryFour" step="1" min="0" :readonly="!isEditing"
                   :class="{ 'editable-field': isEditing }">
          </div>
          <div class="form-group">
            <label>范畴三 (类别五)</label>
            <input type="number" v-model.number="emissionData.categoryFive" step="1" min="0" :readonly="!isEditing"
                   :class="{ 'editable-field': isEditing }">
          </div>
          <div class="form-group">
            <label>范畴三 (类别六)</label>
            <input type="number" v-model.number="emissionData.categorySix" step="1" min="0" :readonly="!isEditing"
                   :class="{ 'editable-field': isEditing }">
          </div>
          <div class="form-group">
            <label>范畴三合计</label>
            <input type="number" :value="categoryThreeTotal" disabled class="calculated-field">
          </div>
          <div class="form-group">
            <label>排放总量</label>
            <input type="number" :value="totalEmission" disabled class="calculated-field">
          </div>
          <div class="form-group">
            <label>营业收入 (万元)</label>
            <input type="number" v-model.number="emissionData.total_revenue" step="1" min="0" :readonly="!isEditing"
                   :class="{ 'editable-field': isEditing }" required>
          </div>
          <div class="form-group">
            <label>排放强度</label>
            <input type="number" :value="emissionIntensity" disabled class="calculated-field">
          </div>
        </div>
      </fieldset>

      <!-- 废气排放统计 -->
      <fieldset class="summary-fieldset">
        <legend>{{ year }}年{{ month }}月废气排放统计 - 有组织排放 (T)</legend>
        <div class="form-row">
          <div class="form-group">
            <label>挥发性有机物 (VOC)</label>
            <input type="number" v-model.number="wasteGasData.voc" step="1" min="0" :readonly="!isEditing"
                   :class="{ 'editable-field': isEditing }">
          </div>
          <div class="form-group">
            <label>碳氢化合物 (非甲烷总烃)</label>
            <input type="number" v-model.number="wasteGasData.nmhc" step="1" min="0" :readonly="!isEditing"
                   :class="{ 'editable-field': isEditing }">
          </div>
          <div class="form-group">
            <label>苯类 (苯、甲苯、二甲苯)</label>
            <input type="number" v-model.number="wasteGasData.benzene" step="1" min="0" :readonly="!isEditing"
                   :class="{ 'editable-field': isEditing }">
          </div>
          <div class="form-group">
            <label>颗粒物</label>
            <input type="number" v-model.number="wasteGasData.particulate" step="1" min="0" :readonly="!isEditing"
                   :class="{ 'editable-field': isEditing }">
          </div>
          <div class="form-group">
            <label>氮氧化物 (NOx)、硫氧化物 (SOx)和其他重大气体排放</label>
            <input type="number" v-model.number="wasteGasData.nox_sox_other" step="1" min="0" :readonly="!isEditing"
                   :class="{ 'editable-field': isEditing }">
          </div>

          <div class="form-group">
            <label>合计</label>
            <input type="number" :value="wasteGasTotal" disabled class="calculated-field">
          </div>
        </div>
      </fieldset>
    </form>
  </div>
</template>

<script setup>
import {computed, onBeforeUnmount, onMounted, reactive, ref} from 'vue'
import {useSelectionStore} from "@/stores/selectionStore.js";
import apiClient from "@/utils/axios.js";
import BaseInfoSelector from "@/components/BaseInfoSelector.vue";
import {handleError, showError, showInfo, showSuccess} from "@/utils/toast.js";

const selectionStore = useSelectionStore()
const factory = computed(() => selectionStore.selectedFactory)
const year = computed(() => selectionStore.selectedYear)
const month = computed(() => selectionStore.selectedMonth)
const isEditing = ref(false)

// 审核状态数据
const review = ref({});

// 温室气体排放数据结构
const emissionData = reactive({
  categoryOne: 0,    // 范畴一（类别一）
  categoryTwo: 0,     // 范畴二（类别二）
  categoryThree: 0,   // 范畴三（类别三）
  categoryFour: 0,    // 范畴三（类别四）
  categoryFive: 0,    // 范畴三（类别五）
  categorySix: 0,     // 范畴三（类别六）
  total_revenue: 0          // 营业收入（用于计算排放强度）
})

// 废气排放数据结构
const wasteGasData = reactive({
  voc: 0,             // 挥发性有机物
  nmhc: 0,            // 碳氢化合物（非甲烷总烃）
  benzene: 0,         // 苯类
  particulate: 0,     // 颗粒物
  nox_sox_other: 0        // 其他气体
})

// 计算范畴三合计
const categoryThreeTotal = computed(() => {
  return (emissionData.categoryThree +
      emissionData.categoryFour +
      emissionData.categoryFive +
      emissionData.categorySix)
})

// 计算排放总量
const totalEmission = computed(() => {
  return (parseFloat(emissionData.categoryOne) +
      parseFloat(emissionData.categoryTwo) +
      parseFloat(categoryThreeTotal.value))
})

// 计算排放强度
const emissionIntensity = computed(() => {
  if (emissionData.total_revenue > 0 && totalEmission.value > 0) {
    return (totalEmission.value / emissionData.total_revenue).toFixed(2)
  }
  return 0
})

// 计算废气排放总量
const wasteGasTotal = computed(() => {
  return (parseFloat(wasteGasData.voc) +
      parseFloat(wasteGasData.nmhc) +
      parseFloat(wasteGasData.benzene) +
      parseFloat(wasteGasData.particulate) +
      parseFloat(wasteGasData.nox_sox_other)).toFixed(2)
})

// 初始化年份列表
onMounted(() => {
  document.addEventListener('click', selectionStore.handleClickOutside)
})

onBeforeUnmount(() => {
  document.removeEventListener('click', selectionStore.handleClickOutside)
})

const resetFormData = () => {
  emissionData.categoryOne = 0;
  emissionData.categoryTwo = 0;
  emissionData.categoryThree = 0;
  emissionData.categoryFour = 0;
  emissionData.categoryFive = 0;
  emissionData.categorySix = 0;
  emissionData.total_revenue = 0;
  wasteGasData.voc = 0;
  wasteGasData.nmhc = 0;
  wasteGasData.benzene = 0;
  wasteGasData.particulate = 0;
  wasteGasData.nox_sox_other = 0;
  review.value = {status: Array(12).fill("pending"), comment: Array(12).fill('')};
};

const fetchData = async () => {
  try {
    const response = await apiClient.get(`/quantitative/emission`, {
      params: {factory: factory.value, year: year.value}
    });
    if (response.data && response.data.data) {
      const data = response.data.data;
      emissionData.categoryOne = data.category_one || 0;
      emissionData.categoryTwo = data.category_two || 0;
      emissionData.categoryThree = data.category_three || 0;
      emissionData.categoryFour = data.category_four || 0;
      emissionData.categoryFive = data.category_five || 0;
      emissionData.categorySix = data.category_six || 0;
      emissionData.total_revenue = data.total_revenue || 0;
      wasteGasData.voc = data.voc || 0;
      wasteGasData.nmhc = data.nmhc || 0;
      wasteGasData.benzene = data.benzene || 0;
      wasteGasData.particulate = data.particulate || 0;
      wasteGasData.nox_sox_other = data.nox_sox_other || 0;
      review.value = response.data.review;
    }else {
      resetFormData();
      showInfo(`未找到数据`)
    }
  } catch (error) {
    console.error('获取数据失败:', error);
    handleError(error);
  }
};

async function submitEdit(ifSubmit) {
  try {
    const payload = {
      factory: factory.value,
      year: year.value,
      month: month.value,
      ...emissionData,
      categoryThreeTotal: categoryThreeTotal.value,
      totalEmission: totalEmission.value,
      emissionIntensity: emissionIntensity.value,
      ...wasteGasData,
      wasteGasTotal: wasteGasTotal.value,
      isSubmitted: ifSubmit
    }
    const response = await apiClient.post('/quantitative/emission', payload)
    if (response.data.status === 'success') {
      showSuccess('数据提交成功!')
    }else {
      showError(`数据提交失败: ${response.data.message || '未知错误'}`)
    }
  } catch (error) {
    console.error('提交失败:', error)
    handleError(error);
  } finally {
    console.log('提交完成，即将刷新');
    isEditing.value = false;
    await fetchData();
  }
}


// 暴露方法给父组件
defineExpose({
  startEditing: () => isEditing.value = true,
  cancelEditing: () => {
    isEditing.value = false;
    fetchData();
  },
  submitEdit,
  fetchData
});
</script>
