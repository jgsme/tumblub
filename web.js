var http = require("http");
var express = require("express");
var parser = require("xml2json");

var app = express.createServer();

app.configure(function() {
    app.use(express.static(__dirname + "/views"));
    app.set("view engine", "jade");
});

app.get("/", function(req, res) {
    console.log(req.query.id);
    if(req.query.id == null) res.render("index.jade");
    else res.render("user.jade");
});

app.get("/x", function(req, res) {
    var tumblr = {
        host: req.query.id+".tumblr.com",
        path: "/api/read?type=photo&start="+req.query.page+"&num="+req.query.num
    };
    var d = "";
    http.get(tumblr, function(r) {
        r.on("data", function(data) {
            d += data.toString();
        }).on("end", function() {
            if(d.match("DOCTYPE html") != null) res.send("Error!");
            else {
                var j = JSON.parse(parser.toJson(d));
                //console.log(j.tumblr.posts.post);
                var out = new Array();
                if(j.tumblr.posts == null) res.send("Error!");
                else {
                    for(var i in j.tumblr.posts.post) out.push(j.tumblr.posts.post[i]["photo-url"][1]["$t"]);
                    res.send(JSON.stringify(out));
                }
            }
        });
    });
});

var port = process.env.PORT || 3000;
app.listen(port, function(){
  console.log("Listening on " + port);
});