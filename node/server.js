// import http from "http";

const http = require("http");

const server = http.createServer((req, res) => {
  if (req.url === "/hello") {
    res.writeHead(200, { "Content-Type": "application/json" });
    res.end(JSON.stringify({ from: "node", msg: "Hello from Node!" }));
  } else {
    // IMPORTANT: real 404 so Nginx triggers the PHP fallback
    res.statusCode = 404;
    res.end("Not found");
  }
});

server.listen(3000, '0.0.0.0', () => console.log("Node listening on 0.0.0.0:3000"));
