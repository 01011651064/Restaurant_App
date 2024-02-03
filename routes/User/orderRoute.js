const express = require("express");
const { placeOrder, getOrdersFilter ,getOrderItems} = require("../../services/User/orderService");
const { verifyTokenAndAuthorization } = require("../../middlewares/verifyToken");
const router = express.Router();

router.post("/placeOrder", verifyTokenAndAuthorization, placeOrder);
router.get("/getOrdersFilter/:deliveryStatus", verifyTokenAndAuthorization, getOrdersFilter);
router.get("/getOrderItems/:orderId", verifyTokenAndAuthorization, getOrderItems);

module.exports = router;