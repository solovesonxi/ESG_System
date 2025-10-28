<template>
  <div class="messages-view page-container">
    <div class="message-section">
      <div class="section-header">
        <div class="message-actions">
          <span v-if="unreadCount > 0" class="unread-badge">{{ unreadCount }}</span>
          <button class="view-all-btn" @click="showAllMessagesModal = true">查看全部</button>
        </div>
      </div>
      <div class="message-preview">
        <div v-if="messages.length === 0" class="empty-message">暂无通知</div>
        <div v-for="msg in previewMessages" :key="msg.id" class="message-card"
             :class="{ unread: !msg.is_read }" @click="openMessageDetail(msg)">
          <div class="message-header">
            <span class="message-title" :class="msg.type">{{ msg.type }}</span>
            <span v-if="!msg.is_read" class="red-dot"></span>
          </div>
          <span class="message-title">{{ msg.title }}</span>
          <span class="message-date">{{ formatDate(msg.created_at) }}</span>
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
                    :disabled="messages.length === 0">批量删除
            </button>
          </div>
          <div v-else class="header-actions">
            <div class="selection-buttons">
              <button class="action-btn" @click="exitSelectMode">取消</button>
              <button class="confirm-delete-btn" @click="confirmBatchDelete"
                      :disabled="!hasSelectedNotifications">删除选中 ({{ selectedNotifications.size }})</button>
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
          <div v-if="messages.length === 0" class="empty-list">暂无消息通知</div>
          <div v-else class="message-list">
            <div v-for="msg in messages" :key="msg.id" class="list-item"
                 @click="handleNotificationItemClick(msg)"
                 :class="{ unread: !msg.is_read, selected: selectedNotifications.has(msg.id) }">
              <div v-if="isSelectMode" class="item-checkbox">
                <div class="custom-checkbox" :class="{ checked: selectedNotifications.has(msg.id) }">
                  <i class="icon-check" v-if="selectedNotifications.has(msg.id)">✓</i>
                </div>
              </div>
              <div class="list-item-content">
                <div class="item-header">
                  <span class="message-type" :class="msg.type">{{ msg.type }}</span>
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

    <!-- 弹窗：系统通知详情 -->
    <div v-if="showMessageModal" class="modal-mask" @click.self="closeDetailModal">
      <div class="modal-container detail-modal">
        <div class="modal-header">
          <h3>{{ currentMessage?.title }}</h3>
          <button class="modal-close" @click="closeDetailModal">×</button>
        </div>
        <div class="modal-content detail-content">
          <div class="message-meta">
            <span class="message-type" :class="currentMessage?.type">{{ currentMessage?.type }}</span>
            <span class="message-date">{{ formatDate(currentMessage?.created_at) }}</span>
          </div>
          <div class="message-body">{{ currentMessage?.content }}</div>
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
            <p v-else-if="deleteMode === 'batch'">确定要删除选中的系统通知吗？共 {{ selectedNotifications.size }} 条消息将被删除。</p>
            <p class="warning-text">此操作不可撤销！</p>
          </div>
        </div>
        <button class="delete-btn" @click="executeDelete">确认删除</button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import axios from '@/utils/axios';


const messages = ref([]);
const selectedNotifications = ref(new Set());
const isSelectMode = ref(false);
const showAllMessagesModal = ref(false);
const showMessageModal = ref(false);
const showDeleteConfirmModal = ref(false);
const currentMessage = ref(null);
const deleteMode = ref('');

const unreadCount = computed(() => messages.value.filter(m => !m.is_read).length);
const readMessagesCount = computed(() => messages.value.filter(m => m.is_read).length);
const previewMessages = computed(() => messages.value.slice(0, 4));

const allNotificationsSelected = computed(() =>
  messages.value.length > 0 && selectedNotifications.value.size === messages.value.length
);
const hasSelectedNotifications = computed(() => selectedNotifications.value.size > 0);

