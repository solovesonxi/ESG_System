<!-- BaseInfoSelector.vue -->
<template>
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
          <div class="options" v-show="showFactoryDropdown"
               :style="{ maxHeight: '200px', overflowY: 'auto' }">
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
</template>

<script setup>
import { computed } from 'vue';
import { useSelectionStore } from "@/stores/selectionStore.js";

const selectionStore = useSelectionStore();

const factory = computed(() => selectionStore.selectedFactory);
const factories = computed(() => selectionStore.factories);
const year = computed(() => selectionStore.selectedYear);
const years = computed(() => selectionStore.years);
const showFactoryDropdown = computed(() => selectionStore.showFactoryDropdown);
const showYearDropdown = computed(() => selectionStore.showYearDropdown);

const toggleFactoryDropdown = () => selectionStore.toggleFactoryDropdown();
const toggleYearDropdown = () => selectionStore.toggleYearDropdown();
const selectFactory = (f) => selectionStore.selectFactory(f);
const selectYear = (y) => selectionStore.selectYear(y);
</script>