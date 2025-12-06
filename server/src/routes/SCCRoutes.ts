import { Router } from "express"
import { AuthMiddleware } from "../middlewares/AuthMiddleware";
import { addSCCRecord, getSCCRecord, getSCCRecords } from "../controllers/SCCController";

const router = Router();

router.get("/scc/records", AuthMiddleware, getSCCRecords);
router.get("/scc/record/:id", AuthMiddleware, getSCCRecord);
router.post("/scc/add-record", AuthMiddleware, addSCCRecord);

export default router