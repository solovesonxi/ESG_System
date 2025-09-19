<!-- BaseInfoSelector.vue -->
<template>
  <div class="base-info-container">
    <!-- 基础信息和提交状态 -->
    <div class="info-header">
      <div class="basic-info">
        <h3 class="section-title">基础信息</h3>
        <div class="info-grid">
          <!-- 工厂名称 -->
          <div class="info-item">
            <label class="info-label">工厂名称</label>
            <div class="custom-select">
              <div class="selected" @click="selectionStore.toggleFactoryDropdown">
                <span class="value">{{ factory }}</span>
                <i class="arrow" :class="{ 'up': selectionStore.showFactoryDropdown }"></i>
              </div>
              <div class="options" v-show="selectionStore.showFactoryDropdown">
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

          <!-- 统计年份 -->
          <div class="info-item">
            <label class="info-label">统计年份</label>
            <div class="custom-select">
              <div class="selected" @click="selectionStore.toggleYearDropdown">
                <span class="value">{{ year }}年</span>
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

          <!-- 统计月份 (仅在DataMode下显示) -->
          <div class="info-item" v-if="authStore.isDataMode">
            <label class="info-label">统计月份</label>
            <div class="custom-select">
              <div class="selected" @click="selectionStore.toggleMonthDropdown">
                <span class="value">{{ month }}月</span>
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
      </div>

      <!-- 提交状态指示器 -->
      <div class="submission-indicator">
        <div class="status-badge" :class="submissionStatusClass">
          <i class="fas" :class="submissionStatusIcon"></i>
          <span class="status-text">{{ submissionStatusText }}</span>
        </div>
        <div class="status-detail">
          提交状态
        </div>
      </div>
    </div>

    <!-- 审核信息区域 -->
    <div class="review-section" v-if="hasReviewData">
      <h3 class="section-title">审核信息</h3>

      <!-- 月度数据审核信息 -->
      <div v-if="isMonthlyData" class="monthly-review">
        <div class="review-item">
          <div class="review-header">
            <span class="month-label">{{ month }}月审核状态</span>
          </div>
          <div class="review-grid">
            <!-- 一级审核 -->
            <div class="review-column" v-if="authStore.canViewLevel1Results">
              <div class="review-title">
                <i class="fas fa-check-circle"></i>
                一级审核
              </div>
              <div class="status-display">
                <span class="status-badge" :class="getStatusClass(currentLevel1Status)">
                  {{ getStatusLabel(currentLevel1Status) }}
                </span>
                <!-- 编辑控制 -->
                <div class="edit-control" v-if="canEditLevel1">
                  <select
                      :value="currentLevel1Status"
                      @change="handleLevel1StatusChange($event.target.value)"
                      class="status-select"
                  >
                    <option v-for="option in auditStatusOptions" :key="option.value" :value="option.value">
                      {{ option.label }}
                    </option>
                  </select>
                </div>
              </div>
              <div class="comment-display" v-if="currentLevel1Comment">
                <div class="comment-label">审核意见</div>
                <div class="comment-text">{{ currentLevel1Comment }}</div>
              </div>
            </div>

            <!-- 二级审核 -->
            <div class="review-column" v-if="authStore.canViewLevel2Results">
              <div class="review-title">
                <i class="fas fa-shield-alt"></i>
                二级审核
              </div>
              <div class="status-display">
                <span class="status-badge" :class="getStatusClass(currentLevel2Status)">
                  {{ getStatusLabel(currentLevel2Status) }}
                </span>
                <!-- 编辑控制 -->
                <div class="edit-control" v-if="canEditLevel2">
                  <select
                      :value="currentLevel2Status"
                      @change="handleLevel2StatusChange($event.target.value)"
                      class="status-select"
                  >
                    <option v-for="option in auditStatusOptions" :key="option.value" :value="option.value">
                      {{ option.label }}
                    </option>
                  </select>
                </div>
              </div>
              <div class="comment-display" v-if="currentLevel2Comment">
                <div class="comment-label">审核意见</div>
                <div class="comment-text">{{ currentLevel2Comment }}</div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- 年度数据审核信息 -->
      <div v-else class="yearly-review">
        <div class="review-grid">
          <!-- 一级审核 -->
          <div class="review-column" v-if="authStore.canViewLevel1Results">
            <div class="review-title">
              <i class="fas fa-check-circle"></i>
              一级审核
            </div>
            <div class="status-display">
              <span class="status-badge" :class="getStatusClass(currentLevel1Status)">
                {{ getStatusLabel(currentLevel1Status) }}
              </span>
              <!-- 编辑控制 -->
              <div class="edit-control" v-if="canEditLevel1">
                <select
                    :value="currentLevel1Status"
                    @change="handleLevel1StatusChange($event.target.value)"
                    class="status-select"
                >
                  <option v-for="option in auditStatusOptions" :key="option.value" :value="option.value">
                    {{ option.label }}
                  </option>
                </select>
              </div>
            </div>
            <div class="comment-display" v-if="currentLevel1Comment">
              <div class="comment-label">审核意见</div>
              <div class="comment-text">{{ currentLevel1Comment }}</div>
            </div>
          </div>

          <!-- 二级审核 -->
          <div class="review-column" v-if="authStore.canViewLevel2Results">
            <div class="review-title">
              <i class="fas fa-shield-alt"></i>
              二级审核
            </div>
            <div class="status-display">
              <span class="status-badge" :class="getStatusClass(currentLevel2Status)">
                {{ getStatusLabel(currentLevel2Status) }}
              </span>
              <!-- 编辑控制 -->
              <div class="edit-control" v-if="canEditLevel2">
                <select
                    :value="currentLevel2Status"
                    @change="handleLevel2StatusChange($event.target.value)"
                    class="status-select"
                >
                  <option v-for="option in auditStatusOptions" :key="option.value" :value="option.value">
                    {{ option.label }}
                  </option>
                </select>
              </div>
            </div>
            <div class="comment-display" v-if="currentLevel2Comment">
              <div class="comment-label">审核意见</div>
              <div class="comment-text">{{ currentLevel2Comment }}</div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 审核评论弹窗 -->
    <teleport to="body">
      <div v-if="showCommentModal" class="modal-overlay" @click="handleOverlayClick">
        <div class="modal-container" @click.stop>
          <div class="modal-header">
            <h3>审核评论</h3>
          </div>
          <div class="modal-body">
            <div class="comment-section">
              <label class="comment-label">审核意见</label>
              <textarea
                  v-model="newComment"
                  rows="4"
                  placeholder="请输入您的审核意见..."
                  class="comment-input"
                  maxlength="500"
              ></textarea>
              <div class="char-count">{{ newComment.length || 0 }}/500</div>
            </div>
          </div>
          <div class="modal-footer">
            <button class="btn btn-cancel" @click="cancelAudit">取消</button>
            <button class="btn btn-submit" @click="submitAudit">提交</button>
          </div>
        </div>
      </div>
    </teleport>
  </div>
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

