import SCC from "../models/SCC";
import { Request, Response } from "express"
import { validateSCCRecord } from "../validation/SCC/validateSCCRecord";

export const addSCCRecord = async(req: Request, res: Response) => {
    try {

        const validation = validateSCCRecord.safeParse(req.body);

        if(!validation.success) return res.json({
            success: false,
            message: validation.error.issues[0]?.message
        });

        const { sccName, faithSharingName, host, date, officiatingPriestName, menAttendance, womenAttendance, youthAttendance, catechumenAttendance, wordOfLife, totalOfferings, task, nextHost, images } = validation.data;

        const record = await new SCC({
            sccName,
            faithSharingName,
            host,
            date,
            officiatingPriestName,
            menAttendance: menAttendance || 0,
            womenAttendance: womenAttendance || 0,
            youthAttendance: youthAttendance || 0,
            catechumenAttendance: catechumenAttendance || 0,
            wordOfLife,
            totalOfferings: totalOfferings || 0,
            task,
            nextHost,
            images
        });

        if(!record) return res.json({
            success: false,
            message: "Error while creating record"
        })

        return res.json({
            success: false,
            message: "Record created successfuly!"
        })

    } catch (e: any) {
        console.error("Signup error:", e);
        return res.status(500).json({
            success: false,
            message: "Internal server error",
            error: e instanceof Error ? e.message : "An unknown error occurred"
        });
    }
}