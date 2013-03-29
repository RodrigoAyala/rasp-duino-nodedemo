
/**
 * Module dependencies.
 */

var express = require('express')
  , app = express()
  , routes = require('./routes')
  , http = require('http')
  , path = require('path')
  , server = http.createServer(app)
  , io = require('socket.io').listen(server);


app.configure(function(){
  app.set('port', process.env.PORT || 3000);
  app.set('views', __dirname + '/views');
  app.set('view engine', 'jade');
  app.use(express.favicon());
  app.use(express.logger('dev'));
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(app.router);
  app.use(express.static(path.join(__dirname, 'public')));
});

app.configure('development', function(){
  app.use(express.errorHandler());
});

app.get('/', routes.index);

var SerialPort = require("serialport").SerialPort
var serialPort = new SerialPort("/dev/ttyACM0", {
  baudrate: 57600
}, false);


io.sockets.on('connection', function (socket) {
  serialPort.open(function () {
    serialPort.on('data', function(data) {
      socket.emit('transmission', { data: data });
    });  
    
    socket.on('arduino_events', function (data) {
      serialPort.write(data.command+"\n", function(err, results) {
      });
    });

  });

});

server.listen(app.get('port'), function(){
  console.log("Express server listening on port " + app.get('port'));
});
