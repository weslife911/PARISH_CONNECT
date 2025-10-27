// queries.ts
import { useSCCStore } from "@/store/useSCCStore";
import { useQuery } from "@tanstack/react-query"

export const useGetSCCRecordsQuery = () => {

    const { getRecords }= useSCCStore();

    return useQuery({
        queryKey: ["records"],
        queryFn: () => getRecords(),  
    });

}

export const useGetSCCRecordQuery = (id: string) => {
    const { getRecord }= useSCCStore();

    return useQuery({
        // CORRECTED: Use the ID in the query key for unique caching
        queryKey: ["record", id],
        queryFn: () => getRecord(id),
        // NEW: Only run the query if the ID is a truthy value (i.e., not an empty string or undefined)
        enabled: !!id, 
    });
}