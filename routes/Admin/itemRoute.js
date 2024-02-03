const express = require("express");
const { verifyTokenAndAdmin, verifyTokenAndAuthorization } = require("../../middlewares/verifyToken");

const {
    addItem,
    sendItemPics,
    deleteItem,
    updateItem,
    getItemsWithFilter,
    searchItem, } = require('../../services/Admin/itemService');

const multer = require('multer');
const storage = multer.diskStorage({
    destination: (req, file, cb) => {

        cb(null, './images')
    },
    filename: (req, file, cb) => {

        cb(null, file.originalname)
    }
})
const upload = multer({ storage: storage })
const router = express.Router();

router.post("/addItem", verifyTokenAndAdmin ,addItem);
router.post("/sendItemPics", upload.array('file'), sendItemPics);
router.delete('/deleteItem/:itemId', verifyTokenAndAdmin,deleteItem)
router.put('/updateItem/:itemId', verifyTokenAndAdmin,updateItem)
router.post("/getItemsWithFilter", verifyTokenAndAdmin,getItemsWithFilter);
router.post("/searchItem",searchItem);
module.exports = router;