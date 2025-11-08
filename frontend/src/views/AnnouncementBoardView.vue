<template>
  <div class="announcement-board" :class="{ 'dark-theme': darkMode }">
    <div class="page-header">
      <h2>公告管理</h2>
      <button class="btn btn-primary" @click="openCreateModal">发布公告</button>
    </div>
    <div class="announcement-list card">
      <table class="announcement-table">
        <thead>
          <tr>
            <th>标题</th>
            <th>内容</th>
            <th>发布时间</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="announcement in announcements" :key="announcement.id"  @click="viewAnnouncement(announcement)">
            <td>{{ announcement.title }}</td>
            <td>{{ announcement.content }}</td>
            <td>{{ formatDate(announcement.created_at) }}</td>
            <td>
              <button class="btn btn-danger" @click.stop="deleteAnnouncement(announcement.id)">删除</button>
            </td>
          </tr>
        </tbody>
      </table>
      <div v-if="announcements.length === 0" class="empty-state">暂无公告</div>
    </div>

    <teleport to="body">
      <div v-if="showViewModal" class="modal-overlay" @click.self="closeViewModal">
        <div class="modal-container">
          <div class="modal-header">
            <h3>公告详情</h3>
          </div>
          <div class="modal-content">
            <div class="form-group">
              <label>标题</label>
              <input v-model="currentAnnouncement.title" class="form-input" readonly />
            </div>
            <div class="form-group">
              <label>内容</label>
              <textarea v-model="currentAnnouncement.content" class="form-input" readonly></textarea>
            </div>
            <div class="form-group">
              <label>接收目标</label>
              <input :value="viewTargetText(currentAnnouncement)" class="form-input" readonly />
            </div>
            <div class="form-group" v-if="currentAnnouncement.receiver_factory">
              <label>接收工厂</label>
              <input v-model="currentAnnouncement.receiver_factory" class="form-input" readonly />
            </div>
            <div class="form-group" v-if="currentAnnouncement.receiver_department">
              <label>接收部门</label>
              <input v-model="currentAnnouncement.receiver_department" class="form-input" readonly />
            </div>
          </div>
        </div>
      </div>
    </teleport>

    <teleport to="body">
      <div v-if="showCreateModal" class="modal-overlay" @click.self="closeCreateModal">
        <div class="modal-container">
          <div class="modal-header">
            <h3>发布公告</h3>
          </div>
          <div class="modal-content">
            <div class="form-group">
              <label>标题</label>
              <input v-model="newAnnouncement.title" class="form-input" placeholder="请输入公告标题" />
            </div>
            <div class="form-group">
              <label>内容</label>
              <textarea v-model="newAnnouncement.content" class="form-input" placeholder="请输入公告内容"></textarea>
            </div>

            <!-- 根据用户角色显示不同的接收目标 -->
            <div class="form-group" v-if="isHeadquarter || isAdmin">
              <label>接收工厂</label>
              <select v-model="newAnnouncement.receiver_factory" class="form-input">
                <option value="">全部工厂</option>
                <option v-for="f in factories" :key="f" :value="f">{{ f }}</option>
              </select>
            </div>

            <div class="form-group" v-else-if="isFactory">
              <label>接收部门</label>
              <select v-model="newAnnouncement.receiver_department" class="form-input">
                <option value="">全部部门</option>
                <option v-for="d in departments" :key="d.id" :value="d.name">{{ d.name }}</option>
              </select>
            </div>

            <!-- 发送时间，可选：为空代表立即发送 -->
            <div class="form-group">
              <label>发布时间（可选）</label>
              <input type="datetime-local" v-model="newAnnouncement.send_time" class="form-input" />
            </div>

            <div class="button-row center">
              <button class="btn btn-secondary" @click="closeCreateModal">取消</button>
              <button class="btn btn-primary" @click="createAnnouncement">发布</button>
            </div>
          </div>
        </div>
      </div>
    </teleport>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue';
import { useAuthStore } from '@/stores/authStore.js';
import { useSelectionStore } from '@/stores/selectionStore.js';
import apiClient from '@/utils/axios';

const authStore = useAuthStore();
const selectionStore = useSelectionStore();

const announcements = ref([
  { id: 1, title: '系统维护通知', content: '系统将于今晚12点进行维护，请提前保存数据。', created_at: new Date() },
]);
const showCreateModal = ref(false);
const showViewModal = ref(false);
const newAnnouncement = ref({
  title: '',
  content: '',
  // receiver_factory or receiver_department will be set depending on role
  receiver_department: '',
  receiver_factory: '',
  send_time: '', // ISO-like from datetime-local, or empty = now
});
const currentAnnouncement = ref({});
const darkMode = ref(false);

const factories = computed(() => selectionStore.factories || []);
const departments = ref([]);
const fetchedDepartments = ref(false);

const isHeadquarter = computed(() => authStore.isHeadquarter)
const isAdmin = computed(() => authStore.isAdmin)
const isFactory = computed(() => authStore.isFactory)

