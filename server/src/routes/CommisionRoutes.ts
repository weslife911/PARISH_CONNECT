import { Router } from "express"
import { addCommissionReport, getCommissionReports, getCommissionReport } from "../controllers/CommissionReportController";
import { AdminMiddleware } from "../middlewares/AdminMiddleware";

const router = Router();

router.post("/add-commission", AdminMiddleware, addCommissionReport);
router.get("/commissions", getCommissionReports);
router.get("/commission/:id", getCommissionReport);

export default router