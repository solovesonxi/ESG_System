import axios from 'axios';

const API_BASE_URL = 'http://localhost:8000/api';

// 通用GET请求
export const fetchData = async (endpoint, params) => {
    try {
        const response = await axios.get(`${API_BASE_URL}/${endpoint}`, { params });
        console.log("fetchData", params);
        console.log(response.data);
        return response.data;
    } catch (error) {
        throw new Error(`获取数据失败: ${error.response?.data?.detail || error.message}`);
    }
};

// 通用POST请求
export const postData = async (endpoint, data) => {
    try {
        const response = await axios.post(`${API_BASE_URL}/${endpoint}`, data);
        console.log("postData", data);
        console.log(response.data);
        return response.data;
    } catch (error) {
        throw new Error(`提交数据失败: ${error.response?.data?.detail || error.message}`);
    }
};

// 定量数据API
export const fetchQuantData = (factory, year) =>
    fetchData('envquant', { factory, year });

export const postQuantReasons = (data) =>
    postData('envquant/reasons', data);

// 定性数据API
export const fetchQualData = (factory, year) =>
    fetchData('envqual', { factory, year });

export const postQualData = (data) =>
    postData('envqual/data', data);