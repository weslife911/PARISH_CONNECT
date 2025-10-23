import { z } from "zod"

export const validateEmailAuth = z.object({
    email: z.email("Invalid email address").min(1, "Email is required")
})