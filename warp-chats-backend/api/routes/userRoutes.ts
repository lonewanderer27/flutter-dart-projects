import { Router } from "express";
import {
  createThread,
createYourselfThread,
} from "../controllers/userController";
import { checkUserId } from "../middlewares/checkUserId";

const router = Router();

router.post(
  "/users/:userId/create-yourself-thread",
  checkUserId,
  createYourselfThread
);

export { router as userRoutes };
