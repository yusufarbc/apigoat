const jwt = require('jsonwebtoken');

/**
 * Generic JWT Authentication Middleware
 * @param {string} jwtKey - Environment variable name for JWT secret
 * @param {boolean} requireAuth - If false, always allows access (for vulnerable endpoints)
 */
module.exports = (jwtKey, requireAuth = true) => {
    return (req, res, next) => {
        // Vulnerable mode - bypass authentication
        if (!requireAuth) {
            return next();
        }

        try {
            // Extract token from Authorization header or body (body is vulnerable pattern)
            let token = req.body.token;
            
            // Check Authorization header (best practice)
            const authHeader = req.headers.authorization;
            if (authHeader && authHeader.startsWith('Bearer ')) {
                token = authHeader.split(' ')[1];
            }

            if (!token) {
                return res.status(401).json({
                    message: 'No token provided'
                });
            }

            // Verify token
            const decoded = jwt.verify(token, process.env[jwtKey]);
            req.userData = decoded;
            next();
        } catch (err) {
            return res.status(401).json({
                message: 'Auth Failed',
                error: err.message
            });
        }
    };
};
