import { NextFunction, Request, Response } from "express";
import jwt, { JwtPayload } from "jsonwebtoken";
import { sendError, unauthorizedError } from "../../utils/response.handler";


interface AuthenticatedRequest extends Request {
    user?: string | JwtPayload;
}

export const adminAuthValidation = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const authHeader = req.headers.authorization
        if (!authHeader?.startsWith("Bearer ")) {
            return unauthorizedError(res, "Authorization header is missing or malformed");
        }

        const token = authHeader.split(" ")[1];
        const secret = process.env.JWT_SECRET

        if (!secret) {
            return sendError(res, "Missing Secret");
        }
        const decoded = jwt.verify(token as string, secret) as JwtPayload;
        if (!decoded?.userType) {
            return unauthorizedError(res, "User role not found in token");
        }
        if (decoded.userType !== "admin") {
            return unauthorizedError(res, "Access denied: Admins only");
        }
        // req.user = decoded;
        return next();

    } catch (error) {
        const err = error as Error;
        return unauthorizedError(res, err.message || "Invalid or expired token");
    }
}