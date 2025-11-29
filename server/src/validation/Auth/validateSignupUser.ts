import * as z from "zod"; 

export const validateSignupUser = z.object({
    full_name: z.string().min(5, "Full name must be at least 5 characters"),
    username: z.string().min(5, "Username must be at least 5 characters").max(20, "Username must be less than 20 characters"),
    email: z.email("Invalid email address").min(5, "Email must be at least 5 characters"),
    SCC: z.string().min(10, "SCC must be at least 10 characters"),
    password: z.string().min(8, "Password must be at least 8 characters long"),
    role: z.string().optional()
});