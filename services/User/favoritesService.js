const dbConnection = require("../../config/database");
const asyncHandelr = require("express-async-handler");
const jwt = require("jsonwebtoken");
const ApiError = require("../../utils/apiError");

const addFavorite = asyncHandelr(async (req, res, next) => {
    const query = 'INSERT INTO favorites (itemId,customerId) VALUES (?, ?)';
    const getIdQuery = `SELECT customerId FROM customers WHERE personId = ?`;
    const checkQuery = 'SELECT * FROM favorites WHERE itemId = ? AND customerId = ?'
    const decoded = jwt.verify(req.headers.token, process.env.JWT_SECRETKEY);

    const [customer] = await (await dbConnection).query(getIdQuery, decoded.id);
    const [checkResult] = await (await dbConnection).query(checkQuery, [req.params.itemId, customer[0].customerId]);
    if (checkResult.length === 0) {
        const [result2] = await (await dbConnection).query(query, [req.params.itemId, customer[0].customerId]);
    }

    res.status(200).json({ message: 'Added Favorite Successfully' });
});

const getAllFavorites = asyncHandelr(async (req, res, next) => {
    const query = 'SELECT m.* FROM menuitems m JOIN favorites f ON m.itemId = f.itemId WHERE f.customerId = ?;';
    const getIdQuery = `SELECT customerId FROM customers WHERE personId = ?`
    const decoded = jwt.verify(req.headers.token, process.env.JWT_SECRETKEY);

    const [customer] = await (await dbConnection).query(getIdQuery, decoded.id);
    const [result] = await (await dbConnection).query(query, customer[0].customerId);

    res.status(200).json(result);
});


const deleteFavorite = asyncHandelr(async (req, res, next) => {
    const query = 'DELETE FROM favorites WHERE itemId = ? AND customerId=?';
    const getIdQuery = `SELECT customerId FROM customers WHERE personId = ?`;
    const checkQuery = 'SELECT * FROM favorites WHERE itemId = ? AND customerId = ?'
    const decoded = jwt.verify(req.headers.token, process.env.JWT_SECRETKEY);

    const [customer] = await (await dbConnection).query(getIdQuery, decoded.id);
    const [checkResult] = await (await dbConnection).query(checkQuery, [req.params.itemId, customer[0].customerId]);
    if (checkResult.length !== 0) {
        const [result2] = await (await dbConnection).query(query, [req.params.itemId, customer[0].customerId]);
    }

    res.status(200).json({ message: 'Deleted Favorite Successfully' });
});

module.exports = {
    addFavorite,
    deleteFavorite,
    getAllFavorites,

};