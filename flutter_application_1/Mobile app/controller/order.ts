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
// backend orders.ts
router.post("/", async (req, res) => {
  const newOrder: { user_id: number; purchase_date: string; lotto_id?: number } = req.body;

  try {
    // 1. insert order
    const [orderResult] = await conn.promise().query(
      "INSERT INTO orders (user_id, purchase_date) VALUES (?,?)",
      [newOrder.user_id, newOrder.purchase_date]
    );

    const orderId = (orderResult as ResultSetHeader).insertId;

    // 2. update lotto ว่าใช้ order ไหนซื้อ
    if (newOrder.lotto_id) {
      await conn.promise().query(
        "UPDATE lottos SET order_id = ? WHERE id = ?",
        [orderId, newOrder.lotto_id]
      );
    }

    res.status(201).json({ order_id: orderId });
  } catch (err: any) {
    res.status(500).json({ error: err.message });
  }
});

router.post("/buy", async (req, res) => {
  const { user_id, purchase_date, lotto_id } = req.body;

  try {
    // 1. Insert order
    const [orderResult] = await conn
      .promise()
      .query("INSERT INTO orders(user_id, purchase_date) VALUES (?, ?)",
        [user_id, purchase_date]);
    const orderId = (orderResult as ResultSetHeader).insertId;

    // 2. Update lotto
    await conn
      .promise()
      .query("UPDATE lottos SET order_id = ?, status='SOLD' WHERE lotto_id = ?",
        [orderId, lotto_id]);

    // 3. ตัดเงิน wallet
    // สมมติคุณมี table wallet หรือ users ที่มี column balance
    // และต้องการหักตามราคา lotto
    await conn.promise().query(`
      UPDATE users
      JOIN lottos ON lottos.lotto_id = ?
      SET users.wallet_balance = users.wallet_balance - lottos.lotto_price
      WHERE users.user_id = ?`,
      [lotto_id, user_id]);

    res.status(201).json({ order_id: orderId, message: "ซื้อสำเร็จและตัดเงินแล้ว" });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: (err as Error).message });
  }
});
