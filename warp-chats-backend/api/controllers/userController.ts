import { Request, Response } from "express";
import { STATUS } from "../enums/status_enum";
import { auth, firestore } from "..";

export const createYourselfThread = async (req: Request, res: Response) => {
  const userId = req.params.userId;

  if (!userId) {
    return res.status(400).send({
      status: STATUS.ERROR,
      error: {
        code: 400,
        message: "User ID was not provided.",
      },
      data: null,
      message: "User ID was not provided.",
    });
  }

  try {
    // try to get the user if it's valid
    await getUser(userId);

    // get the user data which includes:
    // name
    // avatarBase64
    const userRef = firestore.collection("users").doc(userId);
    const userRefData = await userRef.get();

    // threads serves as a collection where we can get
    // all the threads, each should contain:
    // [string] name
    // [collection] chats
    //    - [string] createdAt
    //    - [string] message
    //    - [userId] userId

    // create the thread
    const threadData = {
      name: "Yourself",
    };
    // not passing any argument to .doc tells it to autogenerate an ID
    const threadRef = firestore.collection("threads").doc();
    await threadRef.set(threadData);

    // add the user to the thread
    const threadUserData = {
      username: userRefData.get("username"),
      avatarBase64: userRefData.get("avatarBase64"),
    };
    const threadUserRef = await firestore
      .collection("threads")
      .doc(threadRef.id)
      .collection("users")
      .doc(userId);
    threadUserRef.set(threadUserData);

    // user_threads serves as a collection where we can get
    // all the threads that the user is a part of
    // each user_thread should contain:
    // [string] userId
    // [collection] threads
    //    - [string] name
    //    - [string] threadId

    // add the newly created thread to user_threads
    const userThreadData = {
      name: threadData.name,
      threadId: threadRef.id,
    };
    const userThreadRef = firestore
      .collection("user_threads")
      .doc(userId)
      .collection("threads")
      .doc(threadRef.id);
    await userThreadRef.set(userThreadData);

    res.status(201).send({
      status: STATUS.SUCCESS,
      error: null,
      data: {
        threadId: threadRef.id,
      },
      message: `User's yourself thread has been created: ${threadRef.id}!`,
    });
  } catch (error) {
    console.log(error);
    res.status(500).send({
      status: STATUS.ERROR,
      error: {
        code: 500,
        message: `Error: ${error}`,
      },
      data: null,
      message: `Error: ${error}`,
    });
  }
};

const getUser = (userId: string) => {
  return auth.getUser(userId);
};
