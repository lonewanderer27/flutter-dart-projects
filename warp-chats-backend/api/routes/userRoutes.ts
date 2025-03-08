import { Router } from "express";
import { createYourselfThread } from "../controllers/userController";

const router = Router();

router.post("/users/:userId/create-yourself-thread", createYourselfThread);

export { router as userRoutes };
