import jwt from "jsonwebtoken"
import { config } from "dotenv"

config();

const JWT_SECRET_KEY = process.env.JWT_SECRET_KEY;

export const decodeToken = (token: string) => {
    if(!JWT_SECRET_KEY) return;
    return jwt.verify(token, JWT_SECRET_KEY);
}