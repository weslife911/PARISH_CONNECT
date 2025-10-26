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
        type: String
    },
    date: {
        type: String
    },
    officiatingPriesName: {
        type: String
    },
    menAttendance: {
        type: Number,
        required: true
    },
    womenAttendance: {
        type: Number,
        required: true
    },
    youthAttendance: {
        type: Number,
        required: true
    },
    catechumenAttendance: {
        type: Number,
        required: true
    },
    wordOfLife: {
        type: String,
        required: true
    },
    totalOfferings: {
        type: Number,
        required: true
    },
    task: {
        type: String
    },
    nextHost: {
        type: String
    },
}, { timestamps: true });

const SCC = model("SCC", sccSchema);

export default SCC;