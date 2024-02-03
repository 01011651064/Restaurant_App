const nodemailer = require('nodemailer');

const sendEmail = (email, subject, message) => {
    const transporter = nodemailer.createTransport({
        service: "gmail",
        auth: {
            user: "mg8846903@gmail.com",
            pass: "bpxfalwtnqildldt"
        }
    });
    const mailOption = {
        from: "mg8846903@gmail.com",
        to: email,
        subject: subject,
        html: `
        <div>
            <h1>${message}</h1>
        </div>`
    };
    transporter.sendMail(mailOption, (error, success) => {
        if (error) {
            console.log(error);
        } else {
            console.log("Email sent : " + success.response);
        }
    });
};

module.exports = sendEmail;