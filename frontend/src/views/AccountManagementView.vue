<template>
  <div class="review-management">
    <!-- 过滤器区 -->
    <div class="filter-section card">
      <h3>筛选账号</h3>
      <div class="filter-grid-modern">
        <div class="filter-item">
          <label>角色</label>
          <select v-model="filterRole">
            <option value="">全部</option>
            <option value="department">部门</option>
            <option value="factory">工厂</option>
            <option value="headquarter">总部</option>
            <option value="admin">管理员</option>
          </select>
        </div>
        <div class="filter-item">
          <label>工厂</label>
          <select v-model="filterFactory">
            <option value="">全部</option>
            <option v-for="f in selectionStore.factories" :key="f" :value="f">{{ f }}</option>
          </select>
        </div>
        <div class="filter-item">
          <label>部门</label>
          <select v-model="filterDepartment">
            <option value="">全部</option>
            <option v-for="d in authStore.QUANT_TYPES" :key="d" :value="d">{{ CATEGORY[d] }}</option>
          </select>
        </div>
        <div class="filter-item">
          <label>搜索用户名/电话/邮箱</label>
          <input v-model="keyword" class="filter-input" placeholder="请输入搜索内容"/>
        </div>
        <button class="reset-btn" @click="resetFilters">
          <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 16 16">
            <path d="M8 3a5 5 0 1 0 4.546 2.914.5.5 0 0 1 .908-.417A6 6 0 1 1 8 2v1z"/>
            <path
                d="M8 4.466V.534a.25.25 0 0 1 .41-.192l2.36 1.966c.12.1.12.284 0 .384L8.41 4.658A.25.25 0 0 1 8 4.466z"/>
          </svg>
          重置
        </button>
      </div>
    </div>

    <!-- 账号表格区 -->
    <div class="records-section">
      <div class="records-header-row"
           style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 16px;">
        <h3 style="margin: 0;">账号列表 <span class="text-muted">共 {{ accounts.length }} 个账号</span></h3>
        <div class="quick-actions">
          <button class="btn btn-secondary" @click="openAddAccount" title="添加账号"><span class="icon-add"></span> 添加账号
          </button>
          <button class="btn btn-secondary" @click="triggerImport" title="批量导入"><span class="icon-upload"></span>
            批量导入
          </button>
          <button class="btn btn-secondary" @click="handleExport" title="导出列表"><span class="icon-download"></span>
            导出列表
          </button>
          <button class="btn btn-secondary" @click="refreshAccounts" title="刷新"><span class="icon-refresh"></span> 刷新
          </button>
          <input type="file" ref="importFile" style="display:none" @change="handleImport" accept=".csv"/>
        </div>
      </div>
      <div class="records-list-modern">
        <div class="record-header-row">
          <span class="header-cell">头像</span>
          <span class="header-cell">用户名</span>
          <span class="header-cell">角色</span>
          <span class="header-cell">工厂</span>
          <span class="header-cell">部门</span>
          <span class="header-cell">电话</span>
          <span class="header-cell">邮箱</span>
          <span class="header-cell">状态</span>
        </div>
        <div v-for="account in accounts" :key="account.username" class="record-row">
          <span class="cell" @click="openDetail(account)">
            <img
                :src="apiClient.defaults.baseURL + (account.avatar ? account.avatar : '/static/avatars/default-avatar.jpg')"
                class="avatar-img" alt="头像"/>
          </span>
          <span class="cell" @click="openDetail(account)">{{ account.username }}</span>
          <span class="cell" @click="openDetail(account)"><span
              :class="['role-badge', `role-${account.role}`]">{{ roleLabel(account.role) }}</span></span>
          <span class="cell" @click="openDetail(account)">{{ account.factory }}</span>
          <span class="cell" @click="openDetail(account)"><span v-for="(dep, idx) in account.departments" :key="dep"
                                                                class="dept-tag">{{
              CATEGORY[dep] || dep
            }}</span></span>
          <span class="cell" @click="openDetail(account)">{{ account.phone }}</span>
          <span class="cell" @click="openDetail(account)">{{ account.email }}</span>
          <span class="cell">
            <label class="switch">
              <input type="checkbox" v-model="account.is_active" @click.stop="toggleAccountStatus(account)">
              <span class="slider round"></span>
            </label>
          </span>
        </div>
        <div v-if="accounts.length === 0" class="empty-state">
          <div class="empty-icon">😢</div>
          <p>暂无账号数据</p>
        </div>
      </div>

      <!-- 分页条 -->
      <div class="pagination-bar pagination-horizontal">
        <button @click="goToPage(1)" :disabled="currentPage===1">首页</button>
        <button @click="goToPage(currentPage-1)" :disabled="currentPage===1">上一页</button>
        <span class="page-text">第 <input type="number" v-model.number="currentPage" min="1" :max="totalPages"
                                          style="width:3em;"> 页 / 共 {{ totalPages }} 页</span>
        <button @click="goToPage(currentPage+1)" :disabled="currentPage===totalPages">下一页</button>
        <button @click="goToPage(totalPages)" :disabled="currentPage===totalPages">尾页</button>
      </div>
    </div>

    <!-- 账号详情弹窗 -->
    <teleport to="body">
      <div v-if="showDetail" class="modal-mask" @click.self="closeDetail">
        <div class="modal-content">
          <div class="modal-header" style="text-align: center;margin-top: 5%;">
            <h3>{{ detailAccount.value && detailAccount.value.id ? '编辑账号' : '注册账号' }}</h3>
          </div>
          <div class="modal-body">
            <div class="form-group">
              <label class="form-label">头像</label>
              <img
                  :src="localAvatar || (apiClient.defaults.baseURL + (detailAccount.avatar || '/static/avatars/default-avatar.jpg'))"
                  class="avatar-img large" alt="头像"/>
              <input type="file" id="avatar-upload" @change="uploadAvatar" accept="image/*" hidden>
              <label for="avatar-upload" class="btn btn-secondary">选择图片</label>
              <button v-if="detailAccount.avatar" @click="handleRemoveAvatar" class="btn btn-secondary">使用默认头像
              </button>
            </div>
            <div class="form-group">
              <label class="form-label">用户名</label>
              <input v-model="detailAccount.username" class="form-input" placeholder="请输入用户名">
            </div>
            <div class="form-group">
              <label class="form-label">角色</label>
              <select v-model="detailAccount.role" class="form-input">
                <option value="department">部门</option>
                <option value="factory">工厂</option>
                <option value="headquarter">总部</option>
                <option value="admin">管理员</option>
              </select>
            </div>
            <div class="form-group" v-if="detailAccount.role === 'department' || detailAccount.role === 'factory'">
              <label class="form-label">工厂</label>
              <select v-model="detailAccount.factory" class="form-input">
                <option value="">请选择工厂</option>
                <option v-for="f in selectionStore.factories" :key="f" :value="f">{{ f }}</option>
              </select>
            </div>
            <div class="form-group" v-if="detailAccount.role === 'department'">
              <label class="form-label">部门</label>
              <div class="departments-tags">
                <div class="add-dept">
                  <select v-model="newDepartment" class="form-input">
                    <option value="">请选择部门</option>
                    <option v-for="dep in availableDepartments" :key="dep" :value="dep">{{
                        CATEGORY[dep] || dep
                      }}
                    </option>
                  </select>
                  <button @click="addDepartment" class="btn btn-primary add-btn" :disabled="!newDepartment">＋</button>
                </div>
              </div>
            </div>
            <span v-for="dep in detailAccount.departments" :key="dep" class="dept-tag"
                  v-if="detailAccount.role === 'department'">
                  {{ CATEGORY[dep] || dep }}
                  <span class="tag-remove" @click.stop="removeDepartment(dep)">×</span>
            </span>
            <div class="form-group">
              <label class="form-label">电话</label>
              <input v-model="detailAccount.phone" class="form-input">
            </div>
            <div class="form-group">
              <label class="form-label">邮箱</label>
              <input v-model="detailAccount.email" class="form-input">
            </div>
            <div class="form-group">
              <label class="form-label">密码</label>
              <input
                  v-model="newPassword"
                  :type="showPassword ? 'text' : 'password'"
                  class="form-input"
                  placeholder="设置密码"
                  autocomplete="new-password"
                  style="padding-right: 40px;"
              >
              <button
                  type="button"
                  class="password-toggle"
                  @click="showPassword = !showPassword"
                  tabindex="-1"
              >
                <svg v-if="showPassword" width="22" height="22" viewBox="0 0 22 22">
                  <path d="M1 11C3.5 5 8.5 2 11 2C13.5 2 18.5 5 21 11C18.5 17 13.5 20 11 20C8.5 20 3.5 17 1 11Z"
                        stroke="#764ba2" stroke-width="2"/>
                  <path d="M4 4L18 18" stroke="#764ba2" stroke-width="2"/>
                  <circle cx="11" cy="11" r="3" stroke="#764ba2" stroke-width="2"/>
                </svg>
                <svg v-else width="22" height="22" viewBox="0 0 22 22">
                  <path d="M1 11C3.5 5 8.5 2 11 2C13.5 2 18.5 5 21 11C18.5 17 13.5 20 11 20C8.5 20 3.5 17 1 11Z"
                        stroke="#764ba2" stroke-width="2"/>
                  <circle cx="11" cy="11" r="3" stroke="#764ba2" stroke-width="2"/>
                </svg>
              </button>
            </div>
          </div>
          <div class="button-row">
            <button v-if="detailAccount.id" class="btn btn-danger" @click="deleteAccount">注销账号</button>
            <button class="btn btn-primary" @click="saveAccount">{{
                detailAccount.id ? '保存修改' : '确认添加'
              }}
            </button>
          </div>
        </div>
      </div>
      <!-- 确认注销弹窗 -->
      <div v-if="showConfirmDelete" class="modal-mask" style="z-index:2000;" @click.self="cancelDeleteAccount">
        <div class="modal-content" style="max-width:400px;">
          <div class="modal-body" style="text-align:center;">
            <p>确定要注销该账号吗？此操作不可恢复。</p>
          </div>
          <div class="button-row">
            <button class="btn btn-danger" @click="confirmDeleteAccount">确认注销</button>
          </div>
        </div>
      </div>
    </teleport>
  </div>
