import express, { Application, Request, Response } from "express"
import { config } from "dotenv"
import { connectToDb } from "./db/connectToDb";
import AuthRoutes from "./routes/AuthRoutes"
import SCCRoutes from "./routes/SCCRoutes"
import ParishRoutes from "./routes/ParishRoutes";
import MissionRoutes from "./routes/MissionRoutes"
import cors from "cors"

config();

const app: Application = express();

connectToDb();

app.use(express.json({ limit: '50mb' }));
app.use(express.urlencoded({ extended: true, limit: '50mb' }));

app.use(cors({
    origin: "*",
    credentials: true,
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization']
}));

app.get("/", (req, res) => res.send("Parish Connect Backend Live"));

app.use("/api/v1", AuthRoutes);
app.use("/api/v1", ParishRoutes);
app.use("/api/v1", SCCRoutes);
app.use("/api/v1", MissionRoutes);

app.get("/health", (req: Request, res: Response) => {
    return res.status(200).json({
        status: 'healthy',
        uptime: process.uptime(),
        timestamp: Date.now()
    });
})

export default app;

const PORT: number = parseInt(process.env.PORT || '8080', 10);
app.listen(PORT, () => {
    console.log(`Server is running locally on port ${PORT}`);
});