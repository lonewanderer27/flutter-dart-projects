import express, { Express, Request, Response } from "express";
import dotenv from "dotenv";
import { cert, initializeApp, ServiceAccount } from "firebase-admin/app";
import { getFirestore } from "firebase-admin/firestore";
import { STATUS } from "../enums/status_enum";
import { getMessaging, Message } from "firebase-admin/messaging";

dotenv.config();

// // create our service key using creds from env vars
const serviceAccount: ServiceAccount = {
  privateKey: process.env.FIREBASE_PRIVATE_KEY,
  clientEmail: process.env.FIREBASE_CLIENT_EMAIL,
  projectId: process.env.FIREBASE_PROJECT_ID,
};

// init firebase
const fbAdmin = initializeApp(
  {
    // create a cert object from the service account
    credential: cert(serviceAccount),
  },
  "warp-chats"
);

// get firestore and fcm
const fs = getFirestore(fbAdmin);
const fcm = getMessaging(fbAdmin);

// init Express
const app: Express = express();
const port = process.env.PORT || 3000;

app.get("/", (req: Request, res: Response) => {
  res.send("Express + TypeScript Server");
});

app.post(
  "/threads/:threadId/chats/:chatId/notifications",
  async (req: Request, res: Response) => {
    const threadId = req.params.threadId;
    const chatId = req.params.chatId;

    // check if threadId was sent
    if (threadId == undefined || threadId == null) {
      return res.status(400).send({
        status: STATUS.ERROR,
        error: {
          code: 400,
          message: "Thread ID was not provided.",
        },
        data: null,
        message: "Thread ID was not provided.",
      });
    }

    // check if chatId was sent
    if (chatId == undefined || chatId == null) {
      return res.status(400).send({
        status: STATUS.ERROR,
        error: {
          code: 400,
          message: "Chat ID was not provided.",
        },
        data: null,
        message: "Chat ID was not provided.",
      });
    }

    // fetch the message and thread from the db
    // at the same time so we save time
    const [chat, thread] = await Promise.all([
      getChat(chatId, threadId),
      getThread(threadId),
    ]);

    if (!chat.exists) {
      return res.status(404).send({
        status: STATUS.ERROR,
        error: {
          code: 404,
          message: `Chat with ID:${chatId} was not found.`,
        },
        data: null,
        message: `Chat with ID:${chatId} was not found.`,
      });
    }

    // construct the message
    const message: Message = {
      topic: `thread-${threadId}`,
      notification: {
        title: thread.get("name"),
        body: chat.get("message"),
      },
    };

    try {
      const resM = await fcm.send(message);
      res.status(201).send({
        status: STATUS.SUCCESS,
        error: null,
        data: {
          messageId: resM,
        },
        message: "The notification has been sent!",
      });
    } catch (error) {
      res.status(500).send({
        status: STATUS.ERROR,
        error: {
          code: 500,
          message: `Server error: ${error}`,
        },
        data: null,
        message: `Server error: ${error}`,
      });
    }
  }
);

async function getChat(chatId: string, threadId: string) {
  return fs
    .collection("threads")
    .doc(threadId)
    .collection("chats")
    .doc(chatId)
    .get();
}

async function getThread(threadId: string) {
  return fs.collection("threads").doc(threadId).get();
}

app.listen(port, () => {
  console.log(`[server]: Server is running on port ${port}`);
});
