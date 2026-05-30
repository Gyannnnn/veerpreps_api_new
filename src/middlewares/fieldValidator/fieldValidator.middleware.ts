import type { ZodObject, ZodArray, ZodTypeAny } from "zod";
import type { Request, Response, NextFunction } from "express";
import { sendError } from "../../utils/response.handler.js";

// Accept either a ZodObject or ZodArray
export const feildValidator =
  (schema: ZodObject<any> | ZodArray<ZodTypeAny>) =>
  (req: Request, res: Response, next: NextFunction) => {
    const result = schema.safeParse(req.body);

    if (!result.success) {
      return sendError(
        res,
        "Validation failed",
        JSON.stringify(result.error.format()), // better structure for arrays
        400
      );
    }

    // Assign validated data
    req.body = result.data;
    next();
  };
