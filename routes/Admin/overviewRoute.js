const express = require("express");
const { verifyTokenAndAdmin } = require("../../middlewares/verifyToken");

const {
    getOrders,
    getOrdersFilterStatus,
    getOrdersNameFilter,
    getDeliveryMen,
    getDeliveryMenFilterStatus,
    getBookings,
    getBookingWithTableNumberFilter,
    getBookingWithNumberOfPeopleFilter, } = require('../../services/Admin/overviewService');
const router = express.Router();

router.post("/getOrders", verifyTokenAndAdmin, getOrders);
router.get("/getOrdersFilterStatus/:deliveryStatus", verifyTokenAndAdmin, getOrdersFilterStatus);
router.get("/getOrdersNameFilter/:name", verifyTokenAndAdmin, getOrdersNameFilter);

router.get("/getDeliveryMen/:maxNumberOfOrders", verifyTokenAndAdmin, getDeliveryMen);
router.get("/getDeliveryMenFilterStatus/:status", verifyTokenAndAdmin, getDeliveryMenFilterStatus);
router.get("/getBookings", verifyTokenAndAdmin, getBookings);

router.get("/getBookingWithTableNumberFilter/:TableNumber", verifyTokenAndAdmin, getBookingWithTableNumberFilter);
router.get("/getBookingWithNumberOfPeopleFilter/:NumberOfPeople", verifyTokenAndAdmin, getBookingWithNumberOfPeopleFilter);
module.exports = router;