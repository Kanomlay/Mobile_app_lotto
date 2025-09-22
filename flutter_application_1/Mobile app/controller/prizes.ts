import express from "express";
import { conn } from "../dbconnect";
import { ResultSetHeader } from "mysql2";

export const router = express.Router();
router.post("/draw", (req, res) => {
  (async () => {
    const prizeMoney = [2000000, 200000, 20000];
    const connection = conn.promise();

    try {
      // ล้างค่าเดิม
      await connection.query("UPDATE lottos SET prize_id = NULL");
      await connection.query("DELETE FROM prizes");
      await connection.query("ALTER TABLE prizes AUTO_INCREMENT = 1");

      // ดึงเลขพร้อม id จาก lottos
      const [lottos]: any = await connection.query(
        "SELECT lotto_id, lotto_number FROM lottos"
      );

      if (lottos.length < 3) {
        return res
          .status(400)
          .json({ error: "ต้องมีลอตเตอรี่ในระบบอย่างน้อย 3 ใบ" });
      }

      // สุ่ม 3 ใบ
      const selected: any[] = [];
      while (selected.length < 3) {
        const rand = Math.floor(Math.random() * lottos.length);
        const row = lottos[rand];
        if (!selected.find((s) => s.lotto_id === row.lotto_id)) {
          selected.push(row);
        }
      }

      const drawDate = new Date().toISOString().slice(0, 10);

      // ====== รางวัลหลัก 3 รางวัล ======
      const prizeIds: number[] = [];
      for (let idx = 0; idx < selected.length; idx++) {
        const row = selected[idx];
        const [result]: any = await connection.query(
          `INSERT INTO prizes(prize_name, prize_amount, winning_number, prize_type, draw_date)
           VALUES (?, ?, ?, ?, ?)`,
          [
            `รางวัลที่ ${idx + 1}`,
            prizeMoney[idx],
            row.lotto_number,
            "FULL_NUMBER",
            drawDate,
          ]
        );
        prizeIds.push(result.insertId);
        // update lotto ให้ prize_id = id ของรางวัล
        await connection.query(
          "UPDATE lottos SET prize_id = ? WHERE lotto_id = ?",
          [result.insertId, row.lotto_id]
        );
      }

      // เลขท้าย 3 ตัว
      const firstPrize = selected[0];
      const last3 = firstPrize.lotto_number.substring(3);
      const last2 = firstPrize.lotto_number.substring(4);

      const [p3]: any = await connection.query(
        `INSERT INTO prizes(prize_name, prize_amount, winning_number, prize_type, draw_date)
         VALUES (?, ?, ?, ?, ?)`,
        ["รางวัลเลขท้าย 3 ตัว", 4000, last3, "LAST_3_DIGITS", drawDate]
      );

      // update lotto ที่เลขท้าย 3 ตัวตรงกับรางวัลนี้
      await connection.query(
        "UPDATE lottos SET prize_id = ? WHERE RIGHT(lotto_number,3) = ? AND prize_id IS NULL",
        [p3.insertId, last3]
      );

      // เลขท้าย 2 ตัว
      const [p2]: any = await connection.query(
        `INSERT INTO prizes(prize_name, prize_amount, winning_number, prize_type, draw_date)
         VALUES (?, ?, ?, ?, ?)`,
        ["รางวัลเลขท้าย 2 ตัว", 2000, last2, "LAST_2_DIGITS", drawDate]
      );

      // update lotto ที่เลขท้าย 2 ตัวตรงกับรางวัลนี้
      await connection.query(
        "UPDATE lottos SET prize_id = ? WHERE RIGHT(lotto_number,2) = ? AND prize_id IS NULL",
        [p2.insertId, last2]
      );

      // ส่งผลกลับ
      res.json({
        message: "ออกรางวัลสำเร็จ",
        prizes: [
          ...prizeIds.map((id, i) => ({
            prize_id: id,
            prize_name: `รางวัลที่ ${i + 1}`,
            prize_amount: prizeMoney[i],
            winning_number: selected[i].lotto_number,
            prize_type: "FULL_NUMBER",
            draw_date: drawDate,
          })),
          {
            prize_id: p3.insertId,
            prize_name: "รางวัลเลขท้าย 3 ตัว",
            prize_amount: 4000,
            winning_number: last3,
            prize_type: "LAST_3_DIGITS",
            draw_date: drawDate,
          },
          {
            prize_id: p2.insertId,
            prize_name: "รางวัลเลขท้าย 2 ตัว",
            prize_amount: 2000,
            winning_number: last2,
            prize_type: "LAST_2_DIGITS",
            draw_date: drawDate,
          },
        ],
      });
    } catch (err: any) {
      console.error(err);
      res.status(500).json({ error: err.message });
    }
  })();
});

