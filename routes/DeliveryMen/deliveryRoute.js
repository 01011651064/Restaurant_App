const express = require("express");
const { getUndeliverdOrders, getTookOrder, updateOrderData, getOrderItems, updateDeliveryManStatus } = require("../../services/DeliveryMen/deliveryService");
const { verifyTokenDeliveryMan } = require("../../middlewares/verifyToken");
const router = express.Router();


router.get("/getUndeliverdOrders", verifyTokenDeliveryMan, getUndeliverdOrders);
router.get("/getTookOrder", verifyTokenDeliveryMan, getTookOrder);
router.put("/updateOrderData/:orderId", verifyTokenDeliveryMan, updateOrderData);
router.get("/getOrderItems/:orderId", verifyTokenDeliveryMan, getOrderItems);
router.put("/updateDeliveryManStatus", verifyTokenDeliveryMan, updateDeliveryManStatus);
module.exports = router;