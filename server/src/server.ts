import express, { Application, Request, Response } from "express"
import { config } from "dotenv"
import { connectToDb } from "./db/connectToDb";
import AuthRoutes from "./routes/AuthRoutes"
import SCCRoutes from "./routes/SCCRoutes"
import cors from "cors"

config();

const app: Application = express();

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use(cors({
    origin: "*",
    credentials: true,
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization']
}));

app.use("/api/v1", AuthRoutes);
app.use("/api/v1", SCCRoutes);

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

