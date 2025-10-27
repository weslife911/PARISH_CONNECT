import { z } from "zod"

export const validateSCCRecord = z.object({
    sccName: z.string().min(1, "SCC Name is required"),
    faithSharingName: z.string().min(1, "Faith sharing Name is required"),
    host: z.string().min(1, "Host name is required"),
    date: z.string().min(1, "Date is required"),
    officiatingPriestName: z.string().min(1, "Officiating Priest is required"),
    
    menAttendance: z.number().int("Attendance must be an integer").min(0, "Attendance cannot be negative").optional(),
    womenAttendance: z.number().int("Attendance must be an integer").min(0, "Attendance cannot be negative").optional(),
    youthAttendance: z.number().int("Attendance must be an integer").min(0, "Attendance cannot be negative").optional(),
    catechumenAttendance: z.number().int("Attendance must be an integer").min(0, "Attendance cannot be negative").optional(),
    
    wordOfLife: z.string().min(1, "Word of Life is required"),
    totalOfferings: z.number().min(0, "Offerings cannot be negative").optional(),
    
    task: z.string().min(1, "Task is required"),
    nextHost: z.string().min(1, "Next Host is required"),
    images: z.array(z.string()).optional()
})