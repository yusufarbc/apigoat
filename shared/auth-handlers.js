const bcrypt = require('bcrypt');
const mongoose = require('mongoose');
const jwt = require('jsonwebtoken');

/**
 * Generic signup handler
 * @param {Model} AccountModel - Mongoose model for accounts
 * @param {Object} options - Configuration options
 */
const handleSignup = (AccountModel, options = {}) => {
    return async (req, res, next) => {
        try {
            const { email, password, name } = req.body;

            // Check if account exists
            const existingAccount = await AccountModel.findOne({ email });
            if (existingAccount) {
                return res.status(409).json({
                    message: 'Mail Exist'
                });
            }

            // Hash password
            const hash = await bcrypt.hash(password, 10);

            // Create account with additional fields from options
            const accountData = {
                _id: new mongoose.Types.ObjectId(),
                name,
                email,
                password: hash,
                ...options.additionalFields
            };

            // Add dynamic fields from request if specified
            if (options.allowedFields) {
                options.allowedFields.forEach(field => {
                    if (req.body[field] !== undefined) {
                        accountData[field] = req.body[field];
                    }
                });
            }

            const account = new AccountModel(accountData);
            const result = await account.save();

            res.status(201).json({
                message: 'auth successful',
                result: result
            });
        } catch (err) {
            console.error(err);
            res.status(500).json({
                message: 'unexpected error',
                error: err.message
            });
        }
    };
};

/**
 * Generic login handler
 * @param {Model} AccountModel - Mongoose model for accounts
 * @param {string} jwtKey - Environment variable name for JWT secret
 * @param {Object} options - Configuration options
 */
const handleLogin = (AccountModel, jwtKey, options = {}) => {
    return async (req, res, next) => {
        try {
            const { email, password } = req.body;

            // Find account
            const accounts = await AccountModel.find({ email });
            if (accounts.length < 1) {
                return res.status(404).json({
                    message: 'Auth Failed'
                });
            }

            // Compare password
            const result = await bcrypt.compare(password, accounts[0].password);
            if (!result) {
                return res.status(401).json({
                    message: 'Auth failed'
                });
            }

            // Create token payload
            const payload = {
                email: accounts[0].email,
                Id: accounts[0]._id
            };

            // Add additional fields to token if specified
            if (options.tokenFields) {
                options.tokenFields.forEach(field => {
                    if (accounts[0][field] !== undefined) {
                        payload[field] = accounts[0][field];
                    }
                });
            }

            // Generate token
            const token = jwt.sign(payload, process.env[jwtKey], {
                expiresIn: options.expiresIn || "1h"
            });

            return res.status(200).json({
                message: 'Auth successful',
                token: token
            });
        } catch (err) {
            console.error(err);
            return res.status(500).json({
                message: 'unexpected error',
                error: err.message
            });
        }
    };
};

module.exports = {
    handleSignup,
    handleLogin
};
