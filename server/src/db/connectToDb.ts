import { connect } from "mongoose"
import { config } from "dotenv"

config();

export const connectToDb = async () => {
  await connect(process.env.MONGODB_URI as string)
    .then(() => console.log("Mongo DB connected successfully"))
    .catch((e) => console.error("Error: ", e));
}