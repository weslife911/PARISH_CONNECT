// MissionController.ts
import Mission from "../models/Mission";
import { Request, Response } from "express";
import { validateMissionRecord } from "../validation/Mission/validateMissionRecord";

export const addMissionRecord = async (req: Request, res: Response) => {
    try {
        const validation = validateMissionRecord.safeParse(req.body);

        if (!validation.success) {
            return res.status(400).json({
                success: false,
                message: validation.error.issues[0]?.message
            });
        }

        const record = await Mission.create(validation.data);

        return res.status(201).json({
            success: true,
            message: "Mission Commission report created successfully!",
            record
        });
    } catch (e: any) {
        return res.status(500).json({
            success: false,
            message: "Internal server error during record creation",
            error: e.message
        });
    }
};

export const getMissionRecords = async (req: Request, res: Response) => {
    try {
        const records = await Mission.find({}).sort({ createdAt: -1 });
        return res.status(200).json({
            success: true,
            records
        });
    } catch (e: any) {
        return res.status(500).json({ success: false, error: e.message });
    }
};
