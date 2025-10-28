import {defineStore} from 'pinia'
import {ref} from 'vue'
import {useAuthStore} from "@/stores/authStore.js";

export const useSelectionStore = defineStore('selection', () => {
    const authStore = useAuthStore();
    const categoriesMonthly = ref([])
    const categoriesYearly = ref([])
    const factories = ref([])
    const years = ref([])
    const months = ref([])
    const selectedCategoryMonthly = ref({})
    const selectedCategoryYearly = ref({})
    const selectedFactory = ref(null)
    const selectedYear = ref(null)
    const selectedMonth = ref(null)
    const showCategoryDropdown = ref(false)
    const showFactoryDropdown = ref(false)
    const showYearDropdown = ref(false)
    const showMonthDropdown = ref(false)

    const toggleCategoryDropdown = () => {
        showCategoryDropdown.value = !showCategoryDropdown.value;
    }

    const selectCategoryMonthly = (item) => {
        authStore.checkTokenValid();
        selectedCategoryMonthly.value = item || {};
        showCategoryDropdown.value = false;
    }
    const selectCategoryYearly = (item) => {
        authStore.checkTokenValid();
        selectedCategoryYearly.value = item || {};
        showCategoryDropdown.value = false;
    }

    const initSelection = () => {
        try {
            if (!authStore.user) {
                setTimeout(initSelection, 100);
                return;
            }
            if (categoriesMonthly.value.length === 0 && categoriesYearly.value.length === 0 && years.value.length === 0 && months.value.length === 0) {
                categoriesMonthly.value = authStore.monthCategories || [];
                selectedCategoryMonthly.value = categoriesMonthly.value[0] || {};
                categoriesYearly.value = authStore.yearCategories || [];
                selectedCategoryYearly.value = categoriesYearly.value[0] || {};
                const currentYear = new Date().getFullYear()
                years.value = []
                for (let y = 2020; y <= currentYear; y++) {
                    years.value.push(y.toString())
                }
                months.value = Array.from({length: 12}, (_, i) => (i + 1).toString())
                selectedFactory.value = factories.value[0] || null;
                selectedYear.value = currentYear.toString()
                selectedMonth.value = (new Date().getMonth() + 1).toString()
                console.log("选择器首次初始化完成");
            } else {
                console.log("选择器已初始化，无需重复初始化");
            }
        } catch (error) {
            console.error('选择器初始化失败:', error);
        }
    };

    const setSelection = (factory, year, month) => {
        if (factory) {
            const factoryStr = factory.toString()
            if (factories.value.includes(factoryStr)) {
                selectedFactory.value = factory
            }
        }
        if (year) {
            const yearStr = year.toString()
            if (years.value.includes(yearStr)) {
                selectedYear.value = yearStr
            }
        }
        if (month !== undefined && month !== null) {
            const monthStr = month.toString()
            if (months.value.includes(monthStr)) {
                selectedMonth.value = monthStr
            }
        }
        console.log("输入参数设置选择器:", factory, year, month);
        console.log("初始参数选项集合:", factories.value, years.value, months.value);
        console.log("选择器数据已更新", selectedFactory.value, selectedYear.value, selectedMonth.value);
    }

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

    const resetSelection = () => {
        categoriesMonthly.value = [];
        categoriesYearly.value = [];
        factories.value = [];
        years.value = [];
        months.value = [];
        selectedCategoryMonthly.value = null;
        selectedCategoryYearly.value = null;
        selectedFactory.value = null;
        selectedYear.value = null;
        selectedMonth.value = null;
        showCategoryDropdown.value = false;
        showFactoryDropdown.value = false;
        showYearDropdown.value = false;
        showMonthDropdown.value = false;
    };

    return {
        categoriesMonthly,
        categoriesYearly,
        factories,
        years,
        months,
        selectedCategoryMonthly,
        selectedCategoryYearly,
        selectedFactory,
        selectedYear,
        selectedMonth,
        showCategoryDropdown,
        showFactoryDropdown,
        showYearDropdown,
        showMonthDropdown,
        setSelection,
        selectCategoryMonthly,
        selectCategoryYearly,
        selectFactory,
        selectYear,
        selectMonth,
        toggleCategoryDropdown,
        toggleFactoryDropdown,
        toggleYearDropdown,
        toggleMonthDropdown,
        handleClickOutside,
        initSelection,
        resetSelection
    }
});