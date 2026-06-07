
import { Request, Response } from "express";
import { createSuccess, sendError, sendSuccess } from "../../utils/response.handler.js";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken"
import { prisma } from "../../utils/prisma/prisma.client.js"





export const signUp = async (req: Request, res: Response) => {
    const { name, email, password } = req.body

    if (!name?.trim() || !email?.trim() || !password?.trim()) return sendError(res, "All fields are required");
    const isUserExist = await prisma.user.findFirst({
        where: {
            email
        }
    });
    if (isUserExist) return sendError(res, "User Already Exists");
    const hashedPw = bcrypt.hashSync(password, 10);
    const newUser = await prisma.user.create({
        data: {
            name,
            email,
            password: hashedPw
        }
    })
    const token = jwt.sign({
        name: newUser.name,
        email: newUser.email
    }, process.env.JWT_SECRET!, {
        expiresIn: "30days"
    })
    createSuccess(res, { user: newUser.email, token }, "User created Successfully")


}




export const signIn = async (req: Request, res: Response) => {
    const { email, password } = req.body;

    if (!process.env.JWT_SECRET) return sendError(res, "empty jwt")
    if (!email?.trim() || !password?.trim()) return sendError(res, "All fields are required");
    const userExist = await prisma.user.findUnique({
        where: {
            email
        }
    });


    if (!userExist) return sendError(res, "User Does not exist");
    const verifyPassword = await bcrypt.compare(
        password,
        userExist.password!
    );

    if (!verifyPassword) return sendError(res, "Invalid Credentials");
    console.log(process.env.JWT_SECRET)


    const token = jwt.sign({
        name: userExist.name,
        email: userExist.email,
        role:userExist.userType
    },
        process.env.JWT_SECRET!,
        {
            expiresIn: "30days"
        });


    return sendSuccess(res,  "User Signed In",{token:token,id:userExist.id})
}


