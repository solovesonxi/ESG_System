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
          </svg> 重置
        </button>
      </div>
    </div>

    <!-- 账号表格区 -->
    <div class="records-section">
      <h3>账号列表
        <span class="text-muted">共 {{ accounts.length }} 个账号</span>
      </h3>
      <div class="records-list-modern">
        <div class="record-header-row">
          <span class="header-cell">头像</span>
          <span class="header-cell">用户名</span>
          <span class="header-cell">角色</span>
          <span class="header-cell">工厂</span>
          <span class="header-cell">部门</span>
          <span class="header-cell">电话</span>
          <span class="header-cell">邮箱</span>
        </div>
        <div v-for="account in accounts" :key="account.username" class="record-row" @click="openDetail(account)">
          <span class="cell">
            <img :src="apiClient.defaults.baseURL + (account.avatar ? account.avatar : '/static/avatars/default-avatar.jpg')" class="avatar-img" alt="头像"/>
          </span>
          <span class="cell">{{ account.username }}</span>
          <span class="cell"><span :class="['role-badge', `role-${account.role}`]">{{ roleLabel(account.role) }}</span></span>
          <span class="cell">{{ account.factory }}</span>
          <span class="cell"><span v-for="(dep, idx) in account.departments" :key="dep" class="dept-tag">{{ CATEGORY[dep] || dep }}</span></span>
          <span class="cell">{{ account.phone }}</span>
          <span class="cell">{{ account.email }}</span>
        </div>
        <div v-if="accounts.length === 0" class="empty-state">
          <div class="empty-icon">😢</div>
          <p>暂无账号数据</p>
        </div>
      </div>
    </div>

    <!-- 账号详情弹窗 -->
    <teleport to="body">
      <div v-if="showDetail" class="modal-mask" @click.self="closeDetail">
        <div class="modal-content">
          <div class="modal-body">
            <div class="form-group">
              <label class="form-label">头像</label>
              <img :src="localAvatar || apiClient.defaults.baseURL + (tempAccount.avatar ? tempAccount.avatar : '/static/avatars/default-avatar.jpg')" class="avatar-img large" alt="头像"/>
              <input type="file" id="avatar-upload" @change="uploadAvatar" accept="image/*" hidden>
              <label for="avatar-upload" class="btn btn-secondary">选择图片</label>
              <button v-if="tempAccount.avatar" @click="handleRemoveAvatar" class="btn btn-secondary">使用默认头像</button>
            </div>
            <div class="form-group">
              <label class="form-label">用户名</label>
              <input v-model="tempAccount.username" class="form-input" readonly>
            </div>
            <div class="form-group">
              <label class="form-label">角色</label>
              <select v-model="tempAccount.role" class="form-input">
                <option value="department">部门</option>
                <option value="factory">工厂</option>
                <option value="headquarter">总部</option>
                <option value="admin">管理员</option>
              </select>
            </div>
            <div class="form-group" v-if="tempAccount.role === 'department' || tempAccount.role === 'factory'">
              <label class="form-label">工厂</label>
              <select v-model="tempAccount.factory" class="form-input">
                <option value="">请选择工厂</option>
                <option v-for="f in selectionStore.factories" :key="f" :value="f">{{ f }}</option>
              </select>
            </div>
            <div class="form-group" v-if="tempAccount.role === 'department'">
              <label class="form-label">部门</label>
              <div class="departments-tags">
                <div class="add-dept">
                  <select v-model="newDepartment" class="form-input">
                    <option value="">请选择部门</option>
                    <option v-for="dep in availableDepartments" :key="dep" :value="dep">{{ CATEGORY[dep] || dep }}</option>
                  </select>
                  <button @click="addDepartment" class="btn btn-primary add-btn" :disabled="!newDepartment">＋</button>
                </div>
              </div>
            </div>
            <span v-for="dep in tempAccount.departments" :key="dep" class="dept-tag">
                  {{ CATEGORY[dep] || dep }}
                  <span class="tag-remove" @click.stop="removeDepartment(dep)">×</span>
            </span>
            <div class="form-group">
              <label class="form-label">电话</label>
              <input v-model="tempAccount.phone" class="form-input">
            </div>
            <div class="form-group">
              <label class="form-label">邮箱</label>
              <input v-model="tempAccount.email" class="form-input">
            </div>
            <div class="form-group">
              <label class="form-label">重置密码</label>
              <input v-model="newPassword" type="password" class="form-input" placeholder="输入新密码">
              <button @click="resetPassword" class="reset-btn">确认重置</button>
            </div>
          </div>
          <div class="button-row">
            <button class="btn btn-danger" @click="deleteAccount">注销账号</button>
            <button class="btn btn-primary" @click="saveAccount">保存修改</button>
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
import {removeToast, showWarning} from "@/utils/toast.js";

