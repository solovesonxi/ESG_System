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
          <label>数据类型</label>
          <select v-model="filterDepartment">
            <option value=0>全部</option>
            <option v-for="d in authStore.monthCategories" :key="d.id" :value="d.id">{{ d.name_zh }}</option>
          </select>
        </div>
        <div class="filter-item">
          <label>搜索用户名/电话/邮箱</label>
          <input v-model="keyword" class="filter-input" placeholder="请输入搜索内容"/>
        </div>
        <button class="btn btn-secondary" @click="resetFilters">
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
      <div class="records-header-row">
        <h3 >账号列表 <span class="text-muted">（共 {{ totalCount }} 个账号）</span></h3>
        <div class="quick-actions">
          <button class="btn btn-secondary" @click="openAddAccount" title="添加账号"><span class="icon-add"></span> 添加账号</button>
          <button class="btn btn-secondary" @click="triggerImport" title="批量导入"><span class="icon-upload"></span>批量导入</button>
          <button class="btn btn-secondary" @click="handleExport" title="导出列表"><span class="icon-download"></span>导出列表</button>
          <button class="btn btn-secondary" @click="refreshAccounts" title="刷新"><span class="icon-refresh"></span> 刷新</button>
          <input type="file" ref="importFile" style="display:none" @change="handleImport" accept=".csv"/>
        </div>
      </div>

      <div class="records-list-modern">
        <div class="record-header-row">
          <span class="header-cell">头像</span>
          <span class="header-cell">用户名</span>
          <span class="header-cell">角色</span>
          <span class="header-cell">工厂</span>
          <span class="header-cell">数据类型</span>
          <span class="header-cell">电话</span>
          <span class="header-cell">邮箱</span>
          <span class="header-cell">启用</span>
        </div>
        <div v-for="account in accounts" :key="account.username" class="record-row">
          <span class="cell" @click="openDetail(account)">
            <img :src="apiClient.defaults.baseURL + (account.avatar ? account.avatar : '/static/avatars/default-avatar.jpg')"
                class="avatar-img" alt="头像"/>
          </span>
          <span class="cell" @click="openDetail(account)">{{ account.username }}</span>
          <span class="cell" @click="openDetail(account)"><span
              :class="['role-badge', `role-${account.role}`]">{{ roleLabel(account.role) }}</span></span>
          <span class="cell" @click="openDetail(account)">{{ account.factory }}</span>
          <span class="cell" @click="openDetail(account)">
            <span v-if="account.departments && account.departments.ids" v-for="dep in account.departments.ids || []" :key="dep" class="dept-tag">{{ authStore.getCategoryMapping(dep).name_zh }}</span>
          </span>
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
          <div class="modal-header">
            <h3>{{ detailAccount && detailAccount.id ? '编辑账号' : '添加账号' }}</h3>
          </div>
          <div class="modal-body">
            <div class="form-group">
              <label class="form-label">头像</label>
              <img :src="localAvatar || (apiClient.defaults.baseURL + (detailAccount.avatar || '/static/avatars/default-avatar.jpg'))"
                  class="avatar-img large" alt="头像"/>
              <input type="file" id="avatar-upload" @change="uploadAvatar" accept="image/*" hidden>
              <label for="avatar-upload" class="btn btn-secondary">选择图片</label>
              <label v-if="detailAccount.avatar" @click="handleRemoveAvatar" class="btn btn-secondary">使用默认头像</label>
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
              <input v-model="detailAccount.departments.name" class="form-input" placeholder="请输入部门名称" style="width: 200px;">
              <select v-model="newDepartment" class="form-input" style="max-width: 150px;">
                <option value=0>请选择数据类型</option>
                <option v-for="dep in availableDepartments" :key="dep.id" :value="dep.id">{{ dep.name_zh }}</option>
              </select>
              <button @click="addDepartment" class="btn btn-primary" style="width: fit-content" :disabled="!newDepartment">＋</button>
            </div>
            <span v-for="dep in detailAccount.departments.ids" :key="dep" class="dept-tag"
                  v-if="detailAccount.role === 'department'">
                  {{ authStore.getCategoryMapping(dep).name_zh }}
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
              <input v-model="newPassword" :type="showPassword ? 'text' : 'password'" class="form-input"
                  placeholder="设置密码" autocomplete="new-password" style="padding-right: 40px;">
              <button type="button" class="password-toggle" @click="showPassword = !showPassword">
                <i :class="showPassword ? 'fas fa-eye' : 'fas fa-eye-slash'"></i>
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
import {handleError, showError, showInfo, showSuccess} from "@/utils/toast.js";
import debounce from 'lodash/debounce';

