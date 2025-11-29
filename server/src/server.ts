// server.ts

import express, { Application, Request, Response } from "express"
import { config } from "dotenv"
import connectToDb from "./db/connectToDb";
import AuthRoutes from "./routes/AuthRoutes"
import CommisionRoutes from "./routes/CommisionRoutes"
import cors from "cors"
// --- REMOVED IMPORT: express-fileupload is no longer used ---
// import fileUpload from 'express-fileupload';

config();

const app: Application = express();

// The JSON limit is essential to handle large Base64 image strings.
app.use(express.json({ limit: '50mb' })); 
app.use(express.urlencoded({ extended: true, limit: '50mb' }));

// --- REMOVED MIDDLEWARE: express-fileupload is no longer used ---
/*
app.use(fileUpload({ 
    useTempFiles: true, 
    tempFileDir: '/tmp/' 
}));
*/

app.use(cors({
    origin: "*",
    credentials: true,
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization']
}));

app.use("/api/v1", AuthRoutes);
app.use("/api/v1", CommisionRoutes);

app.get("/health", (req: Request, res: Response) => {
    return res.status(200).json({
        status: 'healthy',
        uptime: process.uptime(),
        timestamp: Date.now()
    });
})

const PORT: number = parseInt(process.env.PORT || '8080', 10) || 8080;

app.listen(PORT, "0.0.0.0", () => {
    connectToDb();
    console.log(`Server is running on port ${PORT}`);
})