const dbConnection = require("../../config/database");
const asyncHandelr = require("express-async-handler");
const jwt = require("jsonwebtoken");
const ApiError = require("../../utils/apiError");

const placeOrder = asyncHandelr(async (req, res, next) => {
    const { longitudeAddress, latitudeAddress, itemsListString } = req.body;
    var itemsList = JSON.parse(itemsListString);
    var totalPrice = 0;
    var items = [];
    for (var i = 0; i < itemsList.length; i++) {
        items[i] = itemsList[i].itemId;
    }
    const [result1] = await (await dbConnection).query(`SELECT itemId,timesOrdered,stock,price FROM menuitems WHERE itemId IN (?)`, [items]);
    
    for (var i = 0; i < itemsList.length; i++) {
        for (var j = 0; j < result1.length; j++) {
            if (result1[j].itemId === itemsList[i].itemId) {
                totalPrice += result1[j].price * itemsList[i].quantity;
                if(result1[j].stock != 0){
                    await (await dbConnection).query(`UPDATE menuitems SET timesOrdered = ? WHERE itemId = ?`, [result1[j].timesOrdered + itemsList[i].quantity, result1[j].itemId]);
                    await (await dbConnection).query(`UPDATE menuitems SET stock = ? WHERE itemId = ?`, [result1[j].stock - itemsList[i].quantity, result1[j].itemId]);
                }
                else{
                    return (new ApiError("Item Not out of stdock",404));
                }
                
            }
        }
    }
    const decoded = jwt.verify(req.headers.token, process.env.JWT_SECRETKEY);
    req.person = decoded;
    const [result2] = await (await dbConnection).query(`SELECT customerId FROM customers WHERE personId=?`, [req.person.id]);
    const [result3] = await (await dbConnection).query(`INSERT INTO orders (longitudeAddress,latitudeAddress,customerId,totalPrice) VALUES (?,?,?,?)`, [longitudeAddress, latitudeAddress, result2[0].customerId, totalPrice]);
    const [result4] = await (await dbConnection).query(`SELECT MAX(orderId) AS orderId FROM orders`);
    for (var i = 0; i < itemsList.length; i++) {

        const [result2] = await (await dbConnection).query(`INSERT INTO orders_has_menuitems VALUES (?,?,?)`, [result4[0].orderId, itemsList[i].itemId, itemsList[i].quantity]);
    }
    res.status(200).json({ message: 'Order Placed!' });
});





const getOrdersFilter = asyncHandelr(async (req, res, next) => {
    const query = `
      SELECT orders.orderId, orders.deliveryStatus, orders.longitudeAddress, orders.latitudeAddress, orders.deliveryManId, orders.customerId, orders.dateOfOrder, orders.totalPrice, persons.firstName, persons.lastName , orders.confirmationNumber
      FROM orders 
      INNER JOIN customers 
      ON orders.customerId = customers.customerId INNER JOIN persons ON customers.personId = persons.personId 
      WHERE orders.deliveryStatus = ? AND orders.customerId = ?;`;
    const query2 = `
      SELECT orders.orderId, orders.deliveryStatus, orders.longitudeAddress, orders.latitudeAddress, orders.deliveryManId, orders.customerId, orders.dateOfOrder, orders.totalPrice, persons.firstName, persons.lastName , orders.confirmationNumber
      FROM orders 
      INNER JOIN customers 
      ON orders.customerId = customers.customerId INNER JOIN persons ON customers.personId = persons.personId 
      WHERE orders.deliveryStatus <= ? AND orders.customerId = ?;`;

    const decoded = jwt.verify(req.headers.token, process.env.JWT_SECRETKEY);
    req.person = decoded;
    const [customer] = await (await dbConnection).query(`SELECT customerId FROM customers WHERE personId = ?`, [req.person.id]);
    if (req.params.deliveryStatus == 4) {
        const [Table] = await (await dbConnection).query(query, [req.params.deliveryStatus, customer[0].customerId]);
        res.status(200).json(Table);
    } else {
        const [Table] = await (await dbConnection).query(query2, [req.params.deliveryStatus, customer[0].customerId]);
        res.status(200).json(Table);
    }

});


const getOrderItems = asyncHandelr(async (req, res, next) => {
    const query = `
    SELECT menuitems.itemId, menuitems.name , menuitems.stock,menuitems.description, menuitems.rating, menuitems.price, menuitems.firstImage, menuitems.secondImage, orders_has_menuitems.quantity
    FROM menuitems 
    INNER JOIN orders_has_menuitems 
    ON menuitems.itemId = orders_has_menuitems.itemId 
    WHERE orders_has_menuitems.orderId = ?;`;

    const [Table] = await (await dbConnection).query(query, req.params.orderId);
    res.status(200).json(Table);
});



module.exports = {
    placeOrder,
    getOrdersFilter,
    getOrderItems
}