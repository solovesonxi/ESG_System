<template>
  <div class="modal-overlay" @click="closeModal">
    <div class="modal-container" @click.stop>
      <div class="modal-header">
        <h3>{{ modalTitle }}</h3>
        <button class="close-btn" @click="closeModal">
          <i class="fas fa-times"></i>
        </button>
      </div>

      <div class="modal-content">
        <div class="batch-info">
          <div class="info-item">
            <i class="fas fa-list"></i>
            <span>已选择 <strong>{{ items.length }}</strong> 项数据进行批量{{ actionText }}</span>
          </div>
          <div class="warning-note" v-if="action === 'reject'">
            <i class="fas fa-exclamation-triangle"></i>
            <span>驳回操作将要求相关人员重新提交数据，请谨慎操作</span>
          </div>
        </div>

        <div class="form-section">
          <div class="form-group">
            <label>{{ action === 'approve' ? '审核意见' : '驳回原因' }}：</label>
            <textarea
              v-model="comment"
              :placeholder="placeholderText"
              rows="4"
              maxlength="500"
            ></textarea>
            <div class="char-count">{{ comment.length }}/500</div>
          </div>

          <div class="quick-options" v-if="quickComments.length > 0">
            <label>快速选择：</label>
            <div class="quick-buttons">
              <button
                v-for="quick in quickComments"
                :key="quick"
                class="quick-btn"
                @click="selectQuickComment(quick)"
              >
                {{ quick }}
              </button>
            </div>
          </div>
        </div>

        <div class="preview-section">
          <h4>
            <i class="fas fa-eye"></i>
            影响的数据预览
          </h4>
          <div class="preview-list">
            <div
              v-for="(item, index) in previewItems"
              :key="index"
              class="preview-item"
            >
              <div class="item-info">
                <span class="factory">{{ item.factory }}</span>
                <span class="data-type">{{ item.dataTypeLabel }}</span>
                <span class="period">{{ item.year }}年{{ item.month }}月</span>
              </div>
              <div class="current-status">
                <span class="status-badge" :class="getStatusClass(item.currentStatus)">
                  {{ getStatusText(item.currentStatus) }}
                </span>
              </div>
            </div>
          </div>
        </div>

        <div class="action-section">
          <div class="action-buttons">
            <button class="btn-secondary" @click="closeModal" :disabled="submitting">
              取消
            </button>
            <button
              class="btn-primary"
              :class="action === 'approve' ? 'btn-success' : 'btn-danger'"
              @click="confirmAction"
              :disabled="!comment.trim() || submitting"
            >
              <i class="fas fa-spinner fa-spin" v-if="submitting"></i>
              <i :class="action === 'approve' ? 'fas fa-check' : 'fas fa-times'" v-else></i>
              {{ submitting ? '处理中...' : `确认${actionText}` }}
            </button>
          </div>

          <div class="confirmation-text">
            <i class="fas fa-info-circle"></i>
            确认后将对所选的 {{ items.length }} 项数据执行{{ actionText }}操作，此操作不可撤销
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useAuthStore } from '@/stores/authStore'
import apiClient from '@/utils/axios'

const authStore = useAuthStore()

// Props
const props = defineProps({
  items: {
    type: Array,
    required: true
  },
  action: {
    type: String,
    required: true,
    validator: (value) => ['approve', 'reject'].includes(value)
  }
})

// Emits
const emit = defineEmits(['close', 'confirm'])

// 数据
const comment = ref('')
const submitting = ref(false)
const previewItems = ref([])

// 数据类型映射
const dataTypes = {
  material: '物料消耗',
  energy: '能源消耗',
  water: '水资源',
  waste: '废料管理',
  emission: '排放数据',
  employment: '雇佣数据',
  training: '培训数据',
  ohs: '职业健康安全',
  satisfaction: '员工满意度',
  community: '社区参与',
  supply: '供应链',
  investment: '社会投资',
  responsibility: '产品责任',
  ip: '知识产权',
  governance: '公司治理',
  management: '管理体系'
}

// 计算属性
const modalTitle = computed(() => {
  return `批量${actionText.value}`
})

