const express = require('express');
const Application = require('../models/application.model');
const router = express.Router();

router.post('/application', (req, res) => {
    const { 
        personalInfo: {
            nationalId,
            birthCertificate,
            citizenship,
            dualCitizenship,
            otherCitizenshipCountry,
            foreignPassportNo,
            maritalStatus,
            profession,
            contactNo,
            email
        },
        permanentAddress: {
            district: permanentDistrict,
            policeStation: permanentPoliceStation,
            postOffice: permanentPostOffice,
            postCode: permanentPostCode,
            city: permanentCity,
            road: permanentRoad
        },
        presentAddress: {
            district: presentDistrict,
            policeStation: presentPoliceStation,
            postOffice: presentPostOffice,
            postCode: presentPostCode,
            city: presentCity,
            road: presentRoad
        }
    } = req.body;

    // Basic validation
    if (
        !nationalId || !birthCertificate || !citizenship || !dualCitizenship || !otherCitizenshipCountry ||
        !foreignPassportNo || !maritalStatus || !profession || !contactNo || !email ||
        !permanentDistrict || !permanentPoliceStation || !permanentPostOffice || !permanentPostCode || !permanentCity || !permanentRoad ||
        !presentDistrict || !presentPoliceStation || !presentPostOffice || !presentPostCode || !presentCity || !presentRoad
    ) {
        return res.status(400).json({ error: "All fields are required" });
    }

    const application = new Application({
        personalInfo: {
            nationalId,
            birthCertificate,
            citizenship,
            dualCitizenship,
            otherCitizenshipCountry,
            foreignPassportNo,
            maritalStatus,
            profession,
            contactNo,
            email
        },
        permanentAddress: {
            district: permanentDistrict,
            policeStation: permanentPoliceStation,
            postOffice: permanentPostOffice,
            postCode: permanentPostCode,
            city: permanentCity,
            road: permanentRoad
        },
        presentAddress: {
            district: presentDistrict,
            policeStation: presentPoliceStation,
            postOffice: presentPostOffice,
            postCode: presentPostCode,
            city: presentCity,
            road: presentRoad
        }
    });

    application.save()
        .then(application => {
            console.log(application);
            res.status(200).json(application); // Send status 201 for a successful creation
        })
        .catch(err => {
            console.error(err);
            res.status(500).json({ error: "Failed to save the application" }); // Send status 500 for server errors
        });
});

module.exports = router;
