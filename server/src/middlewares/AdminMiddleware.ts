import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import User from '../models/User';
import { UserDocument } from '../types/Auth/IUser';

declare global {
  namespace Express {
    interface Request {
      user?: UserDocument; 
    }
  }
}

export const AdminMiddleware = async(req: Request, res: Response, next: NextFunction) => {
  try {
    const authHeader = req.headers.authorization;
    
    const secretKey = process.env.JWT_SECRET_KEY;
    if (!secretKey) {
      console.error("JWT_SECRET_KEY is not set in environment variables!");
      return res.status(500).json({
        success: false,
        message: "Server configuration error: JWT Secret Key missing."
      });
    }

    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({
        success: false,
        message: "Token not provided!"
      });
    }

    const token = authHeader.replace("Bearer ", "");
    if (!token) {
      return res.status(401).json({
        success: false,
        message: "Token not provided!"
      });
    }
    
    const decoded = jwt.verify(token, secretKey) as { id: string };
    
    if (!decoded || !decoded.id) { 
      return res.status(401).json({
        success: false,
        message: "Invalid or corrupt token payload!"
      });
    }
    
    const user = await User.findById(decoded.id).select("-password"); 
    
    if (!user) {
      return res.status(401).json({
        success: false,
        message: "User with given ID does not exist!"
      });
    }

    if(user && user.role != "admin") {
        return res.status(401).json({
            success: false,
            message: "You do not have sufficient permissions to execute these processes"
        });
    }
    
    req.user = user; 
    
    next();
  
  } catch(e: any) {
    console.error("Authentication Error:", e.message);
    return res.status(401).json({
      success: false,
      message: "Token is invalid or expired."
    });
  }
}