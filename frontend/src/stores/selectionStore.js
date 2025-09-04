import {defineStore} from 'pinia'
import {ref} from 'vue'
import {useAuthStore} from "@/stores/authStore.js";

export const useSelectionStore = defineStore('selection', () => {
    const authStore = useAuthStore();
    const factories = ref([])
    const selectedFactory = ref(null)
    const years = ref([])
    const selectedYear = ref(null)
    const showFactoryDropdown = ref(false)
    const showYearDropdown = ref(false)
    const initFactories = () => {
        if (authStore.isFactory) {
            factories.value = [authStore.factory];
        } else if (authStore.isHeadquarters) {
            factories.value = ["安徽光大美科", "安徽光大同创", "昆山一", "昆山二", "成都厂", "惠阳厂", "厦门奔方", "武汉厂", "南昌厂", "越南", "墨西哥", "深圳光大", "沃普智选", "青岛音诺", "天津茂创", "合肥山秀", "苏州领新", "东莞美科同创", "重庆致贯", "苏州致贯"];
        }
        selectedFactory.value = factories.value[0];
    };
    const initYears = () => {
        const currentYear = new Date().getFullYear()
        years.value = []
        for (let y = 2020; y <= currentYear; y++) {
            years.value.push(y.toString())
        }
        selectedYear.value = currentYear.toString()
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
        showYearDropdown.value = !showYearDropdown.value
    }

    const selectYear = (y) => {
        authStore.checkTokenValid()
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
        initFactories,
        initYears,
        toggleFactoryDropdown,
        selectFactory,
        toggleYearDropdown,
        selectYear,
        handleClickOutside
    }
})