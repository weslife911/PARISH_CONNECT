// sccTypes.ts

export type ImageUri = {
    uri: string;
    mimeType?: string;
};

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
    images?: ImageUri[],
    createdAt?: string,
    updatedAt?: string
}

export type SCCRecord = Omit<createSCCRecordType, '_id'> & { _id: string };

export type sccRecordReturnType = {
    success: boolean,
    message?: string,
    records?: SCCRecord[], //
    record?: SCCRecord //
}

export type useSCCStoreType = {
    createRecord: (data: createSCCRecordType | FormData) => Promise<sccRecordReturnType>,
    getRecords: () => Promise<sccRecordReturnType>,
    getRecord: (id: string) => Promise<sccRecordReturnType>,
}