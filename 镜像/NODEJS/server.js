var http = require('http');

var ppp = process.env.HOST +":"+ process.env.PORT_8080;

var handleRequest = function(request, response) {
  response.writeHead(200);
  
  response.end("Hello World from nodejs hhhh!, service at " + ppp );
}
var www = http.createServer(handleRequest);
www.listen(8080);
