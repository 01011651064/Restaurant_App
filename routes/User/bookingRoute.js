const express = require("express");
const { addBooking,getCurrentBooking, getAllBooking, getByDate, getBusyTables, deleteBooking } = require("../../services/User/bookingService");
const { verifyTokenAndAuthorization } = require("../../middlewares/verifyToken");

const router = express.Router();

router.post("/addBooking", verifyTokenAndAuthorization, addBooking);
router.get("/getCurrentBooking", verifyTokenAndAuthorization, getCurrentBooking);
router.post("/getByDate", verifyTokenAndAuthorization, getByDate);
router.get("/getAllBooking", verifyTokenAndAuthorization, getAllBooking);
router.post("/getBusyTables", verifyTokenAndAuthorization, getBusyTables);
router.delete("/deleteBooking", verifyTokenAndAuthorization, deleteBooking);

module.exports = router;