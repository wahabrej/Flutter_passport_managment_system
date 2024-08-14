const mongoose = require('mongoose');
const Schema = mongoose.Schema;

// Define the schema with all required fields
const userSchema = new Schema({
    firstName: { type: String, required: true },
    lastName: { type: String, required: true },
    dob: { type: String, required: true }, // Consider using Date type if appropriate
    phone: { type: String, required: true },
    nid: { type: String, required: true },
    email: { type: String, required: true, unique: true },
    password: { type: String, required: true },
    role: { type: String, required: true }

});

// Create and export the model based on the schema
module.exports = mongoose.model('User', userSchema);