const fetchMessages = async () => {
  try {
    const response = await axios.get('/messages');
    const data = response.data;
    messages.value = (data.messages || []).map(msg => ({ ...msg, is_read: msg.is_read !== undefined ? msg.is_read : false }));
  } catch (error) {
    console.error('获取通知失败:', error);
    messages.value = [];
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

const closeAllModals = () => { showAllMessagesModal.value = false; };
const closeDetailModal = () => { showMessageModal.value = false; };
const closeDeleteConfirm = () => { showDeleteConfirmModal.value = false; };

const markMessageAsRead = async (messageId) => {
  try { await axios.patch(`/messages/read`, messageId); } catch (e) { console.error('标记通知为已读失败:', e); }
};

const markAllAsRead = async () => {
  try {
    await axios.patch('/messages/read-all');
    messages.value.forEach(msg => msg.is_read = true);
  } catch (error) {
    console.error('标记所有通知为已读失败:', error);
  }
};

const deleteReadMessages = () => { deleteMode.value = 'read'; showDeleteConfirmModal.value = true; };

const executeDelete = async () => {
  try {
    if (deleteMode.value === 'read') {
      const readMessageIds = messages.value.filter(msg => msg.is_read).map(msg => msg.id);
      await axios.delete('/messages/batch-delete', { data: readMessageIds });
      messages.value = messages.value.filter(msg => !msg.is_read);
    } else if (deleteMode.value === 'batch') {
      const selectedIds = Array.from(selectedNotifications.value);
      await axios.delete('/messages/batch-delete', { data: selectedIds });
      messages.value = messages.value.filter(msg => !selectedIds.includes(msg.id));
      exitSelectMode();
    }
    closeDeleteConfirm();
  } catch (error) {
    console.error('删除失败:', error);
  }
};

const formatDate = (dateString) => {
  if (!dateString) return '';
  const date = new Date(dateString);
  return date.toLocaleString('zh-CN', { year: 'numeric', month: '2-digit', day: '2-digit', hour: '2-digit', minute: '2-digit' });
};

const enterSelectMode = () => { isSelectMode.value = true; selectedNotifications.value = new Set(); };
const exitSelectMode = () => { isSelectMode.value = false; selectedNotifications.value.clear(); };
const toggleNotificationSelection = (id) => { selectedNotifications.value.has(id) ? selectedNotifications.value.delete(id) : selectedNotifications.value.add(id); };
const toggleAllNotifications = () => { if (allNotificationsSelected.value) selectedNotifications.value.clear(); else messages.value.forEach(msg => selectedNotifications.value.add(msg.id)); };
const confirmBatchDelete = () => { showDeleteConfirmModal.value = true; deleteMode.value = 'batch'; };
const handleNotificationItemClick = (msg) => { if (isSelectMode.value) { toggleNotificationSelection(msg.id); } else { openMessageDetail(msg); } };

onMounted(() => { fetchMessages(); });
</script>

<style scoped>
/* migrated notification styles */
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

.view-all-btn:hover { background: #1565c0; }

.message-preview { display: flex; flex-direction: column; gap: 0.7rem; margin-top: 0.7rem; }

.empty-message { text-align: center; color: #888; padding: 1rem 0; }

.message-card {
  background: #ccc8c8;
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
.message-card:hover, .list-item:hover { background: #adadad; }
.message-card.unread, .list-item.unread { background: linear-gradient(120deg, #d0e7f8 0%, #b7b2fd 100%); }
.message-card.unread:hover, .list-item.unread:hover{ background: linear-gradient(120deg, #b5cada 0%, #9994de 100%); }

.dark-theme .message-card, .dark-theme .list-item {
  background: #626161;
  color: #dbeafe;
  box-shadow: 0 1px 6px rgba(2,6,23,0.7);
}
.dark-theme .message-card:hover, .dark-theme .list-item:hover { background: #7a7979; }
.dark-theme .message-card.unread, .dark-theme .list-item.unread {
  background: linear-gradient(120deg, #1e456c 0%, #4d1019 100%) !important;
}
.dark-theme .message-card.unread:hover, .dark-theme .list-item.unread:hover {
  background: linear-gradient(120deg, #265686 0%, #85091b 100%) !important;
}

.message-title { flex: 1; margin-left: 0.5rem; color: #03396e; }
.message-date { font-size: 0.95rem; color: #888; margin-left: 1rem; }

.red-dot { width: 10px; height: 10px; background: #e53935; border-radius: 50%; display: inline-block; margin-left: 0.5rem; }


.modal-mask { position: fixed; z-index: 9999; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); display: flex; align-items: center; justify-content: center; backdrop-filter: blur(2px); }
.modal-container { background: linear-gradient(120deg, #f8f1f1 0%, #fadcb3 100%); border-radius: 12px; box-shadow: 0 8px 32px rgba(0,0,0,0.2); display: flex; flex-direction: column; max-height: 90vh; }
.list-modal { width: 60%; height: 80%; }
.detail-modal { width: 50%; max-width: 70%; }
.modal-header { display: flex; justify-content: space-between; align-items: center; padding: 1.2rem 1.5rem; border-bottom: 1px solid #eee; flex-shrink: 0; }
.modal-header h3 { margin:0; color:#333; font-size:1.2rem; font-weight:600; }
.header-actions { display:flex; align-items:center; gap:0.8rem; }
.select-all-container { display:flex; align-items:center; cursor:pointer; padding:0.4rem 0.6rem; border-radius:4px; transition:background-color 0.2s; flex-direction:row; }
.custom-checkbox { width:20px; height:20px; border:2px solid #ddd; border-radius:3px; display:flex; align-items:center; justify-content:center; margin-right:0.5rem; transition:all 0.2s; margin-top:1.2rem; cursor:pointer !important; }
.custom-checkbox.checked { background-color: #66aff6; border-color:#66aff6; }
.custom-checkbox .icon-check { color: white; font-size:12px; font-weight: bold; }
.select-all-text { font-size:0.9rem; color:#555; user-select:none; justify-content:left; margin-right:0.5rem; margin-top:1.2rem; }
.selection-buttons { display:flex; gap:0.5rem; }
.modal-close { background:none; border:none; font-size:1.5rem; cursor:pointer; color:#999; padding:0; width:30px; height:30px; display:flex; align-items:center; justify-content:center; border-radius:50%; transition:all 0.2s; flex-shrink:0; }
.modal-close:hover { background:#f5f5f5; color:#333; }
.modal-content { padding:1.5rem; overflow:hidden; display:flex; flex-direction:column; }
.list-content { max-height:60vh; overflow-y:auto; padding:0; }
.detail-content { flex:1; display:flex; flex-direction:column; gap:1rem; }
.empty-list { text-align:center; color:#888; padding:2rem 0; }
.message-list { display:flex; flex-direction:column; width:100%; }
.list-item { padding:0.9rem 1.2rem; border-bottom:1px solid #e5e7eb; cursor:pointer; transition:all 0.2s ease; display:flex; align-items:center; width:100%; box-sizing:border-box; background:#ccc8c8; border-radius:6px; margin-bottom:2px; box-shadow:0 1px 3px rgba(0,0,0,0.1); }
.list-item.selected { background:#fef3c7; border-left:8px solid #0b1ef5;}
.list-item-content { display:flex; align-items:center; width:100%; }
.item-header { margin-right:1rem; display:flex; align-items:center; }
.item-content { display:flex; flex:1; justify-content:space-between; align-items:center; }
.item-checkbox { margin-left:0.8rem; display:flex; align-items:center; }
.item-title { font-weight:500; color:#333; font-size:0.95rem; }
.item-date { font-size:0.85rem; color:#888; }
.modal-footer button { background:#66aff6; color:#fff; border:none; border-radius:4px; padding:0.7rem 1.2rem; font-size:1rem; cursor:pointer; transition:background 0.2s; flex:0 0 auto; width:20%; justify-content:center; }
.modal-footer button:hover { background:#1565c0; }
.action-btn { background:#9946e1; color:#fff; border-radius:4px; font-size:0.85rem; position:relative; min-width:100px; }
.action-btn:not(:disabled):hover { background:#6020da; }
.action-btn:disabled { opacity:0.5; cursor:not-allowed; }
.confirm-delete-btn { display:flex; border-radius:4px; font-size:0.85rem; cursor:pointer; transition:all 0.2s; white-space:nowrap; background:#c72222; }
.confirm-delete-btn:hover:not(:disabled) { background:#9a0d0d; }
.confirm-delete-btn:disabled { background:#444; color:#e0e0e0; }
.delete-btn:not(:disabled) { background:#c72222; color:#e0e0e0; border-radius:4px; padding:0.7rem 1.2rem; cursor:pointer; transition:all 0.2s; white-space:nowrap; display:flex; justify-content:center; align-items:center; }
.delete-btn:hover:not(:disabled) { background:#9a0d0d; }
.icon-check { font-size:0.9rem; }
.confirm-message { font-size:1rem; color:#333; }
.dark-theme .confirm-message { color:#e0e0e0; }
.warning-text { color:#e53935; font-weight:bold; }

.page-container { padding: 2rem; }

/* CSS - 将下面内容粘贴到 `src/views/NotificationsView.vue` 的 <style scoped> 中 */
.dark-theme .page-container {
  background: #0b1220;
  color: #e6eef8;
}

.dark-theme .message-section {
  background: linear-gradient(120deg, #0f1724 0%, #0b1320 100%);
  box-shadow: 0 2px 12px rgba(0,0,0,0.6);
}



.dark-theme .message-title { color: #dbeafe; }
.dark-theme .message-date  { color: #9fb0c6; }

.dark-theme .unread-badge {
  background: #ff6b6b;
  color: #fff;
  box-shadow: 0 1px 4px rgba(255,107,107,0.15);
}

.dark-theme .view-all-btn,
.dark-theme .action-btn {
  background: #235fa8;
  color: #f0f8ff;
  box-shadow: 0 2px 8px rgba(35,95,168,0.18);
}
.dark-theme .action-btn:not(:disabled):hover { background: #1a497e; }

.dark-theme .modal-mask { background: rgba(2,6,23,0.7); backdrop-filter: blur(4px); }
.dark-theme .modal-container {
  background: linear-gradient(120deg, #071022 0%, #0b1724 100%);
  border: 1px solid rgba(255,255,255,0.04);
  color: #dbeafe;
  box-shadow: 0 10px 40px rgba(2,6,23,0.8);
}

.dark-theme .modal-header { border-bottom-color: rgba(255,255,255,0.04); }
.dark-theme .modal-header h3 { color: #e6f0ff; }

.dark-theme .list-item {
  background: #071022;
  border-bottom: 1px solid rgba(255,255,255,0.03);
  color: #dbeafe;
  box-shadow: 0 1px 3px rgba(2,6,23,0.6);
}
.dark-theme .list-item:hover {
  background: #0b2233;
  box-shadow: 0 6px 18px rgba(2,6,23,0.6);
}

.dark-theme .list-item.unread {
  background: linear-gradient(90deg, rgba(14,50,86,0.6), rgba(12,42,74,0.6));
  border-left-color: #2563eb;
}
.dark-theme .list-item.selected {
  background: linear-gradient(90deg, #263149, #2b3746);
  border-left-color: #f59e0b;
}

.dark-theme .item-title { color: #e6f3ff; }
.dark-theme .item-date  { color: #90a7bf; }

.dark-theme .modal-close { color: #bfcbdc; }
.dark-theme .modal-close:hover { background: rgba(255,255,255,0.03); color: #fff; }

.dark-theme .confirm-delete-btn,
.dark-theme .delete-btn {
  background: #9b1d1d;
  color: #fff;
}
.dark-theme .confirm-delete-btn:hover:not(:disabled),
.dark-theme .delete-btn:hover:not(:disabled) {
  background: #7a1212;
}

.dark-theme .custom-checkbox {
  border-color: rgba(255,255,255,0.08);
  background: rgba(255,255,255,0.01);
}
.dark-theme .custom-checkbox.checked {
  background-color: #2563eb;
  border-color: #2563eb;
}
.dark-theme .select-all-text { color: #c8d9ea; }

</style>