<template>
  <div class="dashboard">
    <div class="main-layout">
      <!-- 左侧主内容区 -->
      <div class="main-left">
        <div class="theme-toggle">
          <label class="theme-label">☀️</label>
          <input type="checkbox" v-model="isDark" @click="toggleTheme" class="theme-switch" />
          <label class="theme-label">🌙</label>
        </div>
        <h1 class="welcome-text">欢迎回来, {{ authStore.user?.username }}!</h1>
        <!-- 快速跳转区 -->
        <div class="quick-actions">
          <div
              v-for="action in quickActions"
              :key="action.label"
              class="action-card"
              @click="navigateTo(action.path)"
          >
            <span class="action-label">{{ action.label }}</span>
          </div>
        </div>
        <!-- 填报进度区 -->
        <div class="progress-section">
          <h2>各页面填报进度</h2>
          <div class="progress-list">
            <div class="progress-card" v-for="item in progressData" :key="item.title">
              <div class="progress-title">{{ item.title }}</div>
              <div class="progress-bar-bg">
                <div class="progress-bar" :style="{ width: item.percent + '%' }"></div>
              </div>
              <div class="progress-percent">{{ item.percent }}%</div>
            </div>
          </div>
        </div>
      </div>
      <!-- 右侧系统消息和最近操作区 -->
      <div class="main-right">
        <!-- 系统消息区 -->
        <div class="message-section">
          <div class="section-header">
            <h2>系统消息</h2>
            <span v-if="unreadCount > 0" class="unread-badge">{{ unreadCount }}</span>
          </div>
          <div class="message-list">
            <div
                v-for="msg in messages"
                :key="msg.id"
                class="message-card"
                :class="{ unread: !msg.read }"
                @click="openMessage(msg)"
            >
              <span class="message-title">{{ msg.title }}</span>
              <span v-if="!msg.read" class="red-dot"></span>
              <span class="message-date">{{ msg.date }}</span>
            </div>
          </div>
        </div>
        <!-- 最近操作区 -->
        <div class="history-section">
          <h2>最近操作</h2>
          <div class="history-list">
            <div
                v-for="record in historyRecords"
                :key="record.id"
                class="history-card"
                @click="openHistory(record)"
            >
              <span class="history-title">{{ record.title }}</span>
              <span class="history-date">{{ record.date }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>
    <!-- 弹窗：系统消息详情 -->
    <div v-if="showMessageModal" class="modal-mask" @click.self="closeModal">
      <div class="modal-container">
        <h3>{{ currentMessage?.title }}</h3>
        <p>{{ currentMessage?.content }}</p>
        <div class="modal-footer">
          <button @click="closeModal">关闭</button>
        </div>
      </div>
    </div>
    <!-- 弹窗：最近操作详情 -->
    <div v-if="showHistoryModal" class="modal-mask" @click.self="closeModal">
      <div class="modal-container">
        <h3>{{ currentHistory?.title }}</h3>
        <p>{{ currentHistory?.content }}</p>
        <div class="modal-footer">
          <button @click="closeModal">关闭</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import {useAuthStore} from '@/stores/authStore';
import {useRouter} from 'vue-router';
import {computed, ref} from 'vue';

const authStore = useAuthStore();
const router = useRouter();

const quickActions = ref([
  {label: '定量数据填报', path: '/material'},
  {label: '年度分析', path: '/env-quantitative'},
  {label: '账号管理', path: '/account'},
]);

const messages = ref([
  {
    id: 1,
    title: '2025年度ESG数据填报已开放',
    content: '请及时提交2025年度ESG数据，避免影响后续分析。',
    date: '2025-09-10',
    read: false
  },
  {id: 2, title: '系统维护通知', content: '系统将于9月20日凌晨维护，请提前保存数据。', date: '2025-09-08', read: true},
  {id: 3, title: '指标库更新', content: '指标库“可再生能源使用比例”公式已更新。', date: '2025-09-05', read: false},
]);

const unreadCount = computed(() => messages.value.filter(m => !m.read).length);

const progressData = ref([
  {title: '环境定量', percent: 80},
  {title: '环境定性', percent: 90},
  {title: '社会定量-劳工', percent: 60},
  {title: '社会定性-劳工', percent: 70},
  {title: '社会定量-其他', percent: 20},
  {title: '社会定性-其他', percent: 40},
  {title: '治理定性', percent: 15},
]);

const historyRecords = ref([
  {id: 1, title: '提交环境定量数据', content: '你刚刚提交了环境定量数据，数据已保存。', date: '2025-09-13 09:20'},
  {id: 2, title: '审核社会定量数据', content: '你审核通过了社会定量数据。', date: '2025-09-12 16:40'},
  {id: 3, title: '修改账号信息', content: '你修改了账号信息。', date: '2025-09-11 14:10'},
]);

const showMessageModal = ref(false);
const currentMessage = ref(null);
const showHistoryModal = ref(false);
const currentHistory = ref(null);
const isDark = ref(true);

const navigateTo = (path) => {
  authStore.isDataMode = !path.includes('env-quantitative');
  router.push(path);
};

function openMessage(msg) {
  currentMessage.value = msg;
  showMessageModal.value = true;
  if (!msg.read) {
    msg.read = true;
  }
}

function openHistory(record) {
  currentHistory.value = record;
  showHistoryModal.value = true;
}

function closeModal() {
  showMessageModal.value = false;
  showHistoryModal.value = false;
}

function toggleTheme() {
  isDark.value = !isDark.value;
  document.body.classList.toggle('dark-theme', isDark.value);
}
</script>

<style scoped>
.dashboard {
  padding: 2rem;
  color: #222;
  background: linear-gradient(120deg, #e3f2fd 0%, #f1f8e9 100%);
  min-height: 90vh;
}

.theme-toggle {
  position: absolute;
  top: 2rem;
  left: 2rem;
  display: flex;
  align-items: center;
  cursor: pointer;
  z-index: 10;
}

.theme-label {
  font-size: 1.5rem;
  color: #1976d2;
  margin: 0 0.5rem;
}

.theme-switch {
  width: 50px;
  height: 24px;
  appearance: none;
  background: #ccc;
  border-radius: 12px;
  position: relative;
  outline: none;
  cursor: pointer !important;
}

.theme-switch:before {
  content: '';
  position: absolute;
  top: 2px;
  left: 2px;
  width: 20px;
  height: 20px;
  background: #fff;
  border-radius: 50%;
  transition: transform 0.3s;
}

.theme-switch:checked {
  background: #1976d2;
}

.theme-switch:checked:before {
  transform: translateX(26px);
}

.main-layout {
  display: flex;
  gap: 2rem;
  max-width: 1200px;
  margin: 0 auto;
}

.main-left {
  flex: 2;
  display: flex;
  flex-direction: column;
  gap: 2rem;
}

.main-right {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 2rem;
  justify-content: flex-start;
}

.welcome-text {
  font-size: 2rem;
  margin-bottom: 1.5rem;
  color: #1565c0;
}

.quick-actions {
  display: flex;
  gap: 1.5rem;
  justify-content: center;
  margin-bottom: 1.5rem;
}

.action-card {
  background: #1976d2;
  color: #fff;
  border-radius: 10px;
  padding: 1.2rem 2.5rem;
  font-size: 1.2rem;
  font-weight: bold;
  cursor: pointer;
  box-shadow: 0 2px 8px rgba(33, 150, 243, 0.08);
  transition: background 0.2s, transform 0.2s;
  display: flex;
  align-items: center;
  justify-content: center;
}

.action-card:hover {
  background: #1565c0;
  transform: translateY(-2px);
}

.action-label {
  letter-spacing: 1px;
}

.progress-section {
  background: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(76, 175, 80, 0.08);
  padding: 1rem 1.2rem;
}

.progress-section h2 {
  font-size: 1.2rem;
  color: #388e3c;
  margin-bottom: 0.5rem;
}

.progress-list {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
  gap: 1.5rem;
}

.progress-card {
  background: #e3f2fd;
  border-radius: 8px;
  padding: 1rem;
  display: flex;
  flex-direction: column;
  align-items: flex-start;
}

.progress-title {
  font-size: 1rem;
  color: #1976d2;
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
  background: #43a047;
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
  padding: 1rem 1.2rem;
  position: relative;
}

.section-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
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

.message-list {
  display: flex;
  flex-direction: column;
  gap: 0.7rem;
  margin-top: 0.7rem;
}

.message-card {
  background: #e3f2fd;
  border-radius: 8px;
  padding: 0.7rem 1rem;
  display: flex;
  align-items: center;
  justify-content: space-between;
  cursor: pointer;
  position: relative;
  transition: box-shadow 0.2s;
  box-shadow: 0 2px 6px rgba(33, 150, 243, 0.06);
}

.message-card.unread {
  font-weight: bold;
  background: #fffde7;
}

.message-title {
  flex: 1;
  color: #1976d2;
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

.history-section {
  background: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(33, 150, 243, 0.08);
  padding: 1rem 1.2rem;
}

.history-section h2 {
  font-size: 1.2rem;
  color: #1976d2;
  margin-bottom: 0.5rem;
}

.history-list {
  display: flex;
  flex-direction: column;
  gap: 0.7rem;
}

.history-card {
  background: #e3f2fd;
  border-radius: 8px;
  padding: 0.7rem 1rem;
  display: flex;
  align-items: center;
  justify-content: space-between;
  cursor: pointer;
  transition: box-shadow 0.2s;
  box-shadow: 0 2px 6px rgba(33, 150, 243, 0.06);
}

.history-title {
  flex: 1;
  color: #1976d2;
}

.history-date {
  font-size: 0.95rem;
  color: #888;
  margin-left: 1rem;
}

.modal-mask {
  position: fixed;
  z-index: 9999;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  background: rgba(0, 0, 0, 0.25);
  display: flex;
  align-items: center;
  justify-content: center;
}

.modal-container {
  background: #fff;
  border-radius: 10px;
  box-shadow: 0 4px 24px rgba(33, 150, 243, 0.18);
  padding: 2rem 2.5rem;
  min-width: 320px;
  max-width: 90vw;
}

.modal-footer {
  margin-top: 1.5rem;
  text-align: right;
}

.modal-footer button {
  background: #1976d2;
  color: #fff;
  border: none;
  border-radius: 4px;
  padding: 0.5rem 1.2rem;
  font-size: 1rem;
  cursor: pointer;
  transition: background 0.2s;
}

.modal-footer button:hover {
  background: #1565c0;
}

@media (max-width: 900px) {
  .main-layout {
    flex-direction: column;
  }

  .main-left,
  .main-right {
    width: 100%;
    max-width: 100%;
  }

  .quick-actions {
    flex-direction: column;
    align-items: center;
  }

  .progress-list {
    grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
  }
}


.dark-theme .dashboard {
  background: #121212;
}

/* 移除布局相关属性，只保留颜色相关 */
.dark-theme .main-layout {
  background: #121212;
}

.dark-theme .welcome-text {
  color: #bb86fc;
}

.dark-theme .action-card {
  background: #230172;
  color: #fff;
}

.dark-theme .action-card:hover {
  background: #6200ea;
}
.dark-theme .progress-section {
  background: #1c1b1b;
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
  background: #82b1ff;
}

.dark-theme .message-section {
  background: #2c2c2c;
}

.dark-theme .message-card {
  background: #3e3e3e;
  color: #e0e0e0;
}

.dark-theme .message-card.unread {
  background: #3e3e3e;
}

.dark-theme .red-dot {
  background: #ff5252;
}

.dark-theme .history-section {
  background: #2c2c2c;
}

.dark-theme .history-card {
  background: #3e3e3e;
}

.dark-theme .modal-container {
  background: #424242;
}

.dark-theme .modal-footer button {
  background: #6200ea;
}

.dark-theme .modal-footer button:hover {
  background: #3700b3;
}
</style>