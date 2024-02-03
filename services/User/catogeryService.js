
const dbConnection = require("../../config/database");
const asyncHandelr = require("express-async-handler");
const ApiError = require("../../utils/apiError");

const getAllCategories = asyncHandelr(async (req, res, next) => {
    const [result] = await (await dbConnection).query("SELECT * FROM categories ORDER BY categoryId");
    // if (result.length === 0) {
    //     return next(new ApiError(`No categories Found`, 404));
    // }
    res.status(200).json(result);
});

module.exports = {
    getAllCategories
};