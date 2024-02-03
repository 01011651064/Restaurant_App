const asyncHandelr = require("express-async-handler");
const jwt = require("jsonwebtoken");
const bcrypt = require("bcrypt");
const dbConnection = require("../config/database");
const ApiError = require("../utils/apiError");
const { validateCreateUser, validateLogineUser } = require("../models/userModel");

async function hashPassword(pass) {
    const saltRounds = 10;
    const hashedPassword = await new Promise((resolve, reject) => {
        bcrypt.hash(pass, saltRounds, function (err, hash) {
            if (err) reject(err)
            resolve(hash)
        });
    })
    return hashedPassword
}


async function comparePassword(plainPass, hashword) {
    const result = await new Promise((resolve, reject) => {
        bcrypt.compare(plainPass, hashword, function (err, isPasswordMatch) {
            if (err) reject(err)
            resolve(isPasswordMatch)
        });
    })
    return result
}


const register = asyncHandelr(async (req, res, next) => {
    let personId;
    let Id;
    const { error } = validateCreateUser(req.body);
    if (error) {
        return next(new ApiError(error.details[0].message, 400));
    }
    const [result1] = await (await dbConnection).query('SELECT * FROM persons where email = ?', [req.body.email]);
    if (result1.length !== 0) {
        return next(new ApiError(`Wrong Email Or Password`, 404));
    }
    const {
        firstName, lastName,
        email, password, birthDate,
        longitudeAddress, latitudeAddress,
        phoneNumber, type } = req.body;
    const hashedPassword = await hashPassword(password);

    const [result2] = await (await dbConnection).query(`INSERT INTO persons
        (firstName,lastName,email,password,birthDate,longitudeAddress,latitudeAddress,phoneNumber,type)
        VALUES(?,?,?,?,?,?,?,?,?)`,
        [firstName, lastName, email, hashedPassword, birthDate, longitudeAddress, latitudeAddress, phoneNumber, type]);

    const [result3] = await (await dbConnection).query('SELECT personId FROM persons where email = ?', [email]);
    personId = result3[0].personId;

    if (type === "admin") {
        Id = personId;
    } else if (type === "customer") {
        const [result] = await (await dbConnection).query(`INSERT INTO customers (personId) VALUES (?)`, [personId]);
        Id = result.insertId;
    } else if (type === "deliveryman") {
        const [result] = await (await dbConnection).query(`INSERT INTO deliverymen (personId) VALUES (?)`, [personId]);
        Id = result.insertId;
    }

    const token = jwt.sign({ id: personId, type: type }, process.env.JWT_SECRETKEY, {
        expiresIn: "90d"
    });

    res.json({ token: token, type: type, Id: Id });
}
);

const login = asyncHandelr(async (req, res, next) => {
    let Id;
    const { error } = validateLogineUser(req.body);
    if (error) {
        return next(new ApiError(error.details[0].message, 400));
    }
    const [result] = await (await dbConnection).query('SELECT * FROM persons where email = ?', [req.body.email]);
    if (result.length === 0) {
        return next(new ApiError(`Wrong Email Or Password`, 404));
    }

    const passwordMatch = await comparePassword(req.body.password, result[0].password);

    if (!passwordMatch) {
        return next(new ApiError(`Wrong Email Or Password`, 404));
    }
    if (result[0].type === 'admin') {
        Id = result[0].personId;
    }
    if (result[0].type === 'customer') {
        const [result0] = await (await dbConnection).query('SELECT customerId FROM customers WHERE personId = ?', [result[0].personId]);
        Id = result0[0].customerId;
    }
    if (result[0].type === 'deliveryman') {
        const [result0] = await (await dbConnection).query('SELECT deliveryManId FROM deliverymen WHERE personId = ?', [result[0].personId]);
        Id = result0[0].deliveryManId;
    }
    const token = jwt.sign({ id: result[0].personId, type: result[0].type }, process.env.JWT_SECRETKEY, {
        expiresIn: "90d"
    });
    res.json({ token: token, type: result[0].type, Id: Id });
}
);

module.exports = {
    register,
    login
};