router.post("/draw/sold", (req, res) => {
  (async () => {
    const prizeMoney = [2000000, 200000, 20000];
    const connection = conn.promise();

    try {
      // ล้างค่าเดิม
      await connection.query("UPDATE lottos SET prize_id = NULL");
      await connection.query("DELETE FROM prizes");
      await connection.query("ALTER TABLE prizes AUTO_INCREMENT = 1");

      // ดึงเลขพร้อม id จาก lottos
      const [lottos]: any = await connection.query(
        "SELECT lotto_id, lotto_number FROM lottos WHERE status = 'SOLD'"
      );

      if (lottos.length < 3) {
        return res
          .status(400)
          .json({ error: "ต้องมีลอตเตอรี่ในระบบอย่างน้อย 3 ใบ" });
      }

      // สุ่ม 3 ใบ
      const selected: any[] = [];
      while (selected.length < 3) {
        const rand = Math.floor(Math.random() * lottos.length);
        const row = lottos[rand];
        if (!selected.find((s) => s.lotto_id === row.lotto_id)) {
          selected.push(row);
        }
      }

      const drawDate = new Date().toISOString().slice(0, 10);

      // ====== รางวัลหลัก 3 รางวัล ======
      const prizeIds: number[] = [];
      for (let idx = 0; idx < selected.length; idx++) {
        const row = selected[idx];
        const [result]: any = await connection.query(
          `INSERT INTO prizes(prize_name, prize_amount, winning_number, prize_type, draw_date)
           VALUES (?, ?, ?, ?, ?)`,
          [
            `รางวัลที่ ${idx + 1}`,
            prizeMoney[idx],
            row.lotto_number,
            "FULL_NUMBER",
            drawDate,
          ]
        );
        prizeIds.push(result.insertId);
        // update lotto ให้ prize_id = id ของรางวัล
        await connection.query(
          "UPDATE lottos SET prize_id = ? WHERE lotto_id = ?",
          [result.insertId, row.lotto_id]
        );
      }

      // เลขท้าย 3 ตัว
      const firstPrize = selected[0];
      const last3 = firstPrize.lotto_number.substring(3);
      const last2 = firstPrize.lotto_number.substring(4);

      const [p3]: any = await connection.query(
        `INSERT INTO prizes(prize_name, prize_amount, winning_number, prize_type, draw_date)
         VALUES (?, ?, ?, ?, ?)`,
        ["รางวัลเลขท้าย 3 ตัว", 4000, last3, "LAST_3_DIGITS", drawDate]
      );

      // update lotto ที่เลขท้าย 3 ตัวตรงกับรางวัลนี้
      await connection.query(
        "UPDATE lottos SET prize_id = ? WHERE RIGHT(lotto_number,3) = ? AND prize_id IS NULL",
        [p3.insertId, last3]
      );

      // เลขท้าย 2 ตัว
      const [p2]: any = await connection.query(
        `INSERT INTO prizes(prize_name, prize_amount, winning_number, prize_type, draw_date)
         VALUES (?, ?, ?, ?, ?)`,
        ["รางวัลเลขท้าย 2 ตัว", 2000, last2, "LAST_2_DIGITS", drawDate]
      );

      // update lotto ที่เลขท้าย 2 ตัวตรงกับรางวัลนี้
      await connection.query(
        "UPDATE lottos SET prize_id = ? WHERE RIGHT(lotto_number,2) = ? AND prize_id IS NULL",
        [p2.insertId, last2]
      );

      // ส่งผลกลับ
      res.json({
        message: "ออกรางวัลสำเร็จ",
        prizes: [
          ...prizeIds.map((id, i) => ({
            prize_id: id,
            prize_name: `รางวัลที่ ${i + 1}`,
            prize_amount: prizeMoney[i],
            winning_number: selected[i].lotto_number,
            prize_type: "FULL_NUMBER",
            draw_date: drawDate,
          })),
          {
            prize_id: p3.insertId,
            prize_name: "รางวัลเลขท้าย 3 ตัว",
            prize_amount: 4000,
            winning_number: last3,
            prize_type: "LAST_3_DIGITS",
            draw_date: drawDate,
          },
          {
            prize_id: p2.insertId,
            prize_name: "รางวัลเลขท้าย 2 ตัว",
            prize_amount: 2000,
            winning_number: last2,
            prize_type: "LAST_2_DIGITS",
            draw_date: drawDate,
          },
        ],
      });
    } catch (err: any) {
      console.error(err);
      res.status(500).json({ error: err.message });
    }
  })();
});
// router.post("/draw", (req, res) => {
//   (async () => {
//     const prizeMoney = [2000000, 200000, 20000];
//     const connection = conn.promise();

