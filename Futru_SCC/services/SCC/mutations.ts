import { useSCCStore } from "@/store/useSCCStore"
import { createSCCRecordType, sccRecordReturnType } from "@/types/sccTypes";
import { useMutation, useQueryClient } from "@tanstack/react-query"
import Toast from "react-native-toast-message";

export const useCreateSCCRecordMutation = () => {
    const { createRecord } = useSCCStore();
    const queryClient = useQueryClient();

    return useMutation({
        mutationFn: (data: createSCCRecordType) => createRecord(data),
        onSuccess: (data: sccRecordReturnType) => {
            if(data.success) {
                Toast.show({
                    type: "success",
                    text1: data?.message,
                    position: "top",
                    visibilityTime: 4000
                });
            } else {
                Toast.show({
                    type: "error",
                    text1: data?.message,
                    position: "top",
                    visibilityTime: 4000
                });
            }
        },
        onError: async(error) => {
            console.error("Record Mutation Network/Request Error:", error);
            Toast.show({
                type: "error",
                text1: error.message || "A network or internal error occurred during adding record.",
                position: "top",
                visibilityTime: 4000
            });
        },
        onSettled: async(_, error) => {
            if(error) {
                console.error("Record Mutation Settled with Error:", error); 
            } else {
                await queryClient.invalidateQueries({
                    queryKey: ["record"]
                });
            }
        }
    });
}