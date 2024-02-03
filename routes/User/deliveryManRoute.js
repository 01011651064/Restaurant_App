const express = require("express");
const { editRating, editStatus, editNumberOfOrders, updateDeliveryManStatus, updateOrderData } = require("../../services/User/deliveryManService");
const { verifyTokenAndAuthorization, verifyTokenDeliveryMan } = require("../../middlewares/verifyToken");

const router = express.Router();

router.put("/editRating", verifyTokenAndAuthorization, editRating);
router.put("/editStatus", verifyTokenAndAuthorization, editStatus);
router.put("/editNumberOfOrders", verifyTokenAndAuthorization, editNumberOfOrders);

router.put("/updateDeliveryManStatus", verifyTokenAndAuthorization, updateDeliveryManStatus);
router.put("/updateOrderData/:orderId", verifyTokenAndAuthorization, updateOrderData);
module.exports = router;