import { Router } from "express";
const authRouter = Router();


import { asyncHandler } from "../../utils/async.handler";

import { signIn, signUp } from "../../controller/auth/auth.controller";


authRouter.post("/signup",asyncHandler(signUp));
authRouter.post("/signIn", asyncHandler(signIn));



export default authRouter