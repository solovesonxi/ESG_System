<template>
  <div class="shared-form">
    <form>
      <BaseInfoSelector :review="review" :isYear="true" :isSummary="true" @selection-changed="fetchData"/>
      <fieldset class="summary-fieldset" v-for="setObj in sets || []" :key="setObj.set">
        <legend>{{ setObj.set }}</legend>
        <div class="form-row">
          <table class="data-table">
            <!-- define columns so table-layout:fixed can enforce widths reliably -->
            <colgroup>
              <col class="col-name"/>
              <col class="col-desc"/>
              <col v-if="isQuantitative" class="col-unit"/>
              <col class="col-source"/>
              <col class="col-last"/>
              <col class="col-current"/>
              <col class="col-compare"/>
              <col class="col-reason"/>
            </colgroup>
            <thead>
            <tr>
              <th>指标</th>
              <th>{{ isQuantitative ? '计算方式' : '指标释义' }}</th>
              <th v-if="isQuantitative">单位</th>
              <th>来源</th>
              <th>{{ (year - 1) + (isQuantitative ? '年数据' : '年的方针、政策、文件、记录等') }}</th>
              <th>{{ year + (isQuantitative ? '年数据' : '年的方针、政策、文件、记录等') }}</th>
              <th>{{'对比去年'+(isQuantitative ? '（%）' : '')}}</th>
              <th>原因分析</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="(item, idx) in setObj.fields" :key="idx" @click="showDescription($event, item)">
              <td class="col-name ellipsis" :title="item.name_zh || ''">{{ item.name_zh || '' }}</td>
              <td class="desc-cell col-desc ellipsis" :title="item.description || ''">{{ item.description || '' }}</td>
              <td v-if="isQuantitative" class="col-unit">{{ item.unit || '' }}</td>
              <td class="col-source" :title="item.source || ''">{{ item.source || '' }}</td>
              <td class="col-last">{{ item.lastYear || '' }}</td>
              <td v-if="isEditing && (!isQuantitative || !item.calculation)" >
                <input v-model="item.currentYear" type="text" class="edit-input"/>
              </td>
              <td v-else class="col-current">{{ item.currentYear || '' }}</td>
              <td v-if="isQuantitative || !isEditing" class="col-compare">{{ item.comparison || '' }}</td>
              <td v-else>
                <input v-model="item.comparison" type="text" class="edit-input"/>
                {{ isQuantitative ? '%' : '' }}
              </td>
              <td v-if="!isEditing" class="col-reason">{{ item.reason || '' }}</td>
              <td v-else>
                <input v-model="item.reason" type="text" class="edit-input"/>
              </td>
            </tr>
            </tbody>
          </table>
        </div>
      </fieldset>
    </form>
  </div>
  <!-- 悬浮弹窗模板，参考公告模态窗口样式 -->
  <teleport to="body">
    <div v-if="descDialogVisible" class="modal-overlay" @click.self="descDialogVisible = false">
      <div class="modal-container" @click.stop>
        <div class="modal-header">
          <h3>{{ currentItem?.name_zh || '指标详情' }}</h3>
        </div>
        <div class="modal-content">
          <div class="item-grid">
            <div class="label" v-if="isQuantitative">计算方式</div>
            <div class="label" v-else>指标释义</div>
            <div class="value prewrap" v-if="isQuantitative">
              {{ currentItem?.calculation || currentItem?.description || '' }}
            </div>
            <div class="value prewrap" v-else>{{ currentItem?.description || currentItem?.calculation || '' }}</div>

            <div class="label" v-if="isQuantitative">单位</div>
            <div class="value" v-if="isQuantitative">{{ currentItem.unit }}</div>

            <div class="label">来源</div>
            <div class="value">{{ currentItem.source }}</div>

            <div class="label">上一年 ({{ year - 1 }})</div>
            <div class="value">{{ currentItem?.lastYear || '' }}</div>

            <div class="label">当前年 ({{ year }})</div>
            <div class="value">{{ currentItem?.currentYear || '' }}</div>

            <div class="label">对比去年 (%)</div>
            <div class="value">{{ currentItem?.comparison || '' }}</div>

            <div class="label">原因分析</div>
            <div class="value prewrap">{{ currentItem?.reason || '' }}</div>
          </div>
        </div>
      </div>
    </div>
  </teleport>
