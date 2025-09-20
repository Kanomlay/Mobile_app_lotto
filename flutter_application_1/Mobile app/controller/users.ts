import express from "express";
import { conn, queryAsync } from "../dbconnect";
import mysql from "mysql";
import { ResultSetHeader } from "mysql2";

export const router = express.Router();
router.get("/", async (req, res) => {
  try {
    // เปลี่ยนคำสั่ง SQL ให้ดึงจากตาราง "users"

    const result = await queryAsync({ sql: "SELECT * FROM users" }); // ส่งผลลัพธ์กลับไป

    res.json(result);
  } catch (err: any) {
    // การจัดการ Error เหมือนเดิม

    console.error("Database query error:", err);

    res.status(500).json({ error: err.message });
  }
});
// 1. createUser(userData): สร้างผู้ใช้ใหม่ (สมัครสมาชิก)
// ในไฟล์ routes/userRouter.ts

router.post("/register", (req, res) => {
  // 1. รับค่าจาก body ให้ครบทุก field ตามหน้า UI
  const newUser: {
    first_name?: string;
    last_name?: string;
    phone_number?: string;
    email: string;
    wallet_balance?: number;
    password_hash: string;
  } = req.body;

  // 2. แก้ไข SQL INSERT ให้รองรับคอลัมน์ใหม่
  let sql = "INSERT INTO `users`(`first_name`, `last_name`, `phone_number`, `email`, `wallet_balance`, `password_hash`) VALUES (?,?,?,?,?,?)";

  // 3. เพิ่มข้อมูลใหม่เข้าไปใน array ของ mysql.format
  sql = mysql.format(sql, [
    newUser.first_name,
    newUser.last_name,
    newUser.phone_number,
    newUser.email,
    newUser.wallet_balance || 0, // ใส่ค่าเริ่มต้น 0 หากไม่ได้ส่งมา
    newUser.password_hash,
  ]);

  conn.query(sql, (err, result) => {
    if (err) {
      if (err.code === "ER_DUP_ENTRY") {
        return res.status(409).json({ error: "This email is already in use." });
      }
      return res.status(500).json({ error: err.message });
    }
    const header = result as ResultSetHeader;
    res.status(201).json({ message: "User created successfully", user_id: header.insertId });
  });
});

router.post("/login", (req, res) => {
  const { email, password } = req.body;
  const sql = "SELECT * FROM users WHERE email = ?";

  conn.query(sql, [email], (err, result) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }

    const users = result as any[];
    if (users.length === 0) {
      return res.status(404).json({ error: "User not found" });
    }

    const user = users[0];
    // !!! คำเตือน: ในระบบจริง ต้องเปรียบเทียบรหัสผ่านที่ hash แล้ว !!!
    // !!! เช่น const isMatch = await bcrypt.compare(password, user.password_hash); !!!
    if (password !== user.password_hash) {
      return res.status(401).json({ error: "Invalid credentials" });
    }

    // ถ้าสำเร็จ ไม่ควรส่ง password_hash กลับไป
    const { password_hash, ...userWithoutPassword } = user;
    res.json({ message: "Login successful", user: userWithoutPassword });
  });
});

// 3. findUserById(userId): ดึงข้อมูลผู้ใช้จาก ID
router.get("/:id", (req, res) => {
  const id = +req.params.id;
  // เลือกเฉพาะ field ที่ปลอดภัย ไม่เอา password_hash มาด้วย
  const sql =
    "SELECT user_id, first_name, last_name, email, role, wallet_balance, created_at FROM users WHERE user_id = ?";

  conn.query(sql, [id], (err, result) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    if ((result as any[]).length === 0) {
      return res.status(404).json({ message: "User not found" });
    }
    res.json((result as any[])[0]);
  });
});
