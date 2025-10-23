import { Router } from "express"
import { checkAuth, loginUser, resetPassword, signupUser, verifyEmail } from "../controllers/AuthController";
import { AuthMiddleware } from "../middlewares/AuthMiddleware";

const router = Router();

router.post("/signup", signupUser);
router.post("/login", loginUser);
router.get("/check", AuthMiddleware, checkAuth);
router.post("/verify", verifyEmail);
router.put("/reset", resetPassword);

export default router