// 审核编辑权限
const canEditLevel1 = computed(() => authStore.canLevel1Review);
const canEditLevel2 = computed(() => authStore.canLevel2Review);

// 审核状态选项
const auditStatusOptions = [
  {value: 'pending', label: '待审核'},
  {value: 'approved', label: '通过'},
  {value: 'rejected', label: '不通过'}
];

// 审核相关状态
const showCommentModal = ref(false);
const newComment = ref('');
const pendingStatus = ref('');
const pendingLevel = ref(0);

// 判断是否为月度数据
const isMonthlyData = computed(() => {
  return authStore.isDataMode && props.review.is_submitted && Array.isArray(props.review.is_submitted);
});

// 判断是否有审核数据
const hasReviewData = computed(() => {
  return props.review && Object.keys(props.review).length > 0;
});

// 提交状态相关计算属性
const currentSubmissionStatus = computed(() => {
  if (isMonthlyData.value && props.review.is_submitted) {
    return props.review.is_submitted[month.value - 1] || false;
  } else if (!isMonthlyData.value && props.review.is_submitted !== undefined) {
    return props.review.is_submitted || false;
  }
  return false;
});

const submissionStatusClass = computed(() => {
  return currentSubmissionStatus.value ? 'status-submitted' : 'status-not-submitted';
});

