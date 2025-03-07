import { Request, Response } from "express";
import { STATUS } from "../enums/status_enum";
import { firestore, messaging } from "..";

export const sendNotification = async (req: Request, res: Response) => {
  const threadId = req.params.threadId;
  const chatId = req.params.chatId;

  if (!threadId) {
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

  if (!chatId) {
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

  const message = {
    topic: `thread-${threadId}`,
    notification: {
      title: thread.get("name"),
      body: chat.get("message"),
    },
  };

  try {
    const resM = await messaging.send(message);
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
};

const getChat = (chatId: string, threadId: string) => {
  return firestore
    .collection("threads")
    .doc(threadId)
    .collection("chats")
    .doc(chatId)
    .get();
};

const getThread = (threadId: string) => {
  return firestore.collection("threads").doc(threadId).get();
};
