<template>
  <div class="power-form">
    <form @submit.prevent="submitForm">
      <fieldset>
        <legend>工厂名称</legend>
        <div class="form-group">
          <input
              type="text"
              v-model="factory"
              :class="{ 'placeholder-text': !factory }"
              placeholder="请输入工厂名称"
              required
          >
        </div>
      </fieldset>

      <!-- 月度电量统计 -->
      <fieldset>
        <legend>2024年月度外购电量统计 (kWh)</legend>
        <div class="monthly-grid">
          <div v-for="(month, index) in monthlyPower" :key="index" class="month-input">
            <label>{{ getMonthName(index) }}</label>
            <input
                type="number"
                v-model.number="monthlyPower[index]"
                :placeholder="`${getMonthName(index)}电量`"
                min="0"
                step="10"
                required
            >
          </div>
        </div>
      </fieldset>


      <button type="submit" :disabled="isSubmitting">
        {{ isSubmitting ? '提交中...' : '提交数据' }}
      </button>
    </form>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import axios from 'axios'

const factory = ref('')
const isSubmitting = ref(false)

// 初始化12个月份的外购电量数据
const monthlyPower = reactive(Array(12).fill(0))

// 月份名称映射
const monthNames = [
  '1月', '2月', '3月', '4月', '5月', '6月',
  '7月', '8月', '9月', '10月', '11月', '12月'
]
// 获取月份名称
const getMonthName = (index) => {
  return monthNames[index]
}

async function submitForm() {
  isSubmitting.value = true
  try {
    const payload = {
      factory: factory.value || '未命名工厂',
      monthlyPower: [...monthlyPower],
      totalPower: totalPower.value,
      averagePower: averagePower.value
    }

    const response = await axios.post('http://localhost:8000/submit/power', payload)

    if (response.data.status === 'success') {
      alert('电量数据提交成功!')
      // 重置表单
      monthlyPower.forEach((_, i) => monthlyPower[i] = 0)
      factory.value = ''
    }
  } catch (error) {
    console.error('提交失败:', error)
    alert(`提交失败: ${error.response?.data?.detail || error.message}`)
  } finally {
    isSubmitting.value = false
  }
}
</script>

<style scoped>
.power-form {
  max-width: none;
  width: 80vw;
  margin: 0 -2rem;
  background: white;
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

h1 {
  text-align: center;
  margin-bottom: 2rem;
  color: #2c3e50;
  font-size: 1.8rem;
}

fieldset {
  border: 1px solid #e0e0e0;
  border-radius: 8px;
  padding: 1.5rem;
  margin-bottom: 1.8rem;
  background: #fafafa;
}

legend {
  padding: 0 12px;
  font-weight: bold;
  color: #3498db;
  font-size: 1.1rem;
}

.monthly-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
  gap: 20px;
}

.month-input {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.form-group {
  margin-bottom: 15px;
}

label {
  display: block;
  margin-bottom: 8px;
  font-weight: 600;
  color: #555;
  font-size: 0.95rem;
}

input {
  width: 100%;
  padding: 12px 15px;
  border: 1px solid #ddd;
  border-radius: 6px;
  font-size: 16px;
  transition: all 0.3s;

  &:disabled {
    background: #f5f5f5;
    cursor: not-allowed;
  }

  &:focus {
    border-color: #3498db;
    outline: none;
    box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.2);
  }
}

button {
  display: block;
  width: 100%;
  padding: 14px;
  background: #42b983;
  color: white;
  border: none;
  border-radius: 6px;
  font-size: 18px;
  font-weight: 600;
  cursor: pointer;
  transition: background 0.3s;
  margin-top: 1.5rem;

  &:hover:not(:disabled) {
    background: #3aa876;
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(0,0,0,0.1);
  }

  &:disabled {
    background: #a0d9bb;
    cursor: not-allowed;
    transform: none;
    box-shadow: none;
  }
}

@media (max-width: 768px) {
  .power-form {
    padding: 1.5rem;
  }

  .monthly-grid {
    grid-template-columns: repeat(auto-fill, minmax(140px, 1fr));
    gap: 15px;
  }
}
</style>