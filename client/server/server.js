const express = require('express')
require('dotenv').config()
const app = express()
const bcrypt = require('bcrypt')
const jwt = require('jsonwebtoken')
app.get('/api', (req,res) => {
    res.json({"users": ["TEST!!", "USERTOW"]})
})

app.listen(5000, () => {console.log("server started on port 5000")})