const actionText = computed(() => {
  return props.action === 'approve' ? '通过' : '驳回'
})

const placeholderText = computed(() => {
  if (props.action === 'approve') {
    return '请输入审核通过的意见（可选）...'
  } else {
    return '请详细说明驳回原因，以便数据提交人员了解问题所在...'
  }
})

const quickComments = computed(() => {
  if (props.action === 'approve') {
    return [
      '数据完整，审核通过',
      '经核实无误，同意通过',
      '符合要求，审核通过'
    ]
  } else {
    return [
      '数据不完整，请补充',
      '数据存在异常，请核实',
      '格式不符合要求',
      '缺少必要的说明文件',
      '数据与实际情况不符'
    ]
  }
})

// 方法
const closeModal = () => {
  if (!submitting.value) {
    emit('close')
  }
}

const fetchPreviewData = async () => {
  try {
    const response = await apiClient.post('/reviews/batch-preview', {
      reviewIds: props.items
    })
    previewItems.value = response.data.map(item => ({
      ...item,
      dataTypeLabel: dataTypes[item.dataType] || item.dataType,
      currentStatus: authStore.isFactory ? item.level1Status : item.level2Status
    }))
  } catch (error) {
    console.error('获取预览数据失败:', error)
    // 如果API不存在，使用模拟数据
    previewItems.value = props.items.map((id, index) => ({
      factory: `工厂${index + 1}`,
      dataType: 'material',
      dataTypeLabel: '物料消耗',
      year: 2024,
      month: index % 12 + 1,
      currentStatus: 'pending'
    }))
  }
}

const selectQuickComment = (quickText) => {
  comment.value = quickText
}

const confirmAction = async () => {
  if (!comment.value.trim()) {
    return
  }

  submitting.value = true

  try {
    await new Promise(resolve => setTimeout(resolve, 500)) // 模拟网络延迟

    emit('confirm', {
      status: props.action === 'approve' ? 'approved' : 'rejected',
      comment: comment.value.trim()
    })
  } catch (error) {
    console.error('批量操作失败:', error)
  } finally {
    submitting.value = false
  }
}

// 工具方法
const getStatusText = (status) => {
  const textMap = {
    pending: '待审核',
    approved: '已通过',
    rejected: '已驳回'
  }
  return textMap[status] || '未知'
}

const getStatusClass = (status) => {
  return `status-${status}`
}

// 生命周期
onMounted(() => {
  fetchPreviewData()

  // 如果是通过操作，设置默认意见
  if (props.action === 'approve') {
    comment.value = '经审核，数据完整准确，审核通过'
  }
})
</script>

<style scoped>
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.7);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 2000;
  backdrop-filter: blur(5px);
}

