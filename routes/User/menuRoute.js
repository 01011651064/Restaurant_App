const express = require("express");
const { getAllItems, getItemByCategory, getMostPopularItems, getRandomItems } = require("../../services/User/menuService");
const { verifyTokenAndAuthorization } = require("../../middlewares/verifyToken");

const router = express.Router();

router.get("/getAllItems", verifyTokenAndAuthorization, getAllItems);
router.get("/getMostPopularItems", verifyTokenAndAuthorization, getMostPopularItems);
router.get("/getItemByCategory/:id", verifyTokenAndAuthorization, getItemByCategory);
router.get("/getRandomItems", verifyTokenAndAuthorization, getRandomItems);
module.exports = router;