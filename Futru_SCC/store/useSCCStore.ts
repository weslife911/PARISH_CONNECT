import { axiosIntance } from "@/lib/axios"
import { createSCCRecordType, useSCCStoreType } from "@/types/sccTypes"
import { create } from "zustand"

export const useSCCStore = create<useSCCStoreType>(() => ({
    createRecord: async(data: createSCCRecordType) => {
        return (await axiosIntance.post("add-record", data)).data;
    }
}))