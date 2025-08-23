import {defineStore} from 'pinia'
import {ref} from 'vue'

export const useSelectionStore = defineStore('selection', () => {
    // 工厂列表
    const factories = ref(["安徽光大美科", "安徽光大同创", "昆山一", "昆山二", "成都厂", "惠阳厂", "厦门奔方", "武汉厂", "南昌厂", "越南", "墨西哥", "深圳光大", "沃普智选", "青岛音诺", "天津茂创", "合肥山秀", "苏州领新", "东莞美科同创", "重庆致贯", "苏州致贯"])
    const selectedFactory = ref(factories.value[0])
    const selectedYear = ref(new Date().getFullYear().toString())
    const years = ref([])

    // 新增响应式状态
    const showFactoryDropdown = ref(false)
    const showYearDropdown = ref(false)

    const initYears = () => {
        const currentYear = new Date().getFullYear()
        years.value = []
        for (let y = 2020; y <= currentYear; y++) {
            years.value.push(y.toString())
        }
    }

    // 封装所有操作方法
    const toggleFactoryDropdown = () => {
        showFactoryDropdown.value = !showFactoryDropdown.value
    }

    const selectFactory = (f) => {
        selectedFactory.value = f
        showFactoryDropdown.value = false
    }

    const toggleYearDropdown = () => {
        showYearDropdown.value = !showYearDropdown.value
    }

    const selectYear = (y) => {
        selectedYear.value = y
        showYearDropdown.value = false
    }

    const handleClickOutside = (event) => {
        const selectElements = document.querySelectorAll('.custom-select')
        let isInsideSelect = false
        selectElements.forEach(select => {
            if (select.contains(event.target)) {
                isInsideSelect = true
            }
        })
        if (!isInsideSelect) {
            showFactoryDropdown.value = false
            showYearDropdown.value = false
        }
    }

    return {
        factories,
        selectedFactory,
        selectedYear,
        years,
        showFactoryDropdown,
        showYearDropdown,
        initYears,
        toggleFactoryDropdown,
        selectFactory,
        toggleYearDropdown,
        selectYear,
        handleClickOutside
    }
})