<template>
  <div class="dashboard">
    <div class="theme-toggle">
      <label class="theme-label">☀️</label>
      <input type="checkbox" v-model="isDark" @click="toggleTheme" class="theme-switch"/>
      <label class="theme-label">🌙</label>
    </div>
    <h1 class="welcome-text">欢迎回来, {{ authStore.user?.username }}!</h1>
    <!-- 快速跳转区 -->
    <div class="quick-actions">
      <div v-for="action in quickActions" :key="action.label" class="action-card" @click="navigateTo(action.path)">
        <span class="action-label">{{ action.label }}</span>
      </div>
    </div>
    <div class="main-layout">
      <!-- 左侧主内容区 -->
      <div class="main-left">
        <div style="display: flex; flex-direction: row; align-items: center; justify-content: space-between;">
          <h2 style="margin: 0;">{{ isAnalytical ? '原因分析模式' : '定量填报模式' }}进度</h2>
          <div style="display: flex; align-items: center; gap: 1rem;">
            <select v-model="selectionStore.selectedYear" class="year-selector">
              <option v-for="year in selectionStore.years" :key="year" :value="year">{{ year }}年</option>
            </select>
            <input type="checkbox" v-model="isAnalytical" class="theme-switch"/>
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
      <!-- 右侧系统消息和最近操作区 -->
      <div class="main-right">
        <!-- 系统消息区 -->
        <div class="message-section">
          <div class="section-header">
            <h2>系统消息</h2>
            <span v-if="unreadCount > 0" class="unread-badge">{{ unreadCount }}</span>
          </div>
          <div class="message-list">
            <div v-for="msg in messages" :key="msg.id" class="message-card" :class="{ unread: !msg.read }"
                 @click="openMessage(msg)">
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
            <div v-for="record in historyRecords" :key="record.id" class="history-card" @click="openHistory(record)">
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
import {computed, onMounted, ref, watch} from 'vue';
import axios from '@/utils/axios';
import {useSelectionStore} from "@/stores/selectionStore.js";

const authStore = useAuthStore();
const selectionStore = useSelectionStore();
const router = useRouter();

