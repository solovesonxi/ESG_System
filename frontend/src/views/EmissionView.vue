<template>
  <div class="shared-form">
    <form @submit.prevent="submitForm">
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

      <!-- 温室气体盘查统计 -->
      <fieldset>
        <legend>{{ year }}年温室气体盘查统计 (吨CO2e)</legend>
        <div class="form-row">
          <div class="form-group">
            <label>范畴一 (类别一)</label>
            <input type="number" v-model.number="emissionData.categoryOne" step="1" min="0">
          </div>
          <div class="form-group">
            <label>范畴二 (类别二)</label>
            <input type="number" v-model.number="emissionData.categoryTwo" step="1" min="0">
          </div>
          <div class="form-group">
            <label>范畴三 (类别三)</label>
            <input type="number" v-model.number="emissionData.categoryThree" step="1" min="0">
          </div>
          <div class="form-group">
            <label>范畴三 (类别四)</label>
            <input type="number" v-model.number="emissionData.categoryFour" step="1" min="0">
          </div>
          <div class="form-group">
            <label>范畴三 (类别五)</label>
            <input type="number" v-model.number="emissionData.categoryFive" step="1" min="0">
          </div>
          <div class="form-group">
            <label>范畴三 (类别六)</label>
            <input type="number" v-model.number="emissionData.categorySix" step="1" min="0">
          </div>
          <div class="form-group">
            <label>范畴三合计</label>
            <input type="number" :value="categoryThreeTotal" disabled>
          </div>
          <div class="form-group">
            <label>排放总量</label>
            <input type="number" :value="totalEmission" disabled>
          </div>
          <div class="form-group">
            <label>营业收入 (万元)</label>
            <input type="number" v-model.number="emissionData.revenue" step="1" min="0" required>
          </div>
          <div class="form-group">
            <label>排放强度</label>
            <input type="number" :value="emissionIntensity" disabled>
          </div>
        </div>
      </fieldset>

      <!-- 废气排放统计 -->
      <fieldset>
        <legend>{{ year }}年废气排放统计 - 有组织排放 (T)</legend>
        <div class="form-row">
          <div class="form-group">
            <label>挥发性有机物 (VOC)</label>
            <input type="number" v-model.number="wasteGasData.voc" step="1" min="0">
          </div>
          <div class="form-group">
            <label>碳氢化合物 (非甲烷总烃)</label>
            <input type="number" v-model.number="wasteGasData.nmhc" step="1" min="0">
          </div>
          <div class="form-group">
            <label>苯类 (苯、甲苯、二甲苯)</label>
            <input type="number" v-model.number="wasteGasData.benzene" step="1" min="0">
          </div>
          <div class="form-group">
            <label>颗粒物</label>
            <input type="number" v-model.number="wasteGasData.particulate" step="1" min="0">
          </div>

          <!-- 自定义排放列 -->
          <div v-for="(custom, index) in wasteGasData.customEmissions" :key="`custom-${index}`" class="form-group">
            <input type="text" v-model="custom.name" placeholder="自定义名称" class="custom-name-input">
            <input type="number" v-model.number="custom.value" step="1" min="0" placeholder="数值">
            <button type="button" @click="removeCustomEmission(index)" class="remove-btn">×</button>
          </div>

          <div class="form-group">
            <button type="button" @click="addCustomEmission" :disabled="wasteGasData.customEmissions.length >= 3"
                    class="add-btn">
              添加自定义排放
            </button>
          </div>

          <div class="form-group">
            <label>合计</label>
            <input type="number" :value="wasteGasTotal" disabled>
          </div>
        </div>
      </fieldset>

      <button type="submit" :disabled="isSubmitting">
        {{ isSubmitting ? '提交中...' : '提交数据' }}
      </button>
    </form>
  </div>
</template>

<script setup>
import {computed, onBeforeUnmount, onMounted, reactive, ref} from 'vue'
import axios from 'axios'
import {useSelectionStore} from "@/stores/selectionStore.js";

const selectionStore = useSelectionStore()
const factory = computed(() => selectionStore.selectedFactory)
const factories = computed(() => selectionStore.factories)
const year = computed(() => selectionStore.selectedYear)
const years = computed(() => selectionStore.years)
const isSubmitting = ref(false)


// 温室气体排放数据结构
const emissionData = reactive({
  categoryOne: 0,    // 范畴一（类别一）
  categoryTwo: 0,     // 范畴二（类别二）
  categoryThree: 0,   // 范畴三（类别三）
  categoryFour: 0,    // 范畴三（类别四）
  categoryFive: 0,    // 范畴三（类别五）
  categorySix: 0,     // 范畴三（类别六）
  revenue: 0          // 营业收入（用于计算排放强度）
})

// 废气排放数据结构
const wasteGasData = reactive({
  voc: 0,             // 挥发性有机物
  nmhc: 0,            // 碳氢化合物（非甲烷总烃）
  benzene: 0,         // 苯类
  particulate: 0,     // 颗粒物
  customEmissions: []  // 自定义排放列
})

// 添加自定义排放列
function addCustomEmission() {
  if (wasteGasData.customEmissions.length < 3) {
    wasteGasData.customEmissions.push({name: '', value: 0})
  }
}

// 移除自定义排放列
function removeCustomEmission(index) {
  wasteGasData.customEmissions.splice(index, 1)
}

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
  if (emissionData.revenue > 0 && totalEmission.value > 0) {
    return (totalEmission.value / emissionData.revenue).toFixed(2)
  }
  return 0
})

// 计算废气排放总量
const wasteGasTotal = computed(() => {
  let total = parseFloat(wasteGasData.voc) +
      parseFloat(wasteGasData.nmhc) +
      parseFloat(wasteGasData.benzene) +
      parseFloat(wasteGasData.particulate)
  wasteGasData.customEmissions.forEach(item => {
    total += parseFloat(item.value || 0)
  })
  return total.toFixed(2)
})

// 初始化年份列表
onMounted(() => {
  selectionStore.initYears()
  document.addEventListener('click', selectionStore.handleClickOutside)
})

onBeforeUnmount(() => {
  document.removeEventListener('click', selectionStore.handleClickOutside)
})

async function submitForm() {
  isSubmitting.value = true
  try {
    const payload = {
      factory: factory.value,
      year: year.value,
      ...emissionData,
      categoryThreeTotal: categoryThreeTotal.value,
      totalEmission: totalEmission.value,
      emissionIntensity: emissionIntensity.value,
      ...wasteGasData,
      wasteGasTotal: wasteGasTotal.value
    }

    const response = await axios.post('http://localhost:8000/submit/emission', payload)
    if (response.data.status === 'success') {
      alert('排放数据提交成功!')
    }
  } catch (error) {
    console.error('提交失败:', error)
    alert(`提交失败: ${error.response?.data?.detail || error.message}`)
  } finally {
    isSubmitting.value = false
  }
}
</script>
