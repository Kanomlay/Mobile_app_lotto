import express from "express";
import { conn } from "../dbconnect";
import { ResultSetHeader } from "mysql2";
import mysql from "mysql";

export const router = express.Router();

// สุ่มล็อตโต้ (100 ใบใหม่)
router.post("/reset", (req, res) => {
  const lottoCount = 100;
  const values: any[] = [];
  for (let i = 0; i < lottoCount; i++) {
    const num = Math.floor(Math.random() * 1000000);
    const formatted = num.toString().padStart(6, '0');
    values.push([formatted, 80, 1, "AVAILABLE", new Date()]);
  }

  // ลบข้อมูลทั้งหมด
  const deleteSql = "DELETE FROM lottos";
  conn.query(deleteSql, (err) => {
    if (err) return res.status(500).json({ error: err.message });

    // รีเซ็ต AUTO_INCREMENT
    const resetAI = "ALTER TABLE lottos AUTO_INCREMENT = 1";
    conn.query(resetAI, (err) => {
      if (err) return res.status(500).json({ error: err.message });

      // สร้างล็อตโต้ใหม่
      const insertSql = "INSERT INTO lottos(lotto_number, lotto_price, created_by_user_id, status, created_at) VALUES ?";
      conn.query(insertSql, [values], (err, result) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json({ message: `ระบบถูกรีเซ็ตและสร้างล็อตโต้ใหม่ ${lottoCount} ใบ` });
      });
    });
  });
});

// ดึงล็อตโต้ทั้งหมด
router.get("/", (req, res) => {
  const sql = "SELECT * FROM lottos";
  conn.query(sql, (err, result) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(result);
  });
});

router.post("/draw", async (req, res) => {
  try {
    const soldLottoSql = "SELECT * FROM lottos WHERE status='SOLD'";
    conn.query(soldLottoSql, (err, result: any[]) => {
      if (err) return res.status(500).json({ error: err.message });
      if (result.length < 5) return res.status(400).json({ error: "ขายล็อตโต้อย่างน้อย 5 ใบก่อน" });

      const shuffled = result.sort(() => 0.5 - Math.random());
      const winners = shuffled.slice(0, 5);

      const prizes = [
        { rank: 1, amount: 1000000 },
        { rank: 2, amount: 500000 },
        { rank: 3, amount: 100000 },
        { rank: 4, amount: 5000 },
        { rank: 5, amount: 2000 },
      ];

      winners.forEach((w, i) => {
        const prizeId = prizes[i].rank;
        const updateSql = "UPDATE lottos SET status='WIN', prize_id=? WHERE lotto_id=?";
        conn.query(updateSql, [prizeId, w.lotto_id]);
      });

      res.json({ message: "ออกรางวัลเรียบร้อย", winners, prizes });
    });
  } catch (e: unknown) {
    // ✅ cast e เป็น Error ก่อนเข้าถึง message
    if (e instanceof Error) {
      res.status(500).json({ error: e.message });
    } else {
      res.status(500).json({ error: "Unknown error" });
    }
  }
});

router.get("/:id", (req, res) => {
    const id = +req.params.id; // แปลง id จาก string เป็น number
    const sql = "SELECT * FROM lottos WHERE lotto_id = ?";
    conn.query(sql, [id], (err, result) => {
        if (err) { // Check if err is not null
            return res.status(500).json({ error: err.message });
        }
        res.json((result as any[])[0]);
    });
});
router.delete("/:id", (req, res) => {
    const id = +req.params.id;
    const sql = "DELETE FROM `lottos` WHERE `lotto_id` = ?";
    
    conn.query(sql, [id], (err, result) => {
        if (err) {
            return res.status(500).json({ error: err.message });
        }
        if ((result as ResultSetHeader).affectedRows === 0) {
            return res.status(404).json({ message: "Lotto not found" });
        }
        res.status(200).json({ affected_row: (result as ResultSetHeader).affectedRows });
    });
});