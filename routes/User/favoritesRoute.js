const express = require("express");
const { addFavorite, deleteFavorite, getAllFavorites } = require("../../services/User/favoritesService");
const { verifyTokenAndAuthorization } = require("../../middlewares/verifyToken");
const router = express.Router();

router.post("/addFavorite/:itemId", verifyTokenAndAuthorization, addFavorite);
router.get("/getAllFavorites", verifyTokenAndAuthorization, getAllFavorites);
router.delete("/deleteFavorite/:itemId", verifyTokenAndAuthorization, deleteFavorite);


module.exports = router;