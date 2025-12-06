import { Document } from "mongoose";

export interface IParish extends Document {
    // --- Header ---
    commissionName: string;
    periodCovered: Date; // Changed to Date

    // --- Table Data ---
    totalMembers: number;
    missionsRepresented: number;
    generalMeetings: number;
    activeMembers: number;
    excoMeetings: number;

    // --- Report Sections ---
    activities: string[];
    problemsAndSolutions: string[];
    issuesForCouncil: string[];
    futurePlans: string[];

    // --- Timestamps ---
    createdAt: Date;
    updatedAt: Date;
}