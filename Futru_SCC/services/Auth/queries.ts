import { useAuthStore } from "@/store/useAuthStore";
import { useQuery } from "@tanstack/react-query";

export const useCheckAuthQuery = () => {
    const { checkAuth } = useAuthStore();

    return useQuery({
        queryKey: ["currentUser"],
        queryFn: () => checkAuth(),
        // Add these options to prevent unnecessary refetches that might cause hook issues
        staleTime: 5 * 60 * 1000, // 5 minutes
        refetchOnWindowFocus: false,
        refetchOnMount: true,
        retry: 1,
    });
}