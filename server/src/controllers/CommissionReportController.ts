// CommissionReportController.ts

import { Request, Response } from "express"
import cloudinary from "../config/cloudinary";
import { validateCommissionReport } from "../validation/Commision/validateCommissionReport";
import CommissionReport from "../models/CommisionReport";

interface Base64ImagePayload {
    base64: string;
    mimeType: string;
}

/**
 * Creates a new Commission Report record, including Base64 image uploads to Cloudinary.
 */
export const addCommissionReport = async(req: Request, res: Response) => {
    try {
        
        const images: Base64ImagePayload[] | undefined = req.body.images;

        // Transform numeric fields from string to Number for Zod validation
        const transformedBody = {
            ...req.body,
            peopleInCommission: req.body.peopleInCommission ? Number(req.body.peopleInCommission) : undefined,
            numberOfMeetingsHeld: req.body.numberOfMeetingsHeld ? Number(req.body.numberOfMeetingsHeld) : undefined,
            numberOfFormationMeetings: req.body.numberOfFormationMeetings ? Number(req.body.numberOfFormationMeetings) : undefined,
            // Array fields are handled directly
        };

        const validation = validateCommissionReport.safeParse(transformedBody);

        if (!validation.success) {
            return res.status(400).json({
                success: false,
                message: validation.error.issues[0]?.message
            });
        }

        const { 
            commissionName, deanery, archdiocese, peopleInCommission, 
            numberOfMeetingsHeld, numberOfFormationMeetings, themesTreated, 
            activities, achievements, difficulties, proposedSolutions, // These are now arrays
            secretaryName, chairpersonName, reportReference
        } = validation.data;
        
        // --- IMAGE UPLOAD LOGIC ---
        let imageUrls: string[] = [];
        
        if (images && images.length > 0) {
            
            const uploadBase64ToCloudinary = async (image: Base64ImagePayload): Promise<string> => {
                const dataUri = `data:${image.mimeType};base64,${image.base64}`;
                
                const result = await cloudinary.uploader.upload(dataUri, {
                    folder: "commission-reports" 
                });
                return result.secure_url;
            };

            const uploadPromises = images.map(uploadBase64ToCloudinary);
            imageUrls = await Promise.all(uploadPromises);
        }
        
        // --- RECORD CREATION ---

        const record = await CommissionReport.create({
            commissionName,
            deanery, 
            archdiocese,
            peopleInCommission: peopleInCommission ?? 0, 
            numberOfMeetingsHeld: numberOfMeetingsHeld ?? 0,
            numberOfFormationMeetings: numberOfFormationMeetings ?? 0,
            themesTreated,
            activities, 
            achievements, 
            difficulties, 
            proposedSolutions, 
            secretaryName,
            chairpersonName,
            reportReference,
            images: imageUrls
        });

        if(!record) return res.status(500).json({
            success: false,
            message: "Error while creating record in database"
        });

        return res.status(201).json({
            success: true,
            message: "Commission Report created successfully!",
            record
        });

    } catch (e: any) {
        console.error("Add Commission Report error:", e);
        return res.status(500).json({
            success: false,
            message: "Internal server error during record creation or file upload",
            error: e instanceof Error ? e.message : "An unknown error occurred"
        });
    }
}

/**
 * Retrieves all Commission Report records.
 */
export const getCommissionReports = async(req: Request, res: Response) => {
    try {

        const records = await CommissionReport.find({});

        if(!records || records.length === 0) return res.json({
            success: false,
            message: "No Commission Reports found"
        });

        return res.status(200).json({
            success: true,
            records
        });

    } catch (e: any) {
        console.error("Getting Commission Reports error:", e);
        return res.status(500).json({
            success: false,
            message: "Internal server error",
            error: e instanceof Error ? e.message : "An unknown error occurred"
        });
    }
}

/**
 * Retrieves a single Commission Report record by ID.
 */
export const getCommissionReport = async(req: Request, res: Response) => {
    try {

        const { id } = req.params;

        const record = await CommissionReport.findById(id);

        if(!record) return res.json({
            success: false,
            message: "Record with given ID does not exist!"
        })

        return res.status(200).json({
            success: true,
            record
        });

    } catch (e: any) {
        console.error("Getting Commission Report error:", e);
        return res.status(500).json({
            success: false,
            message: "Internal server error",
            error: e instanceof Error ? e.message : "An unknown error occurred"
        });
    }
}