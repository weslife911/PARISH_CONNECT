// Mission.ts
import { model, Schema } from "mongoose";

const missionSchema = new Schema({
    missionName: { type: String, required: true },
    periodCovered: { type: String, required: true },
    commissionName: { type: String, required: true },

    // --- Membership Statistics ---
    totalMembers: { type: Number, required: true, default: 0 },
    sccsRepresented: { type: Number, required: true, default: 0 }, // "No of SCCs represented"
    activeMembers: { type: Number, required: true, default: 0 },

    // --- Meetings ---
    generalMeetings: { type: Number, required: true, default: 0 },
    excoMeetings: { type: Number, required: true, default: 0 },

    // --- Report Content (String Arrays) ---
    activitiesCarriedOut: { type: [String], required: true },
    problemsEncountered: { type: [String], required: true },
    proposedSolutions: { type: [String], required: true },
    issuesForCouncil: { type: [String], required: true },
    nextMonthPlans: { type: [String], required: true } // Includes budget/income plans
}, { timestamps: true });

const Mission = model("Mission", missionSchema);
export default Mission;
