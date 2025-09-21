import express from "express";
import {router as index} from "./controller/index";
import {router as lotto} from "./controller/lotto";
import {router as trip} from "./controller/trip";
import {router as user} from "./controller/users";
import {router as order} from "./controller/order";
import bodyParser from "body-parser";
import {router as upload} from "./controller/upload";
import cors from "cors";


export const app = express();

const allowedOrigins = [
  "http://127.0.0.1:3001", // Your local development frontend (e.g., Vite default)
  "http://localhost:3000", // Another local dev frontend (e.g., Create React App default)
  "https://your-production-frontend.com", // Your production frontend domain
  "https://another-approved-domain.org", // Another approved domain
  // Add more origins as needed
];

app.use(
  cors({
    origin: function (origin, callback) {
      // Check if the origin of the request is in our whitelist
      if (!origin || allowedOrigins.indexOf(origin) !== -1) {
        callback(null, true); // Allow the request
      } else {
        callback(new Error("Not allowed by CORS")); // Deny the request
      }
    },
    methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
    allowedHeaders: ["Content-Type", "Authorization"],
  })
);

app.use(bodyParser.text());
app.use(bodyParser.json());
app.use("/",index);
app.use("/lottos",lotto);
app.use("/trip",trip);
app.use('/users', user);
app.use("/order", order);
app.use("/upload", upload);
app.use("/uploads", express.static("uploads"));

// app.use("/", (req, res) => {
//   res.send("Hello");
// });