const authStore = useAuthStore()
const selectionStore = useSelectionStore()
const accounts = ref([])
const filterRole = ref('')
const filterFactory = ref('')
const filterDepartment = ref('')
const keyword = ref('')

const detailAccount = ref({})
const tempAccount = ref(null)
const showDetail = ref(false)
const newPassword = ref('')
const newDepartment = ref('')
const localAvatar = ref(null)

const confirmDialog = async (title, message) => {
  return new Promise((resolve) => {
    const id = showWarning(message, 0)
    const confirmBtn = document.createElement('button')
    confirmBtn.textContent = '确认'
    confirmBtn.className = 'toast-confirm-btn'
    confirmBtn.onclick = () => {
      removeToast(id)
      resolve(true)
    }

    const cancelBtn = document.createElement('button')
    cancelBtn.textContent = '取消'
    cancelBtn.className = 'toast-cancel-btn'
    cancelBtn.onclick = () => {
      removeToast(id)
      resolve(false)
    }

    const toastElement = document.querySelector(`.toast-container div[key=\"${id}\"]`)
    if (toastElement) {
      toastElement.appendChild(confirmBtn)
      toastElement.appendChild(cancelBtn)
    }
  })
}

const handleRemoveAvatar = () => {
  localAvatar.value = null;
  tempAccount.value.avatar = '/static/avatars/default-avatar.jpg';
}

const availableDepartments = computed(() => {
  console.log('availableDepartments computed')
  console.log('detailAccount.departments:', detailAccount.value?.departments)
  console.log('authStore.departments:', authStore.departments)
  if (!detailAccount.value || !detailAccount.value.departments) {
    return authStore.QUANT_TYPES;
  }
  return authStore.QUANT_TYPES.filter(dep => !detailAccount.value.departments.includes(dep) && !tempAccount.value.departments.includes(dep));
})

watch(() => tempAccount.value?.role, (newRole, oldRole) => {
  console.log(`tempAccount.role changed from ${oldRole} to ${newRole}`);
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
      keyword: keyword.value
    }
  }).then(res => {
    accounts.value = res.data.accounts || []
  })
}

function resetFilters() {
  filterRole.value = ''
  filterFactory.value = ''
  filterDepartment.value = ''
  keyword.value = ''
  fetchAccounts()
}

function openDetail(account) {
  detailAccount.value = account;
  tempAccount.value = deepClone(account);
  showDetail.value = true
}

function closeDetail() {
  showDetail.value = false;
  tempAccount.value = null;
  newPassword.value = '';
  newDepartment.value = '';
  localAvatar.value = null;
}

async function saveAccount() {
  try {
    // 提交 tempAccount 到后端
    await axios.post('/api/account/update', tempAccount.value);
    // 同步到 detailAccount
    Object.assign(detailAccount.value, tempAccount.value);
    showDetail.value = false;
    tempAccount.value = null;
  } catch (e) {
    alert('保存失败');
  }
}

function resetPassword() {
  if (!newPassword.value) {
    alert('请输入新密码')
    return
  }
  axios.post('/admin/account/reset-password', {
    username: detailAccount.value.username,
    newPassword: newPassword.value
  }).then(() => {
    newPassword.value = ''
    alert('密码重置成功')
  })
}

async function deleteAccount() {
  const isConfirmed = await confirmDialog('注销账号', '确定要注销该账号吗？此操作不可恢复。')
  if (!isConfirmed) return
  axios.post('/admin/account/delete', {
    username: detailAccount.value.username
  }).then(() => {
    fetchAccounts()
    closeDetail()
  })
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
  tempAccount.value.departments = tempAccount.value.departments.filter(d => d !== dep)
}

function addDepartment() {
  if (newDepartment.value && tempAccount.value.departments && !tempAccount.value.departments.includes(newDepartment.value)) {
    tempAccount.value.departments.push(newDepartment.value)
    newDepartment.value = ''
  }
}


watch([filterRole, filterFactory, filterDepartment, keyword], fetchAccounts)

onMounted(() => {
  fetchAccounts();
  selectionStore.initSelection();
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
  margin-right: 80px;
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
  margin-bottom:  6px;
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
  width: 100%;
  max-width: 600px;
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
  margin-bottom: 20px;
  display: flex;
  justify-content: flex-start;
  flex-wrap: wrap;
  flex-direction: row;
  align-items: center;
  gap: 16px;
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