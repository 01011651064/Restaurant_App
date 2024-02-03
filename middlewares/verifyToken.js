const jwt = require("jsonwebtoken");
const dbConnection = require("../config/database");

const verifyToken = (req, res, next) => {
    const token = req.headers.token;
    if (token) {
        try {
            const decoded = jwt.verify(token, process.env.JWT_SECRETKEY);
            req.person =decoded ;
            next();
        } catch {
            res.status(401).json({ message: "Invalid Token" });
        }
    } else {
        res.status(401).json({ message: "No Token Provided" });
    }
}

const verifyTokenAndAuthorization = (req, res, next) => {
    verifyToken(req, res, async () => {
        const [rows] = await (await dbConnection).query('SELECT personId FROM persons where personId=?', [req.person.id]);
        if (rows.length > 0) {
            if ((req.person.id == rows[0].personId) || (req.person.type === "admin")) {
                next();
            } else {
                return res.status(403).json({ message: "You Are Not Allowed" });
            }
        } else {
            return res.status(403).json({ message: "You Are Not Allowed" });
        }
    })
}


const verifyTokenDeliveryMan = (req, res, next) => {
    verifyToken(req, res, async () => {
        const [rows] = await (await dbConnection).query('SELECT personId FROM persons where personId=?', [req.person.id]);
        if (rows.length > 0) {
            if (((req.person.id == rows[0].personId) && (req.person.type === "deliveryman")) || (req.person.type === "admin")) {
                next();
            } else {
                return res.status(403).json({ message: "You Are Not Allowed:)" });
            }
        } else {
            return res.status(403).json({ message: "You Are Not Allowed" });
        }
    })
}

const verifyTokenAndAdmin = async (req, res, next) => {
    verifyToken(req, res, async () => {
        const [rows] = await (await dbConnection).query('SELECT personId FROM persons where personId=?', [req.person.id]);
        if (rows.length > 0) {
            if (req.person.type === "admin") {
                next();
            } else {
                return res.status(403).json({ message: "You Are Not Allowed, Only Admin" });
            }
        } else {
            return res.status(403).json({ message: "You Are Not Allowed" });
        }
    })
}

module.exports = {
    verifyTokenAndAuthorization,
    verifyTokenAndAdmin,
    verifyTokenDeliveryMan
}