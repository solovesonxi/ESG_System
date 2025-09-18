<!-- BaseInfoSelector.vue -->
<template>
  <fieldset class="info-fieldset">
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
      <div class="form-group" v-if="authStore.isDataMode">
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
      <div class="form-group">
        <label>审核状态</label>
        <div class="custom-select">
          <div class="selected" @click="isAuditEditable && (showAuditDropdown = !showAuditDropdown)">
            {{ currentAuditStatusLabel }}
            <i class="arrow" :class="{ 'up': showAuditDropdown }"></i>
          </div>
          <div class="options" v-show="showAuditDropdown">
            <div
                v-for="status in auditStatusOptions"
                :key="status.value"
                class="option"
                :class="{
                  'selected-option': status.value === currentAuditStatus,
                  'option-disabled': !isAuditEditable
                }"
                @click="handleAuditStatusChange(status.value)"
                :style="{ cursor: isAuditEditable ? 'pointer' : 'not-allowed' }"
            >
              {{ status.label }}
            </div>
          </div>
        </div>
      </div>

    </div>
    <div class="form-comment">
      <label>审核评论</label>
      <div class="audit-comment" :title="currentAuditComment">
        <span v-if="currentAuditComment" class="comment-text">{{ currentAuditComment }}</span>
        <span v-else class="empty-comment">暂无评论</span>
      </div>
    </div>
  </fieldset>

  <!-- 独立的悬浮审核评论弹窗 -->
  <teleport to="body">
    <div v-if="showCommentModal" class="audit-modal-overlay" @click="handleOverlayClick">
      <div class="audit-modal" @click.stop>
        <div class="audit-modal-header">
          <div class="header-left">
            <div class="audit-icon">
            </div>
            审核状态
            <div class="header-text">
              <div class="status-badge" :class="getStatusClass(pendingStatus)">
                <h2>{{ auditStatusOptions.find(opt => opt.value === pendingStatus)?.label }}</h2>
              </div>
            </div>
          </div>
          <button type="button" class="close-btn" @click="cancelAudit">
            <svg viewBox="0 0 24 24" width="18" height="18">
              <path
                  d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/>
            </svg>
          </button>
        </div>
        <div class="audit-modal-body">
          <div class="comment-section">
            <label for="audit-comment" class="comment-label">
              <svg viewBox="0 0 24 24" width="16" height="16">
                <path d="M20 2H4c-1.1 0-2 .9-2 2v12c0 1.1.9 2 2 2h4l4 4 4-4h4c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2z"/>
              </svg>
              审核意见
            </label>
            <div class="textarea-wrapper">
              <textarea
                  id="audit-comment"
                  v-model="newComment"
                  rows="4"
                  placeholder="请输入您的审核意见..."
                  class="comment-input"
                  maxlength="500"
              ></textarea>
              <div class="char-count">{{ newComment.length || 0 }}/500</div>
            </div>
          </div>
        </div>
        <div class="audit-modal-footer">
          <button type="button" class="btn btn-cancel" @click="cancelAudit">
            取消
          </button>
          <button type="button" class="btn btn-submit" @click="submitAudit">
            <svg viewBox="0 0 24 24" width="16" height="16">
              <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/>
            </svg>
            提交审核
          </button>
        </div>
      </div>
    </div>
  </teleport>
</template>

<script setup>
import {computed, ref, watch} from 'vue';
import {useSelectionStore} from "@/stores/selectionStore.js";
import {useAuthStore} from '@/stores/authStore';
import apiClient from "@/utils/axios.js";
import {handleError, showInfo} from "@/utils/toast.js";

const selectionStore = useSelectionStore();
const authStore = useAuthStore();

// Props - 接收来自父组件的审核数据
const props = defineProps({
  review: {
    type: Object,
    default: () => ({})
  },
  formType: {
    type: String,
    required: true,
    default: 'material'
  }
});

const emit = defineEmits(['selection-changed']);

const factory = computed(() => selectionStore.selectedFactory);
const year = computed(() => selectionStore.selectedYear);
const month = computed(() => selectionStore.selectedMonth);

