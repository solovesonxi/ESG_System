<template>
  <div class="dashboard">
    <!-- 权限错误提示 -->
    <div v-if="permissionError" class="permission-error-banner">
      <div class="error-content">
        <i class="fas fa-exclamation-triangle"></i>
        <div class="error-text">
          <h4>访问受限</h4>
          <p>{{ permissionErrorMessage }}</p>
        </div>
        <button class="close-error-btn" @click="dismissError">
          <i class="fas fa-times"></i>
        </button>
      </div>
    </div>

    <!-- 页面顶部区域 -->
    <div class="top-section">
      <div class="theme-toggle">
        <label class="theme-label">☀️</label>
        <input type="checkbox" v-model="isDark" @click="toggleTheme" class="theme-switch"/>
        <label class="theme-label">🌙</label>
      </div>
      <div class="welcome-section">
        <h1 class="welcome-text">欢迎回来, {{ authStore.user?.username }}!</h1>
        <div class="user-role-badge">
          <i class="fas fa-user-shield"></i>
          <span>{{ getRoleDisplayName() }}</span>
        </div>
      </div>
      <div class="user-info-section">
        <div class="current-time">{{ currentTime }}</div>
        <div class="online-status">
          <div class="status-dot"></div>
          <span>在线</span>
        </div>
      </div>
    </div>

    <!-- 部门权限卡片 -->
    <div v-if="authStore.isDepartment && authStore.departments.length > 0" class="department-permissions-wrapper">
      <div class="department-info-card modern">
        <div class="card-content">
          <div class="permission-header">
            <div class="header-left">
              <div class="permission-icon">
                <i class="fas fa-shield-check"></i>
              </div>
              <div class="permission-title">
                <h3>您的访问权限</h3>
                <p>您可以管理以下 {{ authStore.departments.length }} 个部门的数据</p>
              </div>
            </div>
          </div>

          <div class="departments-container">
            <div class="department-grid">
              <div
                  v-for="dept in departmentList"
                  :key="dept.value"
                  class="department-item"
                  :class="dept.class"
                  @click="navigateToDepartment(dept.value)"
              >
                <div class="dept-icon">
                  <i :class="getDepartmentIcon(dept.value)"></i>
                </div>
                <div class="dept-info">
                  <span class="dept-name">{{ dept.label }}</span>
                  <span class="dept-status">可访问</span>
                </div>
                <div class="dept-arrow">
                  <i class="fas fa-chevron-right"></i>
                </div>
              </div>
            </div>
          </div>

          <div class="permission-footer">
            <div class="permission-stats">
              <span class="stat-item">
                <i class="fas fa-database"></i>
                {{ authStore.departments.length }} 个部门
              </span>
              <span class="stat-item">
                <i class="fas fa-calendar"></i>
                {{ '月度填报' }}
              </span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 主内容区（填报进度、系统通知、最近操作） -->
    <div class="main-layout">
      <div class="main-half">
        <div style="display: flex; flex-direction: row; align-items: center; justify-content: space-between;">
          <h2 style="margin: 0;">{{ authStore.isDataMode ? '月度填报' : '年度分析' }}进度</h2>
          <div style="display: flex; align-items: center; gap: 1rem;">
            <div class="small-select" v-if="authStore.isHeadquarter || authStore.isAdmin">
              <div class="selected" @click="selectionStore.toggleFactoryDropdown()">
                {{ selectionStore.selectedFactory }}
                <i class="arrow" :class="{ 'up': selectionStore.showFactoryDropdown }"></i>
              </div>
              <div class="options" v-show="selectionStore.showFactoryDropdown"
                   :style="{ maxHeight: '200px', overflowY: 'auto' }">
                <div v-for="factory in selectionStore.factories" :key="factory" class="option"
                     :class="{ 'selected-option': factory === selectionStore.selectedFactory }"
                     @click="selectionStore.selectFactory(factory)">
                  {{ factory }}
                </div>
              </div>
            </div>
            <div class="small-select">
              <div class="selected" @click="selectionStore.toggleYearDropdown()">
                {{ selectionStore.selectedYear }}年
                <i class="arrow" :class="{ 'up': selectionStore.showYearDropdown }"></i>
              </div>
              <div class="options" v-show="selectionStore.showYearDropdown">
                <div v-for="year in selectionStore.years" :key="year" class="option"
                     :class="{ 'selected-option': year === selectionStore.selectedYear }"
                     @click="selectionStore.selectYear(year)">
                  {{ year }}年
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="progress-list">
          <div class="progress-card" v-for="item in currentProgressData" :key="item.title">
            <div class="progress-title">{{ item.title }}</div>
            <div class="progress-bar-bg">
              <div class="progress-bar" :style="{ width: item.percent + '%' }"></div>
            </div>
            <div class="progress-percent">{{ item.percent }}%</div>
          </div>
        </div>
      </div>
      <div class="main-half">
        <!-- 系统通知区 -->
        <div class="message-section">
          <div class="section-header">
            <h2>系统通知</h2>
            <div class="message-actions">
              <span v-if="unreadCount > 0" class="unread-badge">{{ unreadCount }}</span>
              <button class="view-all-btn" @click="showAllMessagesModal = true">查看全部</button>
            </div>
          </div>
          <div class="message-preview">
            <div v-if="notifications.length === 0" class="empty-message">暂无通知</div>
            <div v-for="msg in previewMessages" :key="msg.id" class="message-card"
                 :class="{ unread: !msg.is_read }" @click="openMessageDetail(msg)">
              <div class="message-header">
                <span class="message-type" :class="getMessageTypeClass(msg.type)">{{ msg.type }}</span>
                <span v-if="!msg.is_read" class="red-dot"></span>
              </div>
              <span class="message-title">{{ msg.title }}</span>
              <span class="message-date">{{ formatDate(msg.created_at) }}</span>
            </div>
          </div>
        </div>

        <!-- 最近操作区 -->
        <div class="message-section">
          <div class="section-header">
            <h2>最近操作</h2>
            <div class="message-actions">
              <button class="view-all-btn" @click="showAllHistoryModal = true">查看全部</button>
            </div>
          </div>
          <div class="message-preview">
            <div v-if="operations.length === 0" class="empty-message">暂无操作记录</div>
            <div v-for="record in previewHistory" :key="record.id" class="message-card" :class="{ unread: false }">
              <span class="message-title">{{ record.title }}</span>
              <span class="message-date">{{ record.date }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 弹窗：查看所有通知 -->
    <div v-if="showAllMessagesModal" class="modal-mask" @click.self="closeAllModals">
      <div class="modal-container list-modal">
        <div class="modal-header">
          <h3>所有系统通知</h3>
          <div v-if="!isSelectMode" class="header-actions">
            <button v-if="!isSelectMode" class="action-btn" @click="markAllAsRead"
                    :disabled="unreadCount === 0">一键已读
            </button>
            <button v-if="!isSelectMode" class="action-btn" @click="deleteReadMessages"
                    :disabled="readMessagesCount === 0">删除已读
            </button>
            <button v-if="!isSelectMode" class="action-btn" @click="enterSelectMode"
                    :disabled="notifications.length === 0">批量删除
            </button>
          </div>
          <div v-else class="header-actions">
            <div class="selection-buttons">
              <button class="action-btn" @click="exitSelectMode">取消
              </button>
              <button class="confirm-delete-btn" @click="confirmBatchDelete"
                      :disabled="!hasSelectedNotifications">删除选中 ({{ selectedNotifications.size }})
              </button>
            </div>
            <div class="select-all-container" @click="toggleAllNotifications">
              <span class="select-all-text">全选</span>
              <div class="custom-checkbox" :class="{ checked: allNotificationsSelected }">
                <i class="icon-check" v-if="allNotificationsSelected"></i>
              </div>
            </div>
          </div>
          <button class="modal-close" @click="closeAllModals">×</button>
        </div>
        <div class="modal-content list-content">
          <div v-if="notifications.length === 0" class="empty-list">暂无消息通知</div>
          <div v-else class="message-list">
            <div v-for="msg in notifications" :key="msg.id" class="list-item" @click="handleNotificationItemClick(msg)"
                 :class="{ unread: !msg.is_read, selected: selectedNotifications.has(msg.id) }">
              <div v-if="isSelectMode" class="item-checkbox">
                <div class="custom-checkbox" :class="{ checked: selectedNotifications.has(msg.id) }">
                  <i class="icon-check" v-if="selectedNotifications.has(msg.id)">✓</i>
                </div>
              </div>
              <div class="list-item-content">
                <div class="item-header">
                  <span class="message-type" :class="getMessageTypeClass(msg.type)">{{ msg.type }}</span>
                  <span v-if="!msg.is_read" class="red-dot"></span>
                </div>
                <div class="item-content">
                  <span class="item-title">{{ msg.title }}</span>
                  <span class="item-date">{{ formatDate(msg.created_at) }}</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 弹窗：查看所有操作记录 -->
    <div v-if="showAllHistoryModal" class="modal-mask" @click.self="closeAllModals">
      <div class="modal-container list-modal">
        <div class="modal-header">
          <h3>所有操作记录</h3>
          <div v-if="!isOperationSelectMode" class="header-actions">
            <button class="action-btn clear-all-btn" @click="confirmClearAllOperations"
                    :disabled="operations.length === 0">
              一键清空
            </button>
            <button class="action-btn" @click="enterOperationSelectMode"
                    :disabled="operations.length === 0">
              批量删除
            </button>
          </div>
          <div v-else class="header-actions">
            <div class="select-all-container" @click="toggleAllOperations">
              <span class="select-all-text">全选</span>
              <div class="custom-checkbox" :class="{ checked: allOperationsSelected }">
                <i class="icon-check" v-if="allOperationsSelected"></i>
              </div>
            </div>
            <div class="selection-buttons">
              <button class="action-btn action-btn" @click="exitOperationSelectMode">
                取消
              </button>
              <button class="action-btn confirm-delete-btn" @click="confirmBatchDeleteOperations"
                      :disabled="!hasSelectedOperations">
                删除选中 ({{ selectedOperations.size }})
              </button>
            </div>
          </div>
          <button class="modal-close" @click="closeAllModals">×</button>
        </div>
        <div class="modal-content list-content">
          <div v-if="operations.length === 0" class="empty-list">暂无操作记录</div>
          <div v-else class="message-list">
            <div v-for="record in operations" :key="record.id" class="list-item"
                 :class="{ selected: selectedOperations.has(record.id), 'select-mode': isOperationSelectMode }"
                 @click="handleOperationItemClick(record.id)">
              <div v-if="isOperationSelectMode" class="item-checkbox">
                <div class="custom-checkbox" :class="{ checked: selectedOperations.has(record.id) }">
                  <i class="icon-check" v-if="selectedOperations.has(record.id)">✓</i>
                </div>
              </div>
              <div class="item-content">
                <span class="item-title">{{ record.title }}</span>
                <span class="item-date">{{ record.date }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 弹窗：系统通知详情 -->
    <div v-if="showMessageModal" class="modal-mask" @click.self="closeDetailModal">
      <div class="modal-container detail-modal">
        <div class="modal-header">
          <h3>{{ currentMessage?.title }}</h3>
          <button class="modal-close" @click="closeDetailModal">×</button>
        </div>
        <div class="modal-content detail-content">
          <div class="message-meta">
            <span class="message-type" :class="getMessageTypeClass(currentMessage?.type)">{{
                currentMessage?.type
              }}</span>
            <span class="message-date">{{ formatDate(currentMessage?.created_at) }}</span>
          </div>
          <div class="message-body">
            {{ currentMessage?.content }}
          </div>
        </div>
      </div>
    </div>

    <!-- 弹窗：删除确认 -->
    <div v-if="showDeleteConfirmModal" class="modal-mask" @click.self="closeDeleteConfirm">
      <div class="modal-container detail-modal">
        <div class="modal-header">
          <h3>确认删除</h3>
          <button class="modal-close" @click="closeDeleteConfirm">×</button>
        </div>
        <div class="modal-content detail-content">
          <div class="confirm-message">
            <p v-if="deleteMode === 'read'">确定要删除所有已读消息吗？共 {{ readMessagesCount }} 条消息将被删除。</p>
            <p v-else-if="deleteMode === 'batch'">确定要删除选中的系统通知吗？共 {{ selectedNotifications.size }}
              条消息将被删除。</p>
            <p v-else-if="deleteMode === 'batch-operations'">确定要删除选中的操作记录吗？共 {{ selectedOperations.size }}
              条记录将被删除。</p>
            <p v-else-if="deleteMode === 'clear-all'">确定要清空所有操作记录吗？共 {{ operations.length }}
              条记录将被删除。</p>
            <p class="warning-text">此操作不可撤销！</p>
          </div>
        </div>
        <button class="delete-btn" @click="executeDelete">确认删除</button>
      </div>
    </div>
  </div>
</template>

<script setup>
import {useAuthStore} from '@/stores/authStore';
import {useRouter} from 'vue-router';
import {computed, onMounted, ref, watch} from 'vue';
import axios from '@/utils/axios';
import {useSelectionStore} from "@/stores/selectionStore.js";

const authStore = useAuthStore();
const selectionStore = useSelectionStore();
const router = useRouter();

// 权限错误相关
const permissionError = ref(false);
const permissionErrorMessage = ref('');

// 部门类型映射
const departmentTypeMap = {
  'material': {label: '物料', class: 'dept-material'},
  'energy': {label: '能源', class: 'dept-energy'},
  'water': {label: '水资源', class: 'dept-water'},
  'waste': {label: '废弃物', class: 'dept-waste'},
  'emission': {label: '排放', class: 'dept-emission'},
  'investment': {label: '资金投入', class: 'dept-investment'},
  'management': {label: '环境管理', class: 'dept-management'},
  'employment': {label: '雇佣', class: 'dept-employment'},
  'training': {label: '教育与培训', class: 'dept-training'},
  'ohs': {label: '职健与安全', class: 'dept-ohs'},
  'satisfaction': {label: '员工满意度', class: 'dept-satisfaction'},
  'supply': {label: '供应链', class: 'dept-supply'},
  'responsibility': {label: '产品责任', class: 'dept-responsibility'},
  'ip': {label: '知识产权', class: 'dept-ip'},
  'community': {label: '社区参与与志愿活动', class: 'dept-community'},
  'governance': {label: '治理', class: 'dept-governance'}
};

// 部门权限列表
const departmentList = computed(() => {
  return authStore.departments.map(dept => {
    const map = departmentTypeMap[dept] || {label: dept, class: 'dept-default'}
    return {value: dept, label: map.label, class: map.class}
  })
})


// 检查URL参数中的错误信息
const checkPermissionErrors = () => {
  const urlParams = new URLSearchParams(window.location.search);
  if (urlParams.get('error') === 'no_permission') {
    permissionError.value = true;
    permissionErrorMessage.value = '您没有权限访问该页面，只能访问您负责的部门数据。';
  } else if (urlParams.get('error') === 'no_review_permission') {
    permissionError.value = true;
    permissionErrorMessage.value = '您没有审核权限，无法访问审核管理页面。';
  }
};

// 关闭权限错误提示
const dismissError = () => {
  permissionError.value = false;
  // 清除URL参数
  const url = new URL(window.location);
  url.searchParams.delete('error');
  window.history.replaceState({}, '', url);
};

// 系统通知相关
const notifications = ref([]);
const operations = ref([]);
const unreadCount = computed(() => notifications.value.filter(m => !m.is_read).length);
const readMessagesCount = computed(() => notifications.value.filter(m => m.is_read).length);
const previewMessages = computed(() => notifications.value.slice(0, 4));
const previewHistory = computed(() => operations.value.slice(0, 4));

// 批量选择相关
const selectedNotifications = ref(new Set());
const selectedOperations = ref(new Set());
const isSelectMode = ref(false);
const isOperationSelectMode = ref(false);
const currentTime = ref('')

// 计算属性
const allNotificationsSelected = computed(() =>
    notifications.value.length > 0 && selectedNotifications.value.size === notifications.value.length
);
const allOperationsSelected = computed(() =>
    operations.value.length > 0 && selectedOperations.value.size === operations.value.length
);
const hasSelectedNotifications = computed(() => selectedNotifications.value.size > 0);
const hasSelectedOperations = computed(() => selectedOperations.value.size > 0);

// 进度数据
const analyticalProgressData = ref([]);
const quantitativeProgressData = ref([]);
const currentProgressData = computed(() =>
    authStore.isDataMode ? quantitativeProgressData.value : analyticalProgressData.value
);

// 弹窗状态
const showMessageModal = ref(false);
const currentMessage = ref(null);
const isDark = ref(null);
const showAllMessagesModal = ref(false);
const showAllHistoryModal = ref(false);
const showDeleteConfirmModal = ref(false);
const deleteMode = ref('');

// 通知相关函数
const fetchMessages = async () => {
  try {
    const response = await axios.get('/messages/get');
    const data = response.data;
    notifications.value = data.notifications.map(msg => ({
      ...msg,
      is_read: msg.is_read !== undefined ? msg.is_read : false
    }));
    operations.value = data.operations.map((msg) => ({
      id: msg.id,
      title: msg.title,
      date: formatDate(msg.created_at)
    }));

  } catch (error) {
    console.error('获取通知失败:', error);
    notifications.value = [];
    operations.value = [];
  }
};

const openMessageDetail = (msg) => {
  currentMessage.value = msg;
  showMessageModal.value = true;
  if (!msg.is_read) {
    msg.is_read = true;
    markMessageAsRead(msg.id);
  }
};

const closeAllModals = () => {
  showAllMessagesModal.value = false;
  showAllHistoryModal.value = false;
};

const closeDetailModal = () => {
  showMessageModal.value = false;
};

const closeDeleteConfirm = () => {
  showDeleteConfirmModal.value = false;
};

const markMessageAsRead = async (messageId) => {
  try {
    await axios.patch(`/messages/read`, messageId);
  } catch (error) {
    console.error('标记通知为已读失败:', error);
  }
};

const markAllAsRead = async () => {
  try {
    await axios.patch('/messages/read-all');
    notifications.value.forEach(msg => msg.is_read = true);
  } catch (error) {
    console.error('标记所有通知为已读失败:', error);
  }
};

const deleteReadMessages = () => {
  deleteMode.value = 'read';
  showDeleteConfirmModal.value = true;
};

const executeDelete = async () => {
  try {
    if (deleteMode.value === 'read') {
      const readMessageIds = notifications.value.filter(msg => msg.is_read).map(msg => msg.id);
      await axios.delete('/messages/batch-delete', {data: readMessageIds});
      notifications.value = notifications.value.filter(msg => !msg.is_read);
    } else if (deleteMode.value === 'batch') {
      const selectedIds = Array.from(selectedNotifications.value);
      await axios.delete('/messages/batch-delete', {data: selectedIds});
      notifications.value = notifications.value.filter(msg => !selectedIds.includes(msg.id));
      exitSelectMode();
    } else if (deleteMode.value === 'batch-operations') {
      const selectedIds = Array.from(selectedOperations.value);
      await axios.delete('/messages/batch-delete', {data: selectedIds});
      operations.value = operations.value.filter(op => !selectedIds.includes(op.id));
      exitOperationSelectMode();
    } else if (deleteMode.value === 'clear-all') {
      await axios.delete('/messages/clear-all');
      operations.value = [];
      exitOperationSelectMode();
    }
    closeDeleteConfirm();
  } catch (error) {
    console.error('删除失败:', error);
  }
};

// 工具函数
const formatDate = (dateString) => {
  if (!dateString) return '';
  const date = new Date(dateString);
  return date.toLocaleString('zh-CN', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit'
  });
};

// 批量删除相关
const enterSelectMode = () => {
  isSelectMode.value = true;
  selectedNotifications.value = new Set();
};

const exitSelectMode = () => {
  isSelectMode.value = false;
  selectedNotifications.value.clear();
};

const toggleNotificationSelection = (id) => {
  if (selectedNotifications.value.has(id)) {
    selectedNotifications.value.delete(id);
  } else {
    selectedNotifications.value.add(id);
  }
};

const toggleAllNotifications = () => {
  if (allNotificationsSelected.value) {
    selectedNotifications.value.clear();
  } else {
    notifications.value.forEach(msg => selectedNotifications.value.add(msg.id));
  }
};

const confirmBatchDelete = () => {
  showDeleteConfirmModal.value = true;
  deleteMode.value = 'batch';
};

const getMessageTypeClass = (type) => {
  const typeMap = {
    '系统更新': 'system',
    '月报': 'monthly',
    '年报': 'yearly',
    '通知': 'notification',
    '警告': 'warning',
    '更新': 'update'
  };
  return typeMap[type] || 'default';
};

const toggleTheme = () => {
  isDark.value = !isDark.value;
  document.body.classList.toggle('dark-theme', isDark.value);
  localStorage.setItem('darkMode', JSON.stringify(isDark.value));
};

// 操作记录批量选择相关
const enterOperationSelectMode = () => {
  isOperationSelectMode.value = true;
  selectedOperations.value = new Set();
};

const exitOperationSelectMode = () => {
  isOperationSelectMode.value = false;
  selectedOperations.value.clear();
};

const toggleOperationSelection = (id) => {
  if (selectedOperations.value.has(id)) {
    selectedOperations.value.delete(id);
  } else {
    selectedOperations.value.add(id);
  }
};

const toggleAllOperations = () => {
  if (allOperationsSelected.value) {
    selectedOperations.value.clear();
  } else {
    operations.value.forEach(op => selectedOperations.value.add(op.id));
  }
};

const handleNotificationItemClick = (msg) => {
  if (isSelectMode.value) {
    toggleNotificationSelection(msg.id);
  } else {
    openMessageDetail(msg)
  }
};
const handleOperationItemClick = (id) => {
  if (isOperationSelectMode.value) {
    toggleOperationSelection(id);
  }
};

const confirmBatchDeleteOperations = () => {
  showDeleteConfirmModal.value = true;
  deleteMode.value = 'batch-operations';
};

const confirmClearAllOperations = () => {
  showDeleteConfirmModal.value = true;
  deleteMode.value = 'clear-all';
};
const initTheme = () => {
  const savedTheme = localStorage.getItem('darkMode');
  if (savedTheme !== null) {
    isDark.value = JSON.parse(savedTheme);
  } else {
    isDark.value = window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches;
  }
  document.body.classList.toggle('dark-theme', isDark.value);
};

// 获取定量进度数据
const fetchProgress = async () => {
  try {
    const factory = selectionStore.selectedFactory;
    const year = selectionStore.selectedYear;
    const response1 = await axios.get(`/progress/quantitative?factory=${factory}&year=${year}`);
    const response2 = await axios.get(`/progress/analytical?factory=${factory}&year=${year}`);
    const data1 = response1.data;
    const data2 = response2.data;
    let quantData = [
      {key: 'material', title: '物料', percent: data1.material || 0},
      {key: 'energy', title: '能源', percent: data1.energy || 0},
      {key: 'water', title: '水资源', percent: data1.water || 0},
      {key: 'emission', title: '排放', percent: data1.emission || 0},
      {key: 'waste', title: '废弃物', percent: data1.waste || 0},
      {key: 'investment', title: '资金投入', percent: data1.investment || 0},
      {key: 'management', title: '环境管理', percent: data1.management || 0},
      {key: 'employment', title: '雇佣', percent: data1.employment || 0},
      {key: 'training', title: '教育与培训', percent: data1.training || 0},
      {key: 'ohs', title: '职健与安全', percent: data1.ohs || 0},
      {key: 'satisfaction', title: '员工满意度', percent: data1.satisfaction || 0},
      {key: 'supply', title: '供应链', percent: data1.supply || 0},
      {key: 'responsibility', title: '产品责任', percent: data1.responsibility || 0},
      {key: 'ip', title: '知识产权', percent: data1.ip || 0},
      {key: 'community', title: '社区参与与志愿活动', percent: data1.community || 0},
    ];
    if (authStore.isDepartment && Array.isArray(authStore.departments) && authStore.departments.length > 0) {
      quantData = quantData.filter(item => authStore.departments.includes(item.key));
    }
    quantitativeProgressData.value = quantData;
    analyticalProgressData.value = [
      {title: '环境定量', percent: data2.env_quant || 0},
      {title: '环境定性', percent: data2.env_qual || 0},
      {title: '社会定量-劳工', percent: data2.social_quant_labor || 0},
      {title: '社会定性-劳工', percent: data2.social_qual_labor || 0},
      {title: '社会定量-其他', percent: data2.social_quant_other || 0},
      {title: '社会定性-其他', percent: data2.social_qual_other || 0},
      {title: '治理定性', percent: data2.governance || 0},
      {title: '总进度', percent: data2.total || 0},
    ];
  } catch (error) {
    console.error('获取进度数据失败:', error);
  }
};
// 获取角色显示名称
const getRoleDisplayName = () => {
  const roleMap = {
    'department': '部门管理员',
    'factory': '工厂管理员',
    'headquarter': '总部管理员',
    'admin': '系统管理员'
  }
  return roleMap[authStore.user?.role] || '用户'
}

// 获取部门图标
const getDepartmentIcon = (deptType) => {
  const iconMap = {
    'material': 'fas fa-boxes',
    'energy': 'fas fa-bolt',
    'water': 'fas fa-tint',
    'waste': 'fas fa-trash',
    'emission': 'fas fa-smog',
    'investment': 'fas fa-coins',
    'management': 'fas fa-cogs',
    'employment': 'fas fa-users',
    'training': 'fas fa-graduation-cap',
    'ohs': 'fas fa-shield-alt',
    'satisfaction': 'fas fa-smile',
    'supply': 'fas fa-truck',
    'responsibility': 'fas fa-handshake',
    'ip': 'fas fa-copyright',
    'community': 'fas fa-heart',
    'governance': 'fas fa-balance-scale'
  }
  return iconMap[deptType] || 'fas fa-folder'
}

// 导航到部门
const navigateToDepartment = (deptType) => {
  // 这里可以添加导航逻辑
  console.log('导航到部门:', deptType)
  router.push(`/${deptType}`)
}

// 更新时间
const updateTime = () => {
  const now = new Date()
  currentTime.value = now.toLocaleString('zh-CN', {
    hour: '2-digit',
    minute: '2-digit',
    month: 'short',
    day: 'numeric'
  })
}

// 在 onMounted 中添加
onMounted(() => {
  initTheme();
  fetchProgress();
  fetchMessages();
  checkPermissionErrors();
  updateTime()
  setInterval(updateTime, 60000) // 每分钟更新一次
});

// 监听年份变化，更新进度数据
watch(() => selectionStore.selectedYear, (newYear, oldYear) => {
  if (newYear !== oldYear) {
    fetchProgress();
  }
});

// 监听工厂变化，管理员或总部账号时也更新进度数据
watch(() => selectionStore.selectedFactory, (newFactory, oldFactory) => {
  if ((authStore.isHeadquarter || authStore.isAdmin) && newFactory !== oldFactory) {
    fetchProgress();
  }
});
</script>

<style scoped>
.dashboard {
  padding: 3rem;
  color: #222;
  background: linear-gradient(120deg, #f8d3d3 0%, #b6e1ee 50%, #d1da79 100%);
  background-size: 300% 300%;
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  animation: gradientFlow 8s ease infinite;
  position: relative;
  overflow: hidden;
}

/* 页面顶部区域 */
.top-section {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 2rem;
  padding: 0 1rem;
  position: relative;
}

.theme-toggle {
  position: static; /* 移除绝对定位 */
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.75rem 1rem;
  background: rgba(255, 255, 255, 0.9);
  border-radius: 25px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.3);
}

.theme-label {
  font-size: 1.2rem;
  transition: all 0.3s ease;
}

.theme-switch {
  width: 45px;
  height: 22px;
  appearance: none;
  background: #ddd;
  border-radius: 11px;
  position: relative;
  outline: none;
  cursor: pointer !important;
  transition: all 0.3s ease;
}

.theme-switch:before {
  content: '';
  position: absolute;
  top: 2px;
  left: 2px;
  width: 18px;
  height: 18px;
  background: #fff;
  border-radius: 50%;
  transition: transform 0.3s ease;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
}

.theme-switch:checked {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.theme-switch:checked:before {
  transform: translateX(23px);
}

/* 欢迎区域 */
.welcome-section {
  text-align: center;
  flex: 1;
  max-width: 500px;
  margin: 0 2rem;
}

.welcome-text {
  font-size: 2.2rem;
  margin: 0 0 0.5rem 0;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  font-weight: 700;
}

.user-role-badge {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.5rem 1rem;
  background: linear-gradient(135deg, rgba(102, 126, 234, 0.1) 0%, rgba(118, 75, 162, 0.1) 100%);
  border: 1px solid rgba(102, 126, 234, 0.2);
  border-radius: 20px;
  color: #495057;
  font-size: 0.9rem;
  font-weight: 500;
}

.user-role-badge i {
  color: #667eea;
}

/* 用户信息区域 */
.user-info-section {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  gap: 0.5rem;
}

.current-time {
  font-size: 0.9rem;
  color: #6c757d;
  font-weight: 500;
}

.online-status {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 0.85rem;
  color: #28a745;
}

.status-dot {
  width: 8px;
  height: 8px;
  background: #28a745;
  border-radius: 50%;
  animation: pulse 2s infinite;
}

/* 部门权限卡片 - 现代化设计 */
.department-permissions-wrapper {
  margin-bottom: 2rem;
}

.department-info-card.modern {
  background: rgba(255, 255, 255, 0.95);
  border: none;
  border-radius: 20px;
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
  backdrop-filter: blur(20px);
  overflow: hidden;
  transition: all 0.3s ease;
  max-width: none;
  margin: 0;
  padding: 0;
}

.department-info-card.modern:hover {
  transform: translateY(-5px);
  box-shadow: 0 15px 50px rgba(0, 0, 0, 0.15);
}

.card-content {
  padding: 1.5rem 2rem;
}

.permission-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1rem;
}

.header-left {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.permission-icon {
  width: 50px;
  height: 50px;
  background: linear-gradient(135deg, #4CAF50 0%, #81C784 100%);
  border-radius: 15px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-size: 1.5rem;
}

.permission-title h3 {
  margin: 0 0 0.2rem 0;
  color: #2c3e50;
  font-size: 1.3rem;
  font-weight: 700;
}

.permission-title p {
  margin: 0;
  color: #6c757d;
  font-size: 0.9rem;
}

.departments-container {
  max-height: 500px;
  margin-bottom: 1rem;
  overflow: hidden;
  transition: all 0.4s ease;
}

.department-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 1rem;
  padding: 1rem 0;
}

.department-item {
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 1rem;
  background: rgba(248, 249, 250, 0.8);
  border: 1px solid rgba(0, 0, 0, 0.05);
  border-radius: 12px;
  cursor: pointer;
  transition: all 0.3s ease;
}

.department-item:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
  border-color: rgba(102, 126, 234, 0.3);
}

.dept-icon {
  width: 40px;
  height: 40px;
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-size: 1.2rem;
}

.dept-material .dept-icon {
  background: linear-gradient(135deg, #FF6B35 0%, #FF8E53 100%);
}

.dept-energy .dept-icon {
  background: linear-gradient(135deg, #4ECDC4 0%, #44A08D 100%);
}

.dept-water .dept-icon {
  background: linear-gradient(135deg, #45B7D1 0%, #96C93D 100%);
}

.dept-waste .dept-icon {
  background: linear-gradient(135deg, #FFA07A 0%, #FA8072 100%);
}

.dept-emission .dept-icon {
  background: linear-gradient(135deg, #98D8C8 0%, #F093FB 100%);
}

.dept-investment .dept-icon {
  background: linear-gradient(135deg, #A8E6CF 0%, #DCEDC1 100%);
}

.dept-management .dept-icon {
  background: linear-gradient(135deg, #C7CEEA 0%, #B19CD9 100%);
}

.dept-employment .dept-icon {
  background: linear-gradient(135deg, #FFB6C1 0%, #FFA0AC 100%);
}

.dept-training .dept-icon {
  background: linear-gradient(135deg, #DDA0DD 0%, #D8BFD8 100%);
}

.dept-ohs .dept-icon {
  background: linear-gradient(135deg, #F0E68C 0%, #E6DB74 100%);
}

.dept-satisfaction .dept-icon {
  background: linear-gradient(135deg, #87CEEB 0%, #87CEFA 100%);
}

.dept-supply .dept-icon {
  background: linear-gradient(135deg, #D2B48C 0%, #DEB887 100%);
}

.dept-responsibility .dept-icon {
  background: linear-gradient(135deg, #F5DEB3 0%, #F0E68C 100%);
}

.dept-ip .dept-icon {
  background: linear-gradient(135deg, #E6E6FA 0%, #DDA0DD 100%);
}

.dept-community .dept-icon {
  background: linear-gradient(135deg, #AFEEEE 0%, #7FFFD4 100%);
}

.dept-governance .dept-icon {
  background: linear-gradient(135deg, #FAFAD2 0%, #F0E68C 100%);
}

.dept-default .dept-icon {
  background: linear-gradient(135deg, #999 0%, #777 100%);
}

.dept-info {
  flex: 1;
}

.dept-name {
  display: block;
  font-weight: 600;
  color: #2c3e50;
  font-size: 1rem;
  margin-bottom: 0.2rem;
}

.dept-status {
  display: block;
  font-size: 0.8rem;
  color: #28a745;
  font-weight: 500;
}

.dept-arrow {
  color: #6c757d;
  font-size: 0.9rem;
}

.permission-footer {
  border-top: 1px solid rgba(0, 0, 0, 0.05);
  padding-top: 1rem;
}

.permission-stats {
  display: flex;
  gap: 2rem;
  justify-content: center;
}

.stat-item {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  color: #6c757d;
  font-size: 0.9rem;
  font-weight: 500;
}

.stat-item i {
  color: #4CAF50;
}

/* 深色模式适配 */
.dark-theme .top-section .theme-toggle {
  background: rgba(45, 55, 72, 0.9);
  border-color: rgba(255, 255, 255, 0.1);
}

.dark-theme .welcome-text {
  background: linear-gradient(135deg, #ff6b9d 0%, #a78bfa 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.dark-theme .user-role-badge {
  background: linear-gradient(135deg, rgba(255, 107, 157, 0.1) 0%, rgba(167, 139, 250, 0.1) 100%);
  border-color: rgba(255, 107, 157, 0.2);
  color: #e2e8f0;
}

.dark-theme .user-role-badge i {
  color: #ff6b9d;
}

.dark-theme .current-time {
  color: #a0aec0;
}

.dark-theme .department-info-card.modern {
  background: rgba(27, 32, 47, 0.95);
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.dark-theme .permission-title h3 {
  color: #e2e8f0;
}

.dark-theme .permission-title p {
  color: #a0aec0;
}

.dark-theme .department-item {
  background: rgba(74, 85, 104, 0.4);
  border-color: rgba(255, 255, 255, 0.1);
}

.dark-theme .department-item:hover {
  border-color: rgba(255, 107, 157, 0.3);
}

.dark-theme .dept-name {
  color: #e2e8f0;
}

.dark-theme .dept-arrow {
  color: #a0aec0;
}

.dark-theme .permission-footer {
  border-color: rgba(255, 255, 255, 0.1);
}

.dark-theme .stat-item {
  color: #a0aec0;
}

.dark-theme .stat-item i {
  color: #ff6b9d;
}

/* 移动端响应式 */
@media (max-width: 768px) {
  .top-section {
    flex-direction: column;
    gap: 1rem;
    align-items: center;
    text-align: center;
  }

  .theme-toggle {
    align-self: flex-start;
  }

  .welcome-section {
    margin: 0;
    max-width: none;
  }

  .welcome-text {
    font-size: 1.8rem;
  }

  .user-info-section {
    align-items: center;
  }

  .department-grid {
    grid-template-columns: 1fr;
  }

  .permission-stats {
    flex-direction: column;
    gap: 1rem;
    align-items: center;
  }

  .card-content {
    padding: 1rem;
  }

  .main-layout {
    flex-direction: column;
    gap: 1.5rem;
  }
}

@media (max-width: 480px) {
  .dashboard {
    padding: 1.5rem;
  }

  .welcome-text {
    font-size: 1.5rem;
  }

  .header-left {
    flex-direction: column;
    align-items: flex-start;
    gap: 0.5rem;
  }

  .permission-icon {
    width: 40px;
    height: 40px;
    font-size: 1.2rem;
  }
}

/* 动画效果 */
@keyframes pulse {
  0% {
    opacity: 1;
    transform: scale(1);
  }
  50% {
    opacity: 0.7;
    transform: scale(1.1);
  }
  100% {
    opacity: 1;
    transform: scale(1);
  }
}

.top-section > * {
  animation: fadeInUp 0.6s ease-out;
}

.department-permissions-wrapper {
  animation: fadeInUp 0.8s ease-out;
}

.main-layout {
  animation: fadeInUp 1s ease-out;
}

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* 权限错误提示横幅 */
.permission-error-banner {
  position: fixed;
  top: 60px;
  left: 0;
  right: 0;
  background: linear-gradient(135deg, #ff5252 0%, #f44336 100%);
  color: white;
  padding: 12px 0;
  z-index: 999;
  box-shadow: 0 2px 10px rgba(244, 67, 54, 0.3);
  animation: slideDown 0.5s ease-out;
}

@keyframes slideDown {
  from {
    transform: translateY(-100%);
    opacity: 0;
  }
  to {
    transform: translateY(0);
    opacity: 1;
  }
}

.error-content {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 15px;
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 20px;
}

.error-content i {
  font-size: 1.5rem;
  color: #ffeb3b;
}

.error-text h4 {
  margin: 0;
  font-size: 1.1rem;
  font-weight: 600;
}

.error-text p {
  margin: 2px 0 0 0;
  font-size: 0.9rem;
  opacity: 0.9;
}

.close-error-btn {
  background: rgba(255, 255, 255, 0.2);
  border: none;
  color: white;
  border-radius: 50%;
  width: 28px;
  height: 28px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: background 0.3s;
}

.close-error-btn:hover {
  background: rgba(255, 255, 255, 0.3);
}

/* 部门信息卡片 */
.department-info-card {
  background: linear-gradient(135deg, rgba(76, 175, 80, 0.1) 0%, rgba(129, 199, 132, 0.1) 100%);
  border: 1px solid rgba(76, 175, 80, 0.2);
  border-radius: 12px;
  padding: 16px 20px;
  margin: 20px auto;
  max-width: 800px;
  backdrop-filter: blur(10px);
  box-shadow: 0 4px 15px rgba(76, 175, 80, 0.1);
}

/* 深色主题下的权限提示 */
.dark-theme .department-info-card {
  background: linear-gradient(135deg, rgba(76, 175, 80, 0.15) 0%, rgba(129, 199, 132, 0.1) 100%);
  border-color: rgba(76, 175, 80, 0.3);
}

.dark-theme .card-header h3 {
  color: #81C784;
}

.dark-theme .card-header i {
  color: #4CAF50;
}

.dark-theme .card-footer small {
  color: #A5D6A7;
}


.main-layout {
  display: flex;
  gap: 3rem;
  margin: 0 auto;
  flex: 1 1 auto;
  height: 100%;
  width: 100%;
}

.main-half {
  flex: 1 1 0;
  display: flex;
  flex-direction: column;
  gap: 1rem;
  min-width: 0;
  padding: 1.5rem;
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(33, 150, 243, 0.08);
}


.welcome-text {
  font-size: 2rem;
  margin-bottom: 1.5rem;
  color: #1565c0;
}

.progress-section h2 {
  font-size: 1.2rem;
  color: #388e3c;
  margin-bottom: 0.5rem;
}

.progress-list {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
  gap: 1rem;
  width: 100%;
}

.progress-card {
  background: #e3f2fd;
  border-radius: 8px;
  padding: 0.5rem 0.7rem;
  margin: 0.2rem 0;
  display: flex;
  flex-direction: column;
  align-items: flex-start;
}

.progress-title {
  font-size: 1rem;
  color: #66aff6;
  margin-bottom: 0.5rem;
}

.progress-bar-bg {
  width: 100%;
  height: 16px;
  background: #c8e6c9;
  border-radius: 8px;
  margin-bottom: 0.3rem;
  overflow: hidden;
}

.progress-bar {
  height: 100%;
  background: linear-gradient(120deg, #a26b04 0%, #4dfc56 100%);
  border-radius: 8px;
  transition: width 0.5s;
}

.progress-percent {
  font-size: 0.95rem;
  color: #388e3c;
  font-weight: bold;
}

.message-section {
  background: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(33, 150, 243, 0.08);
  padding: 0.7rem 0.8rem;
  position: relative;
}

.message-section h2,
.operation-section h2 {
  font-size: 1.2rem;
  color: #000000;
  margin-bottom: 1rem;
}

.dark-theme .message-section h2,
.dark-theme .operation-section h2 {
  color: #e0e0e0;
}

.section-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.message-actions {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.unread-badge {
  background: #e53935;
  color: #fff;
  border-radius: 50%;
  padding: 0.3rem 0.7rem;
  font-size: 1rem;
  font-weight: bold;
  margin-left: 0.5rem;
}

.view-all-btn {
  background: #66aff6;
  color: #fff;
  border: none;
  border-radius: 4px;
  padding: 0.4rem 0.8rem;
  font-size: 0.9rem;
  cursor: pointer;
  transition: background 0.2s;
}

.view-all-btn:hover {
  background: #1565c0;
}

.dark-theme .view-all-btn {
  background: #3192b0;
}

.message-preview {
  display: flex;
  flex-direction: column;
  gap: 0.7rem;
  margin-top: 0.7rem;
}

.empty-message {
  text-align: center;
  color: #888;
  padding: 1rem 0;
}

.message-card {
  background: #d8dada;
  border-radius: 8px;
  padding: 0.5rem 0.7rem;
  margin: 0.2rem 0;
  display: flex;
  align-items: center;
  justify-content: space-between;
  cursor: pointer;
  position: relative;
  transition: box-shadow 0.2s;
  box-shadow: 0 2px 6px rgba(33, 150, 243, 0.06);
}

.message-card.unread {
  background: linear-gradient(120deg, #d0e7f8 0%, #b7b2fd 100%);
}

.message-card:hover {
  background: #bebdbd;
}

.message-card.unread:hover {
  background: linear-gradient(120deg, #b5cada 0%, #9994de 100%);
}

.dark-theme .message-card {
  background: #2a2a2a;
  color: #fff;
}

.dark-theme .message-card.unread {
  background: linear-gradient(120deg, #3d082a 0%, #0c0633 100%);
}

.dark-theme .message-card:hover {
  background: #414141;
}

.dark-theme .message-card.unread:hover {
  background: linear-gradient(120deg, #59103f 0%, #180d5e 100%);
}


.message-title {
  flex: 1;
  margin-left: 0.5rem;
  color: #03396e;
}

.dark-theme .message-title, .dark-theme .message-date {
  color: #f5f5f5;
}

.red-dot {
  width: 10px;
  height: 10px;
  background: #e53935;
  border-radius: 50%;
  display: inline-block;
  margin-left: 0.5rem;
}

.message-date {
  font-size: 0.95rem;
  color: #888;
  margin-left: 1rem;
}

.modal-mask {
  position: fixed;
  z-index: 9999;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  backdrop-filter: blur(2px);
}

.modal-container {
  background: linear-gradient(120deg, #f8f1f1 0%, #fadcb3 100%);
  border-radius: 12px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
  display: flex;
  flex-direction: column;
  max-height: 90vh;
}

.list-modal {
  width: 60%;
  height: 80%;
}

.detail-modal {
  width: 50%;
  max-width: 70%;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1.2rem 1.5rem;
  border-bottom: 1px solid #eee;
  flex-shrink: 0;
}

.modal-header h3 {
  margin: 0;
  color: #333;
  font-size: 1.2rem;
  font-weight: 600;
}

.header-actions {
  display: flex;
  align-items: center;
  gap: 0.8rem;
}

.select-all-container {
  display: flex;
  align-items: center;
  cursor: pointer;
  padding: 0.4rem 0.6rem;
  border-radius: 4px;
  transition: background-color 0.2s;
  flex-direction: row;
}

.custom-checkbox {
  width: 20px;
  height: 20px;
  border: 2px solid #ddd;
  border-radius: 3px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 0.5rem;
  transition: all 0.2s;
  margin-top: 1.2rem;
  cursor: pointer !important;
}

.custom-checkbox.checked {
  background-color: #66aff6;
  border-color: #66aff6;
}

.custom-checkbox .icon-check {
  color: white;
  font-size: 12px;
  font-weight: bold;
}

.select-all-text {
  font-size: 0.9rem;
  color: #555;
  user-select: none;
  justify-content: left;
  margin-right: 0.5rem;
  margin-top: 1.2rem;
}

.selection-buttons {
  display: flex;
  gap: 0.5rem;
}

.modal-close {
  background: none;
  border: none;
  font-size: 1.5rem;
  cursor: pointer;
  color: #999;
  padding: 0;
  width: 30px;
  height: 30px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  transition: all 0.2s;
  flex-shrink: 0;
}

.modal-close:hover {
  background: #f5f5f5;
  color: #333;
}

.modal-content {
  padding: 1.5rem;
  overflow: hidden;
  display: flex;
  flex-direction: column;
}

.list-content {
  max-height: 60vh;
  overflow-y: auto;
  padding: 0;
}

.detail-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.empty-list {
  text-align: center;
  color: #888;
  padding: 2rem 0;
}

.message-list {
  display: flex;
  flex-direction: column;
  width: 100%;
}

.list-item {
  padding: 0.9rem 1.2rem;
  border-bottom: 1px solid #e5e7eb;
  cursor: pointer;
  transition: all 0.2s ease;
  display: flex;
  align-items: center;
  width: 100%;
  box-sizing: border-box;
  background: #ffffff;
  border-radius: 6px;
  margin-bottom: 2px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.list-item.unread {
  background: #eff6ff; /* 更柔和的浅蓝色 */
  border-left: 4px solid #3b82f6;
  font-weight: 500;
}


.list-item:last-child {
  border-bottom: none;
}

.list-item:hover {
  background: #f3f3ca;
  transform: translateY(-1px);
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.list-item.select-mode {
  padding-left: 0.8rem;
}

.list-item.selected {
  background-color: #fef3c7;
  border-left: 4px solid #f59e0b;
  box-shadow: 0 2px 8px rgba(245, 158, 11, 0.2);
}

.list-item-content {
  display: flex;
  align-items: center;
  width: 100%;
}

.item-header {
  margin-right: 1rem;
  display: flex;
  align-items: center;
}

.item-content {
  display: flex;
  flex: 1;
  justify-content: space-between;
  align-items: center;
}

.item-checkbox {
  margin-left: 0.8rem;
  display: flex;
  align-items: center;
}

.item-title {
  font-weight: 500;
  color: #333;
  font-size: 0.95rem;
}

.item-date {
  font-size: 0.85rem;
  color: #888;
}

.modal-footer button {
  background: #66aff6;
  color: #fff;
  border: none;
  border-radius: 4px;
  padding: 0.7rem 1.2rem;
  font-size: 1rem;
  cursor: pointer;
  transition: background 0.2s;
  flex: 0 0 auto;
  width: 20%;
  justify-content: center;
}

.modal-footer button:hover {
  background: #1565c0;
}

.action-btn {
  background: #9946e1;
  color: #fff;
  border-radius: 4px;
  font-size: 0.85rem;
  position: relative;
  min-width: 100px;
}

.action-btn:not(:disabled):hover {
  background: #6020da;
}

.action-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}


.clear-all-btn:not(:disabled):hover {
  background: #e53935;
  color: white;
}

.confirm-delete-btn {
  display: flex;
  border-radius: 4px;
  font-size: 0.85rem;
  cursor: pointer;
  transition: all 0.2s;
  white-space: nowrap;
  background: #c72222;
}

.confirm-delete-btn:hover:not(:disabled) {
  background: #9a0d0d;
}

.confirm-delete-btn:disabled {
  background: #444;
  color: #e0e0e0;
}

.delete-btn:not(:disabled) {
  background: #c72222;
  color: #e0e0e0;
  border-radius: 4px;
  padding: 0.7rem 1.2rem;
  cursor: pointer;
  transition: all 0.2s;
  white-space: nowrap;
  display: flex;
  justify-content: center;
  align-items: center;
}

.delete-btn:hover:not(:disabled) {
  background: #9a0d0d;
}

.icon-check {
  font-size: 0.9rem;
}

.confirm-message {
  font-size: 1rem;
  color: #333;
}

.dark-theme .confirm-message {
  color: #e0e0e0;
}

.warning-text {
  color: #e53935;
  font-weight: bold;
}

@media (max-width: 900px) {
  .main-layout {
    flex-direction: column;
  }

  .main-half {
    width: 100%;
    max-width: 100%;
  }

  .progress-list {
    grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
  }

  .detail-modal {
    width: 95vw;
    height: 95vh;
  }

  .list-modal {
    width: 90%;
    max-width: 95%;
  }

  .header-actions {
    flex-wrap: wrap;
    gap: 0.5rem;
  }
}

.dark-theme .main-half {
  background: #21212c;
  color: #84a2d5;
}

.dark-theme .dashboard {
  background: linear-gradient(60deg, #15010b 0%, #340530 50%, #040225 100%);
  background-size: 300% 300%;
  animation: gradientFlow 8s ease infinite;
}


@keyframes gradientFlow {
  0% {
    background-position: 0 0;
  }
  50% {
    background-position: 100% 100%;
  }
  100% {
    background-position: 0 0;
  }
}

.dark-theme .welcome-text {
  color: #bb86fc;
}

.dark-theme .progress-card {
  background: #2c2c2c;
}

.dark-theme .progress-title {
  color: #bb86fc;
}

.dark-theme .progress-bar-bg {
  background: #444;
}

.dark-theme .progress-bar {
  background: linear-gradient(120deg, #930651 0%, #82b1ff 100%);
}

.dark-theme .message-section {
  background: #1c1c1c;
}


.dark-theme .red-dot {
  background: #ff5252;
}

.dark-theme .modal-container {
  background: linear-gradient(120deg, #3f0927 0%, #080433 100%);
  color: #e0e0e0;
}

.dark-theme .modal-header {
  border-bottom-color: #555;
}

.dark-theme .modal-header h3 {
  color: #e0e0e0;
}

.dark-theme .modal-close {
  color: #aaa;
}

.dark-theme .modal-close:hover {
  background: #3a3a3a;
  color: #e0e0e0;
}

.dark-theme .list-item {
  background: #1f1f1f;
  border-bottom-color: #4b5563;
  color: #e5e7eb;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.3);
}

.dark-theme .list-item:hover, .dark-theme .list-item.unread:hover, .dark-theme .list-item.selected:hover {
  background: #4b4b4b;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.3);
}


.dark-theme .list-item.unread {
  background: linear-gradient(60deg, #3d082a 0%, #0c0633 100%);
  border-left-color: #60a5fa;
}


.dark-theme .list-item.selected {
  background: linear-gradient(60deg, #650c20 0%, #230009 100%);
  border-left-color: #fa6060;
}

.dark-theme .item-title {
  color: #e0e0e0;
}

.dark-theme .select-all-text {
  color: #e0e0e0;
}

.dark-theme .action-btn {
  background: #444;
  color: #e0e0e0;
}

.dark-theme .action-btn:not(:disabled):hover {
  background: #555;
}

.small-select {
  position: relative;
  min-width: 120px;
}

.small-select .selected {
  cursor: pointer;
  display: flex;
  justify-content: space-between;
  align-items: center;
  background: linear-gradient(135deg, #ffffff 0%, #f0f7ff 100%);
  color: #333;
  padding: 0.4rem 0.8rem;
  border: 1px solid #e3f2fd;
  border-radius: 6px;
  transition: all 0.3s ease;
  box-shadow: 0 1px 6px rgba(102, 175, 246, 0.1);
  font-size: 0.85rem;
  font-weight: 500;
}

.small-select .selected:hover {
  border-color: #66aff6;
  background: linear-gradient(135deg, #ffffff 0%, #f0f7ff 100%);
  box-shadow: 0 2px 12px rgba(102, 175, 246, 0.2);
  transform: translateY(-1px);
}

.small-select .arrow {
  display: inline-block;
  width: 0;
  height: 0;
  border-left: 3px solid transparent;
  border-right: 3px solid transparent;
  border-top: 3px solid #555;
  transition: transform 0.3s;
  margin-left: 0.4rem;
}

.small-select .arrow.up {
  transform: rotate(180deg);
}

.small-select .options {
  position: absolute;
  top: 100%;
  left: 0;
  right: 0;
  background: white;
  border: 1px solid #ddd;
  border-radius: 6px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  z-index: 100;
  max-height: 180px;
  overflow-y: auto;
}

.small-select .option {
  padding: 0.4rem 0.8rem;
  cursor: pointer;
  transition: background-color 0.2s;
  color: #333;
  font-size: 0.8rem;
}

.small-select .option:hover {
  background-color: #f0f8ff;
}

.small-select .selected-option {
  background-color: #e1f0fa;
  font-weight: bold;
  color: #1a5276;
}

/* 深色主题下的small-select样式 */
.dark-theme .small-select .selected {
  background: linear-gradient(135deg, #3a3a3a 0%, #2c2c2c 100%);
  color: #e0e0e0;
  border: 1px solid #555;
  box-shadow: 0 1px 6px rgba(0, 0, 0, 0.3);
}

.dark-theme .small-select .selected:hover {
  border-color: #bb86fc;
  background: linear-gradient(135deg, #404040 0%, #323232 100%);
  box-shadow: 0 2px 12px rgba(187, 134, 252, 0.2);
}

.dark-theme .small-select .arrow {
  border-top-color: #e0e0e0;
}

.dark-theme .small-select .options {
  background: #2c2c2c;
  border: 1px solid #555;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
}

.dark-theme .small-select .option {
  color: #e0e0e0;
  background: #2c2c2c;
}

.dark-theme .small-select .option:hover {
  background: #3e3e3e;
}

.dark-theme .small-select .selected-option {
  background: #4a4a4a;
  color: #bb86fc;
}
</style>
