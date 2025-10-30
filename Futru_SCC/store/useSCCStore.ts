import { axiosIntance } from "@/lib/axios"
import { createSCCRecordType, useSCCStoreType } from "@/types/sccTypes"
import { create } from "zustand"

export const useSCCStore = create<useSCCStoreType>(() => ({
    createRecord: async(data: createSCCRecordType | FormData) => {
        return (await axiosIntance.post("/add-record", data)).data;
    },
    getRecords: async() => {
        return (await axiosIntance.get("/records")).data;
    },
    getRecord: async(id: string) => {
        return (await axiosIntance.get(`/record/${id}`)).data;
    }
}))