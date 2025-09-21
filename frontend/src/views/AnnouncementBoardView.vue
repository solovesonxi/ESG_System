<template>
  <div class="announcement-board" :class="{ 'dark-theme': darkMode }">
    <div class="page-header">
      <h2>公告管理</h2>
      <button class="btn btn-primary" @click="openCreateModal">发布公告</button>
    </div>
    <div class="announcement-list card">
      <h3>公告列表</h3>
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
              <button class="btn btn-danger" @click="deleteAnnouncement(announcement.id)">删除</button>
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
              <label>接收角色</label>
              <input v-model="currentAnnouncement.receiver_role" class="form-input" readonly />
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
            <div class="form-group">
              <label>接收角色</label>
              <select v-model="newAnnouncement.receiver_role" class="form-input">
                <option value="all">全员</option>
                <option value="工厂">工厂</option>
                <option value="部门">部门</option>
              </select>
            </div>
            <div class="form-group" v-if="newAnnouncement.receiver_role === '工厂' || newAnnouncement.receiver_role === '部门'">
              <label>接收工厂</label>
              <input v-model="newAnnouncement.receiver_factory" class="form-input" placeholder="请输入接收工厂" />
            </div>
            <div class="form-group" v-if="newAnnouncement.receiver_role === '部门'">
              <label>接收部门</label>
              <input v-model="newAnnouncement.receiver_department" class="form-input" placeholder="请输入接收部门" />
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
import { ref } from 'vue';

const announcements = ref([
  { id: 1, title: '系统维护通知', content: '系统将于今晚12点进行维护，请提前保存数据。', created_at: new Date() },
]);
const showCreateModal = ref(false);
const showViewModal = ref(false);
const newAnnouncement = ref({
  title: '',
  content: '',
  type: 'announcement',
  sender_role: '',
  receiver_role: 'all',
  receiver_department: '',
  receiver_factory: '',
});
const currentAnnouncement = ref({});
const darkMode = ref(false);

function openCreateModal() {
  showCreateModal.value = true;
}

function closeCreateModal() {
  showCreateModal.value = false;
  newAnnouncement.value = {
    title: '',
    content: '',
    type: 'announcement',
    sender_role: '',
    receiver_role: 'all',
    receiver_department: '',
    receiver_factory: '',
  };
}

function createAnnouncement() {
  const newId = announcements.value.length + 1;
  announcements.value.push({
    id: newId,
    title: newAnnouncement.value.title,
    content: newAnnouncement.value.content,
    type: newAnnouncement.value.type,
    sender_role: newAnnouncement.value.sender_role,
    receiver_role: newAnnouncement.value.receiver_role,
    receiver_department: newAnnouncement.value.receiver_department,
    receiver_factory: newAnnouncement.value.receiver_factory,
    created_at: new Date(),
    is_read: false,
  });
  closeCreateModal();
}

function deleteAnnouncement(id) {
  announcements.value = announcements.value.filter((a) => a.id !== id);
}

function formatDate(date) {
  return new Date(date).toLocaleString();
}

function viewAnnouncement(announcement) {
  currentAnnouncement.value = { ...announcement };
  showViewModal.value = true;
}

function closeViewModal() {
  showViewModal.value = false;
}
</script>

<style scoped>
.announcement-board {
  padding: 24px;
  background: #f9fafb;
  min-height: 100vh;
  transition: all 0.3s ease;
}

.dark-theme {
  background: #1e1e2f;
  color: #ffffff;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
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
  background: #ffffff;
  border-radius: 12px;
  padding: 20px;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
}

.dark-theme .card {
  background: #2e2e3e;
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
