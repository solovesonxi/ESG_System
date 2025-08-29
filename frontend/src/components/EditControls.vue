<template>
  <div class="edit-controls" :class="{ editing: isEditing }">
    <button v-if="!isEditing" class="edit-button" @click="$emit('start-edit')">✏️</button>
    <div v-else class="edit-actions">
      <button @click="$emit('cancel-edit')" class="cancel-button">取消</button>
      <button @click="$emit('submit-edit')" class="submit-button">提交</button>
    </div>
  </div>
</template>

<script setup>
defineProps({
  isEditing: Boolean
});

defineEmits(['start-edit', 'cancel-edit', 'submit-edit']);
</script>

<style scoped>
.edit-controls {
  position: fixed;
  top: 100px;       /* 距离顶部 */
  right: 20px;     /* 距离右侧 */
  z-index: 9999;
  background: rgba(44, 62, 80, 0.85);
  padding: 12px;
  border-radius: 24px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 12px;
  color: white;
  font-size: 16px;
  cursor: pointer;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
  backdrop-filter: blur(5px);
  transition: all 0.3s ease;
  min-width: 60px;
}

.edit-controls:hover {
  background: rgba(44, 62, 80, 0.95);
  box-shadow: 0 6px 25px rgba(0, 0, 0, 0.3);
}

.edit-controls::before {
  content: '编辑';
  opacity: 0;
  transition: all 0.3s;
  font-size: 14px;
  font-weight: bold;
  position: absolute;
  top: -25px;
  left: 50%;
  transform: translateX(-50%);
  white-space: nowrap;
}

.edit-controls:hover::before {
  opacity: 1;
  transform: translateX(-50%) translateY(0);
}

.edit-button, .cancel-button, .submit-button {
  padding: 10px 16px;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  font-size: 16px;
  transition: all 0.2s;
  min-width: 80px;
  text-align: center;
}

.edit-button {
  background-color: transparent;
  font-size: 28px;
  width: 50px;
  height: 50px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
}

.edit-button:hover {
  background-color: rgba(255, 255, 255, 0.1);
  transform: scale(1.1);
}

.cancel-button {
  background-color: #f44336;
  color: white;
}

.cancel-button:hover {
  background-color: #d32f2f;
  transform: translateY(-2px);
}

.submit-button {
  background-color: #2196F3;
  color: white;
}

.submit-button:hover {
  background-color: #1976d2;
  transform: translateY(-2px);
}

/* 响应式设计 */
@media (max-width: 768px) {
  .edit-controls {
    right: 20px;
    bottom: 20px;
    padding: 10px;
  }

  .edit-controls::before {
    top: 50%;
    left: -40px;
    transform: translateY(-50%) translateX(10px);
  }

  .edit-controls:hover::before {
    transform: translateY(-50%) translateX(0);
  }
}
</style>
