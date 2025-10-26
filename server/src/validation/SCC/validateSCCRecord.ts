import { z } from "zod"

export const validateSCCRecord = z.object({
    sccName: z.string().min(1, "SCC Name is required"),
    faithSharingName: z.string().min(1, "Faith sharing Name is required"),
    host: z.string("Host name is required"),
    date: z.string().optional(),
    officiatingPriestName: z.string().optional(),
    menAttendance: z.number().int("Attendance must be an integer").min(0, "Attendance cannot be negative"),
    womenAttendance: z.number().int("Attendance must be an integer").min(0, "Attendance cannot be negative"),
    youthAttendance: z.number().int("Attendance must be an integer").min(0, "Attendance cannot be negative"),
    catechumenAttendance: z.number().int("Attendance must be an integer").min(0, "Attendance cannot be negative"),
    wordOfLife: z.string().min(1, "Word of Life is required"),
    totalOfferings: z.number().optional(),
    task: z.string().optional(),
    nextHost: z.string("Host name is required"),
    images: z.array(z.string()).optional()
})