// 审核相关
const auditStatusOptions = [
  {value: 'pending', label: '待审核'},
  {value: 'approved', label: '通过'},
  {value: 'rejected', label: '不通过'}
];

const showAuditDropdown = ref(false);
const showCommentModal = ref(false);
const newComment = ref('');
const pendingStatus = ref(''); // 添加变量存储用户选择的状态
const isAuditEditable = computed(() => authStore.isAdmin || authStore.isHeadquarter);

// 根据当前选择的月份获取对应的审核状态和评论 - 统一使用props.review
const currentAuditStatus = computed(() => {
  if (authStore.isDataMode && props.review.status && Array.isArray(props.review.status)) {
    return props.review.status[month.value - 1] || 'pending';
  } else if (!authStore.isDataMode && props.review.status && typeof props.review.status === 'string') {
    return props.review.status || 'pending';
  }
  return 'pending';
});

const currentAuditComment = computed(() => {
  if (authStore.isDataMode && props.review.comment && Array.isArray(props.review.comment)) {
    return props.review.comment[month.value - 1] || '';
  } else if (!authStore.isDataMode && props.review.comment && typeof props.review.comment === 'string') {
    return props.review.comment || '';
  }
  return '';
});

const currentAuditStatusLabel = computed(() => {
  const found = auditStatusOptions.find(opt => opt.value === currentAuditStatus.value);
  return found ? found.label : '待审核';
});

// 切换审核状态
const handleAuditStatusChange = (status) => {
  if (!isAuditEditable.value) return;
  showAuditDropdown.value = false;
  if (status !== currentAuditStatus.value) {
    pendingStatus.value = status; // 先存储选择的状态
    if (status === 'pending') {
      // 待审核状态不需要评论，直接提交
      newComment.value = '';
      submitAudit();
    } else {
      // 通过和不通过都需要填写评论
      showCommentModal.value = true;
      newComment.value = currentAuditComment.value || '';
    }
  }
};

// 提交审核状态和评论
const submitAudit = async () => {
  const auditData = {
    factory: factory.value,
    year: year.value,
    month: authStore.isDataMode ? month.value : null,
    formType: props.formType,
    status: pendingStatus.value,
    comment: newComment.value
  };
  try {
    const response = await apiClient.patch('/review', auditData);
    if (response.data && response.data.status === 'success') {
      emit('selection-changed');
    } else {
      console.error('审核状态提交失败:', response.data);
      showInfo('审核状态更新失败：' + (response.data?.message || '未知错误'));
    }
  } catch (error) {
    console.error('审核状态更新失败:', error);
    handleError(error)
  } finally {
    showCommentModal.value = false;
    pendingStatus.value = '';
    newComment.value = '';
  }
};

const cancelAudit = () => {
  showCommentModal.value = false;
  pendingStatus.value = '';
  newComment.value = '';
};

// 处理弹窗背景点击
const handleOverlayClick = (e) => {
  if (e.target === e.currentTarget) {
    cancelAudit();
  }
};

// 获取状态样式类
const getStatusClass = (status) => {
  switch (status) {
    case 'approved':
      return 'status-approved';
    case 'rejected':
      return 'status-rejected';
    case 'pending':
      return 'status-pending';
    default:
      return '';
  }
};

// 监听选择变化
watch([factory, year], () => {
  emit('selection-changed');
});
</script>

<style scoped>
.audit-comment {
  padding: 0.75rem;
  border: 1px solid #ddd;
  border-radius: 6px;
  background-color: #f9f9f9;
  min-height: 45px;
  display: flex;
  align-items: center;
  font-size: 14px;
  line-height: 1.4;
}

.empty-comment {
  color: #999;
  font-style: italic;
}

/* 审核弹窗样式 */
.audit-modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.6);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 10000;
  backdrop-filter: blur(4px);
}

.audit-modal {
  background: white;
  border-radius: 12px;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
  width: 90%;
  max-width: 500px;
  max-height: 80vh;
  overflow: hidden;
  animation: modalSlideIn 0.3s ease-out;
}

@keyframes modalSlideIn {
  from {
    opacity: 0;
    transform: translateY(-50px) scale(0.95);
  }
  to {
    opacity: 1;
    transform: translateY(0) scale(1);
  }
}

