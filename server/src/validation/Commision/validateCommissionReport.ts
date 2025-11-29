import { z } from "zod"

export const validateCommissionReport = z.object({
    // Context fields (optional for API submission if using defaults)
    deanery: z.string().optional(),
    archdiocese: z.string().optional(),
    
    // Core fields
    commissionName: z.string().min(1, "Commission Name is required"),
    
    // MODIFIED: Now requires an array of non-empty strings
    activities: z.array(z.string().min(1, "Each activity item cannot be empty")).min(1, "Activities list is required and must contain at least one item"),
    // MODIFIED: Now requires an array of non-empty strings
    achievements: z.array(z.string().min(1, "Each achievement item cannot be empty")).min(1, "Achievements list is required and must contain at least one item"),
    // MODIFIED: Now requires an array of non-empty strings
    difficulties: z.array(z.string().min(1, "Each difficulty item cannot be empty")).min(1, "Difficulties list is required and must contain at least one item"),
    // MODIFIED: Now requires an array of non-empty strings
    proposedSolutions: z.array(z.string().min(1, "Each proposed solution item cannot be empty")).min(1, "Proposed Solutions list is required and must contain at least one item"),
    
    // Signatories
    secretaryName: z.string().min(1, "Secretary's Name is required"),
    chairpersonName: z.string().min(1, "Chairperson's Name is required"),
    
    // Optional/Numeric fields
    peopleInCommission: z.number().int("Must be an integer").min(0, "Cannot be negative").optional(),
    numberOfMeetingsHeld: z.number().int("Must be an integer").min(0, "Cannot be negative").optional(),
    numberOfFormationMeetings: z.number().int("Must be an integer").min(0, "Cannot be negative").optional(),
    themesTreated: z.string().optional(),
    reportReference: z.string().optional(),
})