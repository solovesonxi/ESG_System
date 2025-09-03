<template>
  <div class="shared-form">
    <form @submit.prevent="submitIP">
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
              <div
                class="options"
                v-show="selectionStore.showFactoryDropdown"
                :style="{ maxHeight: '200px', overflowY: 'auto' }"
              >
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

      <!-- ===== 七类表格块，已去掉工厂列 ===== -->

      <!-- 发明专利 -->
      <fieldset>
        <legend>{{ year }}年知识产权统计 - 发明专利 (件)</legend>
        <div class="table-wrapper">
          <table class="ip-table">
            <thead>
              <tr>
                <th>单位</th>
                <th v-for="(m, idx) in monthNames" :key="`inv-h-${idx}`">{{ m }}</th>
                <th>合计</th>
                <th>之前累计数</th>
              </tr>
            </thead>
            <tbody>
              <tr v-if="currentFactoryIndex !== -1">
                <td>件</td>
                <td v-for="c in 12" :key="`inv-c-${c-1}`">
                  <input type="number" min="0" step="1" v-model.number="invPatents[currentFactoryIndex][c-1]" />
                </td>
                <td class="total-cell">{{ rowSum(invPatents[currentFactoryIndex]) }}</td>
                <td>
                  <input type="number" min="0" step="1" v-model.number="prevInvPatents[currentFactoryIndex]" />
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <!-- 发明专利申请数量 -->
      <fieldset>
        <legend>{{ year }}年知识产权统计 - 发明专利申请数量 (件)</legend>
        <div class="table-wrapper">
          <table class="ip-table">
            <thead>
              <tr>
                <th>单位</th>
                <th v-for="(m, idx) in monthNames" :key="`app-h-${idx}`">{{ m }}</th>
                <th>合计</th>
                <th>之前累计数</th>
              </tr>
            </thead>
            <tbody>
              <tr v-if="currentFactoryIndex !== -1">
                <td>件</td>
                <td v-for="c in 12" :key="`app-c-${c-1}`">
                  <input type="number" min="0" step="1" v-model.number="invApplications[currentFactoryIndex][c-1]" />
                </td>
                <td class="total-cell">{{ rowSum(invApplications[currentFactoryIndex]) }}</td>
                <td>
                  <input type="number" min="0" step="1" v-model.number="prevInvApplications[currentFactoryIndex]" />
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <!-- 实用新型专利 -->
      <fieldset>
        <legend>{{ year }}年知识产权统计 - 实用新型专利 (件)</legend>
        <div class="table-wrapper">
          <table class="ip-table">
            <thead>
              <tr>
                <th>单位</th>
                <th v-for="(m, idx) in monthNames" :key="`util-h-${idx}`">{{ m }}</th>
                <th>合计</th>
                <th>之前累计数</th>
              </tr>
            </thead>
            <tbody>
              <tr v-if="currentFactoryIndex !== -1">
                <td>件</td>
                <td v-for="c in 12" :key="`util-c-${c-1}`">
                  <input type="number" min="0" step="1" v-model.number="utilityPatents[currentFactoryIndex][c-1]" />
                </td>
                <td class="total-cell">{{ rowSum(utilityPatents[currentFactoryIndex]) }}</td>
                <td>
                  <input type="number" min="0" step="1" v-model.number="prevUtilityPatents[currentFactoryIndex]" />
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <!-- 外观设计专利 -->
      <fieldset>
        <legend>{{ year }}年知识产权统计 - 外观设计专利 (件)</legend>
        <div class="table-wrapper">
          <table class="ip-table">
            <thead>
              <tr>
                <th>单位</th>
                <th v-for="(m, idx) in monthNames" :key="`des-h-${idx}`">{{ m }}</th>
                <th>合计</th>
                <th>之前累计数</th>
              </tr>
            </thead>
            <tbody>
              <tr v-if="currentFactoryIndex !== -1">
                <td>件</td>
                <td v-for="c in 12" :key="`des-c-${c-1}`">
                  <input type="number" min="0" step="1" v-model.number="designPatents[currentFactoryIndex][c-1]" />
                </td>
                <td class="total-cell">{{ rowSum(designPatents[currentFactoryIndex]) }}</td>
                <td>
                  <input type="number" min="0" step="1" v-model.number="prevDesignPatents[currentFactoryIndex]" />
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <!-- 被授权专利 -->
      <fieldset>
        <legend>{{ year }}年知识产权统计 - 被授权专利 (件)</legend>
        <div class="table-wrapper">
          <table class="ip-table">
            <thead>
              <tr>
                <th>单位</th>
                <th v-for="(m, idx) in monthNames" :key="`grant-h-${idx}`">{{ m }}</th>
                <th>合计</th>
                <th>之前累计数</th>
              </tr>
            </thead>
            <tbody>
              <tr v-if="currentFactoryIndex !== -1">
                <td>件</td>
                <td v-for="c in 12" :key="`grant-c-${c-1}`">
                  <input type="number" min="0" step="1" v-model.number="grantedPatents[currentFactoryIndex][c-1]" />
                </td>
                <td class="total-cell">{{ rowSum(grantedPatents[currentFactoryIndex]) }}</td>
                <td>
                  <input type="number" min="0" step="1" v-model.number="prevGrantedPatents[currentFactoryIndex]" />
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <!-- 软件著作权 -->
      <fieldset>
        <legend>{{ year }}年知识产权统计 - 软件著作权 (件)</legend>
        <div class="table-wrapper">
          <table class="ip-table">
            <thead>
              <tr>
                <th>单位</th>
                <th v-for="(m, idx) in monthNames" :key="`soft-h-${idx}`">{{ m }}</th>
                <th>合计</th>
                <th>之前累计数</th>
              </tr>
            </thead>
            <tbody>
              <tr v-if="currentFactoryIndex !== -1">
                <td>件</td>
                <td v-for="c in 12" :key="`soft-c-${c-1}`">
                  <input
                    type="number"
                    min="0"
                    step="1"
                    v-model.number="softwareCopyrights[currentFactoryIndex][c-1]"
                  />
                </td>
                <td class="total-cell">{{ rowSum(softwareCopyrights[currentFactoryIndex]) }}</td>
                <td>
                  <input
                    type="number"
                    min="0"
                    step="1"
                    v-model.number="prevSoftwareCopyrights[currentFactoryIndex]"
                  />
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <!-- 商标注册 -->
      <fieldset>
        <legend>{{ year }}年知识产权统计 - 商标注册 (件)</legend>
        <div class="table-wrapper">
          <table class="ip-table">
            <thead>
              <tr>
                <th>单位</th>
                <th v-for="(m, idx) in monthNames" :key="`tm-h-${idx}`">{{ m }}</th>
                <th>合计</th>
                <th>之前累计数</th>
              </tr>
            </thead>
            <tbody>
              <tr v-if="currentFactoryIndex !== -1">
                <td>件</td>
                <td v-for="c in 12" :key="`tm-c-${c-1}`">
                  <input type="number" min="0" step="1" v-model.number="trademarks[currentFactoryIndex][c-1]" />
                </td>
                <td class="total-cell">{{ rowSum(trademarks[currentFactoryIndex]) }}</td>
                <td>
                  <input type="number" min="0" step="1" v-model.number="prevTrademarks[currentFactoryIndex]" />
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <button type="submit" :disabled="isSubmitting">
        {{ isSubmitting ? "提交中..." : "提交知识产权数据" }}
      </button>
    </form>
  </div>
