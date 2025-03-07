import express from "express";
import dotenv from "dotenv";
import { initializeFirebase } from "./config/firebase";
import { notificationRoutes } from "./routes/notificationRoutes";

dotenv.config();

const app = express();
const port = process.env.PORT || 3000;

// Initialize Firebase
const { firestore, messaging, auth } = initializeFirebase();

app.use("/", notificationRoutes);

app.listen(port, () => {
  console.log(`[server]: Server is running on port ${port}`);
});

export { firestore, messaging, auth };