</template>

<script setup>
import {computed, onMounted, ref, watch} from 'vue'
import axios from '@/utils/axios'
import apiClient from '@/utils/axios'
import {useAuthStore} from '@/stores/authStore.js'
import {useSelectionStore} from '@/stores/selectionStore.js'
import {CATEGORY} from '@/constants/indicators.js'
import {handleError, showError, showInfo, showSuccess} from "@/utils/toast.js";
import debounce from 'lodash/debounce';

const authStore = useAuthStore()
const selectionStore = useSelectionStore()
const accounts = ref([])
const filterRole = ref('')
const filterFactory = ref('')
const filterDepartment = ref('')
const keyword = ref('')

const detailAccount = ref(null)
const showDetail = ref(false)
const newPassword = ref('')
const newDepartment = ref('')
const localAvatar = ref(null)
const showPassword = ref(false)
const showConfirmDelete = ref(false)
const importFile = ref(null);
const currentPage = ref(1);
const pageSize = ref(10);
const totalPages = ref(1);

const handleRemoveAvatar = () => {
  localAvatar.value = null;
  detailAccount.value.avatar = '/static/avatars/default-avatar.jpg';
}

const availableDepartments = computed(() => {
  if (!detailAccount.value || !detailAccount.value.departments) {
    return authStore.QUANT_TYPES;
  }
  return authStore.QUANT_TYPES.filter(dep => !detailAccount.value.departments.includes(dep));
})

