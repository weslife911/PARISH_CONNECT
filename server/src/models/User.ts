import { model, Schema } from "mongoose"
import { UserDocument } from "../types/Auth/IUser";

const userSchema = new Schema<UserDocument>({
    full_name: {
        type: String,
        required: true
    },
    username: {
        type: String,
        required: true
    },
    email: {
        type: String,
        required: true
    },
    // New fields: deanery and parish
    deanery: {
        type: String,
        required: true
    },
    parish: {
        type: String,
        required: true
    },
    // End new fields
    password: {
        type: String,
        required: true,
        minLength: 8
    },
    bio: {
        type: String
    },
    profile_pic: {
        type: String
    },
    role: {
        type: String,
        default: "user"
    }
}, { timestamps: true });

const User = model<UserDocument>("User", userSchema);

export default User;