</template>

<script setup>
import {computed, onBeforeUnmount, onMounted, ref} from 'vue';
import {useSelectionStore} from "@/stores/selectionStore.js";
import apiClient from "@/utils/axios.js";
import BaseInfoSelector from "@/components/BaseInfoSelector.vue";
import {handleError, showError, showInfo, showSuccess} from "@/utils/toast.js";


const selectionStore = useSelectionStore();
const category = computed(() => selectionStore.selectedCategoryYearly);
const year = computed(() => selectionStore.selectedYear);
const isEditing = ref(false);
const sets = ref([]);
const review = ref({});
const isQuantitative = ref(false);
const descDialogVisible = ref(false);
const currentDescription = ref('');
const currentItem = ref(null);

onMounted(() => {
  document.addEventListener('click', selectionStore.handleClickOutside)
})

onBeforeUnmount(() => {
  document.removeEventListener("click", selectionStore.handleClickOutside);
});

const resetFormData = () => {
  sets.value = []
  review.value = {id: -1, is_submitted: false, status1: "pending", comment1: '', status2: "pending", comment22: ''}
}

const fetchData = async () => {
  try {
    resetFormData();
    // console.log("请求参数：", category.value, factory.value, year.value)
    const response = await apiClient.get('/summary', {
      params: {
        category_id: category.value.id,
        year: year.value
      }
    });
    if (response.data && response.data.sets) {
      isQuantitative.value = response.data.is_quant
      sets.value = response.data.sets
      review.value = response.data.review;
      console.log("汇总结果：", response.data)
    } else {
      showInfo('未找到数据')
    }
  } catch (error) {
    console.error(error)
    handleError(error);
  }
}

const submitEdit = async (ifSubmit) => {
  try {
    const payload = {
      category_id: category.value.id,
      year: parseInt(year.value),
      sets: sets.value,
      isSubmitted: ifSubmit
    }
    // console.log(payload)
    const response = await apiClient.post(`/summary`, payload);
    const operation = ifSubmit ? '提交' : '保存';
    if (response.data && response.data.status === 'success') {
      showSuccess('数据' + operation + '成功!')
    } else {
      showError('数据' + operation + '失败: ' + (response.data.message || '未知错误'))
    }
  } catch (error) {
    handleError(error);
  } finally {
    isEditing.value = false;
    await fetchData();
  }
};

const showDescription = (event, item) => {
  const tag = event?.target?.tagName;
  if (tag && ['INPUT', 'BUTTON', 'TEXTAREA', 'SELECT', 'A'].includes(tag.toUpperCase())) return;
  currentItem.value = item;
  currentDescription.value = isQuantitative.value ? (item.calculation || item.description || '') : (item.description || item.calculation || '');
  descDialogVisible.value = true;
}

defineExpose({
  startEditing: () => isEditing.value = true,
  cancelEditing: () => {
    isEditing.value = false
    fetchData()
  },
  submitEdit,
  fetchData
});
</script>

<style>
.modal-overlay {
  position: fixed;
  left: 0;
  top: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.35);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 9999;
  backdrop-filter: blur(4px);
}

.modal-container {
  background: #fff;
  color: #222;
  border-radius: 16px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.18);
  width: 40%;
  padding: 10px;
  animation: fadeIn 0.25s;
  max-height: 80%;
  overflow: hidden;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: scale(0.97);
  }
  to {
    opacity: 1;
    transform: scale(1);
  }
}

.modal-header {
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 1.2rem 1.5rem 0.5rem 1.5rem;
  border-bottom: 1px solid #eee;
}

.modal-header h3 {
  font-size: 1.3rem;
  font-weight: 700;
  margin: 0;
}

