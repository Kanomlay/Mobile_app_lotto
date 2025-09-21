import express from "express";
import { conn, queryAsync } from "../dbconnect";
import mysql from "mysql";
import { ResultSetHeader } from "mysql2";

export const router = express.Router();
router.get("/", async (_req, res) => {
 const result = await queryAsync({ sql: "SELECT * FROM orders" });
 res.json(result);
});

router.get("/:user_id", async (req, res) => {
  const userId = req.params.user_id;
  const sql = "SELECT * FROM orders WHERE user_id = ?";
  const result = await queryAsync({ sql: sql, values: [userId] });
  res.json(result);
 });

// POST: สร้าง Order ใหม่
router.post("/", (req, res) => {
    const newOrder: { user_id: number; purchase_date: string; } = req.body;
    
    let sql = "INSERT INTO `orders`(`user_id`, `purchase_date`) VALUES (?,?)";
    
    sql = mysql.format(sql, [
        newOrder.user_id,
        newOrder.purchase_date
    ]);

    conn.query(sql, (err, result) => {
        if (err) {
            return res.status(500).json({ error: err.message });
        }
        res.status(201).json({ affected_row: (result as ResultSetHeader).affectedRows, last_idx: (result as ResultSetHeader).insertId });
    });
});