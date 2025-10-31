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
        required: true
    },
    date: {
        type: String,
        required: true
    },
    officiatingPriestName: {
        type: String,
        required: true
    },
    menAttendance: {
        type: Number,
        required: false,
        default: 0
    },
    womenAttendance: {
        type: Number,
        required: false,
        default: 0
    },
    youthAttendance: {
        type: Number,
        required: false,
        default: 0
    },
    catechumenAttendance: {
        type: Number,
        required: false,
        default: 0
    },
    wordOfLife: {
        type: String,
        required: true
    },
    totalOfferings: {
        type: Number,
        required: false,
        default: 0
    },
    task: {
        type: String,
        required: true
    },
    nextHost: {
        type: String,
        required: true
    },
    images: {
        type: [String],
        default: []
    }
}, { timestamps: true });

const SCC = model("SCC", sccSchema);

export default SCC;