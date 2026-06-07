import { Router } from "express";
const instituteRouter = Router();


// module-imports
import { asyncHandler } from "../../utils/async.handler.js";
import { createInstitute, getAllInstitutes } from "../../controller/institute/institute.controller.js";


// routes
instituteRouter.post("/create-institute", asyncHandler(createInstitute));
instituteRouter.get("/get-all-institutes", asyncHandler(getAllInstitutes));

// exports
export default instituteRouter