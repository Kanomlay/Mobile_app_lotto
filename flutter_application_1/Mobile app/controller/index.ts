import express from "express";
import { conn, queryAsync } from "../dbconnect";
import { Lotto } from "../model/lotto";
import mysql from "mysql";

export const router = express.Router();

router.get("/", (req, res) => {
  conn.query('select * from lotto', (err, result, fields)=>{
    res.json(result);
  });
});
