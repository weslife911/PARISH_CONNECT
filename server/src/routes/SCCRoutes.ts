import { Router } from "express"
import { AuthMiddleware } from "../middlewares/AuthMiddleware";
import { addSCCRecord, getSCCRecord, getSCCRecords } from "../controllers/SCCController";

const router = Router();

router.get("/records", AuthMiddleware, getSCCRecords);
router.get("/record/:id", AuthMiddleware, getSCCRecord);
router.post("/add-record", AuthMiddleware, addSCCRecord);

export default router