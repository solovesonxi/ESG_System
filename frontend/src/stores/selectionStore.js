import {defineStore} from 'pinia'
import {ref} from 'vue'
import {useAuthStore} from "@/stores/authStore.js";

export const useSelectionStore = defineStore('selection', () => {
    const authStore = useAuthStore();
    const factories = ref([])
    const years = ref([])
    const months = ref([])
    const selectedFactory = ref(null)
    const selectedYear = ref(null)
    const selectedMonth = ref(null)
    const showFactoryDropdown = ref(false)
    const showYearDropdown = ref(false)
    const showMonthDropdown = ref(false)
    const initSelection = () => {
        try {
            if (!authStore.user) {
                setTimeout(initSelection, 100);
                return;
            }
            if (authStore.isFactory) {
                factories.value = [authStore.factory];
            } else if (authStore.isHeadquarter || authStore.isAdmin) {
                factories.value = ["安徽光大美科", "安徽光大同创", "昆山一", "昆山二", "成都厂", "惠阳厂", "厦门奔方", "武汉厂", "南昌厂", "越南", "墨西哥", "深圳光大", "沃普智选", "青岛音诺", "天津茂创", "合肥山秀", "苏州领新", "东莞美科同创", "重庆致贯", "苏州致贯"];
            }
            const currentYear = new Date().getFullYear()
            years.value = []
            for (let y = 2020; y <= currentYear; y++) {
                years.value.push(y.toString())
            }
            months.value = Array.from({ length: 12 }, (_, i) => (i + 1).toString())
            selectedFactory.value = factories.value[0] || null;
            selectedYear.value = currentYear.toString()
            selectedMonth.value = (new Date().getMonth() + 1).toString()
        } catch (error) {
            console.error('选择器初始化失败:', error);
        }
    };

    // 封装所有操作方法
    const toggleFactoryDropdown = () => {
        if (!authStore.isFactory) {
            showFactoryDropdown.value = !showFactoryDropdown.value;
        }
    }

    const selectFactory = (f) => {
        authStore.checkTokenValid()
        selectedFactory.value = f
        showFactoryDropdown.value = false
    }

    const toggleYearDropdown = () => {
        showYearDropdown.value = !showYearDropdown.value;
    }

    const selectYear = (y) => {
        authStore.checkTokenValid()
        selectedYear.value = y
        showYearDropdown.value = false
    }
    const toggleMonthDropdown = () => {
        showMonthDropdown.value = !showMonthDropdown.value
    }

    const selectMonth = (m) => {
        authStore.checkTokenValid()
        selectedMonth.value = m
        showMonthDropdown.value = false
    }

    const handleClickOutside = (event) => {
        const selectElements = document.querySelectorAll('.custom-select, .small-select')
        let isInsideSelect = false
        selectElements.forEach(select => {
            if (select.contains(event.target)) {
                isInsideSelect = true
            }
        })
        if (!isInsideSelect) {
            showFactoryDropdown.value = false
            showYearDropdown.value = false
        } else {
        }
    }

    return {
        factories,
        years,
        months,
        selectedFactory,
        selectedYear,
        selectedMonth,
        showFactoryDropdown,
        showYearDropdown,
        showMonthDropdown,
        initSelection,
        toggleFactoryDropdown,
        selectFactory,
        toggleYearDropdown,
        selectYear,
        toggleMonthDropdown,
        selectMonth,
        handleClickOutside
    }
});