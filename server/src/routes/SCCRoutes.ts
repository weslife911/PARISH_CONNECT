import { Router } from "express"
import { addSCCRecord } from "../controllers/SCCController";

const router = Router();

router.post("/add-record", addSCCRecord);

export default router