//     try {
//       await connection.query("UPDATE lottos SET prize_id = NULL");
//       await connection.query("DELETE FROM prizes");
//       await connection.query("ALTER TABLE prizes AUTO_INCREMENT = 1");
//       // เคลียร์ prize_id ใน lottos ด้วย

//       // ดึงเลขพร้อม id จาก lottos
//       const [lottos]: any = await connection.query(
//         "SELECT lotto_id, lotto_number FROM lottos"
//       );

//       if (lottos.length < 3) {
//         return res
//           .status(400)
//           .json({ error: "ต้องมีลอตเตอรี่ในระบบอย่างน้อย 3 ใบ" });
//       }

//       // สุ่ม 3 ใบ
//       const selected: any[] = [];
//       while (selected.length < 3) {
//         const rand = Math.floor(Math.random() * lottos.length);
//         const row = lottos[rand];
//         if (!selected.find((s) => s.lotto_id === row.lotto_id))
//           selected.push(row);
//       }

//       const drawDate = new Date().toISOString().slice(0, 10);

//       // ใส่รางวัลหลัก 3 รางวัล
//       const prizeIds: number[] = [];
//       for (let idx = 0; idx < selected.length; idx++) {
//         const row = selected[idx];
//         const [result]: any = await connection.query(
//           `INSERT INTO prizes(prize_name, prize_amount, winning_number, prize_type, draw_date)
//            VALUES (?, ?, ?, ?, ?)`,
//           [
//             `รางวัลที่ ${idx + 1}`,
//             prizeMoney[idx],
//             row.lotto_number,
//             "FULL_NUMBER",
//             drawDate,
//           ]
//         );
//         // result.insertId คือ id ของรางวัล
//         prizeIds.push(result.insertId);
//         // update lotto ให้ prize_id = id ของรางวัล
//         await connection.query(
//           "UPDATE lottos SET prize_id = ? WHERE lotto_id = ?",
//           [result.insertId, row.lotto_id]
//         );
//       }

//       // เลขท้าย 3 ตัว
//       const firstPrize = selected[0];
//       const [p3]: any = await connection.query(
//         `INSERT INTO prizes(prize_name, prize_amount, winning_number, prize_type, draw_date)
//          VALUES (?, ?, ?, ?, ?)`,
//         [
//           "รางวัลเลขท้าย 3 ตัว",
//           4000,
//           firstPrize.lotto_number.substring(3),
//           "LAST_3_DIGITS",
//           drawDate,
//         ]
//       );
//       // เลขท้าย 2 ตัว
//       const [p2]: any = await connection.query(
//         `INSERT INTO prizes(prize_name, prize_amount, winning_number, prize_type, draw_date)
//          VALUES (?, ?, ?, ?, ?)`,
//         [
//           "รางวัลเลขท้าย 2 ตัว",
//           2000,
//           firstPrize.lotto_number.substring(4),
//           "LAST_2_DIGITS",
//           drawDate,
//         ]
//       );

//       // (เลขท้ายปกติไม่ได้ผูกกับใบใดใบหนึ่งตรงๆ เลยไม่ต้อง update prize_id ใน lottos)

