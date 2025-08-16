<template>
  <div class="material-form">
    <form @submit.prevent="submitForm">
      <fieldset>
        <legend>基础信息</legend>
        <div class="form-row">
          <div class="form-group">
            <label>工厂名称</label>
            <div class="custom-select">
              <div class="selected" @click="toggleFactoryDropdown">
                {{ factory }}
                <i class="arrow" :class="{ 'up': showFactoryDropdown }"></i>
              </div>
              <div class="options" v-show="showFactoryDropdown" :style="{ maxHeight: '200px', overflowY: 'auto' }">
                <div
                    v-for="f in factories"
                    :key="f"
                    class="option"
                    :class="{ 'selected-option': f === factory }"
                    @click="selectFactory(f)"
                >
                  {{ f }}
                </div>
              </div>
            </div>
          </div>
          <div class="form-group">
            <label>统计年份</label>
            <div class="custom-select">
              <div class="selected" @click="toggleYearDropdown">
                {{ year }}年
                <i class="arrow" :class="{ 'up': showYearDropdown }"></i>
              </div>
              <div class="options" v-show="showYearDropdown">
                <div
                    v-for="y in years"
                    :key="y"
                    class="option"
                    :class="{ 'selected-option': y === year }"
                    @click="selectYear(y)"
                >
                  {{ y }}年
                </div>
              </div>
            </div>
          </div>
        </div>
      </fieldset>

      <!-- 物料统计部分 -->
      <fieldset>
        <legend>物料进出统计</legend>
        <div class="form-row">
          <!-- 进料部分 -->
          <div class="form-group">
            <label>进料-可再生料总量 (吨)</label>
            <input type="number" v-model.number="formData.renewableInput" step="0.1" required>
          </div>
          <div class="form-group">
            <label>进料-不可再生料总量 (吨)</label>
            <input type="number" v-model.number="formData.nonRenewableInput" step="0.1" required>
          </div>
          <div class="form-group">
            <label>进料总量 (吨)</label>
            <input type="number" :value="totalInput" disabled>
          </div>
          <div class="form-group">
            <label>可再生进料占比 (%)</label>
            <input type="number" :value="renewableInputRatio" disabled>
          </div>

          <!-- 出料部分 -->
          <div class="form-group">
            <label>出料-可再生料总量 (吨)</label>
            <input type="number" v-model.number="formData.renewableOutput" step="0.1" required>
          </div>
          <div class="form-group">
            <label>进料-不可再生料总量 (吨)</label>
            <input type="number" v-model.number="formData.nonRenewableOutput" step="0.1" required>
          </div>
          <div class="form-group">
            <label>出料总量 (吨)</label>
            <input type="number" v-model.number="totalOutput" disabled>
          </div>
          <div class="form-group">
            <label>可再生出料占比 (%)</label>
            <input type="number" :value="renewableOutputRatio" disabled>
          </div>

          <!-- 消耗部分 -->
          <div class="form-group">
            <label>物料消耗总量 (吨)</label>
            <input type="number" v-model.number="formData.materialConsumption" step="0.1" required>
          </div>
          <div class="form-group">
            <label>包装材料总量 (吨)</label>
            <input type="number" v-model.number="formData.packagingMaterial" step="0.1" required>
          </div>
          <div class="form-group">
            <label>纸张总量 (吨)</label>
            <input type="number" v-model.number="formData.paper" step="0.1" required>
          </div>
          <div class="form-group">
            <label>总营收 (万元)</label>
            <input type="number" v-model.number="formData.revenue" step="0.1" required>
          </div>

          <!-- 消耗强度部分 -->
          <div class="form-group">
            <label>包装材料消耗强度 (吨/万元)</label>
            <input type="number" v-model.number="packagingIntensity" disabled>
          </div>
          <div class="form-group">
            <label>纸张消耗强度 (吨/万元)</label>
            <input type="number" v-model.number="paperIntensity" disabled>
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
import { computed, reactive, ref, onMounted, onBeforeUnmount } from 'vue'
import axios from 'axios'

const factories = [
  "安徽光大美科", "安徽光大同创", "昆山一", "昆山二", "成都厂",
  "惠阳厂", "厦门奔方", "武汉厂", "南昌厂", "越南",
  "墨西哥", "深圳光大", "沃普智选", "青岛音诺", "天津茂创",
  "合肥山秀", "苏州领新", "东莞美科同创", "重庆致贯", "苏州致贯"
]

const factory = ref(factories[0])
const year = ref('')
const years = ref([])
const showFactoryDropdown = ref(false)
const showYearDropdown = ref(false)
const isSubmitting = ref(false)



// 表单数据结构
const formData = reactive({
  renewableInput: 0,
  nonRenewableInput: 0,
  renewableOutput: 0,
  nonRenewableOutput: 0,
  materialConsumption: 0,
  packagingMaterial: 0,
  paper: 0,
  packagingIntensity: 0,
  paperIntensity: 0,
  revenue: 0
})

// 计算进料总量
const totalInput = computed(() => {
  return (formData.renewableInput + formData.nonRenewableInput).toFixed(2)
})
const totalOutput = computed(() => {
  return (formData.renewableOutput + formData.nonRenewableOutput).toFixed(2)
})

// 计算可再生进料占比
const renewableInputRatio = computed(() => {
  if (totalInput.value > 0) {
    return ((formData.renewableInput / totalInput.value) * 100).toFixed(2)
  }
  return 0
})

