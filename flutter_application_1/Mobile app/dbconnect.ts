import mysql from "mysql2";
import util from "util";

export const conn = mysql.createPool({
  connectionLimit: 10,
  host: "202.28.34.203", // <-- 1. เปลี่ยนจาก "localhost" เป็น IP Address ของเซิร์ฟเวอร์
  // port: 3306, // <-- 2. (อาจจะต้องเพิ่ม) Port ของ MySQL โดยปกติคือ 3306
  user: "mb68_66011212006",
  password: "mHB^@RbpDCxB",
  database: "mb68_66011212006", // <-- 5. เช็คชื่อ database ให้ถูกต้อง
});

export const queryAsync = util.promisify(conn.query).bind(conn);