const authStore = useAuthStore()
const selectionStore = useSelectionStore()
const accounts = ref([])
const filterRole = ref('')
const filterFactory = ref('')
const filterDepartment = ref(0)
const keyword = ref('')

const detailAccount = ref(null)
const showDetail = ref(false)
const newPassword = ref('')
const newDepartment = ref(0)
const localAvatar = ref(null)
const showPassword = ref(false)
const showConfirmDelete = ref(false)
const importFile = ref(null);
const currentPage = ref(1);
const pageSize = ref(10);
const totalPages = ref(1);
const totalCount = ref(0);
const handleRemoveAvatar = () => {
  localAvatar.value = null;
  detailAccount.value.avatar = '/static/avatars/default-avatar.jpg';
}

const availableDepartments = computed(() => {
  if (detailAccount.value && detailAccount.value.departments && detailAccount.value.departments.ids) {
    return authStore.monthCategories.filter(dep => !detailAccount.value.departments.ids.includes(dep.id));
  }
  return authStore.monthCategories;
})

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
  axios.get('/account', {
    params: {
      role: filterRole.value,
      factory: filterFactory.value,
      department: filterDepartment.value,
      keyword: keyword.value,
      page: currentPage.value,
      page_size: pageSize.value
    }
  }).then(res => {
    console.log(res.data)
    accounts.value = res.data.accounts || []
    totalCount.value = res.data.total || accounts.value.length
    totalPages.value = Math.max(1, Math.ceil(res.data.total / res.data.page_size))
  }).catch(error => {
    console.error('获取账号列表失败:', error)
    handleError(error)
  })
}


function resetFilters() {
  filterRole.value = ''
  filterFactory.value = ''
  filterDepartment.value = 0
  keyword.value = ''
  currentPage.value = 1;
  fetchAccounts()
}

function openDetail(account) {
  detailAccount.value = deepClone(account);
  detailAccount.value.departments = {name: account.departments?.name || "部门", ids: account.departments ? deepClone(account.departments.ids) : []};
  console.log(detailAccount.value)
  newPassword.value = '';
  showDetail.value = true
}

function closeDetail() {
  localAvatar.value = null;
  newPassword.value = '';
  newDepartment.value = 0;
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
      response = await axios.post('/account/add', submitData);
    } else {
      // 更新账号
      response = await axios.patch('/account/update', submitData);
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
    const response = await axios.delete('/account/delete', {
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
  console.log(detailAccount)
  console.log(detailAccount.value)
  console.log(detailAccount.value.departments.ids)
  detailAccount.value.departments.ids = detailAccount.value.departments.ids.filter(d => d !== dep)
}

function addDepartment() {
  if (newDepartment.value) {
    if (!detailAccount.value.departments || !detailAccount.value.departments.ids) {
      detailAccount.value.departments.ids = {"name": "", "ids": []}
    }
    if (!detailAccount.value.departments.ids.includes(newDepartment.value)) {
      detailAccount.value.departments.ids.push(newDepartment.value)
      newDepartment.value = 0
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
      const response = await apiClient.post('/account/import', importedAccounts);
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
    const response = await axios.patch('/account/toggle-status', {id: account.id, is_active: !account.is_active});
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

/* Page-specific overrides (keep minimal to ensure consistency) */
.record-row .cell:first-child img.avatar-img { width: 40px; height: 40px; }
.record-row .cell { min-height: 48px; }

</style>
