import mongoose from "mongoose";

const MONGODB_URI = process.env.MONGODB_URI;

export const connectToDb = async () => {
  if (mongoose.connection.readyState >= 1) return;

  try {
    await mongoose.connect(MONGODB_URI as string);
    console.log("✅ MongoDB connected successfully");
  } catch (e) {
    console.error("❌ MongoDB connection error: ", e);
    throw e;
  }
};