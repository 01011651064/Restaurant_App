const dbConnection = require("../../config/database");
const asyncHandelr = require("express-async-handler");
const ApiError = require("../../utils/apiError");
const jwt = require("jsonwebtoken");


const addCategory = asyncHandelr(async (req, res, next) => {
    const { categoryName } = req.body;

    const checkQuery = 'SELECT COUNT(*) AS count FROM categories';
    const insertQuery = 'INSERT INTO categories (categoryId,categoryName) VALUES (?, ?)';
    const [checkResult] = await (await dbConnection).query(checkQuery);

    console.log(checkResult[0].count);

    if (checkResult[0].count < 5) {
        await (await dbConnection).query(insertQuery, [null, categoryName]);
        res.status(200).json({ message: 'Category added successfully' });
    }
    else {
        res.status(200).json({ message: 'Cant have more than 5 catagories' });
    }

});

const getCategories = asyncHandelr(async (req, res, next) => {
    const query = 'SELECT * FROM categories';

    const [result] = await (await dbConnection).query(query);

    res.status(200).json(result);
});

const deleteCategory = asyncHandelr(async (req, res, next) => {

    const checkQuery = 'SELECT COUNT(*) AS count FROM categories WHERE categoryId = ?';
    const deleteQuery = 'DELETE FROM categories WHERE categoryId = ?';
    const [checkResult] = await (await dbConnection).query(checkQuery, req.params.categoryId);


    if (checkResult[0].count > 0) {
        await (await dbConnection).query(deleteQuery, req.params.categoryId);
        res.status(200).json({ message: 'Category deleted successfully' });
    } else {
        return next(new ApiError(`Category not found`, 404));
    }
});



module.exports = {

    addCategory,
    getCategories,
    deleteCategory,

}
