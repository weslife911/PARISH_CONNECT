// SCCController.ts

import SCC from "../models/SCC";
import { Request, Response } from "express"
import { validateSCCRecord } from "../validation/SCC/validateSCCRecord";
// --- REMOVED: express-fileupload imports ---
// import { UploadedFile, FileArray } from "express-fileupload"; 
import cloudinary from "../config/cloudinary";

// Define the structure of the incoming Base64 image data
interface Base64ImagePayload {
    base64: string;
    mimeType: string;
}

export const addSCCRecord = async(req: Request, res: Response) => {
    try {
        
        // Extract the Base64 images array from the JSON request body
        const images: Base64ImagePayload[] | undefined = req.body.images;

        const transformedBody = {
            ...req.body,
            menAttendance: req.body.menAttendance ? Number(req.body.menAttendance) : undefined,
            womenAttendance: req.body.womenAttendance ? Number(req.body.womenAttendance) : undefined,
            youthAttendance: req.body.youthAttendance ? Number(req.body.youthAttendance) : undefined,
            catechumenAttendance: req.body.catechumenAttendance ? Number(req.body.catechumenAttendance) : undefined,
            totalOfferings: req.body.totalOfferings ? Number(req.body.totalOfferings) : undefined,
        };

        const validation = validateSCCRecord.safeParse(transformedBody);

        if (!validation.success) {
            return res.status(400).json({
                success: false,
                message: validation.error.issues[0]?.message
            });
        }

        const { sccName, faithSharingName, host, date, officiatingPriestName, menAttendance, womenAttendance, youthAttendance, catechumenAttendance, wordOfLife, totalOfferings, task, nextHost } = validation.data;
        
        // --- 2. IMAGE UPLOAD LOGIC (MODIFIED for Base64) ---
        let imageUrls: string[] = [];
        
        if (images && images.length > 0) {
            
            // Function to upload a single Base64 string to Cloudinary
            const uploadBase64ToCloudinary = async (image: Base64ImagePayload): Promise<string> => {
                // Cloudinary accepts a data URI string: data:[<Mime-type>][;base64],<data>
                const dataUri = `data:${image.mimeType};base64,${image.base64}`;
                
                const result = await cloudinary.uploader.upload(dataUri, {
                    folder: "scc-records" // Folder for organization in Cloudinary
                });
                return result.secure_url;
            };

            // Upload images to Cloudinary concurrently using Promise.all
            const uploadPromises = images.map(uploadBase64ToCloudinary);
            imageUrls = await Promise.all(uploadPromises);
        }
        
        // --- 3. RECORD CREATION ---

        const record = await SCC.create({
            sccName,
            faithSharingName,
            host,
            date,
            officiatingPriestName,
            menAttendance: menAttendance ?? 0, 
            womenAttendance: womenAttendance ?? 0,
            youthAttendance: youthAttendance ?? 0,
            catechumenAttendance: catechumenAttendance ?? 0,
            wordOfLife,
            totalOfferings: totalOfferings ?? 0, 
            task,
            nextHost,
            images: imageUrls
        });

        if(!record) return res.status(500).json({
            success: false,
            message: "Error while creating record in database"
        });

        return res.status(201).json({
            success: true,
            message: "Record created successfully!",
            record
        });

    } catch (e: any) {
        console.error("Add SCC Record error:", e);
        // Handle specific Cloudinary error if needed, or return a general 500 error
        return res.status(500).json({
            success: false,
            message: "Internal server error during record creation or file upload",
            error: e instanceof Error ? e.message : "An unknown error occurred"
        });
    }
}

export const getSCCRecords = async(req: Request, res: Response) => {
    try {

        const records = await SCC.find({});

        if(!records) return res.json({
            success: false,
            message: "No SCC Records found"
        });

        return res.status(200).json({
            success: true,
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

        return res.status(200).json({
            success: true,
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