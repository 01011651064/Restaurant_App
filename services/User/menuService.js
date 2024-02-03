const dbConnection = require("../../config/database");
const asyncHandelr = require("express-async-handler");
const ApiError = require("../../utils/apiError");

const getAllItems = asyncHandelr(async (req, res, next) => {
    const [result] = await (await dbConnection).query("SELECT * FROM menuitems");
    // if (result.length === 0) {
    //     return next(new ApiError(`No Items Found`, 404));
    // }
    res.status(200).json(result);
});

const getItemByCategory = asyncHandelr(async (req, res, next) => {
    const [result] = await (await dbConnection).query(`SELECT
    menuitems.itemId,menuitems.name,menuitems.stock,menuitems.description,menuitems.rating,menuitems.price,menuitems.timesOrdered,menuitems.firstImage ,menuitems.secondImage
    FROM menuitems INNER JOIN categories_has_menuitems
    ON categories_has_menuitems.itemId=menuitems.itemId AND categories_has_menuitems.categoyId=?`, [req.params.id]);
    // if (result2.length === 0) {
    //     return next(new ApiError(`No Items Found`, 404));
    // }
    res.status(200).json(result);
});

const getMostPopularItems = asyncHandelr(async (req, res, next) => {
    const [result] = await (await dbConnection).query("SELECT * FROM menuitems ORDER BY rating DESC LIMIT 5");
    // if (result.length === 0) {
    //     return next(new ApiError(`No Items Found`, 404));
    // }
    res.status(200).json(result);
});

const getRandomItems = asyncHandelr(async (req, res, next) => {
    const [result] = await (await dbConnection).query("SELECT * FROM menuitems ORDER BY RAND() LIMIT 5");
    // if (result.length === 0) {
    //     return next(new ApiError(`No Items Found`, 404));
    // }
    res.status(200).json(result);
});

// const calculateRating = async (req, res) => {
//     try {
//       const { customerId, itemId, rating } = req.body;
//       const query = 'SELECT * FROM calculaterate WHERE customerId = ? AND itemId = ? ';
//       const combunationQuery = await new Promise((resolve, reject) => {
//         db.query(query, [customerId, itemId], (err, results) => {
//           if (err) {
//             console.error('Error retrieving data: ' + err);
//             reject(err);
//           } else {
//             resolve(results);
//           }
//         });
//       });
//       if (combunationQuery.length > 0) {
//         // combination exist so update
//         const query = 'UPDATE calculaterate SET rating = ? WHERE customerId = ? AND itemId = ? ';

//         const createQuery = await new Promise((resolve, reject) => {
//           db.query(query, [rating, customerId, itemId], (err, results) => {
//             if (err) {
//               console.error('Error updatting data: ' + err);
//               reject(err);
//             } else {
//               resolve(results);
//             }
//           });
//         });

//       }
//       else {
//         const query = 'insert into  resto.calculaterate (customerId,itemId,rating) values(?,?,?)';

//         const updateQuery = await new Promise((resolve, reject) => {
//           db.query(query, [customerId, itemId, rating], (err, results) => {
//             if (err) {
//               console.error('Error retrieving data: ' + err);
//               reject(err);
//             } else {
//               resolve(results);
//             }
//           });
//         });
//       }

//       // calculating avg (rating) for the item id 
//       let newRate;
//       const avgquery = ' SELECT   AVG(rating)  FROM calculaterate WHERE itemId = ? ';

//       const avgqueryCalc = await new Promise((resolve, reject) => {
//         db.query(avgquery, [itemId], (err, results) => {
//           if (err) {
//             console.error('Error calc avg : ' + err);
//             reject(err);
//           } else {
//             // convert query to value only
//             const x = Object.values(results[0]);
//             newRate = parseFloat(x[0]);

//             console.log(newRate);

//             resolve(results);
//           }
//         });
//       });
//       res.send(avgqueryCalc);


//       //update rating in menueitems table
//       const menuItemQuery = 'UPDATE menuitems SET rating = ? WHERE itemId = ?';

//       const updateQuery = await new Promise((resolve, reject) => {
//         db.query(menuItemQuery, [newRate, itemId], (err, results) => {
//           if (err) {
//             console.error('Error updating data: ' + err);
//             reject(err);
//           } else {
//             resolve(results);
//           }
//         });
//       });


//     } catch (err) {
//       console.error('Error updating data: ' + err);
//       res.status(500).send('Error updating data');
//     }
//   }
module.exports = {
    getAllItems,
    getItemByCategory,
    getMostPopularItems,
    getRandomItems,
};