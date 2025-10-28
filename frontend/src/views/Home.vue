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

        <div class="user-role-controls">
          <span class="role-badge" :class="authStore.user?.role">{{ getRoleDisplayName() }}</span>
          <button class="permission-toggle-btn" @click="showPermissionDetails = !showPermissionDetails"
                  :class="{ 'active': showPermissionDetails }">
            {{ showPermissionDetails ? '隐藏权限' : '查看权限' }}
          </button>
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

    <div v-show="showPermissionDetails" class="permission-card">
      <div class="permission-details">
        <h4>系统角色权限说明</h4>
        <div class="roles-grid">
          <!-- 部门账号 -->
          <div class="role-card" :class="{ 'current-user': authStore.isDepartment }">
            <div class="role-card-header">
              <span class="role-badge department">部门</span>
              <span v-if="authStore.isDepartment" class="current-label">您当前角色</span>
            </div>
            <div class="role-permissions">
              <div class="permission-item">查看管辖部门每月的定量数据以及审核结果</div>
              <div class="permission-item">每月填写管辖部门的数据</div>
            </div>
          </div>

          <!-- 工厂账号 -->
          <div class="role-card" :class="{ 'current-user': authStore.isFactory }">
            <div class="role-card-header">
              <span class="role-badge factory">工厂</span>
              <span v-if="authStore.isFactory" class="current-label">您当前角色</span>
            </div>
            <div class="role-permissions">
              <div class="permission-item">查看所有部门的定量数据以及审核结果</div>
              <div class="permission-item">审核所有部门的月度数据</div>
              <div class="permission-item">填写本工厂的年度数据</div>
            </div>
          </div>

          <!-- 总部账号 -->
          <div class="role-card" :class="{ 'current-user': authStore.isHeadquarter }">
            <div class="role-card-header">
              <span class="role-badge headquarter">总部</span>
              <span v-if="authStore.isHeadquarter" class="current-label">您当前角色</span>
            </div>
            <div class="role-permissions">
              <div class="permission-item">查看所有工厂月度和年度数据以及审核结果
              </div>
              <div class="permission-item">最终审核确认所有工厂所有部门的定量数据</div>
              <div class="permission-item">最终审核确认所有工厂的年度数据</div>
            </div>
          </div>

          <!-- 管理员账号 -->
          <div class="role-card" :class="{ 'current-user': authStore.isAdmin }">
            <div class="role-card-header">
              <span class="role-badge admin">管理员</span>
              <span v-if="authStore.isAdmin" class="current-label">您当前角色</span>
            </div>
            <div class="role-permissions">
              <div class="permission-item">访问所有数据和审核结果</div>
              <div class="permission-item">账号管理和权限分配</div>
              <div class="permission-item">指标库管理</div>
              <div class="permission-item">系统维护和公告发布</div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 部门权限卡片 -->
    <div v-if="authStore.isDepartment && departmentList.length > 0" class="department-permissions-wrapper">
      <div class="department-info-card modern">
        <div class="card-content">
          <div class="permission-header">
            <div class="header-left">
              <div class="permission-title">
                <h3>您的访问权限</h3>
                <p>您可以管理以下 {{ departmentList.length }} 个类别的数据</p>
              </div>
            </div>
          </div>

          <div class="departments-container">
            <div class="department-grid">
              <div v-for="dept in departmentList" :key="dept.id" class="department-item" :class="dept.name_en"
                   @click="navigateToDepartment(dept)" :style="getDeptIconStyle(dept.name_en)">
                <div class="dept-info">
                  <span class="dept-name">{{ dept.name_zh }}</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 主内容区（填报进度） -->
    <div class="main-layout">
      <div class="main-half">
        <div style="display: flex; flex-direction: row; justify-content: flex-start;">
          <div class="small-select" v-if="authStore.isHeadquarter || authStore.isAdmin" style="margin-right: 20px;">
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
        <div>
          <h2>月度数据进度</h2>
          <div class="progress-list">
            <div class="progress-card" v-for="item in quantitativeProgressData" :key="item.title">
              <div class="progress-title">{{ item.title }}</div>
              <div class="progress-bar-bg">
                <div class="progress-bar" :style="{ width: item.percent + '%' }"></div>
              </div>
              <div class="progress-percent">{{ item.percent }}%</div>
            </div>
          </div>
        </div>

        <div v-if="!authStore.isDepartment">
          <h2>年度数据进度</h2>
          <div class="progress-list">
            <div class="progress-card" v-for="item in analyticalProgressData" :key="item.title">
              <div class="progress-title">{{ item.title }}</div>
              <div class="progress-bar-bg">
                <div class="progress-bar" :style="{ width: item.percent + '%' }"></div>
              </div>
              <div class="progress-percent">{{ item.percent }}%</div>
            </div>
          </div>
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
import {useThemeStore} from "@/stores/themeStore.js";

