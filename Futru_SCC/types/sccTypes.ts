

export type createSCCRecordType = {
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
    nextHost: string
}

export type sccRecordReturnType = {
    success: boolean,
    message: string
}

export type useSCCStoreType = {
    createRecord: (data: createSCCRecordType) => Promise<sccRecordReturnType>
}