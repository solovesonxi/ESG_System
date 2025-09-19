<template>
  <div class="modal-overlay" @click="closeModal">
    <div class="modal-container" @click.stop>
      <div class="modal-header">
        <h3>审核详情</h3>
        <button class="close-btn" @click="closeModal">
          <i class="fas fa-times"></i>
        </button>
      </div>

      <div class="modal-content">
        <!-- 基本信息 -->
        <div class="info-section">
          <h4>基本信息</h4>
          <div class="info-grid">
            <div class="info-item">
              <label>工厂：</label>
              <span>{{ review.factory }}</span>
            </div>
            <div class="info-item">
              <label>数据类型：</label>
              <span class="data-type-badge" :class="getDataTypeClass(review.dataType)">
                {{ getDataTypeLabel(review.dataType) }}
              </span>
            </div>
            <div class="info-item">
              <label>年月：</label>
              <span>{{ review.year }}年{{ review.month }}月</span>
            </div>
            <div class="info-item">
              <label>提交时间：</label>
              <span>{{ formatDateTime(review.createdAt) }}</span>
            </div>
          </div>
        </div>

        <!-- 审核状态 -->
        <div class="status-section">
          <h4>审核状态</h4>
          <div class="status-flow">
            <div class="status-step" :class="{active: review.level1Status !== 'pending', approved: review.level1Status === 'approved', rejected: review.level1Status === 'rejected'}">
              <div class="step-icon">
                <i class="fas fa-industry"></i>
              </div>
              <div class="step-content">
                <h5>工厂审核</h5>
                <span class="status-badge" :class="getStatusClass(review.level1Status)">
                  {{ getStatusText(review.level1Status) }}
                </span>
                <div v-if="review.level1Reviewer" class="reviewer-info">
                  <small>审核人：{{ review.level1Reviewer }}</small>
                  <small v-if="review.level1ReviewTime">时间：{{ formatDateTime(review.level1ReviewTime) }}</small>
                </div>
                <div v-if="review.level1Comment" class="comment">
                  <small>{{ review.level1Comment }}</small>
                </div>
              </div>
            </div>

            <div class="flow-arrow">
              <i class="fas fa-arrow-right"></i>
            </div>

            <div class="status-step" :class="{active: review.level2Status !== 'pending', approved: review.level2Status === 'approved', rejected: review.level2Status === 'rejected'}">
              <div class="step-icon">
                <i class="fas fa-building"></i>
              </div>
              <div class="step-content">
                <h5>总部审核</h5>
                <span class="status-badge" :class="getStatusClass(review.level2Status)">
                  {{ getStatusText(review.level2Status) }}
                </span>
                <div v-if="review.level2Reviewer" class="reviewer-info">
                  <small>审核人：{{ review.level2Reviewer }}</small>
                  <small v-if="review.level2ReviewTime">时间：{{ formatDateTime(review.level2ReviewTime) }}</small>
                </div>
                <div v-if="review.level2Comment" class="comment">
                  <small>{{ review.level2Comment }}</small>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- 业务数据 -->
        <div class="data-section">
          <div class="data-header">
            <h4>具体数据</h4>
            <button class="view-full-btn" @click="viewFullData">
              <i class="fas fa-external-link-alt"></i>
              查看完整数据页面
            </button>
          </div>

          <div class="data-preview" v-if="businessData">
            <div class="data-summary">
              <div class="summary-item" v-for="(value, key) in getDataSummary()" :key="key">
                <label>{{ key }}：</label>
                <span>{{ value }}</span>
              </div>
            </div>
            <div class="data-note">
              <i class="fas fa-info-circle"></i>
              以上为数据摘要，点击"查看完整数据页面"可查看详细信息
            </div>
          </div>

          <div class="loading" v-else-if="loadingData">
            <i class="fas fa-spinner fa-spin"></i>
            加载数据中...
          </div>
        </div>

        <!-- 审核操作 -->
        <div class="review-actions" v-if="canReview">
          <h4>审核操作</h4>
          <div class="action-form">
            <div class="form-group">
              <label>审核意见：</label>
              <textarea
                v-model="reviewComment"
                placeholder="请输入审核意见..."
                rows="3"
              ></textarea>
            </div>
            <div class="action-buttons">
              <button class="btn-success" @click="submitReview('approved')" :disabled="submitting">
                <i class="fas fa-check"></i>
                {{ submitting && reviewAction === 'approved' ? '提交中...' : '通过' }}
              </button>
              <button class="btn-danger" @click="submitReview('rejected')" :disabled="submitting">
                <i class="fas fa-times"></i>
                {{ submitting && reviewAction === 'rejected' ? '提交中...' : '驳回' }}
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useAuthStore } from '@/stores/authStore'
import { useRouter } from 'vue-router'
import apiClient from '@/utils/axios'
import { showSuccess, showError } from '@/utils/toast'