watch(() => detailAccount.value?.role, (newRole, oldRole) => {
  console.log(`detailAccount.role changed from ${oldRole} to ${newRole}`);
});

function deepClone(obj) {
  return JSON.parse(JSON.stringify(obj));
}

function roleLabel(role) {
  switch (role) {
    case 'department':
      return '部门'
    case 'factory':
      return '工厂'
    case 'headquarter':
      return '总部'
    case 'admin':
      return '管理员'
    default:
      return role
  }
}

function fetchAccounts() {
  axios.get('/admin/account', {
    params: {
      role: filterRole.value,
      factory: filterFactory.value,
      department: filterDepartment.value,
      keyword: keyword.value,
      page: currentPage.value,
      page_size: pageSize.value
    }
  }).then(res => {
      accounts.value = res.data.accounts || []
      totalPages.value = Math.ceil(res.data.total / pageSize.value)
    }).catch(error => {
      console.error('获取账号列表失败:', error)
      handleError(error)
    })
}


function resetFilters() {
  filterRole.value = ''
  filterFactory.value = ''
  filterDepartment.value = ''
  keyword.value = ''
  currentPage.value = 1;
  fetchAccounts()
}

function openDetail(account) {
  detailAccount.value = deepClone(account);
  newPassword.value = '';
  showDetail.value = true
}

