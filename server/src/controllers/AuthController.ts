import { Request, Response } from 'express';
import { validateSignupUser } from '../validation/Auth/validateSignupUser';
import User from '../models/User';
import { compare, genSalt, hash } from "bcryptjs"
import { generateToken } from '../lib/genToken';
import { validateLoginUser } from '../validation/Auth/validateLoginUser';
import { validateEmailAuth } from '../validation/Auth/validateEmailAuth';
import { validateResetPassword } from '../validation/Auth/validateResetPassword';
import { decodeToken } from '../lib/decodeToken';
import { validateUserData } from '../validation/Auth/validateProfile';

export const signupUser = async (req: Request, res: Response) => {
    try {
        const validation = validateSignupUser.safeParse(req.body);

        if (!validation.success) {

            const firstError = validation.error.issues[0];

            return res.status(400).json({
                success: false,
                message: firstError?.message,
                field: firstError?.path.join(".") || "Unknown"
            });
        }        

        const { full_name, username, email, SCC, password } = validation.data;

        const user = await User.findOne({ email });

        if(user) return res.status(409).json({
            success: false,
            message: "User with given email exists already!"
        });

        const salt = await genSalt(10);
        const hashedPassword = await hash(password, salt);

        const newUser = await new User({
            full_name,
            username,
            email,
            SCC,
            password: hashedPassword
        });

        if(!newUser) return res.status(500).json({
            success: false,
            message: "Error creating user!"
        });

        const token = generateToken(newUser._id.toString());

        await newUser.save();

        return res.json({
            success: true,
            message: "User created successfully",
            token
        });
        
        
        return res.status(201).json({ success: true, message: "User created" });

    } catch (e: any) {
        console.error("Signup error:", e);
        return res.status(500).json({
            success: false,
            message: "Internal server error",
            error: e instanceof Error ? e.message : "An unknown error occurred"
        });
    }
}

export const loginUser = async(req: Request, res: Response) => {
    try {

        const validation = validateLoginUser.safeParse(req.body);

        if (!validation.success) {

            const firstError = validation.error.issues[0];

            return res.status(400).json({
                success: false,
                message: firstError?.message,
            });
        }    

        const { email, password } = validation.data;

        const user = await User.findOne({ email });

        if(!user) return res.status(404).json({
            success: false,
            message: "User with given email does not exist!"
        });

        const verifyPassword = await compare(password, user.password);

        if(!verifyPassword) return res.status(401).json({
            success: false,
            message: "Password is incorrect!"
        });

        const token = generateToken(user._id.toString());

        return res.json({
            success: true,
            message: "Login successful",
            token
        });

    } catch (e: any) {
        console.error("Signup error:", e);
        return res.status(500).json({
            success: false,
            message: "Internal server error",
            error: e instanceof Error ? e.message : "An unknown error occurred"
        });
    }
}

export const verifyEmail = async(req: Request, res: Response) => {
    try {

        const validation = validateEmailAuth.safeParse(req.body);

        if(!validation.success) return res.json({
            success: false,
            message: validation.error.issues[0]?.message
        })

        const { email } = validation.data;

        const user = await User.findOne({ email });

        if(!user) return res.status(404).json({
            success: false,
            message: "User with given email does not exist!"
        });

        const token = generateToken(user._id.toString())

        return res.json({
            success: true,
            message: "Email verified successfully",
            token
        })

    } catch (e: any) {
        console.error("Verification error:", e);
        return res.status(500).json({
            success: false,
            message: "Internal server error",
            error: e instanceof Error ? e.message : "An unknown error occurred"
        });
    }
}


export const resetPassword = async(req: Request, res: Response) => {
    try {
        
        const validation = validateResetPassword.safeParse(req.body);

        if(!validation.success) return res.json({
            success: false,
            message: validation.error.issues[0]?.message
        })

        const { token, newPassword } = validation.data;

        const decoded = decodeToken(token) as any; 

        if(!decoded || !decoded.id) {
            return res.status(401).json({
                success: false,
                message: "Invalid or expired reset token provided."
            });
        }
        
        const salt = await genSalt(10);
        const hashedPassword = await hash(newPassword, salt);

        const updatedUser = await User.findByIdAndUpdate(
            decoded.id,
            {
                $set: { 
                    password: hashedPassword,
                }
            },
            {
                new: true
            }
        );

        if (!updatedUser) {
            return res.status(404).json({
                success: false,
                message: "User not found or password reset failed."
            });
        }

        return res.json({
            success: true,
            message: "Password successfully reset."
        });

    } catch (e: any) {
        if (e.name === 'JsonWebTokenError' || e.name === 'TokenExpiredError') {
             return res.status(401).json({
                success: false,
                message: "Invalid or expired reset token."
            });
        }
        
        console.error("Reset password error:", e);
        return res.status(500).json({
            success: false,
            message: "Internal server error",
            error: e instanceof Error ? e.message : "An unknown error occurred"
        });
    }
}

export const checkAuth = (req: Request, res:Response) => {
    return res.json(req.user);
}

export const updateProfile = async(req: Request, res: Response) => {
    try {

        const { userId } = req.params;

        const { full_name, username, email, SCC, bio, profile_pic } = req.body;

        const validateUser = validateUserData.safeParse({
            full_name: full_name || req.user?.full_name,
            username: username || req.user?.username,
            email: email || req.user?.email,
            SCC: SCC || req.user?.SCC,
            bio: bio || "",
            profile_pic: profile_pic || ""
        });

        if(!validateUser.success) return res.json({
            success: false,
            message: validateUser.error.issues[0]?.message
        });

        const updatedUser = await User.findByIdAndUpdate(userId, {
            $set: { full_name: validateUser.data.full_name, username: validateUser.data.username, email: validateUser.data.email, SCC: validateUser.data.SCC, bio: validateUser.data.bio, profile_pic: validateUser.data.profile_pic }
        }, { new: true });

        if(!updatedUser) return res.json({
            success: false,
            message: "Error while updating user"
        });

        return res.json({
            success: true,
            message: "Profile updated successfully"
        });

    } catch (e: any) {
        if (e.name === 'JsonWebTokenError' || e.name === 'TokenExpiredError') {
             return res.status(401).json({
                success: false,
                message: "Invalid or expired reset token."
            });
        }
        
        console.error("Update Profile error:", e);
        return res.status(500).json({
            success: false,
            message: "Internal server error",
            error: e instanceof Error ? e.message : "An unknown error occurred"
        });
    }
}