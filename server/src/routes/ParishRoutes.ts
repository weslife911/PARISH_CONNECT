// routes/ParishRoutes.ts

import { Router } from "express";
import { AuthMiddleware } from "../middlewares/AuthMiddleware";
import { addParishRecord, getParishRecord, getParishRecords } from "../controllers/ParishController";

const router = Router();

router.get("/parish/records", AuthMiddleware, getParishRecords);
router.get("/parish/record/:id", AuthMiddleware, getParishRecord);
router.post("/parish/add-record", AuthMiddleware, addParishRecord);

export default router;