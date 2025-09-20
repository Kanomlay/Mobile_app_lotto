import express from "express";
import { conn } from "../dbconnect";
import { Lotto } from "../model/lotto";
import mysql from "mysql";
import { ResultSetHeader } from "mysql2";

export const router = express.Router();

// GET: ดึงข้อมูลลอตเตอรี่ทั้งหมด
// router.get("/", (req, res) => {
//     const sql = "SELECT * FROM lottos";
//     conn.query(sql, (err, result) => {
//         if (err) {
//             return res.status(500).json({ error: err.message });
//         }
//         res.json(result);
//     });
// });
router.get("/", (req, res) => {
    const sql = "SELECT * FROM lottos WHERE status = 'AVAILABLE'";
    conn.query(sql, (err, result) => {
        if (err) {
            return res.status(500).json({ error: err.message });
        }
        res.json(result);
    });
});

router.get("/:name", (req, res) => {
  const name = req.params.name;
  const sql = "SELECT * FROM lottos WHERE lotto_name = ?";
  conn.query(sql, [name], (err, result) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.json(result); 
  });
});

// GET: ดึงข้อมูลลอตเตอรี่ตาม ID
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

// POST: สร้างลอตเตอรี่ใหม่
router.post("/", (req, res) => {
    const newLotto: { lotto_number: string; lotto_price: number; created_by_user_id: number; } = req.body;
    
    let sql = "INSERT INTO `lottos`(`lotto_number`, `lotto_price`, `created_by_user_id`) VALUES (?,?,?)";
    
    sql = mysql.format(sql, [
        newLotto.lotto_number,
        newLotto.lotto_price,
        newLotto.created_by_user_id
    ]);

    conn.query(sql, (err, result) => {
        if (err) {
            return res.status(500).json({ error: err.message });
        }
        res.status(201).json({ affected_row: (result as ResultSetHeader).affectedRows, last_idx: (result as ResultSetHeader).insertId });
    });
});

// PUT: อัปเดตข้อมูลลอตเตอรี่
router.put("/:id", (req, res) => {
    const id = +req.params.id;
    const updatedLotto: { lotto_number: string; lotto_price: number; } = req.body;
    
    let sql = "UPDATE `lottos` SET `lotto_number`=?, `lotto_price`=? WHERE `lotto_id`=?";
    
    sql = mysql.format(sql, [
        updatedLotto.lotto_number,
        updatedLotto.lotto_price,
        id
    ]);

    conn.query(sql, (err, result) => {
        if (err) {
            return res.status(500).json({ error: err.message });
        }
        if ((result as ResultSetHeader).affectedRows === 0) {
            return res.status(404).json({ message: "Lotto not found or no new data to update" });
        }
        res.status(200).json({ affected_row: (result as ResultSetHeader).affectedRows });
    });
});

// DELETE: ลบลอตเตอรี่
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
router.delete("/", (req, res) => {
    // คำสั่ง SQL สำหรับลบข้อมูลทั้งหมดจากตาราง lottos
    const sql = "DELETE FROM `lottos`";

    // ไม่ต้องส่ง parameter ตัวที่สอง ([id]) เพราะเราจะลบทั้งหมด
    conn.query(sql, (err, result) => {
        if (err) {
            // หากมีข้อผิดพลาดจากฐานข้อมูล
            return res.status(500).json({ error: err.message });
        }
        
        // ส่งผลลัพธ์กลับไปว่าลบไปกี่แถว
        res.status(200).json({ 
            message: "All data from lottos table has been deleted successfully.",
            affected_rows: (result as ResultSetHeader).affectedRows 
        });
    });
});