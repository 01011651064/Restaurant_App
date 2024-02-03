const express = require("express");
const { verifyTokenAndAdmin } = require("../../middlewares/verifyToken");

const { addCategory, getCategories, deleteCategory } = require('../../services/Admin/categoryService');
const router = express.Router();

router.post("/addCategory", verifyTokenAndAdmin,addCategory);
router.get("/getCategories", verifyTokenAndAdmin,getCategories);
router.delete("/deleteCategory/:categoryId", verifyTokenAndAdmin,deleteCategory);
module.exports = router;