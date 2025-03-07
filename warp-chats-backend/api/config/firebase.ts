import { cert, initializeApp, ServiceAccount } from "firebase-admin/app";
import { getFirestore } from "firebase-admin/firestore";
import { getMessaging } from "firebase-admin/messaging";
import { getAuth } from "firebase-admin/auth";
import dotenv from "dotenv";

dotenv.config();

const serviceAccount: ServiceAccount = {
  privateKey: process.env.FIREBASE_PRIVATE_KEY?.replace(/\\n/g, "\n"),
  clientEmail: process.env.FIREBASE_CLIENT_EMAIL,
  projectId: process.env.FIREBASE_PROJECT_ID,
};

export const initializeFirebase = () => {
  const fbAdmin = initializeApp(
    {
      credential: cert(serviceAccount),
    },
    "warp-chats"
  );

  return {
    firestore: getFirestore(fbAdmin),
    messaging: getMessaging(fbAdmin),
    auth: getAuth(fbAdmin),
  };
};
