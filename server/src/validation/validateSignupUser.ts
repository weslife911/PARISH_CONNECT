import * as z from "zod"; 

export const validateSignupUser = z.object({
    full_name: z.string().min(5, "Full name is required"),
    username: z.string().min(5, "Username is required").max(20, "Username must be less than 20 characters"),
    email: z.email("Invalid email address").min(1, "Email is required"),
    SCC: z.string().min(10, "SCC is required"),
    password: z.string().min(8, "Password must be at least 8 characters long")
});