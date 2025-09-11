<!-- BaseInfoSelector.vue -->
<template>
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
</template>

<script setup>
import {computed, watch} from 'vue';
import { useSelectionStore } from "@/stores/selectionStore.js";
const selectionStore = useSelectionStore();
const emit = defineEmits(['selection-changed']);
const factory = computed(() => selectionStore.selectedFactory);
const year = computed(() => selectionStore.selectedYear);
const  month = computed(() => selectionStore.selectedMonth);
watch([factory, year], () => {
  emit('selection-changed');
});
</script>