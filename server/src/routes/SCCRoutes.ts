import { Router } from "express"
import { addSCCRecord, getSCCRecord, getSCCRecords } from "../controllers/SCCController";

const router = Router();

router.post("/add-record", addSCCRecord);
router.get("/records", getSCCRecords);
router.get("/record/:id", getSCCRecord);

export default router