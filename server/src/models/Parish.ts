// models/Parish.ts

import { model, Schema } from "mongoose";
import { IParish } from "../types/Parish/IParish";



const ParishSchema: Schema = new Schema({
    // --- Header ---
    commissionName: { type: String, required: true },
    periodCovered: { type: Date, required: true }, // Schema type is Date

    // --- Table Data ---
    totalMembers: { type: Number, required: true, default: 0 },
    missionsRepresented: { type: Number, required: true, default: 0 },
    generalMeetings: { type: Number, required: true, default: 0 },
    activeMembers: { type: Number, required: true, default: 0 },
    excoMeetings: { type: Number, required: true, default: 0 },

    // --- Report Sections ---
    activities: { type: [String], required: true },
    problemsAndSolutions: { type: [String], required: true },
    issuesForCouncil: { type: [String], required: true },
    futurePlans: { type: [String], required: true },
}, {
    timestamps: true 
});

export default model<IParish>("Parish", ParishSchema);