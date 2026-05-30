import dotenv from "dotenv";
dotenv.config()

// imports
import express from "express"
import cors from "cors"
import helmet from "helmet";
import morgan from "morgan"





// file imports
import authRouter from "./routes/auth/auth.routes.js";
import userRouter from "./routes/user/user.routes.js";







// initialisation
const app = express();


// allow point
app.get("/",(req,res)=>{
    res.status(200).json({
        message: "Welcome to veerpreps api 69",
        version:"1.0.0"
    })
})



// middlewares
app.use(express.json());
app.use(cors());
app.use(helmet());
app.use(morgan("dev"))




// routings
app.use("/api/v1/auth",authRouter)
app.use("/api/v1/user",userRouter)



// server configs
app.listen(process.env.PORT || 8000,()=>{
    console.log(`Server is running @ : http://localhost:${process.env.PORT || 8000}`)
})
