const express = require('express');
const router = express.Router();
const path = require('path');
const mongoose = require('mongoose');

const Book = require('./book');
const installer = require('./installer');
const checkAuth = require('./check-auth');

//index endpoint: runs installer
router.get('/', installer, (req, res, next) => {
    res.status(200);
    res.json({
        message:"API5 is working"
    });
});

//books endpoit: gets all books
router.get('/books', (req, res, next) => {
    Book
        .find()
        .select('name author')
        .exec()
        .then(result=>{
            console.log(result);
            if (result.length >= 0){
                res.status(200).json({
                    count: result.length,
                    books: result
                });
            } else {
                res.status(404).json({
                    
                    message: 'No entires found'
                })
            } 
        })
        .catch(err=>{
            console.log(err);
            res.status(500).json({
                error:err
            });
        });
});

//books endpoint: create a book
router.post('/books', checkAuth,  (req, res, next) => {
    console.log("request to product")
    const book = new Book({
        _id: new mongoose.Types.ObjectId(),
        name: req.body.name,
        author: req.body.author
    });
    book
        .save()
        .then(result => {
        //success call back
        console.log(result);
        res.status(201).json({
            message: 'book successfully created',
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

//books endpoint: gets a book
router.get('/books/:bookId', (req, res, next) => {
    const id = req.params.bookId;
    Book.findById(id)
        .exec()
        .then(doc => {
            console.log(doc);
            if (doc) {
               res.status(200).json({book: doc}); 
            } else {
                res.status(404).json({message: 'No valid entry found for provided id'});
            }
            
        })
        .catch( err => {
            console.log(err);
            res.status(500).json({error:err});
        });
});

//books endpoint: patchs a boook
router.patch('/books/:bookId', (req, res, next) => {
    console.log("patch book request")
    const id = req.params.bookId;
    const updateOps = {};
    for (const ops of req.body){
        updateOps[ops.propName] = ops.value;
    }
    Book.updateOne({ _id:id }, { $set: updateOps})
    .exec()
    .then(result => {
        console.log(result);
        res.status(200).json({result})
    })
    .catch(err => {
        console.log(err);
        res.status(500).json({
            error:err
        });
    });
});

module.exports = router;