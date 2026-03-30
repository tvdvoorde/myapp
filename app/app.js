const express = require('express');
const path = require('path');

const app = express();

app.use(express.urlencoded({ extended: true }));
app.use(express.static(path.join(__dirname, 'static')));

app.set('views', path.join(__dirname, 'templates'));
app.set('view engine', 'html');
app.engine('html', require('ejs').renderFile);

app.get('/', (req, res) => {
    console.log('Request for index page received');
    res.render('index.html');
});

app.post('/hello', (req, res) => {
    const name = req.body.name;
    if (name) {
        console.log('Request for hello page received with name=%s', name);
        res.render('hello.html', { name });
    } else {
        console.log('Request for hello page received with no name or blank name -- redirecting');
        res.redirect('/');
    }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log('Server running on port %d', PORT);
});
