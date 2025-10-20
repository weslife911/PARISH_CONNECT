import { useAuthStore } from "@/store/useAuthStore";
import { useQuery } from "@tanstack/react-query";

export const UseCheckAuthQuery = () => {

    const { checkAuth } = useAuthStore();

    return useQuery({
        queryKey: ["currentUser"],
        queryFn: () => checkAuth()
    });

}