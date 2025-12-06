// validation/Parish/validateParishRecord.ts

import { z } from "zod";

// Helper for integer/non-negative number validation
const nonNegativeInt = z.number().int("Must be an integer").min(0, "Cannot be negative").default(0);

// Helper for REQUIRED string array fields
const requiredStringArray = z.array(z.string()); 

export const validateParishRecord = z.object({
    // --- Header Fields ---
    commissionName: z.string().min(1, "Commission Name is required"),
    
    // Validates that the input is a string (e.g., "2023-10-27"), which the controller converts
    periodCovered: z.string().min(1, "Period Covered date is required"),

    // --- Table Fields (all non-negative integers) ---
    totalMembers: nonNegativeInt,
    missionsRepresented: nonNegativeInt,
    generalMeetings: nonNegativeInt,
    activeMembers: nonNegativeInt,
    excoMeetings: nonNegativeInt,

    // --- Report Sections (REQUIRED string arrays) ---
    activities: requiredStringArray,
    problemsAndSolutions: requiredStringArray,
    issuesForCouncil: requiredStringArray,
    futurePlans: requiredStringArray,
});