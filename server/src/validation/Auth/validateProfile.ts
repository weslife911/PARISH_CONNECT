import { z } from "zod"

export const validateUserData = z.object({
    full_name: z.string().min(5, "Full name must be at least 5 characters").optional(),
    username: z.string().min(5, "Username must be at least 5 characters").max(20, "Username must be less than 20 characters").optional(),
    email: z.email("Invalid email address").min(5, "Email must be at least 5 characters").optional(),
    SCC: z.string().min(10, "SCC must be at least 10 characters").optional(),
    bio: z.string().optional(),
    profile_pic: z.string().optional()
})