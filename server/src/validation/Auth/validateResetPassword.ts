import * as z from "zod"; 

export const validateResetPassword = z.object({
    token: z.string("Token is required"),
    newPassword: z.string("New password is required").min(8, "Password must be atleast 8 characters")
})