function closeDetail() {
  localAvatar.value = null;
  newPassword.value = '';
  newDepartment.value = '';
  detailAccount.value = null;
  showDetail.value = false;
}

function openAddAccount() {
  detailAccount.value = {
    username: '',
    role: '',
    phone: '',
    email: '',
    factory: '',
    departments: [],
    avatar: '/static/avatars/default-avatar.jpg',
  };
  newPassword.value = '';
  localAvatar.value = null;
  showDetail.value = true;
}

async function saveAccount() {
  try {
    detailAccount.value.hashed_password = newPassword.value;
    const submitData = {
      ...detailAccount.value,
      localAvatar: localAvatar.value
    };
    let response;
    if (!detailAccount.value.id) {
      // 注册账号
      response = await axios.post('/admin/account/add', submitData);
    } else {
      // 更新账号
      response = await axios.patch('/admin/account/update', submitData);
    }
    if (response.data.status === "success") {
      showSuccess(detailAccount.value.id ? '修改成功' : '添加成功');
      showDetail.value = false;
      detailAccount.value = null;
      fetchAccounts();
    } else {
      showInfo('操作失败，请稍后重试');
    }
  } catch (error) {
    handleError(error);
  }
}

async function deleteAccount() {
  showConfirmDelete.value = true;
}

async function confirmDeleteAccount() {
  try {
    const response = await axios.delete('/admin/account/delete', {
      data: {id: detailAccount.value.id}
    })
    if (response.data.status === "success") {
      fetchAccounts()
      closeDetail()
      showSuccess('注销成功')
    } else {
      showError('注销失败')
    }
  } catch (error) {
    handleError(error)
  } finally {
    showConfirmDelete.value = false;
  }
}

function cancelDeleteAccount() {
  showConfirmDelete.value = false;
}

function uploadAvatar(e) {
  const file = e.target.files[0]
  if (!file) return
  const reader = new FileReader()
  reader.onload = (event) => {
    localAvatar.value = event.target.result
  }
  reader.readAsDataURL(file)
}


function removeDepartment(dep) {
  detailAccount.value.departments = detailAccount.value.departments.filter(d => d !== dep)
}

function addDepartment() {
  if (newDepartment.value) {
    if (!detailAccount.value.departments) {
      detailAccount.value.departments = []
    }
    if (!detailAccount.value.departments.includes(newDepartment.value)) {
      detailAccount.value.departments.push(newDepartment.value)
      newDepartment.value = ''
    }
  }
}

function triggerImport() {
  importFile.value.click();
}