const submissionStatusIcon = computed(() => {
  return currentSubmissionStatus.value ? 'fa-check-circle' : 'fa-clock';
});

const submissionStatusText = computed(() => {
  return currentSubmissionStatus.value ? '已提交' : '未提交';
});

// 一级审核状态
const currentLevel1Status = computed(() => {
  if (isMonthlyData.value && props.review.status1) {
    return props.review.status1[month.value - 1] || 'pending';
  } else if (!isMonthlyData.value && props.review.status1) {
    return props.review.status1 || 'pending';
  }
  return 'pending';
});

const currentLevel1Comment = computed(() => {
  if (isMonthlyData.value && props.review.comment1) {
    return props.review.comment1[month.value - 1] || '';
  } else if (!isMonthlyData.value && props.review.comment1) {
    return props.review.comment1 || '';
  }
  return '';
});

// 二级审核状态
const currentLevel2Status = computed(() => {
  if (isMonthlyData.value && props.review.status2) {
    return props.review.status2[month.value - 1] || 'pending';
  } else if (!isMonthlyData.value && props.review.status2) {
    return props.review.status2 || 'pending';
  }
  return 'pending';
});

const currentLevel2Comment = computed(() => {
  if (isMonthlyData.value && props.review.comment2) {
    return props.review.comment2[month.value - 1] || '';
  } else if (!isMonthlyData.value && props.review.comment2) {
    return props.review.comment2 || '';
  }
  return '';
});

// 处理审核状态变更
const handleLevel1StatusChange = (status) => {
  if (status !== currentLevel1Status.value) {
    pendingStatus.value = status;
    pendingLevel.value = 1;
    if (status === 'pending') {
      newComment.value = '';
      submitAudit();
    } else {
      showCommentModal.value = true;
      newComment.value = currentLevel1Comment.value || '';
    }
  }
};

const handleLevel2StatusChange = (status) => {
  if (status !== currentLevel2Status.value) {
    pendingStatus.value = status;
    pendingLevel.value = 2;
    if (status === 'pending') {
      newComment.value = '';
      submitAudit();
    } else {
      showCommentModal.value = true;
      newComment.value = currentLevel2Comment.value || '';
    }
  }
};

// 提交审核
const submitAudit = async () => {
  const auditData = {
    id: authStore.isDataMode ? props.review.id[month.value - 1] : props.review.id,
    level: pendingLevel.value,
    status: pendingStatus.value,
    comment: newComment.value
  };
  try {
    const response = await apiClient.patch(`/review`, auditData);
    if (response.data && response.data.status === 'success') {
      emit('selection-changed');
    } else {
      console.error('审核状态提交失败:', response.data);
      showInfo('审核状态更新失败：' + (response.data?.message || '未知错误'));
    }
  } catch (error) {
    console.error('审核状态更新失败:', error);
    handleError(error);
  } finally {
    showCommentModal.value = false;
    pendingStatus.value = '';
    pendingLevel.value = '';
    newComment.value = '';
  }
};

const cancelAudit = () => {
  showCommentModal.value = false;
  pendingStatus.value = '';
  pendingLevel.value = '';
  newComment.value = '';
};

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
      return 'status-pending';
  }
};

// 获取状态标签
const getStatusLabel = (status) => {
  const found = auditStatusOptions.find(opt => opt.value === status);
  return found ? found.label : '待审核';
};

// 监听选择变化
watch([factory, year, month], () => {
  emit('selection-changed');
});
</script>

