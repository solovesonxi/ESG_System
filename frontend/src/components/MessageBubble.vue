<template>
  <div class="msg" :class="role">
    <div class="avatar">{{ role === 'user' ? 'U' : 'A' }}</div>
    <div class="content" v-html="formatted"></div>
    <div class="meta">{{ meta }}</div>
  </div>
</template>

<script>
export default {
  name: 'MessageBubble',
  props: {
    message: { type: Object, required: true }
  },
  computed: {
    role() { return this.message.role; },
    formatted() {
      const t = this.message.content || '';
      return t.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/\n/g, '<br/>');
    },
    meta() { return this.message.status || '' }
  }
}
</script>

<style scoped>
.msg { display:flex; gap:8px; align-items:flex-start; }
.avatar { width:36px; height:36px; border-radius:18px; background:#ddd; display:flex; align-items:center; justify-content:center; }
.content { background:#fff; padding:8px; border-radius:6px; max-width:70%; }
.msg.user .content { background:#e6f7ff; }
.msg.assistant .content { background:#f5f5f5; }
.meta { font-size:12px; color:#888; }
</style>