</template>

<script setup>
import { computed, onBeforeUnmount, onMounted, reactive, ref } from "vue";
import apiClient from '@/utils/axios';
import { useSelectionStore } from "@/stores/selectionStore";

const selectionStore = useSelectionStore();
const factory = computed(() => selectionStore.selectedFactory);
const factories = computed(() => selectionStore.factories);
const year = computed(() => selectionStore.selectedYear);
const years = computed(() => selectionStore.years);
const isSubmitting = ref(false);

onMounted(() => {
  document.addEventListener("click", selectionStore.handleClickOutside);
});
onBeforeUnmount(() => {
  document.removeEventListener("click", selectionStore.handleClickOutside);
});

const monthNames = [
  "1月","2月","3月","4月","5月","6月","7月","8月","9月","10月","11月","12月",
];
function buildMatrix(rows) {
  return Array.from({ length: rows }, () => Array(12).fill(0));
}

// 七类矩阵
const invPatents = reactive(buildMatrix(factories.value.length));
const invApplications = reactive(buildMatrix(factories.value.length));
const utilityPatents = reactive(buildMatrix(factories.value.length));
const designPatents = reactive(buildMatrix(factories.value.length));
const grantedPatents = reactive(buildMatrix(factories.value.length));
const softwareCopyrights = reactive(buildMatrix(factories.value.length));
const trademarks = reactive(buildMatrix(factories.value.length));