const authStore = useAuthStore()
const router = useRouter()

// Props
const props = defineProps({
  review: {
    type: Object,
    required: true
  }
})

// Emits
const emit = defineEmits(['close', 'review-action'])

// 数据
const businessData = ref(null)
const loadingData = ref(true)
const reviewComment = ref('')
const submitting = ref(false)
const reviewAction = ref('')

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

// 路由映射
const routeMap = {
  material: '/material',
  energy: '/energy',
  water: '/water',
  waste: '/waste',
  emission: '/emission',
  employment: '/employment',
  training: '/training',
  ohs: '/ohs',
  satisfaction: '/satisfaction',
  community: '/community',
  supply: '/supply',
  investment: '/investment',
  responsibility: '/responsibility',
  ip: '/ip',
  governance: '/governance',
  management: '/management'
}

// 计算属性
const canReview = computed(() => {
  if (authStore.isFactory) {
    return props.review.level1Status === 'pending'
  } else if (authStore.isHeadquarter || authStore.isAdmin) {
    return props.review.level1Status === 'approved' && props.review.level2Status === 'pending'
  }
  return false
})

// 方法
const closeModal = () => {
  emit('close')
}

const fetchBusinessData = async () => {
  try {
    loadingData.value = true
    const response = await apiClient.get(`/data/${props.review.dataType}`, {
      params: {
        factory: props.review.factory,
        year: props.review.year,
        month: props.review.month
      }
    })
    businessData.value = response.data
  } catch (error) {
    console.error('获取业务数据失败:', error)
  } finally {
    loadingData.value = false
  }
}

const getDataSummary = () => {
  if (!businessData.value) return {}

  const data = businessData.value
  const summary = {}

  // 根据不同数据类型生成摘要
  switch (props.review.dataType) {
    case 'material':
      summary['总消耗量'] = `${data.totalConsumption || 0} 吨`
      summary['主要材料'] = data.mainMaterial || '-'
      break
    case 'energy':
      summary['总能耗'] = `${data.totalEnergyConsumption || 0} kWh`
      summary['能耗强度'] = `${data.energyConsumptionIntensity || 0} kWh/万元`
      break
    case 'water':
      summary['总用水量'] = `${data.totalWaterConsumption || 0} 立方米`
      summary['循环利用率'] = `${data.recyclingRate || 0}%`
      break
    default:
      // 通用摘要
      Object.keys(data).slice(0, 3).forEach(key => {
        if (typeof data[key] === 'number') {
          summary[key] = data[key]
        }
      })
  }

  return summary
}

const submitReview = async (action) => {
  if (!reviewComment.value.trim()) {
    showError('请输入审核意见')
    return
  }

  try {
    submitting.value = true
    reviewAction.value = action

    const level = authStore.isFactory ? 1 : 2
    await apiClient.post(`/reviews/${props.review.id}/review`, {
      level,
      status: action,
      comment: reviewComment.value.trim()
    })

    showSuccess(action === 'approved' ? '审核通过' : '审核驳回')
    emit('review-action', { action, comment: reviewComment.value })
    closeModal()
  } catch (error) {
    showError('审核失败')
  } finally {
    submitting.value = false
    reviewAction.value = ''
  }
}

const viewFullData = () => {
  const route = routeMap[props.review.dataType]
  if (route) {
    // 在新标签页中打开完整数据页面
    const url = router.resolve({
      path: route,
      query: {
        factory: props.review.factory,
        year: props.review.year,
        month: props.review.month
      }
    })
    window.open(url.href, '_blank')
  }
}

// 工具方法
const getDataTypeLabel = (type) => {
  return dataTypes[type] || type
}

const getDataTypeClass = (type) => {
  const classMap = {
    material: 'material',
    energy: 'energy',
    water: 'water',
    waste: 'waste',
    emission: 'emission'
  }
  return classMap[type] || 'default'
}

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

const formatDateTime = (dateStr) => {
  if (!dateStr) return '-'
  const date = new Date(dateStr)
  return date.toLocaleString('zh-CN')
}

