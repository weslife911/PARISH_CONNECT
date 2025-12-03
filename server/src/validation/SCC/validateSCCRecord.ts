// validateSCCRecord.ts

import { z } from "zod"

// Helper for integer/non-negative number validation
const nonNegativeInt = z.number().int("Must be an integer").min(0, "Cannot be negative").default(0);

// Helper for non-negative float/double validation
const nonNegativeFloat = z.number().min(0, "Cannot be negative").default(0.0);

// Helper for REQUIRED string array fields (activities, problems, etc.)
// They must be present in the request body and validated as an array of strings.
const requiredStringArray = z.array(z.string()); 

export const validateSCCRecord = z.object({
    // --- Metadata & Top Table Fields ---
    sccName: z.string().min(1, "SCC Name is required"),
    periodStart: z.string().min(1, "Period Start date is required"),
    periodEnd: z.string().min(1, "Period End date is required"),

    // --- Statistics & Meetings (all non-negative integers) ---
    totalFamilies: nonNegativeInt,
    gospelSharingGroups: nonNegativeInt,
    councilMeetings: nonNegativeInt,
    generalMeetings: nonNegativeInt,
    noOfCommissions: nonNegativeInt,
    activeCommissions: nonNegativeInt,
    totalMembership: nonNegativeInt,
    gospelSharingExpected: nonNegativeInt,
    gospelSharingDone: nonNegativeInt,
    noChristiansAttendingGS: nonNegativeInt,
    gsAttendancePercentage: nonNegativeFloat,

    // --- Membership Breakdown (all non-negative integers) ---
    children: nonNegativeInt,
    youth: nonNegativeInt,
    adults: nonNegativeInt,

    // --- Sacramental/Pastoral Records (all non-negative integers) ---
    baptism: nonNegativeInt,
    lapsedChristians: nonNegativeInt,
    irregularMarriages: nonNegativeInt,
    burials: nonNegativeInt,

    // --- Activities carried out by Commissions (REQUIRED string arrays) ---
    biblicalApostolateActivities: requiredStringArray,
    liturgyActivities: requiredStringArray,
    financeActivities: requiredStringArray,
    familyLifeActivities: requiredStringArray,
    justiceAndPeaceActivities: requiredStringArray,
    youthApostolateActivities: requiredStringArray,
    catecheticalActivities: requiredStringArray,
    healthCareActivities: requiredStringArray,
    socialCommunicationActivities: requiredStringArray,
    socialWelfareActivities: requiredStringArray,
    educationActivities: requiredStringArray,
    vocationActivities: requiredStringArray,
    dialogueActivities: requiredStringArray,
    womensAffairsActivities: requiredStringArray,
    mensAffairsActivities: requiredStringArray,
    prayerAndActionActivities: requiredStringArray,
    
    // --- General Report Sections (REQUIRED string arrays) ---
    problemsEncountered: requiredStringArray,
    proposedSolutions: requiredStringArray,
    issuesForCouncil: requiredStringArray,
    nextMonthPlan: z.string().min(1, "Next Month Plan is required"),
})