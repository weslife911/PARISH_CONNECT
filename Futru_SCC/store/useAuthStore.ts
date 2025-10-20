import { create } from "zustand"
import { AuthReturnType, LoginUser, SignupUser, useAuthStoreType } from "@/types/authTypes"
import { axiosIntance } from "@/lib/axios";
import AsyncStorage from "@react-native-async-storage/async-storage";

const AUTH_TOKEN_KEY = "auth_token";

export const useAuthStore = create<useAuthStoreType>((set) => ({
    isAuthenticated: false,

    loginUser: async(data: LoginUser): Promise<AuthReturnType> => {
        try {
            const response = await axiosIntance.post("/login", data);
            const authData: AuthReturnType = response.data;

            if (authData.success && authData.token) {
                await AsyncStorage.setItem(AUTH_TOKEN_KEY, authData.token);
                set({ isAuthenticated: true }); 
                return authData;
            } else {
                set({ isAuthenticated: false });
                return authData;
            }
        } catch (error: any) {
            set({ isAuthenticated: false });
            
            const errorMessage = 
                error.response?.data?.message || 
                error.message || 
                "Network error occurred";
            
            throw new Error(errorMessage);
        }
    },
    
    signupUser: async(data: SignupUser): Promise<AuthReturnType> => {
        try {
            const response = await axiosIntance.post("/signup", data);
            return response.data;
        } catch (error: any) {
            throw new Error(
                error.response?.data?.message || 
                error.message || 
                "Signup failed"
            );
        }
    },
    
    checkAuth: async () => {
        const auth_token = await AsyncStorage.getItem(AUTH_TOKEN_KEY);

        if (!auth_token) {
            set({ isAuthenticated: false });
            return null;
        }

        console.log(auth_token);

        try {
            const response = await axiosIntance.get("/check", {
                headers: {
                    Authorization: `Bearer ${auth_token}`
                }
            });

            if (response.data && response.data.success !== false) {
                set({ 
                    isAuthenticated: true,
                });
                return response.data;
            }
            set({ isAuthenticated: false });
            return null; 

        } catch (error) {
            console.error("Authentication check failed:", error);
            
            set({ isAuthenticated: false }); 
            return null;
        }
    },

    logout: async() => {
        try {
            await AsyncStorage.removeItem(AUTH_TOKEN_KEY);
            set({ isAuthenticated: false });
        } catch (error) {
            console.error("Error during logout:", error);
        }
    }
}));