function openCreateModal() {
  showCreateModal.value = true;
  if (!fetchedDepartments.value) {
    fetchDepartments();
  }
}

function closeCreateModal() {
  showCreateModal.value = false;
  newAnnouncement.value = {
    title: '',
    content: '',
    receiver_department: '',
    receiver_factory: '',
    send_time: '',
  };
}

async function fetchDepartments() {
  try {
    const res = await apiClient.get('/messages/departments');
    if (res && res.data && Array.isArray(res.data.departments)) {
      departments.value = res.data.departments;
    } else {
      departments.value = [];
    }
  } catch (e) {
    console.warn('获取部门列表失败', e);
    departments.value = [];
  } finally {
    fetchedDepartments.value = true;
  }
}

function formatDate(date) {
  if (!date) return '';
  try {
    return new Date(date).toLocaleString();
  } catch (e) {
    return '';
  }
}

function viewTargetText(item) {
  if (!item) return '';
  if (item.receiver_factory) return `工厂: ${item.receiver_factory}`;
  if (item.receiver_department) return `部门: ${item.receiver_department}`;
  return '全部';
}

async function createAnnouncement() {
  if (!newAnnouncement.value.title || !newAnnouncement.value.content) {
    alert('请填写标题和内容');
    return;
  }
  const payload = {
    title: newAnnouncement.value.title,
    content: newAnnouncement.value.content,
  };
  if (isHeadquarter.value || isAdmin.value) {
    if (newAnnouncement.value.receiver_factory && newAnnouncement.value.receiver_factory !== '') {
      payload.receiver_factory = newAnnouncement.value.receiver_factory;
    }
  } else if (isFactory.value) {
    if (newAnnouncement.value.receiver_department && newAnnouncement.value.receiver_department !== '') {
      payload.receiver_department = newAnnouncement.value.receiver_department;
    }
  }

  if (newAnnouncement.value.send_time && newAnnouncement.value.send_time !== '') {
    const dt = new Date(newAnnouncement.value.send_time);
    if (!isNaN(dt.getTime())) {
      payload.send_time = dt.toISOString();
    }
  }

  announcements.value.push({
    title: payload.title,
    content: payload.content,
    send_time: payload.send_time ? payload.send_time : new Date(),
    receiver_factory: payload.receiver_factory || null,
    receiver_department: payload.receiver_department || null,
  });
  try {
    await apiClient.post('/messages', payload);
  } catch (e) {
    console.warn('公告发布失败：', e);
  }
  closeCreateModal();
}

function deleteAnnouncement(id) {
  announcements.value = announcements.value.filter((a) => a.id !== id);
}

function viewAnnouncement(announcement) {
  currentAnnouncement.value = { ...announcement };
  showViewModal.value = true;
}

function closeViewModal() {
  showViewModal.value = false;
}

onMounted(() => {
  selectionStore.initSelection?.();
  if (!fetchedDepartments.value) fetchDepartments();
});
</script>

<style scoped>
.announcement-board {
  padding: 24px;
  background: transparent;
  min-height: 100vh;
  transition: all 0.3s ease;
}

.dark-theme .announcement-board{
  background: #1e1e2f;
  color: #ffffff;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
}
.page-header h2{
  color: #141418;
}
.dark-theme .page-header h2{
  color: #eee8d8;
}


.btn {
  padding: 10px 18px;
  border-radius: 8px;
  font-weight: 500;
  font-size: 14px;
  cursor: pointer;
  transition: all 0.3s ease;
  border: none;
  width: fit-content;
  text-align: center;
  color: white;
}

.btn-primary {
  background: #7c3aed;
}

.btn-secondary {
  background: #ffffff;
  border: 1px solid #e5e7eb;
  color: #374151;
}

.btn-danger {
  background: #ef4444;
}

.card {
  background: transparent;
  padding: 20px;
}

.dark-theme .card {
  background: #2e2e3e;
}
.card h3{
  background: transparent;
  color: #0a0a23;
}
.dark-theme .card h3{
  color: #fff3e0;
}

.modal-overlay {
  position: fixed;
  left: 0;
  top: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.35);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 9999;
  backdrop-filter: blur(4px);
}

.modal-container {
  background: #fff;
  color: #222;
  border-radius: 16px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.18);
  width: 60%;
  padding: 10px;
  animation: fadeIn 0.25s;
}

.dark-theme .modal-container {
  background: #2e2e3e;
  color: #ffffff;
}

.form-group {
  margin-bottom: 20px;
}

.form-input {
  width: 100%;
  padding: 10px;
  border: 1px solid #e5e7eb;
  border-radius: 8px;
}

.dark-theme .form-input {
  background: #2b2b34;
  color: #ffffff;
  border: 1px solid #5e5e6e;
}

.button-row.center {
  display: flex;
  justify-content: center;
  gap: 10px;
}
</style>
