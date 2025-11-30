import { Router } from "express"
import { AuthMiddleware } from "../middlewares/AuthMiddleware";
import { addSCCRecord, getSCCRecord, getSCCRecords } from "../controllers/SCCController";

const router = Router();

router.get("/records", getSCCRecords);
router.post("/add-record", AuthMiddleware, addSCCRecord);
router.get("/record/:id", getSCCRecord);

export default router