module.exports = function(app) {
  var express = require('express');
  var mailThreadsRouter = express.Router();

  mailThreadsRouter.get('/', function(req, res) {
    res.send({
      'mail-threads': []
    });
  });

  mailThreadsRouter.post('/', function(req, res) {
    res.status(201).end();
  });

  mailThreadsRouter.get('/:id', function(req, res) {
    res.send({
      'mail-threads': {
        id: req.params.id
      }
    });
  });

  mailThreadsRouter.put('/:id', function(req, res) {
    res.send({
      'mail-threads': {
        id: req.params.id
      }
    });
  });

  mailThreadsRouter.delete('/:id', function(req, res) {
    res.status(204).end();
  });

  app.use('/api/mail_threads', mailThreadsRouter);
};
