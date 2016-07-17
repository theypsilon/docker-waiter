var http = require('http');
var url = require("url");

var server = http.createServer(function (request, response) {
    var pathname = url.parse(request.url).pathname;
    console.log("Incoming request to " + pathname);
	if (pathname === "/api/ping") {
	  	response.writeHead(200);
  		response.end("Hello World\n");		
	} else {
	  	response.writeHead(404);
	  	response.end("Document not found\n");		
	}
});

setTimeout(function() {
	server.listen(9000);	
}, 6000);
