const dbConnection = require("../../config/database");
const asyncHandelr = require("express-async-handler");
const ApiError = require("../../utils/apiError");
const jwt = require("jsonwebtoken");

const addBooking = asyncHandelr(async (req, res, next) => {
    const { numOfPeople, tableNumber, date, startTime, endTime } = req.body;
    console.log(startTime);
    console.log(endTime);
    if ((startTime > '00:00' && startTime < '08:00') || (endTime > '00:00' && endTime < '08:00')) {
        return next(new ApiError("Resto is only open from 8:00 AM to 12:00 AM!", 400));
    }
    if (startTime > endTime) {
        return next(new ApiError("The time entered is incorrect!", 400));
    }
    const sql2 = (`SELECT tableNumber,startTime,endTime FROM bookings WHERE date='${date}' And tableNumber=${tableNumber} And startTime < '${endTime}' And  endTime > '${startTime}' order by startTime;`)
    const [conflictingBookings] = await (await dbConnection).query(sql2);

    if (conflictingBookings.length === 0) {
        const decoded = jwt.verify(req.headers.token, process.env.JWT_SECRETKEY);
        req.person = decoded;
        const [result] = await (await dbConnection).query(`SELECT customerId FROM customers where personId=? `, [req.person.id]);
        const customerId = result[0].customerId;
        const sql = 'INSERT INTO bookings (numberOfPeople,tableNumber,date,startTime,endTime,customerId) VALUES (?,?,?,?,?,?);'
        const Values = [numOfPeople, tableNumber, date, startTime, endTime, customerId];
        await (await dbConnection).query(sql, Values);
        res.status(200).send({ message: 'Table Has Been Booked!' });
    } else {
        res.status(400).json(conflictingBookings);
    }
});


const getCurrentBooking = asyncHandelr(async (req, res) => {
    var currentDateTime = new Date();
    var currentDate =
        currentDateTime.getFullYear() + "-" +
        ("00" + (currentDateTime.getMonth() + 1)).slice(-2) + "-" +
        ("00" + currentDateTime.getDate()).slice(-2);
    var currentTime =
        ("00" + currentDateTime.getHours()).slice(-2) + ":" +
        ("00" + currentDateTime.getMinutes()).slice(-2) + ":" +
        ("00" + currentDateTime.getSeconds()).slice(-2);
    const [result] = await (await dbConnection).query(`SELECT customerId FROM customers where personId = ? `, [req.person.id]);
    const sqlQuery = `SELECT  bookings.bookingId,
    bookings.numberOfPeople,
    bookings.tableNumber,
    bookings.date,
    bookings.startTime,
    bookings.endTime,
    bookings.customerId,
    persons.firstName,
    persons.lastName
    FROM bookings
    INNER JOIN customers ON bookings.customerId = customers.customerId 
    INNER JOIN persons ON persons.personId = customers.personId 
    WHERE bookings.customerId = ${result[0].customerId} AND (date >= '${currentDate}'  OR (endTime > '${currentTime}' AND date >= '${currentDate}')) order by startTime;`;
    const [bookings] = await (await dbConnection).query(sqlQuery)
    res.status(200).json(bookings)
});

const getByDate = asyncHandelr(async (req, res) => {
    const date = req.body.date;
    const sql = (`SELECT tableNumber,startTime,endTime FROM bookings WHERE date='${date}'order by startTime;`);
    const [bookings] = await (await dbConnection).query(sql)
    res.status(200).json(bookings)
});

const getAllBooking = asyncHandelr(async (req, res) => {
    const sql = (`SELECT * FROM bookings ORDER BY date,startTime;`);
    const [bookings] = await (await dbConnection).query(sql)
    res.status(200).json(bookings)
});

const getBusyTables = asyncHandelr(async (req, res) => {
    const { date, startTime, endTime } = req.body;
    var sql = (`SELECT tableNumber FROM bookings WHERE date='${date}' And startTime < '${endTime}' And  endTime > '${startTime}' order by startTime;`);
    const [busyTables] = await (await dbConnection).query(sql)
    // var numbers = []
    // for( i = 0; i <busyTables.length; i++ ){
    //     numbers.
    // }
    res.status(200).send(busyTables)
});

const deleteBooking = asyncHandelr(async (req, res, next) => {
    const { date, startTime, tableNumber } = req.body;
    const decoded = jwt.verify(req.headers.token, process.env.JWT_SECRETKEY);
    req.person = decoded;
    const [result] = await (await dbConnection).query(`SELECT customerId FROM customers where personId=? `, [req.person.id]);
    const customerId = result[0].customerId;
    var sql = (`DELETE from bookings WHERE customerId=${customerId} AND startTime='${startTime}' AND date ='${date}' AND tableNumber=${tableNumber};`)
    const [bookings] = await (await dbConnection).query(sql)
    if (bookings.affectedRows === 0) {
        return ApiError("there is no bookings with the entered details", 404);
    }
    else {
        res.status(200).json({ message: "Cancelation was Successfull" })
    }
});

module.exports = {

    addBooking,
    getCurrentBooking,
    getByDate,
    getAllBooking,
    getBusyTables,
    deleteBooking
}