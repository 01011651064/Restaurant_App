
const dbConnection = require("../../config/database");
const asyncHandelr = require("express-async-handler");
const ApiError = require("../../utils/apiError");
const jwt = require("jsonwebtoken");

const getOrders = asyncHandelr(async (req, res, next) => {
  const { minPrice, maxPrice } = req.body;

  const query = `
    SELECT orders.orderId, orders.deliveryStatus, orders.longitudeAddress, orders.latitudeAddress, orders.deliveryManId, orders.customerId, orders.dateOfOrder, orders.totalPrice, persons.firstName, persons.lastName 
    FROM orders 
    INNER JOIN customers ON orders.customerId = customers.customerId INNER JOIN persons ON customers.personId = persons.personId 
    WHERE orders.totalPrice BETWEEN ? AND ?;`;
  const maxPriceQuery = 'SELECT MAX(totalPrice) FROM orders';

  const [maxPriceResult] = await (await dbConnection).query(maxPriceQuery);
  res.appendHeader("maxPrice", maxPriceResult[0]['MAX(totalPrice)']);
  const [Table] = await (await dbConnection).query(query, [minPrice, maxPrice]);
  res.status(200).json(Table);
});


const getOrdersFilterStatus = asyncHandelr(async (req, res, next) => {
  const query = `
    SELECT orders.orderId, orders.deliveryStatus, orders.longitudeAddress, orders.latitudeAddress, orders.deliveryManId, orders.customerId, orders.dateOfOrder, orders.totalPrice, persons.firstName, persons.lastName 
    FROM orders 
    INNER JOIN customers 
    ON orders.customerId = customers.customerId INNER JOIN persons ON customers.personId = persons.personId 
    WHERE orders.deliveryStatus = ? `;

  const [Table] = await (await dbConnection).query(query, req.params.deliveryStatus);

  res.status(200).json(Table);
});


const getOrdersNameFilter = asyncHandelr(async (req, res, next) => {
  const query = 'SELECT * FROM persons WHERE firstName LIKE ? ';
  const query2 = 'SELECT * FROM customers WHERE personId = ? ';
  const query3 = `
  SELECT orders.orderId, orders.deliveryStatus, orders.longitudeAddress, orders.latitudeAddress, orders.deliveryManId, orders.customerId, orders.dateOfOrder, orders.totalPrice, persons.firstName, persons.lastName 
  FROM orders 
  INNER JOIN customers 
  ON orders.customerId = customers.customerId INNER JOIN persons ON customers.personId = persons.personId 
  WHERE orders.customerId = ? `;

  const [Table] = await (await dbConnection).query(query, `%${req.params.name}%`);

  if (Table.length !== 0) {
    const [Table2] = await (await dbConnection).query(query2, Table[0].personId);
    const [Table3] = await (await dbConnection).query(query3, Table2[0].customerId);
    res.status(200).json(Table3);
  }
  else {
    return next(new ApiError(`Name not found`, 404));
  }

});


const getDeliveryMen = asyncHandelr(async (req, res, next) => {

  const query = `
    SELECT * FROM deliverymen 
    INNER JOIN persons ON deliverymen.personId = persons.personId WHERE numberOfOrders >= ?`;
  const maxNumberOfOrdersQuery = 'SELECT MAX(numberOfOrders) FROM deliverymen';

  const [maxNumberOfOrders] = await (await dbConnection).query(maxNumberOfOrdersQuery);
  res.appendHeader("maxnumberoforders", maxNumberOfOrders[0]['MAX(numberOfOrders)']);

  const [Table] = await (await dbConnection).query(query, req.params.maxNumberOfOrders);

  res.status(200).json(Table);

});

const getDeliveryMenFilterStatus = asyncHandelr(async (req, res, next) => {
  const query = ` SELECT * FROM deliverymen 
    INNER JOIN persons ON deliverymen.personId = persons.personId WHERE status = ?`;
  const [Table] = await (await dbConnection).query(query, req.params.status);
  res.status(200).json(Table);
});



const getBookings = asyncHandelr(async (req, res, next) => {
  const query = 'SELECT * FROM bookings';
  const [Table] = await (await dbConnection).query(query);
  res.status(200).json(Table);
});

const getBookingWithTableNumberFilter = asyncHandelr(async (req, res, next) => {
  const query = 'SELECT * FROM bookings WHERE tableNumber = ?';
  const [Table] = await (await dbConnection).query(query, req.params.TableNumber);
  res.status(200).json(Table);
});


const getBookingWithNumberOfPeopleFilter = asyncHandelr(async (req, res, next) => {
  const query = 'SELECT * FROM bookings WHERE numberOfPeople = ?';
  const [Table] = await (await dbConnection).query(query, req.params.NumberOfPeople);
  res.status(200).json(Table);
});


module.exports = {
  getOrders,
  getOrdersFilterStatus,
  getOrdersNameFilter,
  getDeliveryMen,
  getDeliveryMenFilterStatus,
  getBookings,
  getBookingWithTableNumberFilter,
  getBookingWithNumberOfPeopleFilter
}