const authStore = useAuthStore();
const selectionStore = useSelectionStore();
const router = useRouter();
const showPermissionDetails = ref(false)
// 权限错误相关
const permissionError = ref(false);
const permissionErrorMessage = ref('');
const departmentList = computed(() => {
  const deptIds = Array.isArray(authStore.departments?.ids) ? authStore.departments.ids : [];
  if (!deptIds || deptIds.length === 0) return [];
  return (authStore.monthCategories || [])
      .filter(item => item && (deptIds.includes(item.id) || deptIds.includes(item.name_en)));
})

// 方法
const getRoleLabel = (role) => {
  const labels = {
    'department': '部门账号',
    'factory': '工厂账号',
    'headquarter': '总部账号',
    'admin': '管理员'
  }
  return labels[role] || role
}

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

// 进度数据
const analyticalProgressData = ref([]);
const quantitativeProgressData = ref([]);
const currentTime = ref('')

const isDark = ref(null);
const initTheme = () => {
  const savedTheme = localStorage.getItem('darkMode');
  if (savedTheme !== null) {
    isDark.value = JSON.parse(savedTheme);
  } else {
    isDark.value = window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches;
  }
  document.body.classList.toggle('dark-theme', isDark.value);
};
const toggleTheme = () => {
  isDark.value = !isDark.value;
  document.body.classList.toggle('dark-theme', isDark.value);
  localStorage.setItem('darkMode', JSON.stringify(isDark.value));
  const themeStore = useThemeStore();
  themeStore.setMode(isDark.value ? 'dark' : 'light');
};

const fetchProgress = async () => {
  try {
    const factory = selectionStore.selectedFactory;
    const year = selectionStore.selectedYear;
    quantitativeProgressData.value = (await axios.get(`/progress/month?factory=${factory}&year=${year}`)).data;
    if (!authStore.isDepartment) {
      analyticalProgressData.value = (await axios.get(`/progress/year?factory=${factory}&year=${year}`)).data;
    }
  } catch (error) {
    console.error('获取进度数据失败:', error);
  }
};

// 其他函数
const getRoleDisplayName = () => {
  const roleMap = {
    'department': authStore.departments.name,
    'factory': authStore.factory,
    'headquarter': '总部',
    'admin': '管理员'
  }
  return roleMap[authStore.user?.role] || '用户'
}

const getDeptIconStyle = (name_en) => {
  const url = `${axios?.defaults?.baseURL}/static/icons/${name_en}.png?t=${new Date().getTime()}`;
  if (!url) return {backgroundColor: '#eee'};
  return {
    backgroundImage: `url('${url}')`,
    backgroundSize: 'cover',
    backgroundPosition: 'center',
    backgroundRepeat: 'no-repeat',
    backgroundColor: '#f3f4f6'
  }
}

const navigateToDepartment = (category) => {
  selectionStore.selectCategoryMonthly(category)
  router.push(`/monthly-data`)
}

const updateTime = () => {
  const now = new Date()
  currentTime.value = now.toLocaleString('zh-CN', {
    hour: '2-digit',
    minute: '2-digit',
    month: 'short',
    day: 'numeric'
  })
}

onMounted(() => {
  initTheme();
  fetchProgress();
  checkPermissionErrors();
  updateTime()
  setInterval(updateTime, 60000)
});

watch(() => selectionStore.selectedYear, (newYear, oldYear) => {
  if (newYear !== oldYear) fetchProgress();
});

watch(() => selectionStore.selectedFactory, (newFactory, oldFactory) => {
  if ((authStore.isHeadquarter || authStore.isAdmin) && newFactory !== oldFactory) fetchProgress();
});
</script>

