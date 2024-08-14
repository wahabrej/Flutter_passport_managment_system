const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const applicationSchema = new Schema({
    personalInfo: {
        nationalId: {
            type: String,
            required: true
        },
        birthCertificate: {
            type: String,
            required: true
        },
        citizenship: {
            type: String,
            required: true
        },
        dualCitizenship: {
            type: String,
            required: true
        },
        otherCitizenshipCountry: {
            type: String,
            required: true
        },
        foreignPassportNo: {
            type: String,
            required: true
        },
        maritalStatus: {
            type: String,
            required: true
        },
        profession: {
            type: String,
            required: true
        },
        contactNo: {
            type: String,
            required: true
        },
        email: {
            type: String,
            required: true
        },
    },
    permanentAddress: {
        district: {
            type: String,
            required: true
        },
        policeStation: {
            type: String,
            required: true
        },
        postOffice: {
            type: String,
            required: true
        },
        postCode: {
            type: String,
            required: true
        },
        city: {
            type: String,
            required: true
        },
        road: {
            type: String,
            required: true
        },
    },
    presentAddress: {
        district: {
            type: String,
            required: true
        },
        policeStation: {
            type: String,
            required: true
        },
        postOffice: {
            type: String,
            required: true
        },
        postCode: {
            type: String,
            required: true
        },
        city: {
            type: String,
            required: true
        },
        road: {
            type: String,
            required: true
        },
    }
}, {
    timestamps: true // Automatically adds createdAt and updatedAt fields
});

module.exports = mongoose.model('Application', applicationSchema);