//       res.json({
//         message: "ออกรางวัลสำเร็จ",
//         prizes: [
//           ...prizeIds.map((id, i) => ({
//             prize_id: id,
//             prize_name: `รางวัลที่ ${i + 1}`,
//             prize_amount: prizeMoney[i],
//             winning_number: selected[i].lotto_number,
//             prize_type: "FULL_NUMBER",
//             draw_date: drawDate,
//           })),
//           {
//             prize_id: p3.insertId,
//             prize_name: "รางวัลเลขท้าย 3 ตัว",
//             prize_amount: 4000,
//             winning_number: firstPrize.lotto_number.substring(3),
//             prize_type: "LAST_3_DIGITS",
//             draw_date: drawDate,
//           },
//           {
//             prize_id: p2.insertId,
//             prize_name: "รางวัลเลขท้าย 2 ตัว",
//             prize_amount: 2000,
//             winning_number: firstPrize.lotto_number.substring(4),
//             prize_type: "LAST_2_DIGITS",
//             draw_date: drawDate,
//           },
//         ],
//       });
//     } catch (err: any) {
//       console.error(err);
//       res.status(500).json({ error: err.message });
//     }
//   })();
// });

// router.post("/draw", (req, res) => {
//   (async () => {
//     const prizeMoney = [2000000, 200000, 20000];
//     const connection = conn.promise();

//     try {
//       // 1️⃣ ลบของเก่า
//       await connection.query("DELETE FROM prizes");
//       await connection.query("ALTER TABLE prizes AUTO_INCREMENT = 1");

//       // 2️⃣ ดึงเลขจาก lottos
//       const [lottos]: any = await connection.query(
//         "SELECT lotto_number FROM lottos"
//       );

//       // ตรวจสอบ
//       if (lottos.length < 3) {
//         return res
//           .status(400)
//           .json({ error: "ต้องมีลอตเตอรี่ในระบบอย่างน้อย 3 ใบ" });
//       }

//       // 3️⃣ สุ่ม
//       const selected: string[] = [];
//       while (selected.length < 3) {
//         const rand = Math.floor(Math.random() * lottos.length);
//         const num = lottos[rand].lotto_number;
//         if (!selected.includes(num)) selected.push(num);
//       }

//       const drawDate = new Date().toISOString().slice(0, 10);

//       const values: any[] = [];

//       selected.forEach((num, idx) => {
//         values.push([
//           `รางวัลที่ ${idx + 1}`,
//           prizeMoney[idx],
//           num,
//           "FULL_NUMBER",
//           drawDate,
//         ]);
//       });

//       // รางวัลเลขท้าย
//       const firstPrize = selected[0];
//       values.push([
//         "รางวัลเลขท้าย 3 ตัว",
//         4000,
//         firstPrize.substring(3),
//         "LAST_3_DIGITS",
//         drawDate,
//       ]);
//       values.push([
//         "รางวัลเลขท้าย 2 ตัว",
//         2000,
//         firstPrize.substring(4),
//         "LAST_2_DIGITS",
//         drawDate,
//       ]);

//       await connection.query(
//         "INSERT INTO prizes(prize_name, prize_amount, winning_number, prize_type, draw_date) VALUES ?",
//         [values]
//       );

//       res.json({
//         message: "ออกรางวัลสำเร็จ",
//         prizes: values.map((v) => ({
//           prize_name: v[0],
//           prize_amount: v[1],
//           winning_number: v[2],
//           prize_type: v[3],
//           draw_date: v[4],
//         })),
//       });
//     } catch (err: any) {
//       console.error(err);
//       res.status(500).json({ error: err.message });
//     }
//   })();
// });

// router.post("/", async (req, res) => {
//   const { prize_name, prize_amount, winning_number, prize_type, draw_date } = req.body;
//   try {
//     const [result] = await conn
//       .promise()
//       .query(
//         "INSERT INTO prizes(prize_name, prize_amount, winning_number, prize_type, draw_date) VALUES (?,?,?,?,?)",
//         [prize_name, prize_amount, winning_number, prize_type, draw_date]
//       );
//     res.status(201).json({
//       prize_id: (result as ResultSetHeader).insertId,
//       message: "เพิ่มรางวัลสำเร็จ",
//     });
//   } catch (err) {
//     res.status(500).json({ error: (err as Error).message });
//   }
// });