// 之前累计数
const prevInvPatents = reactive(Array(factories.value.length).fill(0));
const prevInvApplications = reactive(Array(factories.value.length).fill(0));
const prevUtilityPatents = reactive(Array(factories.value.length).fill(0));
const prevDesignPatents = reactive(Array(factories.value.length).fill(0));
const prevGrantedPatents = reactive(Array(factories.value.length).fill(0));
const prevSoftwareCopyrights = reactive(Array(factories.value.length).fill(0));
const prevTrademarks = reactive(Array(factories.value.length).fill(0));

const rowSum = (row) => row.reduce((s, v) => s + (Number(v) || 0), 0);
const currentFactoryIndex = computed(() => factories.value.indexOf(factory.value));

async function submitIP() {
  isSubmitting.value = true;
  try {
    const payload = {
      year: Number(year.value),
      factories: factories.value,
      invPatents,
      invApplications,
      utilityPatents,
      designPatents,
      grantedPatents,
      softwareCopyrights,
      trademarks,
      prevInvPatents: [...prevInvPatents],
      prevInvApplications: [...prevInvApplications],
      prevUtilityPatents: [...prevUtilityPatents],
      prevDesignPatents: [...prevDesignPatents],
      prevGrantedPatents: [...prevGrantedPatents],
      prevSoftwareCopyrights: [...prevSoftwareCopyrights],
      prevTrademarks: [...prevTrademarks],
    };
    await apiClient.post("/api/ipData", payload);
    alert("提交成功!");
  } catch (e) {
    console.error("提交失败:", e);
    alert("提交失败，请检查控制台日志");
  } finally {
    isSubmitting.value = false;
  }
}
</script>

<style scoped>
.shared-form {
  max-width: 1200px;
  margin: 0 auto;
  padding: 1rem;
  background-color: #fff;
  box-shadow: 0 0 10px rgba(0,0,0,0.05);
  border-radius: 8px;
  box-sizing: border-box;
}

fieldset { border: 1px solid #ddd; padding: 1rem; margin-bottom: 1.5rem; border-radius: 6px; }
legend { font-weight: 600; padding: 0 0.5rem; }

.custom-select { position: relative; width: 200px; }
.custom-select .selected {
  padding: 6px 12px; border: 1px solid #ccc; cursor: pointer;
  display: flex; justify-content: space-between; align-items: center; border-radius: 4px;
}
.custom-select .options {
  position: absolute; top: 100%; left: 0; right: 0;
  background: #fff; border: 1px solid #ccc; z-index: 10; max-height: 200px; overflow-y: auto;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
}
.custom-select .option { padding: 6px 12px; cursor: pointer; }
.custom-select .option.selected-option { background-color: #f0f0f0; }
.arrow { border: solid black; border-width: 0 1px 1px 0; display: inline-block; padding: 4px; transform: rotate(45deg); transition: transform 0.2s; }
.arrow.up { transform: rotate(-135deg); }

.table-wrapper { width: 100%; overflow-x: auto; margin-bottom: 1rem; }
.ip-table { width: 100%; min-width: 900px; border-collapse: collapse; table-layout: fixed; }
.ip-table th, .ip-table td { border: 1px solid #ddd; padding: 6px; text-align: center; white-space: nowrap; }
.total-cell { font-weight: 600; }

button[type="submit"] {
  padding: 8px 16px; font-size: 1rem; border: none; border-radius: 4px;
  background-color: #007bff; color: white; cursor: pointer; transition: background-color 0.2s;
}
button[type="submit"]:disabled { background-color: #999; cursor: not-allowed; }
button[type="submit"]:hover:not(:disabled) { background-color: #0056b3; }

@media (max-width: 768px) { .ip-table { min-width: 600px; } }
</style>
