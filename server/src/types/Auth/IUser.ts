import { Document } from "mongoose";

export interface IUser {
    _id?: string,
    full_name: string;
    username: string;
    email: string;
    SCC: string;
    password: string;
    bio?: string,
    profile_pic?: string,
    role?: string
}

export type UserDocument = IUser & Document;