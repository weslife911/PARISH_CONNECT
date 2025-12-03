// SCCController.ts

import SCC from "../models/SCC";
import { Request, Response } from "express"
import { validateSCCRecord } from "../validation/SCC/validateSCCRecord";
// Removed: import cloudinary from "../config/cloudinary";

// Removed: interface Base64ImagePayload 

export const addSCCRecord = async(req: Request, res: Response) => {
    try {
        
        // Removed: Image extraction logic (const images: Base64ImagePayload[]...)

        // Validation data now directly maps to the SccReportModel fields.
        const transformedBody = {
            ...req.body,
        };

        const validation = validateSCCRecord.safeParse(transformedBody);

        if (!validation.success) {
            return res.status(400).json({
                success: false,
                message: validation.error.issues[0]?.message
            });
        }

        // Destructure ALL validated fields
        const { 
            sccName, periodStart, periodEnd, totalFamilies, gospelSharingGroups, 
            councilMeetings, generalMeetings, noOfCommissions, activeCommissions, 
            totalMembership, gospelSharingExpected, gospelSharingDone, noChristiansAttendingGS, 
            gsAttendancePercentage, children, youth, adults, baptism, lapsedChristians, 
            irregularMarriages, burials, biblicalApostolateActivities, liturgyActivities, 
            financeActivities, familyLifeActivities, justiceAndPeaceActivities, 
            youthApostolateActivities, catecheticalActivities, healthCareActivities, 
            socialCommunicationActivities, socialWelfareActivities, educationActivities, 
            vocationActivities, dialogueActivities, womensAffairsActivities, 
            mensAffairsActivities, prayerAndActionActivities, problemsEncountered, 
            proposedSolutions, issuesForCouncil, nextMonthPlan 
        } = validation.data;
        
        // --- 2. IMAGE UPLOAD LOGIC (REMOVED) ---
        // Removed: let imageUrls: string[] = [];
        // Removed: if (images && images.length > 0) { ... upload logic ... }
        
        // --- 3. RECORD CREATION (Using ALL new fields) ---

        const record = await SCC.create({
            sccName,
            periodStart: new Date(periodStart), // Convert string to Date
            periodEnd: new Date(periodEnd), // Convert string to Date
            totalFamilies,
            gospelSharingGroups,
            councilMeetings,
            generalMeetings,
            noOfCommissions,
            activeCommissions,
            totalMembership,
            gospelSharingExpected,
            gospelSharingDone,
            noChristiansAttendingGS,
            gsAttendancePercentage,
            children,
            youth,
            adults,
            baptism,
            lapsedChristians,
            irregularMarriages,
            burials,
            biblicalApostolateActivities,
            liturgyActivities,
            financeActivities,
            familyLifeActivities,
            justiceAndPeaceActivities,
            youthApostolateActivities,
            catecheticalActivities,
            healthCareActivities,
            socialCommunicationActivities,
            socialWelfareActivities,
            educationActivities,
            vocationActivities,
            dialogueActivities,
            womensAffairsActivities,
            mensAffairsActivities,
            prayerAndActionActivities,
            problemsEncountered,
            proposedSolutions,
            issuesForCouncil,
            nextMonthPlan,
            // Removed: images: imageUrls 
        });

        if(!record) return res.status(500).json({
            success: false,
            message: "Error while creating record in database"
        });

        // SUCCESS RESPONSE FORMAT
        return res.status(201).json({
            success: true,
            message: "Record created successfully!"
        });

    } catch (e: any) {
        console.error("Add SCC Record error:", e);
        // Changed message to reflect no file upload is occurring
        return res.status(500).json({
            success: false,
            message: "Internal server error during record creation",
            error: e instanceof Error ? e.message : "An unknown error occurred"
        });
    }
}

export const getSCCRecords = async(req: Request, res: Response) => {
    try {

        const records = await SCC.find({});

        if(!records || records.length === 0) return res.json({
            success: false,
            message: "No SCC Records found"
        });

        // RESPONSE FORMAT
        return res.status(200).json({
            success: true,
            message: "Records fetched successfully.",
            records
        });

    } catch (e: any) {
        console.error("Getting SCC Records error:", e);
        return res.status(500).json({
            success: false,
            message: "Internal server error",
            error: e instanceof Error ? e.message : "An unknown error occurred"
        });
    }
}

export const getSCCRecord = async(req: Request, res: Response) => {
    try {

        const { id } = req.params;

        const record = await SCC.findById(id);

        if(!record) return res.json({
            success: false,
            message: "Record with given ID does not exist!"
        })

        // RESPONSE FORMAT
        return res.status(200).json({
            success: true,
            message: "Record fetched successfully.",
            record
        });

    } catch (e: any) {
        console.error("Getting SCC Record error:", e);
        return res.status(500).json({
            success: false,
            message: "Internal server error",
            error: e instanceof Error ? e.message : "An unknown error occurred"
        });
    }
}