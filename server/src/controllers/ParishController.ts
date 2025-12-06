// controllers/ParishController.ts

import Parish from "../models/Parish";
import { Request, Response } from "express";
import { validateParishRecord } from "../validation/Parish/validateParishRecord";

export const addParishRecord = async(req: Request, res: Response) => {
    try {
        const transformedBody = {
            ...req.body,
        };

        const validation = validateParishRecord.safeParse(transformedBody);

        if (!validation.success) {
            return res.status(400).json({
                success: false,
                message: validation.error.issues[0]?.message
            });
        }

        const { 
            commissionName, periodCovered, totalMembers, missionsRepresented, 
            generalMeetings, activeMembers, excoMeetings, activities, 
            problemsAndSolutions, issuesForCouncil, futurePlans
        } = validation.data;

        // --- RECORD CREATION ---
        const record = await Parish.create({
            commissionName,
            periodCovered: new Date(periodCovered), // Convert string to Date
            totalMembers,
            missionsRepresented,
            generalMeetings,
            activeMembers,
            excoMeetings,
            activities,
            problemsAndSolutions,
            issuesForCouncil,
            futurePlans
        });

        if(!record) return res.status(500).json({
            success: false,
            message: "Error while creating record in database"
        });

        return res.status(201).json({
            success: true,
            message: "Parish record created successfully!"
        });

    } catch (e: any) {
        console.error("Add Parish Record error:", e);
        return res.status(500).json({
            success: false,
            message: "Internal server error during record creation",
            error: e instanceof Error ? e.message : "An unknown error occurred"
        });
    }
}

export const getParishRecords = async(req: Request, res: Response) => {
    try {
        const parishes = await Parish.find({});

        if(!parishes || parishes.length === 0) return res.json({
            success: false,
            message: "No Parish Records found"
        });

        return res.status(200).json({
            success: true,
            message: "Records fetched successfully.",
            parishes 
        });

    } catch (e: any) {
        console.error("Getting Parish Records error:", e);
        return res.status(500).json({
            success: false,
            message: "Internal server error",
            error: e instanceof Error ? e.message : "An unknown error occurred"
        });
    }
}

export const getParishRecord = async(req: Request, res: Response) => {
    try {
        const { id } = req.params;

        const parish = await Parish.findById(id);

        if(!parish) return res.json({
            success: false,
            message: "Record with given ID does not exist!"
        })

        return res.status(200).json({
            success: true,
            message: "Record fetched successfully.",
            parish 
        });

    } catch (e: any) {
        console.error("Getting Parish Record error:", e);
        return res.status(500).json({
            success: false,
            message: "Internal server error",
            error: e instanceof Error ? e.message : "An unknown error occurred"
        });
    }
}