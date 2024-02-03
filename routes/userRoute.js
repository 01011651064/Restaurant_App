const express = require("express");
const { getUser, changeEmail, changePassword, changeForgotPassword, forgotPassword, updateUser } = require('../services/userService');
const { verifyTokenAndAdmin, verifyTokenAndAuthorization } = require("../middlewares/verifyToken");

const router = express.Router();

router.get("/getUser", verifyTokenAndAuthorization, getUser);
router.put("/updateUser", verifyTokenAndAuthorization, updateUser);
router.put("/changeEmail", verifyTokenAndAuthorization, changeEmail);
router.put("/changePassword", verifyTokenAndAuthorization, changePassword);
router.put("/changeForgotPassword", changeForgotPassword);
router.post("/forgotPassword", forgotPassword);

module.exports = router;