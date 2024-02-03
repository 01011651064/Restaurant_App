var fs = require('fs');
var util = require('util');
var log_file = fs.createWriteStream(__dirname + '/errors.log', { flags: 'a' });

debugLog = function (d) { //
    log_file.write(Date().toString() + '\n' + util.format(d) + '\n');
};

const globalError = (err, req, res, next) => {
    err.statusCode = err.statusCode || 500;
    err.status = err.status || "error";
    if (process.env.NODE_ENV === "development") {
        sendErrorForDev(err, res);
    } else {
        sendErrorForProd(err, res);
    }
};


const sendErrorForDev = (err, res) => {
    debugLog({
        status: err.status,
        err: err,
        message: err.message,
        stack: err.stack
    })
    console.error("\x1b[31m", err.message, "\x1b[0m");

    return res.status(err.statusCode).json({
        status: err.status,
        err: err,
        message: err.message,
        stack: err.stack
    });
};
const sendErrorForProd = (err, res) => {
    return res.status(err.statusCode).json({
        status: err.status,
        message: err.message,
    });
};

module.exports = globalError;