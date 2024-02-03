const dbConnection = require("../../config/database");
const asyncHandelr = require("express-async-handler");
const jwt = require("jsonwebtoken");
const ApiError = require("../../utils/apiError");

const editRating = asyncHandelr(async (req, res, next) => {
    const decoded = jwt.verify(req.headers.token, process.env.JWT_SECRETKEY);
    req.person = decoded;
    const personId = req.person.id;
    const [result2] = await (await dbConnection).query(`SELECT rating FROM deliveryMen where personId=? `, [personId]);
    const rating = parseFloat(result2[0].rating) + parseFloat(req.body.rating) * 0.01;
    const [result3] = await (await dbConnection).query(`UPDATE deliveryMen SET rating=? WHERE personId=?`, [rating, personId]);
    res.status(200).json(result3);
});



const updateDeliveryManStatus = asyncHandelr(async (req, res, next) => {
    const { status } = req.body;
    const updateQuery = `
      UPDATE deliverymen
      SET status = ?
      WHERE deliveryManId = ?
    `;
    const [Table] = await (await dbConnection).query(updateQuery, [status, req.body.deliveryManId]);
    res.status(200).json({ message: 'Record updated successfully' });

});

const updateOrderData = asyncHandelr(async (req, res, next) => {
    const { deliveryStatus } = req.body;
    const checkItemQuery = 'SELECT * FROM orders WHERE orderId = ?';
    const updateQuery = `
      UPDATE orders
      SET deliveryManId = ?, deliveryStatus = ?
      WHERE orderId = ?
    `;

    const [checkItemResult] = await (await dbConnection).query(checkItemQuery, req.params.orderId);
    if (checkItemResult.length === 0) {
        return next(new ApiError({ message: 'Order not found' }, 404));
    }


    if (deliveryStatus == 4) {
        const [result2] = await (await dbConnection).query(`SELECT numberOfOrders FROM deliveryMen WHERE deliveryManId=? `, [req.body.deliveryManId]);
        const [result3] = await (await dbConnection).query(`UPDATE deliveryMen SET numberOfOrders=? WHERE deliveryManId=?`, [result2[0].numberOfOrders + 1, req.body.deliveryManId]);
    }

    const [Table] = await (await dbConnection).query(updateQuery, [req.body.deliveryManId, deliveryStatus, req.params.orderId]);

    res.status(200).json({ message: 'Order delivery process has started!' });

});

const editStatus = asyncHandelr(async (req, res, next) => {
    // const status = req.body.status;
    // const decoded = jwt.verify(req.headers.token, process.env.JWT_SECRETKEY);
    // req.person = decoded;
    // const personId = req.person.id;
    // const [result2] = await (await dbConnection).query(`UPDATE deliveryMen SET status=? WHERE personId=?`, [status, personId]);
    // res.status(200).json(result2);
});

const editNumberOfOrders = asyncHandelr(async (req, res, next) => {
    // const decoded = jwt.verify(req.headers.token, process.env.JWT_SECRETKEY);
    // req.person = decoded;
    // const personId = req.person.id;
    // const [result2] = await (await dbConnection).query(`SELECT numberOfOrders FROM deliveryMen where personId=? `, [personId]);
    // const numberOfOrders = result2[0].numberOfOrders + 1;
    // const [result3] = await (await dbConnection).query(`UPDATE deliveryMen SET numberOfOrders=? WHERE personId=?`, [numberOfOrders, personId]);
    // res.status(200).json(result3);
});
module.exports = {
    updateOrderData,
    updateDeliveryManStatus,
    editRating,
    editStatus,
    editNumberOfOrders
};