async function handleImport(event) {
  const file = event.target.files[0];
  if (!file) return;
  const reader = new FileReader();
  reader.onload = async (e) => {
    const content = e.target.result;
    const lines = content.split('\n').filter(line => line.trim());
    const dataLines = lines.slice(1);
    const importedAccounts = dataLines.map(line => {
      const [username, role, factory, departments, phone, email, is_active] = line.split(',');
      return {
        username, role, factory, departments: departments ? departments.split(';') : [],
        phone, email, is_active: is_active === 'true', hashed_password: '123456'
      };
    });
    showInfo('正在导入账号，请稍候...');
    try {
      const response = await apiClient.post('/admin/account/import', importedAccounts);
      if (response.data.status === 'success') {
        showSuccess(`导入成功 ${response.data.imported} 条，失败 ${response.data.failed.length} 条`);
        fetchAccounts(); // 刷新账号列表
      } else {
        showError('导入失败');
      }
    } catch (error) {
      handleError(error);
    }
  };
  reader.readAsText(file);
}


function handleExport() {
  const header = '用户名,角色,工厂,部门,电话,邮箱,启用';
  const csvContent = accounts.value.map(account => {
    return [account.username || '', account.role || '', account.factory || '', (account.departments || []).join(';') || '',
      account.phone || '', account.email || '', account.is_active].join(',');
  }).join('\n');
  const blob = new Blob([header + '\n' + csvContent], {type: 'text/csv'});
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = 'accounts.csv';
  document.body.appendChild(a);
  a.click();
  document.body.removeChild(a);
  URL.revokeObjectURL(url);
}

function refreshAccounts() {
  fetchAccounts();
  showInfo('账号列表已刷新');
}

async function toggleAccountStatus(account) {
  try {
    console.log('Toggling account status from', account.is_active);
    console.log('1账号已', account.is_active ? '激活' : '禁用')
    const response = await axios.post('/admin/account/toggle-status', {id: account.id, is_active: !account.is_active});
    console.log(response)
    if (response.data.status === 'success') {
      showSuccess('账号已' + (account.is_active ? '激活' : '禁用'));
      console.log('3账号已', account.is_active ? '激活' : '禁用')
    } else {
      account.is_active = !account.is_active;
      showError('状态更新失败，请稍后重试');
    }
  } catch (error) {
    account.is_active = !account.is_active;
    showError('状态更新失败');
  }
  console.log('Toggled account status for', account, 'to', account.is_active);
}

function goToPage(page) {
  if (page < 1 || page > totalPages.value) return;
  currentPage.value = page;
  fetchAccounts();
}

const debouncedFetchAccounts = debounce(() => {
  fetchAccounts();
}, 300);

watch([filterRole, filterFactory, filterDepartment, keyword, currentPage], () => {
  debouncedFetchAccounts();
})

onMounted(() => {
  selectionStore.initSelection();
  fetchAccounts();
})

</script>

<style scoped>
@import '@/assets/filter-list-styles.css';

.filter-title svg {
  width: 20px;
  height: 20px;
  color: #764ba2;
}

.dark-theme .filter-title svg {
  color: #7ab7ff;
}

.filter-input {
  width: 100%;
  height: fit-content;
  padding: 10px 14px;
  border-radius: 8px;
  border: 1px solid rgba(118, 75, 162, 0.3);
  background: rgba(255, 255, 255, 0.8);
  color: #374151;
  font-size: 14px;
  transition: all 0.3s ease;
}

.dark-theme .filter-input {
  background: rgba(26, 26, 46, 0.8);
  border-color: rgba(118, 75, 162, 0.5);
  color: #b0d9ff;
}

.filter-input:focus {
  outline: none;
  border-color: #764ba2;
  box-shadow: 0 0 0 3px rgba(118, 75, 162, 0.2);
}

.btn {
  padding: 10px 18px;
  border-radius: 8px;
  font-weight: 500;
  font-size: 14px;
  cursor: pointer;
  transition: all 0.3s ease;
  border: none;
  display: flex;
  align-items: center;
  gap: 6px;
}

