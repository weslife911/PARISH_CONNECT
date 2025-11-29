import { model, Schema } from "mongoose"

const commissionReportSchema = new Schema({
    deanery: {
        type: String,
        required: true,
        default: "FUTRU DEANERY" // Based on the PDF content
    },
    archdiocese: {
        type: String,
        required: true,
        default: "ARCHDIOCESE OF BAMENDA" 
    },
    
    // Core report fields from the PDF
    commissionName: {
        type: String,
        required: true // Corresponds to "Name of Commission"
    },
    peopleInCommission: {
        type: Number,
        required: false,
        default: 0 
    },
    numberOfMeetingsHeld: {
        type: Number,
        required: false,
        default: 0 
    },
    numberOfFormationMeetings: {
        type: Number,
        required: false,
        default: 0 
    },
    themesTreated: {
        type: String, 
        required: false,
        default: ""
    },
    
    // MODIFIED: Changed from String to [String]
    activities: {
        type: [String], // Corresponds to "Activities"
        required: true,
        default: []
    },
    // MODIFIED: Changed from String to [String]
    achievements: {
        type: [String],
        required: true, // Corresponds to "Achievements"
        default: []
    },
    // MODIFIED: Changed from String to [String]
    difficulties: {
        type: [String],
        required: true, // Corresponds to "Difficulties"
        default: []
    },
    // MODIFIED: Changed from String to [String]
    proposedSolutions: {
        type: [String],
        required: true, // Corresponds to "Proposed Solutions"
        default: []
    },
    
    // Signatories/Reporting individuals
    secretaryName: {
        type: String,
        required: true 
    },
    chairpersonName: {
        type: String,
        required: true 
    },
    
    reportReference: {
        type: String,
        required: false,
        default: "" 
    },
    
    images: {
        type: [String],
        default: []
    }
}, { timestamps: true });

const CommissionReport = model("CommissionReport", commissionReportSchema);

export default CommissionReport;