.modal-content {
  padding: 1.2rem 1.5rem 1.5rem 1.5rem;
  overflow-y: auto;
  max-height: calc(80vh - 140px);
}

/* Dark theme adjustments to keep text legible */
.dark-theme .modal-container {
  background: #191d25;
  color: #b0d9ff;
}

.dark-theme .modal-header {
  border-bottom: 1px solid #3a3f4b;
}

.dark-theme .modal-content {
  color: #bcd9ff;
}

/* small helper for truncated description cell cursor */
.desc-cell {
  cursor: pointer;
}

/* Grid layout for modal details: two columns label/value, responsive */
.item-grid {
  display: grid;
  grid-template-columns: 140px 1fr;
  gap: 1rem 2rem;
  align-items: start;
}

.item-grid .label {
  font-weight: 700;
  color: #4a5568;
  padding-top: 0.2rem;
}

.item-grid .value {
  color: #222;
}

.prewrap {
  white-space: pre-wrap;
  max-height: 220px;
  overflow-y: auto;
}

/* Dark theme tweaks for the grid */
.dark-theme .item-grid .label {
  color: #9fb0d7;
}

.dark-theme .item-grid .value {
  color: #d6e9ff;
}

/* Ensure close button sits nicely in header */
.modal-header .close-btn {
  padding: 0.4rem 0.8rem;
  font-size: 0.9rem;
}

/* Table column width and truncation rules */
.data-table {
  table-layout: fixed;
  width: 100%;
}

/* ellipsis utility for single-line truncation */
.ellipsis {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

/* Use percentage widths on <col> for responsive distribution. */
/* These are "preferred" percentages; specific min widths are enforced on td to
   avoid columns collapsing too narrow on very small viewports. */
.data-table col.col-name {
  width: 12%;
}

.data-table col.col-desc {
  width: 12%;
}

.data-table col.col-unit {
  width: 6%;
}

.data-table col.col-source {
  width: 14%;
}

.data-table col.col-last {
  width: 14%;
}

.data-table col.col-current {
  width: 14%;
}

.data-table col.col-compare {
  width: 14%;
}

.data-table col.col-reason {
  width: 14%;
}

/* Apply robust min/max constraints to actual table cells (better cross-browser
   behaviour than relying solely on <col> min/max). */
td.col-name {
  min-width: 90px;
  max-width: 220px;
}

td.col-desc {
  min-width: 120px;
  max-width: 420px;
}

td.col-unit {
  min-width: 50px;
  max-width: 100px;
}

td.col-source {
  min-width: 100px;
  max-width: 260px;
}

td.col-last, td.col-current, td.col-compare {
  min-width: 80px;
  max-width: 160px;
}

td.col-reason {
  min-width: 140px;
  max-width: 360px;
}

/* break long unbroken strings if needed inside cells */
td {
  word-break: break-word;
  overflow-wrap: anywhere;
}

/* Responsive adjustments: on narrower screens reduce desc width and allow
   some breathing room. These keep modal/source unchanged as requested. */
@media (max-width: 1200px) {
  .data-table col.col-desc {
    width: 30%;
  }

  .data-table col.col-name {
    width: 14%;
  }

  .data-table col.col-reason {
    width: 16%;
  }
}

@media (max-width: 900px) {
  /* On smaller screens reduce less-important columns slightly */
  .data-table col.col-desc {
    width: 34%;
  }

  .data-table col.col-name {
    width: 18%;
  }

  .data-table col.col-source {
    width: 0%;
  }

  td.col-source, th:nth-child(4) {
    display: none;
  }
}

@media (max-width: 640px) {
  /* Very small screens: make table more compact; allow wrapping where needed */
  .data-table {
    font-size: 0.9rem;
  }

  .data-table col.col-desc {
    width: 40%;
  }

  .data-table col.col-name {
    width: 20%;
  }

  td.col-reason {
    display: none;
  }

  th:nth-child(8), td.col-reason {
    display: none;
  }
}
</style>
