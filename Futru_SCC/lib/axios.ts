import AsyncStorage from "@react-native-async-storage/async-storage";
import axios from "axios"

const API_URL = "https://futru-scc-server.onrender.com/api/v1";

// FIXED: Corrected typo from axiosIntance to axiosInstance
export const axiosInstance = axios.create({
    baseURL: API_URL,
    headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
    },
    timeout: 30000, // Add timeout to prevent hanging requests
});

axiosInstance.interceptors.request.use(
    async (config) => {
        try {
            const token = await AsyncStorage.getItem("auth_token");
            if (token) {
                config.headers.Authorization = `Bearer ${token}`;
            }
        } catch (error) {
            console.error("Error getting token:", error);
        }
        return config;
    },
    (error) => {
        return Promise.reject(error);
    }
);

axiosInstance.interceptors.response.use(
    (response) => response,
    (error) => {
        if (error.response) {
            console.error('API Error Response:', error.response.data);
        } else if (error.request) {
            console.error('API No Response:', error.request);
            console.error('Possible causes: Server not running, wrong URL, or network issue');
        } else {
            console.error('API Request Setup Error:', error.message);
        }
        return Promise.reject(error);
    }
);