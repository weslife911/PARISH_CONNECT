import { connect } from "mongoose"
import { config } from "dotenv"

config();

export const connectToDb = async() => {
    return await connect(process.env.MONGO_URI!)
    .then(() => console.log("Connected to MongoDB Successfully"))
    .catch((err) => console.error("Error connecting to MongoDB:", err));
}