// 计算可再生出料占比
const renewableOutputRatio = computed(() => {
  if (totalOutput.value > 0) {
    return ((formData.renewableOutput / totalOutput.value) * 100).toFixed(2)
  }
  return 0
})

const packagingIntensity=computed(() => {
  if (formData.revenue > 0) {
    return (formData.packagingMaterial / formData.revenue).toFixed(2)
  }
  return 0
})

const paperIntensity=computed(() => {
  if (formData.revenue > 0) {
    return (formData.paper / formData.revenue).toFixed(2)
  }
  return 0
})
// 初始化年份选择器
onMounted(() => {
  const currentYear = new Date().getFullYear()
  year.value = currentYear.toString()
  for (let y = 2000; y <= currentYear; y++) {
    years.value.push(y)
  }
  document.addEventListener('click', handleClickOutside)
})

onBeforeUnmount(() => {
  document.removeEventListener('click', handleClickOutside)
})

// 切换工厂下拉框
function toggleFactoryDropdown() {
  showFactoryDropdown.value = !showFactoryDropdown.value
}

// 选择工厂
function selectFactory(f) {
  factory.value = f
  showFactoryDropdown.value = false
}

// 切换年份下拉框
function toggleYearDropdown() {
  showYearDropdown.value = !showYearDropdown.value
}

// 选择年份
function selectYear(y) {
  year.value = y
  showYearDropdown.value = false
}

// 点击外部关闭下拉框
function handleClickOutside(event) {
  const selectElements = document.querySelectorAll('.custom-select')
  let isInsideSelect = false
  selectElements.forEach(select => {
    if (select.contains(event.target)) {
      isInsideSelect = true
    }
  })
  if (!isInsideSelect) {
    showFactoryDropdown.value = false
    showYearDropdown.value = false
  }
}

async function submitForm() {
  isSubmitting.value = true
  try {
    const payload = {
      factory: factory.value || '未命名工厂',
      year: year.value,
      ...formData,
      totalInput: totalInput.value,
      totalOutput: totalOutput.value,
      renewableInputRatio: renewableInputRatio.value,
      renewableOutputRatio: renewableOutputRatio.value
    }

    const response = await axios.post('http://localhost:8000/submit/material', payload)

    if (response.data.status === 'success') {
      alert('数据提交成功!')
    }
  } catch (error) {
    console.error('提交失败:', error)
    alert(`提交失败: ${error.response?.data?.detail || error.message}`)
  } finally {
    isSubmitting.value = false
  }
}
</script>

<style scoped>
.material-form {
  max-width: none;
  width: 80vw;
  margin: 0 auto;
  padding: 2rem;
  background: white;
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

h1 {
  text-align: center;
  margin-bottom: 2rem;
  color: #2c3e50;
  font-size: 1.8rem;
}

fieldset {
  border: 1px solid #e0e0e0;
  border-radius: 8px;
  padding: 1.5rem;
  margin-bottom: 1.8rem;
  background: #fafafa;
}

legend {
  padding: 0 12px;
  font-weight: bold;
  color: #3498db;
  font-size: 1.1rem;
}

.form-row {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 25px;
}

.form-group {
  margin-bottom: 15px;
  position: relative;
}

label {
  display: block;
  margin-bottom: 8px;
  font-weight: 600;
  color: #555;
  font-size: 0.95rem;
}

input {
  width: 100%;
  padding: 12px 15px;
  border: 1px solid #ddd;
  border-radius: 6px;
  font-size: 16px;
  transition: all 0.3s;
  background-color: white;

  &:disabled {
    background: #f5f5f5;
    cursor: not-allowed;
  }

  &:focus {
    border-color: #3498db;
    outline: none;
    box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.2);
  }
}

/* 自定义年份选择器样式 */
.custom-select {
  position: relative;
  width: 100%;
}

.selected {
  padding: 12px 15px;
  border: 1px solid #ddd;
  border-radius: 6px;
  background-color: white;
  cursor: pointer;
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 16px;
}

.arrow {
  display: inline-block;
  width: 0;
  height: 0;
  border-left: 5px solid transparent;
  border-right: 5px solid transparent;
  border-top: 5px solid #555;
  transition: transform 0.3s;
}

.arrow.up {
  transform: rotate(180deg);
}

.options {
  position: absolute;
  top: 100%;
  left: 0;
  right: 0;
  background: white;
  border: 1px solid #ddd;
  border-radius: 6px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  z-index: 100;
  max-height: 200px;
  overflow-y: auto;
}

.option {
  padding: 10px 15px;
  cursor: pointer;
  transition: background-color 0.2s;

  &:hover {
    background-color: #f0f8ff;
  }
}

.selected-option {
  background-color: #e1f0fa;
  font-weight: bold;
}

button {
  display: block;
  width: 100%;
  padding: 14px;
  background: #42b983;
  color: white;
  border: none;
  border-radius: 6px;
  font-size: 18px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s;
  margin-top: 1.5rem;

  &:hover:not(:disabled) {
    background: #3aa876;
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  }

  &:disabled {
    background: #a0d9bb;
    cursor: not-allowed;
    transform: none;
    box-shadow: none;
  }
}

@media (max-width: 768px) {
  .material-form {
    padding: 1.5rem;
    width: 95vw;
  }

  .form-row {
    grid-template-columns: 1fr;
    gap: 15px;
  }
}
</style>