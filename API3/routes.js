const express = require('express');
const router = express.Router();
const path = require('path');
const installer = require('./installer');
const checkAuth = require('./check-auth');
const Account = require('./Account');
const mongoose = require('mongoose');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

// index endpoint runs installer.js
router.get('/', installer, (req, res, next) => {
    res.status(200);
    res.json({
        message:"API3 is working"
    });
});

// Require admin priveleged, list users 
router.get('/users', checkAuth, (req, res, next) => {
    isAdmin = req.userData.isAdmin;
    if (!isAdmin) {
    return res.status(403).send('Forbidden');
    }
    else {
        Account.find({}).
        then( (result => {
        result = JSON.stringify(result);
        return res.status(200).json(result)
      }))
      .catch( (err) => {
        return res.status(500).json({error:err});
      })
  }
});

// Require only authantication not admin privileges
router.get('/users/:userId', checkAuth, (req, res, next) => {
  const userId = req.params.userId;
  
  Account.findById(userId)
    .exec()
    .then(user => {
      if (!user) {
        return res.status(404).json({message: 'User not found'});
      }
      // Return all user properties regardless of permissions! (Vulnerable)
      res.status(200).json({user: user});
    })
    .catch(err => {
      console.error(err);
      res.status(500).json({error: err});
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
                  const account = new Account({_id: new mongoose.Types.ObjectId, name:req.body.name, isAdmin:req.body.isAdmin, email: req.body.email, password: hash, posts: req.body.posts});
                  
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
                  isAdmin: accounts[0].isAdmin
              }, process.env.JWT_KEY3, 
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


module.exports = router;