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
    SCC: {
        type: String,
        required: true
    },
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
    }
}, { timestamps: true });

const User = model<UserDocument>("User", userSchema);

export default User;