.modal-container {
  background: linear-gradient(135deg, #1e3c72, #2a5298);
  border-radius: 16px;
  width: 90%;
  max-width: 600px;
  max-height: 90vh;
  overflow: hidden;
  box-shadow: 0 20px 50px rgba(0, 0, 0, 0.5);
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.modal-header h3 {
  color: #fff;
  margin: 0;
  font-size: 1.5rem;
}

.close-btn {
  background: none;
  border: none;
  color: #fff;
  font-size: 1.2rem;
  cursor: pointer;
  padding: 5px;
  border-radius: 50%;
  transition: background 0.3s;
}

.close-btn:hover {
  background: rgba(255, 255, 255, 0.1);
}

.modal-content {
  padding: 20px;
  max-height: 70vh;
  overflow-y: auto;
}

.batch-info {
  margin-bottom: 20px;
}

.info-item {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 12px;
  background: rgba(71, 118, 230, 0.2);
  border-radius: 8px;
  color: #fff;
  margin-bottom: 10px;
}

.info-item i {
  color: #4776E6;
}

.warning-note {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 12px;
  background: rgba(255, 152, 0, 0.2);
  border: 1px solid rgba(255, 152, 0, 0.3);
  border-radius: 8px;
  color: #FF9800;
}

.warning-note i {
  color: #FF9800;
}

.form-section {
  margin-bottom: 20px;
}

.form-group {
  margin-bottom: 15px;
}

.form-group label {
  display: block;
  color: rgba(255, 255, 255, 0.9);
  margin-bottom: 8px;
  font-weight: 500;
}

.form-group textarea {
  width: 100%;
  padding: 12px;
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 8px;
  background: rgba(0, 0, 0, 0.2);
  color: #fff;
  resize: vertical;
  font-family: inherit;
  box-sizing: border-box;
}

.form-group textarea:focus {
  outline: none;
  border-color: #4776E6;
  box-shadow: 0 0 0 2px rgba(71, 118, 230, 0.3);
}

.char-count {
  text-align: right;
  font-size: 0.8rem;
  color: rgba(255, 255, 255, 0.6);
  margin-top: 5px;
}

.quick-options {
  margin-top: 15px;
}

.quick-options label {
  display: block;
  color: rgba(255, 255, 255, 0.9);
  margin-bottom: 8px;
  font-weight: 500;
}

.quick-buttons {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.quick-btn {
  padding: 6px 12px;
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 15px;
  color: rgba(255, 255, 255, 0.8);
  cursor: pointer;
  font-size: 0.9rem;
  transition: all 0.3s;
}

.quick-btn:hover {
  background: rgba(71, 118, 230, 0.3);
  color: #fff;
  border-color: rgba(71, 118, 230, 0.5);
}

.preview-section {
  margin-bottom: 20px;
}

.preview-section h4 {
  color: #fff;
  margin-bottom: 12px;
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 1rem;
}

.preview-list {
  max-height: 200px;
  overflow-y: auto;
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 8px;
  background: rgba(0, 0, 0, 0.1);
}

.preview-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 12px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.05);
}

.preview-item:last-child {
  border-bottom: none;
}

.item-info {
  display: flex;
  align-items: center;
  gap: 12px;
}

.factory {
  color: #fff;
  font-weight: 500;
}

.data-type {
  padding: 2px 6px;
  background: rgba(76, 175, 80, 0.2);
  border-radius: 10px;
  font-size: 0.8rem;
  color: #4CAF50;
}

.period {
  color: rgba(255, 255, 255, 0.7);
  font-size: 0.9rem;
}

.status-badge {
  padding: 2px 8px;
  border-radius: 10px;
  font-size: 0.8rem;
  font-weight: 500;
}

.status-badge.status-pending {
  background: #FFA726;
  color: #fff;
}

.status-badge.status-approved {
  background: #4CAF50;
  color: #fff;
}

.status-badge.status-rejected {
  background: #F44336;
  color: #fff;
}

.action-section {
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  padding-top: 20px;
}

.action-buttons {
  display: flex;
  gap: 12px;
  margin-bottom: 15px;
}

.btn-secondary,
.btn-primary {
  flex: 1;
  padding: 12px 20px;
  border-radius: 8px;
  font-weight: 500;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  transition: all 0.3s;
  border: none;
}

.btn-secondary {
  background: rgba(255, 255, 255, 0.1);
  color: rgba(255, 255, 255, 0.8);
  border: 1px solid rgba(255, 255, 255, 0.2);
}

.btn-secondary:hover:not(:disabled) {
  background: rgba(255, 255, 255, 0.2);
}

.btn-primary.btn-success {
  background: #4CAF50;
  color: #fff;
}

.btn-primary.btn-success:hover:not(:disabled) {
  background: #45a049;
}

.btn-primary.btn-danger {
  background: #F44336;
  color: #fff;
}

.btn-primary.btn-danger:hover:not(:disabled) {
  background: #da190b;
}

.btn-secondary:disabled,
.btn-primary:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.confirmation-text {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 10px;
  background: rgba(255, 193, 7, 0.1);
  border: 1px solid rgba(255, 193, 7, 0.3);
  border-radius: 6px;
  color: #FFC107;
  font-size: 0.9rem;
}

.confirmation-text i {
  color: #FFC107;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .modal-container {
    width: 95%;
    margin: 10px;
  }

  .action-buttons {
    flex-direction: column;
  }

  .quick-buttons {
    flex-direction: column;
  }

  .quick-btn {
    text-align: left;
  }

  .item-info {
    flex-direction: column;
    align-items: flex-start;
    gap: 4px;
  }
}
</style>
