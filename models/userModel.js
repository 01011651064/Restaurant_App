const Joi = require("joi");

const validateCreateUser = (obj) => {
    const shcema = Joi.object({
        firstName: Joi.string().trim().min(3).max(200).required(),
        lastName: Joi.string().trim().min(3).max(200).required(),
        email: Joi.string().trim().min(11).max(200).required(),
        password: Joi.string().trim().min(8).max(200).required(),
        birthDate: Joi.string().trim().min(6).max(200).required(),
        longitudeAddress: Joi.string().trim().max(200).required(),
        latitudeAddress: Joi.string().trim().max(200).required(),
        phoneNumber: Joi.string().trim().min(11).max(11).required(),
        type: Joi.string().trim().max(200).required(),
    });
    return shcema.validate(obj);
}

const validateLogineUser = (obj) => {
    const shcema = Joi.object({
        email: Joi.string().trim().min(11).max(200).required(),
        password: Joi.string().trim().min(8).max(200).required()
    });
    return shcema.validate(obj);
}


module.exports = {
    validateCreateUser,
    validateLogineUser
}