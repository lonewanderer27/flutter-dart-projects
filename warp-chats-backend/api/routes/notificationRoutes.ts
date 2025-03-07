import { Router } from "express";
import { sendNotification } from "../controllers/notificationController";

const router = Router();

router.post("/threads/:threadId/chats/:chatId/notifications", sendNotification);

export { router as notificationRoutes };