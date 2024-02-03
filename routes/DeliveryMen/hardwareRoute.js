const express = require("express");
const { getOrderConfrimationNumber } = require("../../services/DeliveryMen/hardwareService");
const router = express.Router();


router.get("/getOrderConfrimationNumber/:id", getOrderConfrimationNumber);

module.exports = router;