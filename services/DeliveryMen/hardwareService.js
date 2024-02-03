const dbConnection = require("../../config/database");
const asyncHandelr = require("express-async-handler");

const getOrderConfrimationNumber = asyncHandelr(async (req, res, next) => {

    const query = `
        SELECT orders.confirmationNumber
        FROM orders 
        WHERE deliveryManId = ? AND deliveryStatus = 3`;

    const [Table] = await (await dbConnection).query(query, req.params.id);
    res.status(200).json(Table[0].confirmationNumber);
});


module.exports = {
    getOrderConfrimationNumber
}
