import jwt from "jsonwebtoken"
import { config } from "dotenv"

config();

export const generateToken = (userId: string) => {
    return jwt.sign({ id: userId }, process.env.JWT_SECRET_KEY as string);
}