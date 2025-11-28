const express = require('express');
const bodyParser = require("body-parser");
const path = require('path');
const dotenv = require("dotenv");

dotenv.config({ path:"../config.env" });


const app = express();

app.use(bodyParser.urlencoded({extended: false}));
app.use(bodyParser.json());


const routes = require('./routes');
app.use('/',routes);

//not found middleware
app.use((req, res, next) => {
    const error = new Error('Not Found');
    error.status = 404; 
    next(error);
});

// other error middleware
app.use((error, req, res, next) =>{
    res.status(error.status || 500);
    res.json({
        error: {
            message: error.message
        }
    });
});


app.listen(process.env.PORT_API9, ()=> {
    console.log("listening on port ",process.env.PORT_API9);
});

