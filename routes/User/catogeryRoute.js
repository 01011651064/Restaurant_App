const express = require("express");
const { getAllCategories } = require("../../services/User/catogeryService");
const { verifyTokenAndAuthorization } = require("../../middlewares/verifyToken");

const router = express.Router();

router.get("/getAllCategories", verifyTokenAndAuthorization, getAllCategories);

module.exports = router;