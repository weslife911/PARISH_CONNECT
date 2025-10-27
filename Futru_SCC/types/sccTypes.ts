// sccTypes.ts

export type createSCCRecordType = {
    _id?: string,
    sccName: string,
    faithSharingName: string,
    host: string,
    date: string,
    officiatingPriestName: string,
    menAttendance?: number,
    womenAttendance?: number,
    youthAttendance?: number,
    catechumenAttendance?: number,
    wordOfLife: string,
    totalOfferings?: number,
    task: string,
    nextHost: string,
    createdAt?: string,
    updatedAt?: string
}

// NEW: Type for a record that has been saved and retrieved from the database
export type SCCRecord = Omit<createSCCRecordType, '_id'> & { _id: string }; //

export type sccRecordReturnType = {
    success: boolean,
    message?: string,
    // Use the new SCCRecord type for fetched records
    records?: SCCRecord[], //
    record?: SCCRecord //
}

export type useSCCStoreType = {
    createRecord: (data: createSCCRecordType) => Promise<sccRecordReturnType>,
    getRecords: () => Promise<sccRecordReturnType>,
    getRecord: (id: string) => Promise<sccRecordReturnType>,
}