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

router.post("/reset", (req, res) => {
  const lottoCount = 100;
  const values: any[] = [];
  const usedNumbers = new Set<string>();

  while (usedNumbers.size < lottoCount) {
    const num = Math.floor(Math.random() * 1000000);
    const formatted = num.toString().padStart(6, "0");
    usedNumbers.add(formatted);
  }

  // เตรียม values สำหรับ insert
  for (const num of usedNumbers) {
    values.push([num, 80, 1, "AVAILABLE", new Date()]);
  }

  // 1️⃣ ลบ lottos
  conn.query("DELETE FROM lottos", (err) => {
    if (err) return res.status(500).json({ error: err.message });

    conn.query("ALTER TABLE lottos AUTO_INCREMENT = 1", (err) => {
      if (err) return res.status(500).json({ error: err.message });

      // 2️⃣ ลบ orders
      conn.query("DELETE FROM orders", (err) => {
        if (err) return res.status(500).json({ error: err.message });

        conn.query("ALTER TABLE orders AUTO_INCREMENT = 1", (err) => {
          if (err) return res.status(500).json({ error: err.message });

          // 3️⃣ ลบ prizes
          conn.query("DELETE FROM prizes", (err) => {
            if (err) return res.status(500).json({ error: err.message });

            conn.query("ALTER TABLE prizes AUTO_INCREMENT = 1", (err) => {
              if (err) return res.status(500).json({ error: err.message });

              // 4️⃣ ลบ users เหลือ admin
              conn.query("DELETE FROM users WHERE role != 'ADMIN'", (err) => {
                if (err) return res.status(500).json({ error: err.message });

                conn.query("ALTER TABLE users AUTO_INCREMENT = 2", (err) => {
                  if (err) return res.status(500).json({ error: err.message });

                  // 5️⃣ สร้างลอตเตอรี่ใหม่
                  const insertSql =
                    "INSERT INTO lottos(lotto_number, lotto_price, created_by_user_id, status, created_at) VALUES ?";
                  conn.query(insertSql, [values], (err, result) => {
                    if (err) return res.status(500).json({ error: err.message });

                    res.json({
                      message: `รีเซ็ตระบบสำเร็จและสร้างลอตเตอรี่ใหม่ ${lottoCount} ใบ`,
                    });
                  });
                });
              });
            });
          });
        });
      });
    });
  });
});


// สุ่มล็อตโต้ (100 ใบใหม่)
// router.post("/reset", (req, res) => {
//   const lottoCount = 100;
//   const values: any[] = [];
//   for (let i = 0; i < lottoCount; i++) {
//     const num = Math.floor(Math.random() * 1000000);
//     const formatted = num.toString().padStart(6, '0');
//     values.push([formatted, 80, 1, "AVAILABLE", new Date()]);
//   }

//   // ลบข้อมูลทั้งหมด
//   const deleteSql = "DELETE FROM lottos";
//   conn.query(deleteSql, (err) => {
//     if (err) return res.status(500).json({ error: err.message });

//     // รีเซ็ต AUTO_INCREMENT
//     const resetAI = "ALTER TABLE lottos AUTO_INCREMENT = 1";
//     conn.query(resetAI, (err) => {
//       if (err) return res.status(500).json({ error: err.message });

//       // สร้างล็อตโต้ใหม่
//       const insertSql = "INSERT INTO lottos(lotto_number, lotto_price, created_by_user_id, status, created_at) VALUES ?";
//       conn.query(insertSql, [values], (err, result) => {
//         if (err) return res.status(500).json({ error: err.message });
//         res.json({ message: `ระบบถูกรีเซ็ตและสร้างล็อตโต้ใหม่ ${lottoCount} ใบ` });
//       });
//     });
//   });
// });

// ดึงล็อตโต้ทั้งหมด
// router.get("/", (req, res) => {
//   const sql = "SELECT * FROM lottos";
//   conn.query(sql, (err, result) => {
//     if (err) return res.status(500).json({ error: err.message });
//     res.json(result);
//   });
// });

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

// GET: ดึงข้อมูลลอตเตอรี่ทั้งหมด
router.get("/", (req, res) => {
    const sql = "SELECT * FROM lottos";
    conn.query(sql, (err, result) => {
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