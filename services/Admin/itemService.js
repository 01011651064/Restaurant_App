const dbConnection = require("../../config/database");
const asyncHandelr = require("express-async-handler");
const ApiError = require("../../utils/apiError");
const jwt = require("jsonwebtoken");

const addItem = asyncHandelr(async (req, res, next) => {

    const { itemId, name, stock, description, rating, price, timesOrdered, firstImage, secondImage, categories } = req.body;
    const queryMenuItem = 'INSERT INTO menuitems (itemId, name, stock, description, rating, price, timesOrdered, firstImage, secondImage) VALUES (?, ?, ?, ?, ?, ?, ?, ?,?)';
    const addCategoryQuery = 'INSERT INTO categories_has_menuitems VALUES (?, ?)'

    const [result] = await (await dbConnection).query(queryMenuItem, [itemId, name, stock, description, rating, price, timesOrdered, firstImage, secondImage]);

    const jsonCategories = JSON.parse(categories);

    for (let i = 0; i < jsonCategories.length; i++) {
        const [result2] = await (await dbConnection).query(addCategoryQuery, [jsonCategories[i]['categoryId'], result.insertId]);
    }
    res.status(200).json({ message: 'Item added successfully' });
});

const sendItemPics = asyncHandelr(async (req, res, next) => {
    res.status(200).send({ message: 'Images sent Successfully' });
});


const deleteItem = asyncHandelr(async (req, res, next) => {

    const checkQuery = 'SELECT COUNT(*) AS count FROM menuitems WHERE itemId = ?';
    const deleteQuery = 'DELETE FROM menuitems WHERE itemId = ?';

    const [checkResult] =
        await (await dbConnection).query(checkQuery, [req.params.itemId]
        );

    if (checkResult[0].conut === 0) {
        return next(new ApiError(`Item not found`, 404));
    }

    const [deleteResult] =
        await (await dbConnection).query(deleteQuery, [req.params.itemId]);


    res.status(200).json({ message: 'Item deleted successfully' });
});


const updateItem = asyncHandelr(async (req, res, next) => {

    const { name, stock, description, rating, price, firstImage, secondImage, categories } = req.body;
    const checkItemQuery = 'SELECT * FROM menuitems WHERE itemId = ?';
    const addCategoryQuery = 'INSERT INTO categories_has_menuitems VALUES (?, ?)'
    const deleteCategoryQuery = 'DELETE FROM categories_has_menuitems WHERE categories_has_menuitems.itemId = ?'

    const updateQuery = `
      UPDATE menuitems
      SET name = ?, description = ?, rating = ?, price = ?, stock = ?, firstImage = ?, secondImage = ?
      WHERE itemId = ?
    `;

    const [checkResult] =
        await (await dbConnection).query(checkItemQuery, [req.params.itemId]
        );

    if (checkResult[0].conut === 0) {
        return next(new ApiError(`Item not found`, 404));
    }

    await (await dbConnection).query(updateQuery, [name, description, rating, price, stock, firstImage, secondImage, req.params.itemId]);
    await (await dbConnection).query(deleteCategoryQuery, [req.params.itemId]);

    const jsonCategories = JSON.parse(categories);

    for (let i = 0; i < jsonCategories.length; i++) {
        const [result2] = await (await dbConnection).query(addCategoryQuery, [jsonCategories[i]['categoryId'], req.params.itemId]);
    }

    res.status(200).json({ message: 'Item updated successfully' });

});


const getItemsWithFilter = asyncHandelr(async (req, res, next) => {
    const { ratingThreshold, maxPrice, minPrice, TimesThreshold } = req.body;
    const query = 'SELECT * FROM menuitems WHERE rating >= ? AND timesOrdered >= ? AND price BETWEEN ? AND ? ORDER BY menuitems.stock DESC';
    const categoryQuery = `SELECT categories.categoryId, categories.categoryName 
      FROM resto.categories_has_menuitems 
      INNER JOIN categories ON categories_has_menuitems.categoyId = categories.categoryId 
      WHERE categories_has_menuitems.itemId = ?;`;

    const maxprice = 'SELECT MAX(price) FROM menuitems';
    const maxOrdered = 'SELECT MAX(timesOrdered) FROM menuitems';

    const [menuItems] = await (await dbConnection).query(query, [ratingThreshold, TimesThreshold, minPrice, maxPrice])

    for (let i = 0; i < menuItems.length; i++) {
        const [categories] = await (await dbConnection).query(categoryQuery, [menuItems[i]['itemId']]);
        menuItems[i]['categories'] = categories;
    }

    const [maxPriceOrder] = await (await dbConnection).query(maxprice);
    res.appendHeader("maxPrice", maxPriceOrder[0]['MAX(price)']);

    const [maxTimesOrdered] = await (await dbConnection).query(maxOrdered);
    res.appendHeader("maxTimesOrdered", maxTimesOrdered[0]['MAX(timesOrdered)']);

    res.status(200).json(menuItems);
});


const searchItem = asyncHandelr(async (req, res, next) => {
    const query = `SELECT * FROM menuitems WHERE menuitems.name LIKE ?`;
    const [Table] = await (await dbConnection).query(query, `%${req.body.searchterm}%`);
    for (let i = 0; i < Table.length; i++) {
        Table[i]['categories'] = [];
    }
    res.status(200).json(Table);
});


module.exports = {
    addItem,
    sendItemPics,
    deleteItem,
    updateItem,
    getItemsWithFilter,
    searchItem,
}