<style scoped>
.base-info-container {
  background: rgba(255, 255, 255, 0.95);
  border-radius: 16px;
  padding: 1.5rem;
  margin-bottom: 1.5rem;
  backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.3);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
}

.info-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 1.5rem;
}

.basic-info {
  flex: 1;
}

.section-title {
  color: #2c3e50;
  font-size: 1.25rem;
  font-weight: 700;
  margin-bottom: 1rem;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.info-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1rem;
}

.info-item {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.info-label {
  font-weight: 600;
  color: #495057;
  font-size: 0.875rem;
}

.custom-select {
  position: relative;
}

.selected {
  background: rgba(255, 255, 255, 0.9);
  border: 2px solid #e9ecef;
  border-radius: 8px;
  padding: 0.75rem 1rem;
  cursor: pointer;
  display: flex;
  justify-content: space-between;
  align-items: center;
  transition: all 0.3s ease;
}

.selected:hover {
  border-color: #667eea;
  box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
}

.selected .value {
  color: #2c3e50;
  font-weight: 500;
}

.arrow {
  transition: transform 0.3s ease;
}

.arrow.up {
  transform: rotate(180deg);
}

.arrow::before {
  content: '▼';
  font-size: 0.75rem;
  color: #6c757d;
}

.options {
  position: absolute;
  top: 100%;
  left: 0;
  right: 0;
  background: white;
  border: 2px solid rgba(102, 126, 234, 0.2);
  border-radius: 8px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.15);
  z-index: 1000;
  max-height: 200px;
  overflow-y: auto;
  margin-top: 0.25rem;
}

.option {
  padding: 0.75rem 1rem;
  cursor: pointer;
  transition: background-color 0.2s;
  color: #495057;
}

.option:hover {
  background-color: rgba(102, 126, 234, 0.1);
}

.selected-option {
  background-color: rgba(102, 126, 234, 0.2);
  color: #667eea;
  font-weight: 600;
}

/* 提交状态指示器 */
.submission-indicator {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.5rem;
}

.status-badge {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.75rem 1.5rem;
  border-radius: 25px;
  font-weight: 600;
  font-size: 0.875rem;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
}

.status-badge.status-submitted {
  background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
  color: white;
}

.status-badge.status-not-submitted {
  background: linear-gradient(135deg, #ffc516 0%, #ff9800 100%);
  color: white;
}

.status-detail {
  font-size: 0.75rem;
  color: #6c757d;
  font-weight: 500;
}

/* 审核信息区域 */
.review-section {
  border-top: 1px solid rgba(0, 0, 0, 0.1);
  padding-top: 1.5rem;
}

.monthly-review, .yearly-review {
  margin-top: 1rem;
}

.review-header {
  margin-bottom: 1rem;
}

.month-label {
  font-weight: 600;
  color: #495057;
  font-size: 1rem;
}

.review-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 1.5rem;
}

.review-column {
  background: rgba(248, 249, 250, 0.8);
  border: 1px solid #e9ecef;
  border-radius: 12px;
  padding: 1.25rem;
  transition: all 0.3s ease;
}

.review-column:hover {
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
  transform: translateY(-2px);
}

.review-title {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-weight: 700;
  color: #495057;
  margin-bottom: 1rem;
  font-size: 1rem;
}

.review-title i {
  color: #667eea;
}

.status-display {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
  margin-bottom: 1rem;
}

.status-badge.status-approved {
  background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
  color: white;
}

