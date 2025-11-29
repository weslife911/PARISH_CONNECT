import mongoose, { Mongoose } from 'mongoose';

// 1. Define the structure for the cached object
interface Cached {
  conn: Mongoose | null;
  promise: Promise<Mongoose> | null;
}

// 2. Extend the Node.js Global object to include our custom cache property
declare global {
  var mongoose: Cached;
}

// 3. Initialize the cache object, checking the global environment
// We use 'var' here to ensure it's a true global variable in Node.js
let cached: Cached = global.mongoose;

if (!cached) {
  // If the cache doesn't exist on the global object, initialize it.
  cached = global.mongoose = { conn: null, promise: null };
}

/**
 * Connects to the MongoDB database or returns the existing connection.
 * @returns {Promise<Mongoose>} The active Mongoose connection instance.
 */
async function connectToDb(): Promise<Mongoose> {
  // Check 1: If connection is already established, return it immediately.
  if (cached.conn) {
    console.log('Using existing database connection.');
    return cached.conn;
  }

  // Check 2: If a connection promise is in progress, await it.
  if (!cached.promise) {
    const mongodbUri = process.env.MONGODB_URI;

    if (!mongodbUri) {
      throw new Error('Please define the MONGODB_URI environment variable inside .env.local');
    }

    const opts = {
      // Recommended for serverless: tells Mongoose not to buffer commands 
      // when there's no connection, forcing errors instead.
      bufferCommands: false, 
      // How long the driver waits to find a server to connect to (ms)
      serverSelectionTimeoutMS: 5000, 
      // Additional options for modern drivers (often implicit now, but safe to include)
      // useNewUrlParser: true,
      // useUnifiedTopology: true,
    };

    // Store the connection promise
    cached.promise = mongoose.connect(mongodbUri, opts);
  }
  
  // 3. Await the promise to get the resolved connection object.
  try {
    cached.conn = await cached.promise;
    console.log('Established new database connection.');
    return cached.conn;
  } catch (e) {
    // If connection fails, clear the promise so the next invocation tries again
    cached.promise = null; 
    throw e;
  }
}

export default connectToDb;