.btn-primary {
  background: linear-gradient(90deg, #91d5de, #ac7ed7);
  color: white;
  width: fit-content;
  justify-self: center;
  margin-top: 0;
}

.btn-primary:hover {
  background: linear-gradient(90deg, #5aa0a9, #7e56a4);
  transform: translateY(-2px);
}

.dark-theme .btn-primary {
  background: linear-gradient(90deg, #035862, #4c038f);
  color: white;
}

.dark-theme .btn-primary:hover {
  background: linear-gradient(90deg, #046e7a, #5f04b2);
}

.btn-secondary {
  background: rgba(255, 255, 255, 0.9);
  border: 1px solid rgba(118, 75, 162, 0.3);
  color: #764ba2;
  width: fit-content;
  margin-top: 0;
}

.dark-theme .btn-secondary {
  background: rgba(26, 26, 46, 0.9);
  border-color: rgba(118, 75, 162, 0.5);
  color: #b0d9ff;
}

.btn-secondary:hover {
  background: rgba(255, 255, 255, 0.8);
}

.dark-theme .btn-secondary:hover {
  background: rgba(41, 41, 75, 0.9);
}

.btn-danger {
  background: linear-gradient(90deg, #e178b8, #e14c61);
  color: white;
  width: fit-content;
  justify-self: center;
  margin-top: 0;
}

.btn-danger:hover {
  background: linear-gradient(90deg, #cc4e9c, #d90826);
}

.dark-theme .btn-danger {
  background: linear-gradient(90deg, #a40366, #96041a);
}

.dark-theme .btn-danger:hover {
  background: linear-gradient(90deg, #c91383, #c50522);
}

.text-muted {
  color: #6b7280;
  font-size: 14px;
}

.dark-theme .text-muted {
  color: #7ab7ff;
}

.account-table th {
  background-color: #f8f9fa;
  color: #222;
  text-align: left;
  padding: 14px 16px;
  font-weight: 600;
  font-size: 1rem;
  align-items: center;
  margin-bottom: 5px;
}

.account-table td {
  padding: 16px;
  border-bottom: 1px solid #e5e7eb;
  vertical-align: middle;
}

.dark-theme .account-table td {
  border-bottom: 1px solid #3a3f4b;
}

.dept-tag {
  background: rgba(124, 58, 237, 0.1);
  color: #7c3aed;
  padding: 4px 10px;
  border-radius: 20px;
  font-size: 12px;
  font-weight: 500;
  margin-right: 6px;
  margin-bottom: 6px;
  display: inline-block;
}

.dark-theme .dept-tag {
  background: rgba(124, 58, 237, 0.2);
  color: #b0d9ff;
}

.role-badge {
  padding: 6px 12px;
  border-radius: 20px;
  font-size: 13px;
  font-weight: 500;
  color: #ffffff;
}

.role-department {
  background: linear-gradient(135deg, rgba(121, 76, 0, 0.65) 0%, #85ff00 100%);
}

.role-factory {
  background: linear-gradient(135deg, rgba(0, 108, 32, 0.65) 0%, #00f6ff 100%);
}

.role-headquarter {
  background: linear-gradient(135deg, rgba(0, 100, 100, 0.65) 0%, #b700ff 100%);
}

.role-admin {
  background: linear-gradient(135deg, rgba(0, 10, 100, 0.93) 0%, #ff0013 100%);
}

.avatar-img {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  object-fit: cover;
  border: 2px solid #e5e7eb;
}

.dark-theme .avatar-img {
  border: 2px solid #3a3f4b;
}

.avatar-img.large {
  width: 80px;
  height: 80px;
}

.empty-state {
  text-align: center;
  padding: 40px 0;
  color: #6b7280;
}

.dark-theme .empty-state {
  color: #7ab7ff;
}

.empty-icon {
  font-size: 48px;
  margin-bottom: 16px;
  opacity: 0.5;
}

.button-row {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  margin-bottom: 30px;
  gap: 10%;
}

.modal-mask {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.35);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  padding: 20px;
  animation: fadeIn 0.3s ease;
  backdrop-filter: blur(4px);
  -webkit-backdrop-filter: blur(4px);
}

@keyframes fadeIn {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}

.modal-content {
  background: #fff;
  color: #222;
  border-radius: 16px;
  width: 60%;
  max-width: 560px;
  max-height: 90vh;
  overflow-y: auto;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.18);
  animation: slideUp 0.3s ease;
}

.dark-theme .modal-content {
  background: #191d25;
  color: #b0d9ff;
}

@keyframes slideUp {
  from {
    transform: translateY(20px);
    opacity: 0;
  }
  to {
    transform: translateY(0);
    opacity: 1;
  }
}

.modal-body {
  padding: 24px;
}

.form-group {
  margin-left: 24px;
  margin-bottom: 20px;
  display: flex;
  justify-content: flex-start;
  flex-wrap: wrap;
  flex-direction: row;
  align-items: center;
  gap: 18px;
}

.form-label {
  margin-bottom: 0;
  min-width: 80px;
  font-weight: 500;
  color: #374151;
}

.dark-theme .form-label {
  color: #b0d9ff;
}

.form-input, select, input[type="password"] {
  flex: 1 1 180px;
  min-width: 120px;
  max-width: 300px;
  margin-bottom: 0;
  padding: 10px 14px;
  border-radius: 8px;
  border: 1px solid rgba(118, 75, 162, 0.3);
  background: rgba(255, 255, 255, 0.8);
  color: #374151;
  font-size: 14px;
}

.dark-theme .form-input,
.dark-theme select,
.dark-theme input[type="password"] {
  background: rgba(26, 26, 46, 0.8);
  border-color: rgba(118, 75, 162, 0.5);
  color: #b0d9ff;
}

.departments-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  align-items: center;
}

.add-dept {
  display: flex;
  gap: 8px;
  align-items: center;
}

.password-wrapper {
  position: relative;
  width: 100%;
  display: flex;
  align-items: center;
}

.password-wrapper .form-input {
  width: 100%;
  padding-right: 40px;
}

.password-toggle {
  position: absolute;
  right: 10px;
  top: 50%;
  transform: translateY(-50%);
  background: none;
  border: none;
  color: #764ba2;
  cursor: pointer;
  font-size: 18px;
  width: 30px;
  height: 30px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  transition: all 0.3s ease;
  z-index: 2;
}

.password-toggle:hover {
  background: rgba(118, 75, 162, 0.08);
}

.dark-theme .password-toggle {
  color: #b0d9ff;
}

.dark-theme .password-toggle:hover {
  background: rgba(118, 75, 162, 0.18);
}

.add-account-btn {
  color: #222;
}

.dark-theme .add-account-btn {
  color: #fff;
}

.quick-actions {
  display: flex;
  gap: 12px;
  align-items: center;
}

.switch {
  position: relative;
  display: inline-block;
  width: 44px;
  height: 24px;
}

.switch input {
  opacity: 0;
  width: 0;
  height: 0;
}

.slider {
  position: absolute;
  cursor: pointer;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: #ccc;
  transition: .4s;
  border-radius: 24px;
}

.slider:before {
  position: absolute;
  content: "";
  height: 18px;
  width: 18px;
  left: 3px;
  bottom: 3px;
  background-color: white;
  transition: .4s;
  border-radius: 50%;
}

input:checked + .slider {
  background-color: #2196F3;
}

input:checked + .slider:before {
  transform: translateX(20px);
}

.slider.round {
  border-radius: 24px;
}

.icon-add::before {
  content: '\2795';
  margin-right: 4px;
}

.icon-upload::before {
  content: '\21E9';
  margin-right: 4px;
}

.icon-download::before {
  content: '\21E7';
  margin-right: 4px;
}

.icon-refresh::before {
  content: '\21BB';
  margin-right: 4px;
}

.records-list-modern {
  width: 100%;
}

.record-header-row .header-cell:last-child,
.record-row .cell:last-child {
  text-align: right;
  padding-right: 30px;
}

.record-row .cell:last-child {
  display: flex;
  justify-content: flex-end;
}

.record-row .cell {
  display: flex;
  width: 100%;
}

@media (max-width: 768px) {
  .add-dept {
    flex-direction: column;
  }

  .modal-content {
    margin: 0;
    max-height: calc(100vh - 40px);
  }

  .modal-footer .btn {
    width: 100%;
  }
}
</style>
