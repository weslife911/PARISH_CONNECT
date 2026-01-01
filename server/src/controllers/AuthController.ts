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
            });
        }

        // Destructure new fields: deanery and parish
        const { full_name, username, email, password, deanery, parish, role } = validation.data;

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
            deanery,
            parish,
            password: hashedPassword,
            role: role || "user"
        });

        if(!newUser) return res.status(500).json({
            success: false,
            message: "Error creating user!"
        });

        const token = generateToken(newUser._id.toString());

        await newUser.save();

        return res.status(201).json({
            success: true,
            message: "User created successfully",
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
    return res.json({
        success: true,
        user: req.user
    });
}

export const updateProfile = async(req: Request, res: Response) => {
    try {
        const { userId } = req.params;

        // Extract deanery and parish from req.body
        const { full_name, username, email, bio, profile_pic, deanery, parish } = req.body;

        // Note: Ensure your 'validateUserData' Zod schema is also updated to allow these fields
        const updatedUser = await User.findByIdAndUpdate(userId, {
            $set: {
                full_name,
                username,
                email,
                bio,
                profile_pic,
                deanery,
                parish
            }
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
        console.error("Update Profile error:", e);
        return res.status(500).json({
            success: false,
            message: "Internal server error"
        });
    }
}
