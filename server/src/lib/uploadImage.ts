import { UploadedFile } from "express-fileupload";
import cloudinary from "../config/cloudinary";

export const uploadImage = async (file: UploadedFile): Promise<string> => {
    const result = await cloudinary.uploader.upload(file.tempFilePath, {
        folder: "scc-records" // Folder for organization in Cloudinary
    });
    return result.secure_url;
}