<style scoped>
.dashboard {
  padding: 3rem;
  color: #222;
  background: linear-gradient(120deg, #f8d3d3 0%, #b6e1ee 50%, #d1da79 100%);
  background-size: 300% 300%;
  min-height: 100%;
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
  /* vertical stack: title above role controls, both centered */
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 0.6rem;
  text-align: center;
  flex: 1;
  max-width: 500px;
  margin: 0 2rem;
}

.user-role-controls {
  display: inline-flex;
  flex-direction: row;
  align-items: center;
  justify-content: center;
  gap: 0.6rem;
  width: auto;
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
  flex-direction: column;
  justify-content: center;
  align-items: center;
  border-radius: 12px;
  padding: 1rem;
  text-align: center;
  cursor: pointer;
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.dark-theme .department-item {
  opacity: 85%;
}

.department-item:hover {
  transform: translateY(-5px);
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
}

.dept-info {
  margin-top: auto;
  padding: 0.2rem 1.6rem;
  border-radius: 10px;
  background: rgba(245, 237, 237, 0.7);
}

.dark-theme .dept-info {
  background: rgba(16, 15, 15, 0.7);
}

.dept-name {
  font-size: 1rem;
  color: rgba(26, 26, 26, 1);
  font-weight: 500;
}

.dark-theme .dept-name {
  color: #fff;
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

  .card-content {
    padding: 1rem;
  }

  .main-layout {
    flex-direction: row;
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

.modal-header h3 {
  margin: 0;
  color: #333;
  font-size: 1.2rem;
  font-weight: 600;
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
}

.dark-theme .main-half {
  background: #21212c;
  color: #84a2d5;
}

.dark-theme .dashboard {
  background: linear-gradient(60deg, #25020d 0%, #171616 50%, #04021f 100%);
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
  background: linear-gradient(120deg, #f83434 0%, #5890fa 100%);
}

.dark-theme .modal-header h3 {
  color: #e0e0e0;
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

.permission-toggle-btn {
  background: transparent;
  border: none;
  color: #764ba2;
  font-size: 0.95rem;
  cursor: pointer;
  display: inline-flex;
  align-items: center;
  gap: 0.3rem;
  padding: 0.2rem 0.6rem;
  border-radius: 0;
  font-weight: 500;
  text-decoration: underline;
  transition: color 0.2s, text-decoration 0.2s;
  box-shadow: none;
  width: fit-content;
}

.permission-toggle-btn:hover {
  color: #e94560;
  text-decoration: underline;
  background: transparent;
}

.permission-toggle-btn.active {
  color: #28a745;
  text-decoration: underline;
  background: transparent;
}

.permission-details h4,
.filter-section h3,
.records-section h3 {
  color: #222;
  font-weight: 700;
  font-size: 1.2rem;
  margin-bottom: 1rem;
  letter-spacing: 1px;
}

.dark-theme .permission-details h4,
.dark-theme .filter-section h3,
.dark-theme .records-section h3 {
  color: #fff;
  background: linear-gradient(90deg, #e94560 0%, #764ba2 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  text-shadow: 0 2px 8px #53348399;
}

.permission-card {
  background: rgba(255, 255, 255, 0.7);
  border-radius: 16px;
  padding: 1.5rem;
  margin-bottom: 2rem;
  backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.3);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
}

.dark-theme .permission-card {
  background: rgba(12, 13, 28, 0.7);
}

.permission-details {
  margin-top: 1rem;
  padding-top: 1rem;
  border-top: 1px solid rgba(0, 0, 0, 0.1);
}

.roles-grid {
  display: flex;
  gap: 1rem;
  flex-direction: row;
}

.role-card {
  background: rgba(255, 255, 255, 0.8);
  border: 2px solid rgba(103, 126, 234, 0.2);
  border-radius: 12px;
  padding: 1rem;
  transition: all 0.3s ease;
  backdrop-filter: blur(10px);
  width: 25%;
}

.dark-theme .role-card {
  background: rgba(47, 18, 30, 0.7);
}

.role-card:hover {
  background: rgba(255, 255, 255, 0.95);
  border-color: rgba(103, 126, 234, 0.4);
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(103, 126, 234, 0.2);
}

.dark-theme .role-card:hover {
  background: rgba(84, 32, 54, 0.7);
}

.role-card.current-user {
  border-color: #e94560;
  background: linear-gradient(135deg, rgba(34, 0, 255, 0.05) 0%, rgba(246, 42, 42, 0.1) 100%);
  box-shadow: 0 0 20px rgba(233, 69, 96, 0.3);
}

.dark-theme .role-card.current-user {
  background: linear-gradient(135deg, rgba(252, 159, 233, 0.2) 0%, rgba(246, 158, 158, 0.01) 100%);
}

.role-card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 0.75rem;
}

.role-badge {
  padding: 0.5rem 1rem;
  border-radius: 25px;
  font-size: 0.875rem;
  font-weight: 600;
  color: white;
  width: fit-content;
  height: fit-content;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
}

.role-badge.department {
  background: linear-gradient(135deg, rgba(248, 220, 170, 0.5) 0%, #88f513 100%);
}

.role-badge.factory {
  background: linear-gradient(135deg, rgba(25, 238, 92, 0.5) 0%, #03ecb6 100%);
}

.role-badge.headquarter {
  background: linear-gradient(135deg, rgba(130, 198, 246, 0.5) 0%, #a007dc 100%);
}

.role-badge.admin {
  background: linear-gradient(135deg, rgba(248, 109, 204, 0.5) 0%, #ff0013 100%);
}

.current-label {
  background: linear-gradient(135deg, #e94560 0%, #ff6b9d 100%);
  color: white;
  padding: 0.2rem 0.6rem;
  border-radius: 12px;
  font-size: 0.7rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 1px;
}

.role-permissions {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.permission-item {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  color: #495057;
  padding: 0.5rem;
  border-radius: 8px;
  background: rgba(103, 126, 234, 0.05);
  border: 1px solid rgba(103, 126, 234, 0.1);
  font-size: 0.875rem;
}

.dark-theme .permission-item {
  background: rgba(119, 132, 217, 0.1);
  color: rgba(255, 243, 224, 0.9);
}
</style>
