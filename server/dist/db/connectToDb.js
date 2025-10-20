"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.connectToDb = void 0;
const mongoose_1 = require("mongoose");
const dotenv_1 = require("dotenv");
(0, dotenv_1.config)();
const connectToDb = async () => {
    return await (0, mongoose_1.connect)(process.env.MONGO_URI)
        .then(() => console.log("Connected to MongoDB Successfully"))
        .catch((err) => console.error("Error connecting to MongoDB:", err));
};
exports.connectToDb = connectToDb;
//# sourceMappingURL=connectToDb.js.map