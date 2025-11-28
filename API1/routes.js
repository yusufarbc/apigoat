const express = require('express');
const router = express.Router();
const path = require('path');

const Account = require('./Account');
const File = require('./File');
const checkAuth = require('./check-auth');
const installer = require('./installer');

const bcrypt = require('bcrypt');
const mongoose = require('mongoose');
const jwt = require('jsonwebtoken');

// index endpoint runs installer.js
router.get('/', installer, (req, res, next) => {
    res.status(200);
    res.json({
        message:"API1 is working"
    });
});

// signup endpoint creates an account
router.post('/signup', (req, res, next) => {
    Account.find({email:req.body.email})
    .exec()
    .then( account=> {
        if (account.length >= 1) {
            return res.status(409).json({
                message: 'Mail Exist'
            });
        } else {
            bcrypt.hash(req.body.password, 10, (err, hash) => {
            
                if (err) {
                    return res.status(500).json({
                        message: "unexpected error",
                        error: err
                    });
        
                } else {
                    const account = new Account({_id: new mongoose.Types.ObjectId, name:req.body.name, email: req.body.email, password: hash});
                    
                    account
                    .save()
                    .then( (result) => {
                        res.status(201).json({
                            message: "auth succesfull",
                            result: result
                        });
                    })
                    .catch( (err) => {
                        res.status(500).json({
                            message: "error",
                            error: err
                        });
                    });
                }
            });
        }
    
    })
    .catch( (err) => {
        console.error(err);
        res.status(500).json({
            message:"unexpected error",
            error: err
        })
    })
});


// login endpoint gives a jwt token
router.post("/login", (req, res, next) => {
    Account.find({ email: req.body.email })
    .exec()
    .then( (accounts) => {
        if (accounts.length <1) {
            return res.status(404).json({
                message: 'Auth Failed - account does not exist'
            });
        } 
        bcrypt.compare(req.body.password, accounts[0].password, (err, result) => {
            if(err) {
                return res.status(401).json({
                    message: 'auth failed'
                });
            }

            if (result) {
                const token = jwt.sign({
                    email: accounts[0].email,
                    Id: accounts[0]._id
                }, process.env.JWT_KEY1, 
                {
                    expiresIn: "1h"
                })

                return res.status(200).json({
                    message: 'Auth succesfull',
                    token: token
                });
            }

            res.status(401).json({
                message: 'Auth failed'
            });
        })
    })
    .catch();
});



// Vulnerable endpoint for downloading files (Broken Authorization)
router.get('/files/:fileId', checkAuth, (req, res) => {
    const fileid = req.params.fileId;
    File.findOne({'number': fileid})
        .exec()
        .then(result => {
            if (result) {
               res.status(200).json({result}); 
            } else {
                res.status(404).json({message: 'No valid entry found for provided id'});
            }
        })
        .catch( err => {
            console.log(err);
            res.status(500).json({error:err});
        });
});

// Files endpoint: post request creates a file
router.post('/files',  (req, res, next) => {
    const file = new File({
        _id: new mongoose.Types.ObjectId(),
        name: req.body.name,
        content: req.body.content,
        path: req.body.path,
        number: req.body.id
    });
    file
        .save()
        .then(result => {
        //success call back
        console.log(result);
        res.status(201).json({
            message: 'files successfully created',
            creadtedProduct: result
        });
        })
        //error call back
        .catch(err => {
            console.log(err);
            res.status(500).json({
                error:err
            })
        });
});

//Files endpoint: delete request deletes a file
router.delete('/files/:filesId', checkAuth, (req, res, next) => {
    const id = req.params.filesId;
    File.deleteOne({ "number":id })
        .exec()
        .then(result => {
            console.log("success")
            console.log(res);
            res.status(200).json({result}); 
        })
        .catch( err => {
            console.log(err);
            res.status(500).json({error:err});
        });
});


module.exports = router;