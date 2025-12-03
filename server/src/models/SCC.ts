// SCC.ts

import { model, Schema } from "mongoose"

const sccSchema = new Schema({
    // --- Metadata & Top Table Fields ---
    sccName: {
        type: String,
        required: true
    },
    periodStart: {
        type: Date, // Using Date type for better date handling
        required: true
    },
    periodEnd: {
        type: Date, // Using Date type for better date handling
        required: true
    },

    // --- Statistics & Meetings ---
    totalFamilies: { type: Number, required: true, default: 0 },
    gospelSharingGroups: { type: Number, required: true, default: 0 },
    councilMeetings: { type: Number, required: true, default: 0 },
    generalMeetings: { type: Number, required: true, default: 0 },
    noOfCommissions: { type: Number, required: true, default: 0 },
    activeCommissions: { type: Number, required: true, default: 0 },
    totalMembership: { type: Number, required: true, default: 0 },
    gospelSharingExpected: { type: Number, required: true, default: 0 },
    gospelSharingDone: { type: Number, required: true, default: 0 },
    noChristiansAttendingGS: { type: Number, required: true, default: 0 },
    gsAttendancePercentage: { type: Number, required: true, default: 0.0 }, // Double in Dart maps to Number in Mongoose

    // --- Membership Breakdown ---
    children: { type: Number, required: true, default: 0 },
    youth: { type: Number, required: true, default: 0 },
    adults: { type: Number, required: true, default: 0 },

    // --- Sacramental/Pastoral Records ---
    baptism: { type: Number, required: true, default: 0 },
    lapsedChristians: { type: Number, required: true, default: 0 },
    irregularMarriages: { type: Number, required: true, default: 0 },
    burials: { type: Number, required: true, default: 0 },

    // --- Activities carried out by Commissions (REQUIRED String Arrays) ---
    biblicalApostolateActivities: { type: [String], required: true },
    liturgyActivities: { type: [String], required: true },
    financeActivities: { type: [String], required: true },
    familyLifeActivities: { type: [String], required: true },
    justiceAndPeaceActivities: { type: [String], required: true },
    youthApostolateActivities: { type: [String], required: true },
    catecheticalActivities: { type: [String], required: true },
    healthCareActivities: { type: [String], required: true },
    socialCommunicationActivities: { type: [String], required: true },
    socialWelfareActivities: { type: [String], required: true },
    educationActivities: { type: [String], required: true },
    vocationActivities: { type: [String], required: true },
    dialogueActivities: { type: [String], required: true },
    womensAffairsActivities: { type: [String], required: true },
    mensAffairsActivities: { type: [String], required: true },
    prayerAndActionActivities: { type: [String], required: true },

    // --- General Report Sections ---
    problemsEncountered: { type: [String], required: true }, // Now required
    proposedSolutions: { type: [String], required: true }, // Now required
    issuesForCouncil: { type: [String], required: true }, // Now required
    nextMonthPlan: { type: String, required: true },
}, { timestamps: true });

const SCC = model("SCC", sccSchema);

export default SCC;