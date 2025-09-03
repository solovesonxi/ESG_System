import apiClient from '@/utils/axios';



// 通用GET请求
export const fetchData = async (endpoint, params) => {
    try {
        const response = await apiClient.get(`/${endpoint}`, { params });
        console.log(response.data);
        return response.data;
    } catch (error) {
        throw new Error(`获取数据失败: ${error.response?.data?.detail || error.message}`);
    }
};

// 通用POST请求
export const postData = async (endpoint, data) => {
    try {
        const response = await apiClient.post(`/${endpoint}`, data);
        console.log("postData", data);
        console.log(response.data);
        return response.data;
    } catch (error) {
        throw new Error(`提交数据失败: ${error.response?.data?.detail || error.message}`);
    }
};

// 定量数据API
export const fetchQuantData = (factory, year) =>
    fetchData('analytical/env_quantitative', { factory, year });

export const postQuantReasons = (data) =>
    postData('analytical/env_quantitative', data);

// 定性数据API
export const fetchQualData = (factory, year) =>
    fetchData('analytical/env_qualitative', { factory, year });

export const postQualData = (data) =>
    postData('analytical/env_qualitative', data);