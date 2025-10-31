import { axiosInstance } from "@/lib/axios"
import { createSCCRecordType, useSCCStoreType } from "@/types/sccTypes"
import { create } from "zustand"

export const useSCCStore = create<useSCCStoreType>(() => ({
    createRecord: async(data: createSCCRecordType | FormData) => {
        return (await axiosInstance.post("/add-record", data)).data;
    },
    getRecords: async() => {
        return (await axiosInstance.get("/records")).data;
    },
    getRecord: async(id: string) => {
        return (await axiosInstance.get(`/record/${id}`)).data;
    }
}))