.audit-modal-header {
  padding: 1.5rem 2rem 1rem;
  border-bottom: 1px solid #eee;
  display: flex;
  justify-content: space-between;
  align-items: center;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
}

.header-left {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.audit-icon {
  width: 24px;
  height: 24px;
}

.header-text h3 {
  margin: 0;
  font-size: 1.25rem;
  font-weight: 600;
}

.status-badge {
  display: flex;
  align-items: center;
  padding: 0.25rem 0.5rem;
  border-radius: 12px;
  font-size: 0.875rem;
  font-weight: 500;
  margin-top: 0.25rem;
  background: rgba(255, 255, 255, 0.2);
  backdrop-filter: blur(8px);
}

.status-approved {
  background: rgba(212, 237, 218, 0.9);
  color: #155724;
}

.status-rejected {
  background: rgba(248, 215, 218, 0.9);
  color: #721c24;
}

.status-pending {
  background: rgba(255, 243, 205, 0.9);
  color: #856404;
}

.close-btn {
  background: none;
  border: none;
  color: white;
  font-size: 1.5rem;
  cursor: pointer;
  padding: 0;
  width: 30px;
  height: 30px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  transition: background-color 0.2s;
}

.close-btn:hover {
  background-color: rgba(255, 255, 255, 0.2);
}

.audit-modal-body {
  padding: 2rem;
}

.comment-section {
  margin-bottom: 1.5rem;
}

.comment-label {
  display: block;
  margin-bottom: 0.75rem;
  font-weight: 600;
  color: #495057;
  position: relative;
}

.comment-label svg {
  position: absolute;
  left: -24px;
  top: 50%;
  transform: translateY(-50%);
  fill: #667eea;
}

.textarea-wrapper {
  position: relative;
}

.comment-input {
  width: 100%;
  padding: 0.75rem;
  border: 2px solid #e9ecef;
  border-radius: 8px;
  font-size: 14px;
  line-height: 1.5;
  resize: vertical;
  min-height: 100px;
  transition: border-color 0.2s, box-shadow 0.2s;
}

.comment-input:focus {
  outline: none;
  border-color: #667eea;
  box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
}

.char-count {
  position: absolute;
  right: 10px;
  bottom: 10px;
  font-size: 12px;
  color: #999;
}

.audit-modal-footer {
  padding: 1rem 2rem 1.5rem;
  display: flex;
  justify-content: flex-end;
  gap: 1rem;
  background: #f8f9fa;
}

.btn {
  padding: 0.75rem 1.5rem;
  border: none;
  border-radius: 6px;
  font-size: 0.875rem;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s;
  min-width: 80px;
}

.btn-cancel {
  background: #6c757d;
  color: white;
}

.btn-cancel:hover {
  background: #5a6268;
  transform: translateY(-1px);
}

.btn-submit {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
}

.btn-submit:hover {
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
}

.btn:active {
  transform: translateY(0);
}

/* 深色主题支持 */
.dark-theme .audit-modal {
  background: #2d3748;
  color: #e2e8f0;
}

.dark-theme .audit-modal-header {
  background: linear-gradient(135deg, #4a5568 0%, #2d3748 100%);
  border-bottom-color: #4a5568;
}

.dark-theme .status-badge {
  background: rgba(255, 255, 255, 0.1);
}

.dark-theme .status-approved {
  background: rgba(72, 187, 120, 0.3);
  color: #9ae6b4;
}

.dark-theme .status-rejected {
  background: rgba(245, 101, 101, 0.3);
  color: #feb2b2;
}

.dark-theme .status-pending {
  background: rgba(237, 137, 54, 0.3);
  color: #fbb064;
}

.dark-theme .comment-section label {
  color: #cbd5e0;
}

.dark-theme .comment-input {
  background: #4a5568;
  border-color: #718096;
  color: #e2e8f0;
}

.dark-theme .comment-input:focus {
  border-color: #667eea;
}

.dark-theme .audit-modal-footer {
  background: #4a5568;
}

.dark-theme .audit-comment {
  background: #4a5568;
  border-color: #718096;
  color: #e2e8f0;
}

.dark-theme .empty-comment {
  color: #a0aec0;
}
</style>
