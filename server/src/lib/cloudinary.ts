import { v2 as cloudinary } from "cloudinary";
import { config } from "dotenv";

config();

const CLOUDINARY_NAME: string | undefined = process.env.CLOUDINARY_NAME;
const CLOUDINARY_API_KEY: string | undefined = process.env.CLOUDINARY_API_KEY;
const CLOUDINARY_API_SECRET: string | undefined = process.env.CLOUDINARY_API_SECRET;

if (!CLOUDINARY_NAME || !CLOUDINARY_API_KEY || !CLOUDINARY_API_SECRET) {
    throw new Error(
        "Cloudinary configuration environment variables (CLOUDINARY_NAME, CLOUDINARY_API_KEY, CLOUDINARY_API_SECRET) must be set."
    );
}

cloudinary.config({
    cloud_name: CLOUDINARY_NAME as string,
    api_key: CLOUDINARY_API_KEY as string,
    api_secret: CLOUDINARY_API_SECRET as string
});

export default cloudinary;