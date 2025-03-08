import { Request, Response, NextFunction } from "express";
import { STATUS } from "../enums/status_enum";

export const checkUserId = (
  req: Request,
  res: Response,
  next: NextFunction
) => {
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

  next();
};
