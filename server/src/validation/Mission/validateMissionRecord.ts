// validateMissionRecord.ts
import { z } from "zod";

const nonNegativeInt = z.number().int("Must be an integer").min(0, "Cannot be negative").default(0);
const requiredStringArray = z.array(z.string());

export const validateMissionRecord = z.object({
    missionName: z.string().min(1, "Mission Name is required"),
    periodCovered: z.string().min(1, "Period covered is required"),
    commissionName: z.string().min(1, "Commission Name is required"),

    totalMembers: nonNegativeInt,
    sccsRepresented: nonNegativeInt,
    activeMembers: nonNegativeInt,
    generalMeetings: nonNegativeInt,
    excoMeetings: nonNegativeInt,

    activitiesCarriedOut: requiredStringArray,
    problemsEncountered: requiredStringArray,
    proposedSolutions: requiredStringArray,
    issuesForCouncil: requiredStringArray,
    nextMonthPlans: requiredStringArray
});
