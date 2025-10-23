import * as z from "zod"; 

export const validateLoginUser = z.object({
    email: z.email("Invalid email address").min(1, "Email is required"),
    password: z.string().min(8, "Password must be at least 8 characters long")
});