import {computed, onMounted, ref, watch} from 'vue';
import {useSelectionStore} from "@/stores/selectionStore.js";
import {fetchQualData, fetchQuantData} from '@/router/envData.js';
import {useRoute} from 'vue-router'

export const useEnvData = (fetchFunction, isQualitative = false) => {
    const selectionStore = useSelectionStore();
    const data = ref(isQualitative ? {} : {
        material: {}, energy: {}, water: {}, emission: {}, waste: {}, investment: {}, envQuant: {}
    });

    const factory = computed(() => selectionStore.selectedFactory);
    const year = computed(() => Number(selectionStore.selectedYear));

    const fetchData = async () => {
        try {
            data.value = await fetchFunction(factory.value, year.value);
        } catch (error) {
            console.error(error.message);
            alert(error.message);
        }
    };

    onMounted(() => {
        // 第一次进入分析页面，初始化工厂和年份列表
        if (localStorage.getItem('lastPath_analyze') === null) {
            selectionStore.initFactories();
            selectionStore.initYears();
            console.log('初始化工厂和年份');
        }
        fetchData().then(r =>  console.log(r));
    });

    watch([factory, year], () => {
        fetchData().then(r =>  console.log(r));
    });

    return {
        data,
        factory,
        year,
        factories: computed(() => selectionStore.factories),
        years: computed(() => selectionStore.years),
        fetchData
    };
};
export const formatComparison = (value) => {
    if (value === null || value === undefined ) return '';
    if (typeof value === 'string') return value;
    return `${value > 0 ? '+' : ''}${value}%`;
};
export const useQuantData = () => useEnvData(fetchQuantData);
export const useQualData = () => useEnvData(fetchQualData, true);
