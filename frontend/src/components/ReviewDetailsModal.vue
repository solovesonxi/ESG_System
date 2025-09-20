<template>
  <div class="modal-overlay" @click.self="closeModal">
    <div class="modal-container" @click.stop>
      <div class="modal-header">
        <h3>审核详情</h3>
      </div>
      <div class="modal-content">
        <div class="info-section">
          <h4>基本信息</h4>
          <div class="info-grid">
            <div class="info-item"><label>工厂：</label><span>{{ record.factory }}</span></div>
            <div class="info-item"><label>数据类型：</label><span>{{ CATEGORY[record.data_type] }}</span></div>
            <div class="info-item"><label>年份：</label><span>{{ record.year }}</span></div>
            <div class="info-item" v-if="record.month"><label>月份：</label><span>{{ record.month }}</span></div>
            <div class="info-item"><label>提交状态：</label><span>{{ record.is_submitted ? '已提交' : '未提交' }}</span></div>
          </div>
        </div>
        <div class="audit-section">
          <h4>一级审核</h4>
          <div class="audit-grid">
            <div class="audit-item"><label>状态：</label><span :class="['status-badge', record.level1_status]">{{ getStatusLabel(record.level1_status) }}</span></div>
            <div class="audit-item"><label>审核人：</label><span>{{ record.level1_reviewer || '' }}</span></div>
            <div class="audit-item"><label>审核时间：</label><span>{{ formatDateTime(record.level1_review_time) }}</span></div>
            <div class="audit-item"><label>评论：</label><span>{{ record.level1_comment || '' }}</span></div>
          </div>
          <h4>二级审核</h4>
          <div class="audit-grid">
            <div class="audit-item"><label>状态：</label><span :class="['status-badge', record.level2_status]">{{ getStatusLabel(record.level2_status) }}</span></div>
            <div class="audit-item"><label>审核人：</label><span>{{ record.level2_reviewer || '' }}</span></div>
            <div class="audit-item"><label>审核时间：</label><span>{{ formatDateTime(record.level2_review_time) }}</span></div>
            <div class="audit-item"><label>评论：</label><span>{{ record.level2_comment || '' }}</span></div>
          </div>
        </div>
        <div class="modal-footer">
          <button class="audit-btn" @click="goToAudit">前往审核</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { defineProps, defineEmits } from 'vue'
import { useRouter } from 'vue-router'
import {CATEGORY} from "@/constants/indicators.js";
import {useSelectionStore} from "@/stores/selectionStore.js";
import {useAuthStore} from "@/stores/authStore.js";
const props = defineProps({ record: Object })
const emit = defineEmits(['close'])
const router = useRouter()
const authStore = useAuthStore()
const selectionStore = useSelectionStore()
function closeModal() { emit('close') }
function getStatusLabel(status) {
  const map = { pending: '待审核', approved: '通过', rejected: '不通过' }
  return map[status] || status || ''
}
function formatDateTime(dt) {
  if (!dt) return ''
  if (typeof dt === 'string') return dt.replace('T', ' ').slice(0, 19)
  return dt
}
function goToAudit() {
  if (props.record?.data_type) {
    authStore.setDataMode(props.record.data_type)
    selectionStore.setSelection(props.record.factory, props.record.year, props.record.month || null)
    router.push('/' + props.record.data_type.replaceAll('_','-'))
    closeModal()
  }
}
</script>

<style scoped>
.modal-overlay {
  position: fixed; left: 0; top: 0; right: 0; bottom: 0;
  background: rgba(0,0,0,0.35); display: flex; align-items: center; justify-content: center;
  z-index: 9999;
  backdrop-filter: blur(4px);
}
.modal-container {
  background: #fff;
  color: #222;
  border-radius: 16px;
  box-shadow: 0 8px 32px rgba(0,0,0,0.18);
  width: 60%;
  padding: 10px;
  animation: fadeIn 0.25s;
}
@keyframes fadeIn { from { opacity: 0; transform: scale(0.97);} to { opacity: 1; transform: scale(1);} }
.modal-header {
  display: flex; justify-content: space-between; align-items: center;
  padding: 1.2rem 1.5rem 0.5rem 1.5rem;
  border-bottom: 1px solid #eee;
}
.modal-header h3 { font-size: 1.3rem; font-weight: 700; }
.modal-content {
  padding: 1.2rem 1.5rem 1.5rem 1.5rem;
}
.info-section h4, .audit-section h4 { font-size: 1.1rem; font-weight: 600; margin-bottom: 0.7rem; color: #764ba2; }
.info-grid, .audit-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 0.5rem 1.2rem;
  margin-bottom: 1.2rem;
}
.info-item, .audit-item {
  display: flex; gap: 0.5rem; align-items: center;
  font-size: 0.98rem;
}
label { color: #888; font-weight: 500; }
.status-badge {
  display: inline-block; padding: 0.2em 0.8em; border-radius: 12px; font-weight: 600; font-size: 0.97rem;
  background: #eee; color: #222;
}
.status-badge.approved { background: linear-gradient(90deg,#44e0b1,#2aa95c); color: #fff; }
.status-badge.rejected { background: linear-gradient(90deg,#f3adbd,#c04a5d); color: #fff; }
.status-badge.pending { background: linear-gradient(90deg,#c7cfea,#ae75e5); color: #fff; }
.audit-section { margin-top: 1.2rem; }
.modal-footer {
  display: flex;
  justify-content: flex-end;
  padding: 1rem 1.5rem 1rem 1.5rem;
  border-top: 1px solid #eee;
}
.audit-btn {
  background: linear-gradient(90deg,#667eea,#764ba2);
  color: #fff;
  border: none;
  border-radius: 8px;
  padding: 0.7em 1.6em;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: background 0.2s, box-shadow 0.2s;
  box-shadow: 0 2px 8px #667eea33;
}
.audit-btn:hover {
  background: linear-gradient(90deg,#764ba2,#667eea);
  box-shadow: 0 4px 16px #764ba233;
}

.dark-theme .modal-container {
  background: #191d25;
  color: #b0d9ff;
}
.dark-theme .modal-header {
  border-bottom: 1px solid #3a3f4b;
}
.dark-theme .info-section h4, .dark-theme .audit-section h4 {
  color: #7ab7ff;
}
.dark-theme .status-badge {
  background: #313543;
  color: #b0d9ff;
}
.dark-theme .status-badge.approved {
  background: linear-gradient(90deg,#199872,#16542e);
  color: #fff;
}
.dark-theme .status-badge.rejected {
  background: linear-gradient(90deg,#c71789,#98041d);
  color: #fff;
}
.dark-theme .status-badge.pending {
  background: linear-gradient(90deg,#364588,#3c1267);
  color: #fff;
}
.dark-theme .audit-btn {
  background: linear-gradient(90deg,#7ab7ff,#533483);
  color: #fff;
}
.dark-theme .audit-btn:hover {
  background: linear-gradient(90deg,#533483,#7ab7ff);
}
</style>
