const dbConnection = require("../../config/database");
const asyncHandelr = require("express-async-handler");
const ApiError = require("../../utils/apiError");
const jwt = require("jsonwebtoken");



const getUndeliverdOrders = asyncHandelr(async (req, res, next) => {
    const query = `SELECT orders.orderId, orders.deliveryStatus, orders.longitudeAddress, orders.latitudeAddress, orders.deliveryManId, orders.customerId, orders.dateOfOrder, orders.totalPrice, persons.firstName, persons.lastName 
    FROM orders 
    INNER JOIN customers 
    ON orders.customerId = customers.customerId 
    INNER JOIN persons 
    ON customers.personId = persons.personId 
    WHERE orders.deliveryStatus = 0 AND orders.deliveryManId IS NULL`;


    const [Table] = await (await dbConnection).query(query);
    res.status(200).json(Table);
});

const getTookOrder = asyncHandelr(async (req, res, next) => {

    const query = `
        SELECT orders.orderId, orders.deliveryStatus, orders.longitudeAddress, orders.latitudeAddress, orders.deliveryManId, orders.customerId, orders.dateOfOrder, orders.totalPrice, orders.confirmationNumber, persons.firstName, persons.lastName ,persons.phoneNumber 
        FROM orders 
        INNER JOIN customers 
        ON orders.customerId = customers.customerId 
        INNER JOIN persons 
        ON customers.personId = persons.personId 
        WHERE deliveryManId = ? AND ( deliveryStatus = 1 OR deliveryStatus = 2 OR deliveryStatus = 3 )`;
    const decoded = jwt.verify(req.headers.token, process.env.JWT_SECRETKEY);
    req.person = decoded;
    const [deliverymen] = await (await dbConnection).query(`SELECT deliveryManId FROM deliverymen WHERE personId = ?`, [req.person.id]);
    const [Table] = await (await dbConnection).query(query, deliverymen[0].deliveryManId);
    res.status(200).json(Table);
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

    const decoded = jwt.verify(req.headers.token, process.env.JWT_SECRETKEY);
    req.person = decoded;
    const [deliverymen] = await (await dbConnection).query(`SELECT deliveryManId FROM deliverymen WHERE personId = ?`, [req.person.id]);
    if (deliveryStatus == 4) {
        const [result2] = await (await dbConnection).query(`SELECT numberOfOrders FROM deliveryMen where personId=? `, [req.person.id]);
        const [result3] = await (await dbConnection).query(`UPDATE deliveryMen SET numberOfOrders=? WHERE personId=?`, [result2[0].numberOfOrders + 1, req.person.id]);
    }

    const [Table] = await (await dbConnection).query(updateQuery, [deliverymen[0].deliveryManId, deliveryStatus, req.params.orderId]);

    res.status(200).json({ message: 'Order delivery process has started!' });

});


const getOrderItems = asyncHandelr(async (req, res, next) => {
    const query = `
    SELECT menuitems.itemId, menuitems.name , menuitems.stock,menuitems.description, menuitems.rating, menuitems.price, menuitems.firstImage, orders_has_menuitems.quantity
    FROM menuitems 
    INNER JOIN orders_has_menuitems 
    ON menuitems.itemId = orders_has_menuitems.itemId 
    WHERE orders_has_menuitems.orderId = ?;`;


    const [Table] = await (await dbConnection).query(query, req.params.orderId);
    res.status(200).json(Table);

});


const updateDeliveryManStatus = asyncHandelr(async (req, res, next) => {
    const { status } = req.body;
    const updateQuery = `
      UPDATE deliverymen
      SET status = ?
      WHERE personId = ?
    `;
    const decoded = jwt.verify(req.headers.token, process.env.JWT_SECRETKEY);
    req.person = decoded;
    const [Table] = await (await dbConnection).query(updateQuery, [status, req.person.id]);
    res.status(200).json({ message: 'Record updated successfully' });

});

module.exports = {
    getUndeliverdOrders,
    getTookOrder,
    updateOrderData,
    getOrderItems,
    updateDeliveryManStatus
}
