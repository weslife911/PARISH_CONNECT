import * as z from "zod"; 

export const validateSignupUser = z.object({
    full_name: z.string().min(5, "Full name must be at least 5 characters"),
    username: z.string().min(5, "Username must be at least 5 characters").max(20, "Username must be less than 20 characters"),
    email: z.email("Invalid email address").min(5, "Email must be at least 5 characters"),
    password: z.string().min(8, "Password must be at least 8 characters long"),
    // New required fields
    deanery: z.string().min(1, "Deanery is required"),
    parish: z.string().min(1, "Parish is required"),
    // End new required fields
    role: z.string().optional()
});