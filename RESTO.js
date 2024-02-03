const express = require("express");
const dotenv = require("dotenv");
const cors = require("cors");
const logger = require("./middlewares/logger");


dotenv.config({ path: "config.env" });
process.env.TZ = process.env.TIMEZONE;
const ApiError = require("./utils/apiError");
const globalError = require("./middlewares/errorMiddleware");

const RESTO = express();

RESTO.use(express.json());
RESTO.use(express.urlencoded({ extended: true }));
RESTO.use(logger);

RESTO.use(cors({ exposedHeaders: ['maxPrice', 'maxTimesOrdered', 'maxNumberOfOrders'], }));
RESTO.use('/images', express.static(__dirname + '/images'));

RESTO.use("/api", require("./routes/userRoute"));
RESTO.use("/api", require("./routes/authRoute"));
RESTO.use("/api", require("./routes/User/catogeryRoute"));
RESTO.use("/api", require("./routes/User/menuRoute"));
RESTO.use("/api", require("./routes/User/deliveryManRoute"));
RESTO.use("/api", require("./routes/User/orderRoute"));
RESTO.use("/api", require("./routes/User/bookingRoute"));
RESTO.use("/api", require("./routes/User/favoritesRoute"));
RESTO.use("/admin", require("./routes/Admin/itemRoute"));
RESTO.use("/admin", require("./routes/Admin/categoryRoute"));
RESTO.use("/admin", require("./routes/Admin/overviewRoute"));
RESTO.use("/delivery", require("./routes/DeliveryMen/deliveryRoute"));
RESTO.use("/delivery", require("./routes/DeliveryMen/hardwareRoute"));



RESTO.all("*", (req, res, next) => {
    next(new ApiError(`Can't find this route ${req.originalUrl}`, 400));
});
RESTO.use(globalError);


const PORT = process.env.PORT;
const server = RESTO.listen(PORT, () => {
    console.log(`Server start in port ${PORT}`);
});

process.on("unhandledRejection", (err) => {
    console.log(`unhandledRejection Errors ${err.name} | ${err.message}`);
    server.close(() => {
        console.log("Shutting down......");
        process.exit(1);
    });
});


