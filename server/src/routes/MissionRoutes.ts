// MissionRoutes.ts
import { Router } from "express";
import { AuthMiddleware } from "../middlewares/AuthMiddleware";
import { addMissionRecord, getMissionRecords } from "../controllers/MissionController";

const router = Router();

router.post("/mission/add-record", AuthMiddleware, addMissionRecord);
router.get("/mission/records", AuthMiddleware, getMissionRecords);

export default router;
