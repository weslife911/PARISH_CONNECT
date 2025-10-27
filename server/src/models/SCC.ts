import { model, Schema } from "mongoose"

const sccSchema = new Schema({
    sccName: {
        type: String,
        required: true
    },
    faithSharingName: {
        type: String,
        required: true
    },
    host: {
        type: String,
        required: true  // Add required since it's required on frontend
    },
    date: {
        type: String,
        required: true  // Add required since it's required on frontend
    },
    officiatingPriestName: {
        type: String,
        required: true  // Add required since it's required on frontend
    },
    menAttendance: {
        type: Number,
        required: false,  // Changed to false
        default: 0
    },
    womenAttendance: {
        type: Number,
        required: false,  // Changed to false
        default: 0
    },
    youthAttendance: {
        type: Number,
        required: false,  // Changed to false
        default: 0
    },
    catechumenAttendance: {
        type: Number,
        required: false,  // Changed to false
        default: 0
    },
    wordOfLife: {
        type: String,
        required: true
    },
    totalOfferings: {
        type: Number,
        required: false,  // Changed to false
        default: 0
    },
    task: {
        type: String,
        required: true  // Add required since it's required on frontend
    },
    nextHost: {
        type: String,
        required: true  // Add required since it's required on frontend
    },
}, { timestamps: true });

const SCC = model("SCC", sccSchema);

export default SCC;