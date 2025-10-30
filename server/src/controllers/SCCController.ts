import SCC from "../models/SCC";
import { Request, Response } from "express"
import { validateSCCRecord } from "../validation/SCC/validateSCCRecord";
import { uploadImage } from "../lib/uploadImage";
import { UploadedFile } from "express-fileupload";

export const addSCCRecord = async(req: Request, res: Response) => {
    try {
        const validation = validateSCCRecord.safeParse(req.body);

        if(!validation.success) return res.json({
            success: false,
            message: validation.error.issues[0]?.message
        });

        const { sccName, faithSharingName, host, date, officiatingPriestName, menAttendance, womenAttendance, youthAttendance, catechumenAttendance, wordOfLife, totalOfferings, task, nextHost } = validation.data;
        
        // --- MULTIPLE IMAGE UPLOAD LOGIC ---
        let imageUrls: string[] = [];
        // req.files.images holds the file data provided by express-fileupload
        const files = req.files ? req.files.images : undefined;
        
        if (files) {
            // express-fileupload returns an array if multiple files are uploaded, or a single object if one file.
            // We ensure it's always an array for uniform processing.
            const imageArray: UploadedFile[] = Array.isArray(files) ? files : [files as UploadedFile];
            
            // Upload images to Cloudinary concurrently using Promise.all
            const uploadPromises = imageArray.map(uploadImage);
            imageUrls = await Promise.all(uploadPromises);
        }
        // --- END IMAGE UPLOAD LOGIC ---

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

        if(!record) return res.json({
            success: false,
            message: "Error while creating record"
        })

        return res.json({
            success: true,
            message: "Record created successfully!"
        })

    } catch (e: any) {
        console.error("Add SCC Record error:", e);
        return res.status(500).json({
            success: false,
            message: "Internal server error",
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