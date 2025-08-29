<template>
  <div class="shared-form">
    <form @submit.prevent="submitCommunity">
      <!-- 基础信息 -->
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

      <!-- 慈善捐款 -->
      <fieldset>
        <legend>{{ year }}年社区参与统计 - 慈善捐款 (元)</legend>
        <div class="table-wrapper">
          <table class="community-table">
            <thead>
              <tr>
                <th>单位</th>
                <th v-for="(m, idx) in monthNames" :key="`cd-h-${idx}`">{{ m }}</th>
                <th>合计</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>元</td>
                <td v-for="c in 12" :key="`cd-c-${c-1}`">
                  <input type="number" min="0" step="0.01" v-model.number="charityDonations[currentFactoryIndex][c-1]" />
                </td>
                <td class="total-cell">{{ rowSum(charityDonations[currentFactoryIndex]) }}</td>
              </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <!-- 社区发展投入 -->
      <fieldset>
        <legend>{{ year }}年社区参与统计 - 社区发展投入 (元)</legend>
        <div class="table-wrapper">
          <table class="community-table">
            <thead>
              <tr>
                <th>单位</th>
                <th v-for="(m, idx) in monthNames" :key="`ci-h-${idx}`">{{ m }}</th>
                <th>合计</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>元</td>
                <td v-for="c in 12" :key="`ci-c-${c-1}`">
                  <input type="number" min="0" step="0.01" v-model.number="communityInvestment[currentFactoryIndex][c-1]" />
                </td>
                <td class="total-cell">{{ rowSum(communityInvestment[currentFactoryIndex]) }}</td>
              </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <!-- 志愿者参与 -->
      <fieldset>
        <legend>{{ year }}年社区参与统计 - 志愿者参与 (人次)</legend>
        <div class="table-wrapper">
          <table class="community-table">
            <thead>
              <tr>
                <th>单位</th>
                <th v-for="(m, idx) in monthNames" :key="`vp-h-${idx}`">{{ m }}</th>
                <th>合计</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>人次</td>
                <td v-for="c in 12" :key="`vp-c-${c-1}`">
                  <input type="number" min="0" step="1" v-model.number="volunteerParticipants[currentFactoryIndex][c-1]" />
                </td>
                <td class="total-cell">{{ rowSum(volunteerParticipants[currentFactoryIndex]) }}</td>
              </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <!-- 志愿者服务 -->
      <fieldset>
        <legend>{{ year }}年社区参与统计 - 志愿者服务 (小时)</legend>
        <div class="table-wrapper">
          <table class="community-table">
            <thead>
              <tr>
                <th>单位</th>
                <th v-for="(m, idx) in monthNames" :key="`vh-h-${idx}`">{{ m }}</th>
                <th>合计</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>小时</td>
                <td v-for="c in 12" :key="`vh-c-${c-1}`">
                  <input type="number" min="0" step="0.1" v-model.number="volunteerHours[currentFactoryIndex][c-1]" />
                </td>
                <td class="total-cell">{{ rowSum(volunteerHours[currentFactoryIndex]) }}</td>
              </tr>
            </tbody>
          </table>
        </div>
      </fieldset>

      <button type="submit" :disabled="isSubmitting">
        {{ isSubmitting ? '提交中...' : '提交社区参与数据' }}
      </button>
    </form>
  </div>
</template>

<script setup>
import { computed, onBeforeUnmount, onMounted, reactive, ref } from "vue";
import axios from "axios";
import { useSelectionStore } from "@/stores/selectionStore";

const selectionStore = useSelectionStore();
const factory = computed(() => selectionStore.selectedFactory);
const factories = computed(() => selectionStore.factories);
const year = computed(() => selectionStore.selectedYear);
const years = computed(() => selectionStore.years);
const isSubmitting = ref(false);

onMounted(() => {
  selectionStore.initYears();
  document.addEventListener("click", selectionStore.handleClickOutside);
});
onBeforeUnmount(() => {
  document.removeEventListener("click", selectionStore.handleClickOutside);
});

const monthNames = ["1月","2月","3月","4月","5月","6月","7月","8月","9月","10月","11月","12月"];
function buildMatrix(rows) {
  return Array.from({ length: rows }, () => Array(12).fill(0));
}

const charityDonations = reactive(buildMatrix(factories.value.length));
const communityInvestment = reactive(buildMatrix(factories.value.length));
const volunteerParticipants = reactive(buildMatrix(factories.value.length));
const volunteerHours = reactive(buildMatrix(factories.value.length));

const currentFactoryIndex = computed(() => factories.value.indexOf(factory.value));

const rowSum = (row) => row.reduce((s, v) => s + (Number(v) || 0), 0);

async function submitCommunity() {
  isSubmitting.value = true;
  try {
    const payload = {
      year: Number(year.value),
      factory: factory.value,
      charityDonations: charityDonations[currentFactoryIndex.value],
      communityInvestment: communityInvestment[currentFactoryIndex.value],
      volunteerParticipants: volunteerParticipants[currentFactoryIndex.value],
      volunteerHours: volunteerHours[currentFactoryIndex.value],
    };
    const resp = await axios.post("http://localhost:8000/quantitative/community", payload);
    if (resp.data.status === "success") alert("社区参与数据提交成功!");
  } catch (e) {
    console.error(e);
    alert(`提交失败: ${e.response?.data?.detail || e.message}`);
  } finally {
    isSubmitting.value = false;
  }
}
</script>

<style scoped>
.table-wrapper {
  overflow-x: auto;
  width: 100%;
  box-sizing: border-box;
  margin-bottom: 20px;
}

.community-table {
  width: 100%;
  min-width: 800px;
  border-collapse: collapse;
  table-layout: fixed;
}

.community-table th,
.community-table td {
  border: 1px solid #ddd;
  padding: 6px;
  text-align: center;
  word-break: break-word;
}

.community-table thead th {
  position: sticky;
  top: 0;
  background: #f7f7f7;
  z-index: 1;
}

.total-cell {
  font-weight: 600;
}

.community-table input {
  width: 100%;
  box-sizing: border-box;
}

@media (max-width: 768px) {
  .community-table {
    min-width: 600px;
  }
}
</style>
