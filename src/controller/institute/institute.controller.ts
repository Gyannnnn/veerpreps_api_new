import { Request, Response } from "express";
import { sendError, sendSuccess } from "../../utils/response.handler.js";
import {prisma} from "../../utils/prisma/prisma.client.js"

export const createInstitute = async (req: Request, res: Response) => {
    const { name, logo, address, slug, about,createdBy } = req.body;

    if (!name?.trim() || !logo?.trim() || !address?.trim() || !slug?.trim() || !about?.trim() || !createdBy?.trim()) return sendError(res, "All fields are required");
    const isUniversityExists = await prisma.institute.findFirst({
        where: {
            slug,
            name
        }
    });

    if (isUniversityExists) return sendError(res, "University already exists");
    const newInstitute = await prisma.institute.create({
        data: {
            name,
            logo,
            address,
            slug,
            about,
            createdBy

        }
    });

    return sendSuccess(res, "Institute created Successfully",{newInstitute}, 201);
}


export const getAllInstitutes = async(req: Request, res: Response)=>{
    const institutes = await prisma.institute.findMany();
    sendSuccess(res,"Institutes Fetched Successfully",institutes)
}