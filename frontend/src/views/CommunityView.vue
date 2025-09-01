<template>
  <div class="shared-form">
    <form>
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
              <th v-for="(m, idx) in monthNames" :key="`cd-h-${idx}`">{{ m }}</th>
              <th>合计</th>
            </tr>
            </thead>
            <tbody>
            <tr>
              <td v-for="c in 12" :key="`cd-c-${c-1}`">
                <input type="number" min="0" step="1" v-model.number="charityDonations[c-1]" :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required />
              </td>
              <td class="total-cell">{{ rowSum(charityDonations) }}</td>
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
              <th v-for="(m, idx) in monthNames" :key="`ci-h-${idx}`">{{ m }}</th>
              <th>合计</th>
            </tr>
            </thead>
            <tbody>
            <tr>
              <td v-for="c in 12" :key="`ci-c-${c-1}`">
                <input type="number" min="0" step="1" v-model.number="communityInvestment[c-1]" :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required />
              </td>
              <td class="total-cell">{{ rowSum(communityInvestment) }}</td>
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
              <th v-for="(m, idx) in monthNames" :key="`vp-h-${idx}`">{{ m }}</th>
              <th>合计</th>
            </tr>
            </thead>
            <tbody>
            <tr>
              <td v-for="c in 12" :key="`vp-c-${c-1}`">
                <input type="number" min="0" step="1" v-model.number="volunteerParticipants[c-1]" :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required />
              </td>
              <td class="total-cell">{{ rowSum(volunteerParticipants) }}</td>
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
              <th v-for="(m, idx) in monthNames" :key="`vh-h-${idx}`">{{ m }}</th>
              <th>合计</th>
            </tr>
            </thead>
            <tbody>
            <tr>
              <td v-for="c in 12" :key="`vh-c-${c-1}`">
                <input type="number" min="0" step="0.1" v-model.number="volunteerHours[c-1]" :readonly="!isEditing" :class="{ 'editable-field': isEditing }" required />
              </td>
              <td class="total-cell">{{ rowSum(volunteerHours) }}</td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>
    </form>
  </div>
</template>

<script setup>
import {computed, onBeforeUnmount, onMounted, reactive, ref, watch} from "vue";
import axios from "axios";
import { useSelectionStore } from "@/stores/selectionStore";

const selectionStore = useSelectionStore();
const factory = computed(() => selectionStore.selectedFactory);
const factories = computed(() => selectionStore.factories);
const year = computed(() => selectionStore.selectedYear);
const years = computed(() => selectionStore.years);
const isSubmitting = ref(false);
const isEditing = ref(false);

onMounted(() => {
  selectionStore.initYears();
  document.addEventListener("click", selectionStore.handleClickOutside);
  fetchData();
});
onBeforeUnmount(() => {
  document.removeEventListener("click", selectionStore.handleClickOutside);
});

const monthNames = ["1月","2月","3月","4月","5月","6月","7月","8月","9月","10月","11月","12月"];


const charityDonations = reactive(Array(12).fill(0));
const communityInvestment = reactive(Array(12).fill(0));
const volunteerParticipants = reactive(Array(12).fill(0));
const volunteerHours = reactive(Array(12).fill(0));
const rowSum = (row) => row.reduce((s, v) => s + (Number(v) || 0), 0);

watch([factory, year], () => {
  fetchData();
});

// 获取数据方法
const fetchData = async () => {
  if (!factory.value || !year.value) {
    resetFormData();
    return;
  }
  try {
    const response = await axios.get(`http://localhost:8000/quantitative/community`, {
      params: { factory: factory.value, year: year.value }
    });
    if (response.data && response.data.data) {
      const data = response.data.data;
      charityDonations.splice(0, 12, ...(data.charityDonations || Array(12).fill(0)));
      communityInvestment.splice(0, 12, ...(data.communityInvestment || Array(12).fill(0)));
      volunteerParticipants.splice(0, 12, ...(data.volunteerParticipants || Array(12).fill(0)));
      volunteerHours.splice(0, 12, ...(data.volunteerHours || Array(12).fill(0)));
    } else {
      resetFormData();
    }
  } catch (error) {
    if (error.response?.status === 404) {
      resetFormData();
    } else {
      console.error('获取数据失败:', error);
    }
  }
};

// 重置表单数据
const resetFormData = () => {
  charityDonations.splice(0, 12, ...Array(12).fill(0));
  communityInvestment.splice(0, 12, ...Array(12).fill(0));
  volunteerParticipants.splice(0, 12, ...Array(12).fill(0));
  volunteerHours.splice(0, 12, ...Array(12).fill(0));
};

async function submitEdit() {
  isSubmitting.value = true;
  try {
    const payload = {
      year: Number(year.value),
      factory: factory.value,
      charityDonations: charityDonations,
      communityInvestment: communityInvestment,
      volunteerParticipants: volunteerParticipants,
      volunteerHours: volunteerHours,
    };
    const resp = await axios.post("http://localhost:8000/quantitative/community", payload);
    if (resp.data.status === "success") alert("社区参与数据提交成功!");
  } catch (e) {
    console.error(e);
    alert(`提交失败: ${e.response?.data?.detail || e.message}`);
  } finally {
    isSubmitting.value = false;
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