// 生命周期
onMounted(() => {
  fetchBusinessData()
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
  max-width: 800px;
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

.info-section,
.status-section,
.data-section,
.review-actions {
  margin-bottom: 25px;
}

.info-section h4,
.status-section h4,
.data-section h4,
.review-actions h4 {
  color: #fff;
  margin-bottom: 15px;
  font-size: 1.1rem;
  border-bottom: 1px solid rgba(255, 255, 255, 0.2);
  padding-bottom: 8px;
}

.info-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 15px;
}

.info-item {
  display: flex;
  align-items: center;
  gap: 8px;
}

.info-item label {
  color: rgba(255, 255, 255, 0.8);
  font-weight: 500;
}

.info-item span {
  color: #fff;
}

.data-type-badge {
  padding: 4px 8px;
  border-radius: 12px;
  font-size: 0.8rem;
  font-weight: 500;
  color: #fff;
}

.data-type-badge.material { background: #FF6B35; }
.data-type-badge.energy { background: #4ECDC4; }
.data-type-badge.water { background: #45B7D1; }
.data-type-badge.waste { background: #FFA07A; }
.data-type-badge.emission { background: #98D8C8; }
.data-type-badge.default { background: #999; }

.status-flow {
  display: flex;
  align-items: center;
  gap: 20px;
}

.status-step {
  flex: 1;
  display: flex;
  align-items: center;
  gap: 15px;
  padding: 15px;
  background: rgba(255, 255, 255, 0.05);
  border-radius: 12px;
  transition: all 0.3s;
}

.status-step.active {
  background: rgba(255, 255, 255, 0.1);
}

.status-step.approved {
  background: rgba(76, 175, 80, 0.2);
  border: 1px solid rgba(76, 175, 80, 0.3);
}

.status-step.rejected {
  background: rgba(244, 67, 54, 0.2);
  border: 1px solid rgba(244, 67, 54, 0.3);
}

.step-icon {
  font-size: 1.5rem;
  color: rgba(255, 255, 255, 0.6);
}

.status-step.active .step-icon {
  color: #fff;
}

.step-content h5 {
  margin: 0 0 5px 0;
  color: #fff;
  font-size: 1rem;
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

.reviewer-info {
  margin-top: 5px;
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.reviewer-info small {
  color: rgba(255, 255, 255, 0.7);
  font-size: 0.75rem;
}

.comment {
  margin-top: 5px;
  padding: 5px 8px;
  background: rgba(0, 0, 0, 0.2);
  border-radius: 6px;
}

.comment small {
  color: rgba(255, 255, 255, 0.9);
  font-style: italic;
}

.flow-arrow {
  color: rgba(255, 255, 255, 0.5);
  font-size: 1.2rem;
}

.data-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
}

.view-full-btn {
  background: rgba(71, 118, 230, 0.3);
  color: #4776E6;
  border: 1px solid rgba(71, 118, 230, 0.4);
  padding: 6px 12px;
  border-radius: 6px;
  cursor: pointer;
  font-size: 0.9rem;
  transition: all 0.3s;
}

.view-full-btn:hover {
  background: rgba(71, 118, 230, 0.4);
  color: #fff;
}

.data-summary {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
  gap: 10px;
  margin-bottom: 10px;
}

.summary-item {
  display: flex;
  justify-content: space-between;
  padding: 8px 12px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 8px;
}

.summary-item label {
  color: rgba(255, 255, 255, 0.8);
  font-size: 0.9rem;
}

.summary-item span {
  color: #fff;
  font-weight: 500;
}

.data-note {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 10px;
  background: rgba(255, 193, 7, 0.1);
  border: 1px solid rgba(255, 193, 7, 0.3);
  border-radius: 8px;
  color: #FFC107;
  font-size: 0.9rem;
}

.loading {
  text-align: center;
  padding: 20px;
  color: rgba(255, 255, 255, 0.8);
}

.action-form {
  background: rgba(255, 255, 255, 0.05);
  padding: 15px;
  border-radius: 12px;
}

.form-group {
  margin-bottom: 15px;
}

.form-group label {
  display: block;
  color: rgba(255, 255, 255, 0.8);
  margin-bottom: 5px;
}

.form-group textarea {
  width: 100%;
  padding: 10px;
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 8px;
  background: rgba(0, 0, 0, 0.2);
  color: #fff;
  resize: vertical;
  min-height: 80px;
}

.form-group textarea:focus {
  outline: none;
  border-color: #4776E6;
  box-shadow: 0 0 0 2px rgba(71, 118, 230, 0.3);
}

.action-buttons {
  display: flex;
  gap: 10px;
}

.btn-success,
.btn-danger {
  flex: 1;
  padding: 10px 20px;
  border: none;
  border-radius: 8px;
  color: #fff;
  font-weight: 500;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 5px;
  transition: all 0.3s;
}

.btn-success {
  background: #4CAF50;
}

.btn-success:hover {
  background: #45a049;
}

.btn-danger {
  background: #F44336;
}

.btn-danger:hover {
  background: #da190b;
}

.btn-success:disabled,
.btn-danger:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .modal-container {
    width: 95%;
    margin: 10px;
  }

  .status-flow {
    flex-direction: column;
    gap: 10px;
  }

  .flow-arrow {
    transform: rotate(90deg);
  }

  .action-buttons {
    flex-direction: column;
  }
}
</style>