.status-badge.status-rejected {
  background: linear-gradient(135deg, #dc3545 0%, #e91e63 100%);
  color: white;
}

.status-badge.status-pending {
  background: linear-gradient(135deg, #ffc107 0%, #ff9800 100%);
  color: white;
}

.edit-control {
  margin-top: 0.5rem;
}

.status-select {
  width: 100%;
  padding: 0.5rem;
  border: 2px solid #e9ecef;
  border-radius: 6px;
  background: white;
  color: #495057;
  font-size: 0.875rem;
  transition: border-color 0.3s ease;
}

.status-select:focus {
  outline: none;
  border-color: #667eea;
  box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
}

.comment-display {
  margin-top: 1rem;
}

.comment-label {
  font-size: 0.75rem;
  color: #6c757d;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  margin-bottom: 0.5rem;
}

.comment-text {
  background: rgba(255, 255, 255, 0.8);
  border: 1px solid #e9ecef;
  border-radius: 6px;
  padding: 0.75rem;
  font-size: 0.875rem;
  color: #495057;
  line-height: 1.5;
  min-height: 2.5rem;
}

/* 弹窗样式 */
.modal-overlay {
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

.modal-container {
  background: white;
  border-radius: 16px;
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

.modal-header {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  padding: 1.5rem;
  display: flex;
  justify-content: left;
}

.modal-header h3 {
  margin: 0;
  font-size: 1.5rem;
  font-weight: 600;
}

.modal-body {
  padding: 1.5rem;
}

.comment-section {
  margin-bottom: 1rem;
}

.comment-input {
  width: 100%;
  padding: 0.75rem;
  border: 2px solid #e9ecef;
  border-radius: 8px;
  font-size: 0.875rem;
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
  text-align: right;
  font-size: 0.75rem;
  color: #6c757d;
  margin-top: 0.5rem;
}

.modal-footer {
  background: #f8f9fa;
  padding: 1rem 1.5rem;
  display: flex;
  justify-content: flex-end;
  gap: 1rem;
}

.btn {
  padding: 0.75rem 1.5rem;
  border: none;
  border-radius: 8px;
  font-size: 0.875rem;
  font-weight: 600;
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

/* 深色模式支持 */
.dark-theme .base-info-container {
  background: rgba(45, 55, 72, 0.95);
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.dark-theme .section-title {
  background: linear-gradient(135deg, #e94560 0%, #533483 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.dark-theme .info-label {
  color: #cbd5e0;
}

.dark-theme .selected {
  background: rgba(74, 85, 104, 0.8);
  border-color: #4a5568;
  color: #e2e8f0;
}

.dark-theme .selected:hover {
  border-color: #e94560;
}

.dark-theme .options {
  background: #2d3748;
  border-color: rgba(233, 69, 96, 0.3);
}

.dark-theme .option {
  color: #cbd5e0;
}

.dark-theme .option:hover {
  background-color: rgba(233, 69, 96, 0.2);
}

.dark-theme .selected-option {
  background-color: rgba(233, 69, 96, 0.3);
  color: #e94560;
}

.dark-theme .review-column {
  background: rgba(74, 85, 104, 0.4);
  border-color: #4a5568;
}

.dark-theme .review-title {
  color: #cbd5e0;
}

.dark-theme .review-title i {
  color: #e94560;
}

.dark-theme .status-select {
  background: #4a5568;
  border-color: #718096;
  color: #e2e8f0;
}

.dark-theme .status-select:focus {
  border-color: #e94560;
}

.dark-theme .comment-text {
  background: rgba(74, 85, 104, 0.6);
  border-color: #4a5568;
  color: #cbd5e0;
}

.dark-theme .modal-container {
  background: #2d3748;
  color: #e2e8f0;
}

.dark-theme .modal-header {
  background: linear-gradient(135deg, #e94560 0%, #533483 100%);
}

.dark-theme .comment-input {
  background: #4a5568;
  border-color: #718096;
  color: #e2e8f0;
}

.dark-theme .comment-input:focus {
  border-color: #e94560;
}

.dark-theme .modal-footer {
  background: #4a5568;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .info-header {
    flex-direction: column;
    gap: 1rem;
  }

  .info-grid {
    grid-template-columns: 1fr;
  }

  .review-grid {
    grid-template-columns: 1fr;
  }

  .submission-indicator {
    align-self: stretch;
  }

  .status-badge {
    justify-content: center;
  }
}
</style>
