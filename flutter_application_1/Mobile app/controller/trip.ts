import express from "express";
import { conn, queryAsync } from "../dbconnect";
import { Trip } from "../model/trip";
import mysql from "mysql";

export const router = express.Router();

router.get("/", (req, res) => {
  conn.query('select * from trip', (err, result, fields)=>{
    res.json(result);
  });
});
// router.get("/:id", (req, res) => {
//   let id = +req.params.id;
//   conn.query("select * from trip where idx = ?" , [id], (err, result, fields) => {
//   if (err) throw err;
//     res.json(result);
//   });
// });
// router.get("/search/fields", (req, res) => {
//   conn.query(
//     "select * from trip where (idx IS NULL OR idx = ?) OR (name IS NULL OR name like ?)",
//     [ req.query.id, "%" + req.query.name + "%"],
//     (err, result, fields) => {
//     if (err) throw err;
//       res.json(result);
//     }
//   );
// });
// router.get("/search/price", (req, res) => {
//   conn.query("select * from trip where (price IS NULL OR price < ?)", [req.query.price], (err, result, fields) => {
//   if (err) throw err;
//     res.json(result);
//   });
// });
// router.get("/", (req, res) => {
//   conn.query("select * from trip", (err, result, fields) => {
//     let trips = result as Trip[];

//     res.json(result);
//   });
// });

// router.post("/", (req, res) => {
//   let trip: Trip = req.body;
//   let sql =
//     "INSERT INTO `trip`(`name`, `country`, `destinationid`, `coverimage`, `detail`, `price`, `duration`) VALUES (?,?,?,?,?,?,?)";
//   sql = mysql.format(sql, [
//     trip.name,
//     trip.country,
//     trip.destinationid,
//     trip.coverimage,
//     trip.detail,
//     trip.price,
//     trip.duration,
//   ]);
//   conn.query(sql, (err, result) => {
//     if (err) throw err;
//     res
//       .status(201)
//       .json({ affected_row: result.affectedRows, last_idx: result.insertId });
//   });
// });

// router.delete("/:id", (req, res) => {
//   let id = +req.params.id;
//   conn.query("delete from trip where idx = ?", [id], (err, result) => {
//      if (err) throw err;
//      res
//        .status(200)
//        .json({ affected_row: result.affectedRows });
//   });
// });
// // router.put("/:id", (req, res) => {
// //   let id = +req.params.id;
// //   let trip: Trip = req.body;
// //   let sql =
// //     "update  `trip` set `name`=?, `country`=?, `destinationid`=?, `coverimage`=?, `detail`=?, `price`=?, `duration`=? where `idx`=?";
// //   sql = mysql.format(sql, [
// //     trip.name,
// //     trip.country,
// //     trip.destinationid,
// //     trip.coverimage,
// //     trip.detail,
// //     trip.price,
// //     trip.duration,
// //     id
// //   ]);
// //   conn.query(sql, (err, result) => {
// //     if (err) throw err;
// //     res
// //       .status(200)
// //       .json({ affected_row: result.affectedRows });
// //   });
// // });
// router.put("/:id", async (req, res) => {
//    // Get the id from the request parameters
//   let id = +req.params.id;
//   // Serialize the request body to Trip object
//   let trip: Trip = req.body;

//   let sql = mysql.format("select * from trip where idx = ?", [id]);
//   // Execute the query and get the result
//   let result = (await queryAsync(sql)) as Trip[];
//   // Convert the result to a JSON string (to be shown)
//   console.log(JSON.stringify(result));

//   if (result.length >  0) {
//     // Get the original trip data from the database
//     let tripOriginal = result[0] as Trip;
//     console.log(tripOriginal);

//     let updateTrip = {...tripOriginal,...trip};
//     console.log("updateTrip");
//     console.log(updateTrip);

//     sql =
//       "update  `trip` set `name`=?, `country`=?, `destinationid`=?, `coverimage`=?, `detail`=?, `price`=?, `duration`=? where `idx`=?";
    
//     sql = mysql.format(sql, [
//       updateTrip.name,
//       updateTrip.country,
//       updateTrip.destinationid,
//       updateTrip.coverimage,
//       updateTrip.detail,
//       updateTrip.price,
//       updateTrip.duration,
//       id,
//     ]);
//     conn.query(sql, (err, result) => {
//       if (err) throw err;
//       res.status(201).json({ affected_row: result.affectedRows });
//     });

//   }else {
//     res.status(404).json({ message: "Trip not found" });
//   }
// });
// // router.get("/",(req,res) => {
// //     res.send("Get in trip.ts");
// // })
// // router.get("/", (req, res) => {
// //   if (req.query.id) {
// //     res.send("Get in trip.ts Query id: " + req.query.id);
// //   }else if (req.query.name){
// //     res.send("Get in trip.ts Query name: " + req.query.name);
// //   } 
// //   else {
// //     res.send("Get in trip.ts");
// //   }
// // });

// // router.get("/:id", (req, res) => {
// //   res.send("Get in trip.ts id: " + req.params.id);
// // }); 