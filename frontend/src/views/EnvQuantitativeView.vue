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

      <!-- 数据展示部分 -->
      <fieldset class="summary-fieldset">
        <legend>物料</legend>
        <div class="form-row">
          <table class="data-table">
            <thead>
            <tr>
              <th>指标</th>
              <th>当期 ({{ year }})</th>
              <th>上期 ({{ year - 1 }})</th>
              <th>对比上期 (%)</th>
              <th>原因分析</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="(indicatorKey, index) in Object.keys(boardData)" :key="index">
              <td>{{ indicatorNames[indicatorKey] || indicatorKey }}</td>
              <td>{{ boardData[indicatorKey].currentYear }}</td>
              <td>{{ boardData[indicatorKey].lastYear || 'N/A' }}</td>
              <td>{{ formatComparison(boardData[indicatorKey].comparison) }}</td>
              <td>
                <span v-if="!isEditing">{{ boardData[indicatorKey].reason || 'N/A' }}</span>
                <textarea v-else v-model="tempReasons[indicatorKey]" class="reason-input"
                          :placeholder="boardData[indicatorKey]?.reason || ''"></textarea>
              </td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>
      <div class="edit-controls" @click="!isEditing && startEditing()">
        <button v-if="!isEditing" class="edit-button">✏️</button>
        <div v-else class="edit-actions">
          <button @click.stop="cancelEditing" class="cancel-button">取消</button>
          <button @click.stop="submitReasons" class="submit-button">提交</button>
        </div>
      </div>
    </form>
  </div>
</template>

<script setup>
import {computed, onMounted, ref} from 'vue';
import axios from 'axios';
import {useSelectionStore} from "@/stores/selectionStore.js";

const selectionStore = useSelectionStore();
const factory = computed(() => selectionStore.selectedFactory);
const factories = computed(() => selectionStore.factories);
const year = computed(() => selectionStore.selectedYear);
const years = computed(() => selectionStore.years);

const boardData = ref({})
const isEditing = ref(false)
const tempReasons = ref({})

// 指标名称映射
const indicatorNames = {
  "renewable_input": "可再生进料量",
  "non_renewable_input": "不可再生进料量",
  "renewable_output": "可再生出料量",
  "non_renewable_output": "不可再生出料量",
  "material_consumption": "物料消耗量",
  "wood_fiber": "木纤维",
  "aluminum": "铝",
  "packaging_material": "包装材料",
  "paper_consumption": "纸张消耗",
  "packaging_intensity": "包装消耗强度",
  "paper_intensity": "纸张消耗强度",
  "total_input": "进料总量",
  "total_output": "出料总量",
  "renewable_input_ratio": "可再生进料占比",
  "renewable_output_ratio": "可再生出料占比"
}

// 获取董事会数据
const fetchBoardData = async () => {
  try {
    const response = await axios.get('http://localhost:8000/api/material', {
      params: {
        factory: factory.value,
        year: year.value
      }
    });
    boardData.value = response.data;
  } catch (error) {
    console.error('获取数据失败:', error);
    alert(`获取数据失败: ${error.response?.data?.detail || error.message}`);
  }
};

// 格式化对比值
const formatComparison = (value) => {
  if (value === null || value === undefined) return 'N/A';
  return `${value > 0 ? '+' : ''}${value}%`;
};

// 初始化
onMounted(() => {
  selectionStore.initYears();
  document.addEventListener('click', selectionStore.handleClickOutside);
  fetchBoardData();
});

// 进入编辑模式
const startEditing = () => {
  isEditing.value = true
  tempReasons.value = {}
  Object.keys(boardData.value).forEach(key => {
    tempReasons.value[key] = boardData.value[key]?.reason || ''
  })
}

// 取消编辑
const cancelEditing = () => {
  isEditing.value = false
  tempReasons.value = {}
}

const submitReasons = async () => {
  try {
    console.log('原始 tempReasons:', tempReasons.value);
    const reasonsMap = {};
    Object.entries(tempReasons.value).forEach(([indicator, reason]) => {
      if (reason && reason.trim() !== '') {
        reasonsMap[indicator] = reason;
      }
    });
    console.log("提交的原因映射:", reasonsMap);
    await axios.post('http://localhost:8000/api/material/reasons', {
      factory: factory.value,
      year: parseInt(year.value),
      reasons: reasonsMap  // 提交映射对象而不是数组
    });
    Object.entries(tempReasons.value).forEach(([indicator, reason]) => {
      if (boardData.value[indicator]) {
        boardData.value[indicator].reason = reason;
      }
    });
    isEditing.value = false;
    alert('原因分析提交成功！');
  } catch (error) {
    console.error('提交原因分析失败:', error);
    alert(`提交原因分析失败: ${error.response?.data?.detail || error.message}`);
  }
}
</script>

<style scoped>
.data-table {
  width: 100%;
  border-collapse: collapse;
  margin-bottom: 20px;
}

.data-table th, .data-table td {
  border: 1px solid #ddd;
  padding: 8px;
  text-align: left;
}

.data-table th {
  background-color: #f2f2f2;
}

.reason-input {
  width: 100%;
  min-height: 60px;
}

.edit-controls {
  position: fixed;
  right: 20px;
  top: 200px;
  z-index: 1000;
  background: rgba(44, 62, 80, 0.6);
  padding: 8px 8px;
  border-radius: 24px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 8px;
  color: white;
  font-size: 16px;
  cursor: pointer;
}
.edit-controls:not(.is-editing)::before {
  content: '编辑';
  opacity: 0;
  transform: translateY(-10px);
  transition: all 0.3s;
  order: -1;
  font-size: 18px;
}
.edit-controls:hover:not(.is-editing)::before {
  opacity: 1;
  transform: translateY(0);
}

.edit-button, .cancel-button, .submit-button {
  padding: 8px 12px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 16px;
  transition: all 0.2s;
}

.edit-button {
  background-color: transparent;
  font-size: 25px;
}
.edit-button:hover {
  background-color: transparent;
}

.cancel-button {
  background-color: #f44336;
  color: white;
}
.cancel-button:hover {
  background-color: #d32f2f;
}

.submit-button {
  background-color: #2196F3;
  color: white;
}
.submit-button:hover {
  background-color: #1976d2;
}


</style>