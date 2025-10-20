import { useAuthStore } from "@/store/useAuthStore";
import { AuthReturnType, LoginUser } from "@/types/authTypes";
import Toast from "react-native-toast-message";
import { useMutation, useQueryClient } from "@tanstack/react-query"
import AsyncStorage from "@react-native-async-storage/async-storage";

const AUTH_TOKEN_KEY = "auth_token"; 

export const useLoginUserMutation = () => {
    const queryClient = useQueryClient();
    const { loginUser } = useAuthStore();

    return useMutation({
        mutationFn: (data: LoginUser) => loginUser(data),
        onSuccess: async(data: AuthReturnType) => {
            console.log("Login Mutation Success (API returned non-error status)");
            if(data?.success) {
                if(data?.token) {
                    await AsyncStorage.setItem(AUTH_TOKEN_KEY, data?.token); 
                }
                Toast.show({
                    type: "success",
                    text1: data?.message,
                    position: "top",
                    visibilityTime: 4000
                });
            } else {
                Toast.show({
                    type: "error",
                    text1: data?.message || "Login failed due to incorrect credentials.",
                    position: "top",
                    visibilityTime: 4000
                });
            }
        },
        onError: async(error) => {
            console.error("Login Mutation Network/Request Error:", error);
            Toast.show({
                type: "error",
                text1: error.message || "A network or internal error occurred during login.",
                position: "top",
                visibilityTime: 4000
            });
        },
        onSettled: async(_, error) => {
            if(error) {
                console.error("Login Mutation Settled with Error:", error); 
            } else {
                await queryClient.invalidateQueries({
                    queryKey: ["currentUser"]
                });
            }
        }
    });
}

export const UseLogoutMutation = () => {

    const { logout } = useAuthStore();
    const queryClient = useQueryClient();

    return useMutation({
        mutationKey: ["currentUser"],
        mutationFn: async () => await logout(),
        onSuccess: async() => {
            Toast.show({
                type: "success",
                text1: "Logged out successfully",
                position: "top",
                visibilityTime: 4000
            });
        },
        onSettled: async () => {
            await queryClient.invalidateQueries({ queryKey: ["currentUser"] }); 
        }
    })
}