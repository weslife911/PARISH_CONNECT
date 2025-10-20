import { Router } from "express"
import { checkAuth, LoginController, SignupController } from "../controllers/AuthController";
import { AuthMiddleware } from "../middlewares/AuthMiddleware";

const router = Router();

router.post("/signup", SignupController);
router.post("/login", LoginController);
router.get("/check", AuthMiddleware, checkAuth);

export default router