const quickActions = ref([
  {label: '月度填报', path: '/material'},
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

const isAnalytical = ref(false);
const analyticalProgressData = ref([
  {title: '环境定量', percent: 0},
  {title: '环境定性', percent: 0},
  {title: '社会定量-劳工', percent: 0},
  {title: '社会定性-劳工', percent: 0},
  {title: '社会定量-其他', percent: 0},
  {title: '社会定性-其他', percent: 0},
  {title: '治理定性', percent: 0},
]);
const quantitativeProgressData = ref([
  {title: '环境', percent: 0},
  {title: '社会-劳工', percent: 0},
  {title: '社会-其他', percent: 0},
]);
const currentProgressData = computed(() =>
    isAnalytical.value ? analyticalProgressData.value : quantitativeProgressData.value
);

const historyRecords = ref([
  {id: 1, title: '提交环境定量数据', content: '你刚刚提交了环境定量数据，数据已保存。', date: '2025-09-13 09:20'},
  {id: 2, title: '审核社会定量数据', content: '你审核通过了社会定量数据。', date: '2025-09-12 16:40'},
  {id: 3, title: '修改账号信息', content: '你修改了账号信息。', date: '2025-09-11 14:10'},
]);

const showMessageModal = ref(false);
const currentMessage = ref(null);
const showHistoryModal = ref(false);
const currentHistory = ref(null);
const isDark = ref(false);

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

// 获取定量进度数据
const fetchQuantitativeProgress = async () => {
  try {
    const factory = selectionStore.selectedFactory;
    const year = selectionStore.selectedYear;
    const response1 = await axios.get(`/progress/quantitative?factory=${factory}&year=${year}`);
    const response2 = await axios.get(`/progress/analytical?factory=${factory}&year=${year}`);
    const data1 = response1.data;
    const data2 = response2.data;
    console.log("data1: ", data1);
    console.log("data2: ", data2);
    quantitativeProgressData.value = [
      {title: '环境', percent: data1.environment || 0},
      {title: '社会-劳工', percent: data1.social_labor || 0},
      {title: '社会-其他', percent: data1.social_other || 0},
    ];
    analyticalProgressData.value = [
      {title: '环境定量', percent: data2.env_quant || 0},
      {title: '环境定性', percent: data2.env_qual || 0},
      {title: '社会定量-劳工', percent: data2.social_quant_labor || 0},
      {title: '社会定性-劳工', percent: data2.social_qual_labor || 0},
      {title: '社会定量-其他', percent: data2.social_quant_other || 0},
      {title: '社会定性-其他', percent: data2.social_qual_other || 0},
      {title: '治理定性', percent: data2.governance || 0},
    ];
  } catch (error) {
    console.error('获取进度数据失败:', error);
  }
};

onMounted(() => {
  fetchQuantitativeProgress();
});

// 监听年份变化，更新进度数据
watch(() => selectionStore.selectedYear, (newYear, oldYear) => {
  if (newYear !== oldYear) {
    fetchQuantitativeProgress();
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
  color: #66aff6;
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
  background: #66aff6;
}

.theme-switch:checked:before {
  transform: translateX(26px);
}

.main-layout {
  display: flex;
  gap: 3rem;
  max-width: 1200px;
  margin: 0 auto;
  flex: 1 1 auto;
  min-height: 0;
  width: 100%;
}

.main-left {
  flex: 1 1 0;
  display: flex;
  flex-direction: column;
  gap: 1rem;
  min-width: 0;
  padding: 1.5rem;
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
}

.main-right {
  flex: 1 1 0;
  display: flex;
  flex-direction: column;
  gap: 1rem;
  min-width: 0;
  padding: 1.5rem;
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
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
  background: #66aff6;
  color: #fff;
  border-radius: 10px;
  padding: 0.8rem 1.2rem;
  font-size: 1rem;
  font-weight: bold;
  cursor: pointer;
  box-shadow: 0 2px 8px rgba(33, 150, 243, 0.08);
  transition: background 0.2s, transform 0.2s;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0.2rem 0;
}

.action-card:hover {
  background: #1565c0;
  transform: translateY(-2px);
}

.action-label {
  letter-spacing: 1px;
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
.history-section h2 {
  font-size: 1.2rem;
  color: #000000;
  margin-bottom: 1rem;
}

.dark-theme .message-section h2,
.dark-theme .history-section h2 {
  color: #e0e0e0;
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
  font-weight: bold;
  background: #fffde7;
}

.message-title {
  flex: 1;
  color: #66aff6;
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
  padding: 0.7rem 0.8rem;
}


.history-list {
  display: flex;
  flex-direction: column;
  gap: 0.7rem;
}

.history-card {
  background: #e3f2fd;
  border-radius: 8px;
  padding: 0.5rem 0.7rem;
  margin: 0.2rem 0;
  display: flex;
  align-items: center;
  justify-content: space-between;
  cursor: pointer;
  transition: box-shadow 0.2s;
  box-shadow: 0 2px 6px rgba(33, 150, 243, 0.06);
}

.history-title {
  flex: 1;
  color: #66aff6;
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
  padding: 1.2rem 1.5rem;
  min-width: 260px;
  max-width: 90vw;
}

.modal-footer {
  margin-top: 1.5rem;
  text-align: right;
}

.modal-footer button {
  background: #66aff6;
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

.dark-theme .action-card {
  background: #6816cc;
  color: #fff;
}

.dark-theme .action-card:hover {
  background: #6200ea;
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

.dark-theme .main-left {
  background: #232323;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.18);
  color: #e0e0e0;
}

.dark-theme .main-right {
  background: #232323;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.18);
  color: #e0e0e0;
}

.year-selector {
  padding: 0.5rem 1rem;
  border-radius: 8px;
  border: 2px solid #e3f2fd;
  background: linear-gradient(135deg, #ffffff 0%, #f8f9ff 100%);
  color: #333;
  font-size: 0.95rem;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 2px 8px rgba(102, 175, 246, 0.1);
  min-width: 100px;
  outline: none;
}

.year-selector:hover {
  border-color: #66aff6;
  background: linear-gradient(135deg, #ffffff 0%, #f0f7ff 100%);
  box-shadow: 0 4px 15px rgba(102, 175, 246, 0.2);
  transform: translateY(-1px);
}

.year-selector:focus {
  border-color: #1565c0;
  background: #ffffff;
  box-shadow: 0 0 0 3px rgba(102, 175, 246, 0.15), 0 4px 15px rgba(102, 175, 246, 0.2);
}

.year-selector option {
  padding: 0.5rem;
  background: #ffffff;
  color: #333;
}

/* Dark theme styles for year selector */
.dark-theme .year-selector {
  background: linear-gradient(135deg, #3a3a3a 0%, #2c2c2c 100%);
  color: #e0e0e0;
  border: 2px solid #555;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.3);
}

.dark-theme .year-selector:hover {
  border-color: #bb86fc;
  background: linear-gradient(135deg, #404040 0%, #323232 100%);
  box-shadow: 0 4px 15px rgba(187, 134, 252, 0.2);
  transform: translateY(-1px);
}

.dark-theme .year-selector:focus {
  border-color: #6200ea;
  background: linear-gradient(135deg, #424242 0%, #353535 100%);
  box-shadow: 0 0 0 3px rgba(187, 134, 252, 0.15), 0 4px 15px rgba(187, 134, 252, 0.2);
}

.dark-theme .year-selector option {
  background: #2c2c2c;
  color: #e0e0e0;
}
</style>
