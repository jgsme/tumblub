var counter = 0;
var page = 20;
var side = true;
$(document).ready(function() {
    var q = new getQuery();
    $.get("/x", {id: q.id, page: 0, num: 20}, function(res) {
        var j = JSON.parse(res);
        for(var i in j) $("#main").append($("<div />", {
            class: "back",
            css: {
                width: $(window).width(),
                height: $(window).height()
            }
        }).append($("<img />").attr("src", j[i])));
        $("#main").css("height", $(window).height()).slider({
            autoplay: true,
            showControls: false,
            showProgress: false,
            hoverPause: false,
            slideafter: function() {
                counter += 1;
                if(counter == 11) {
                    $.get("/x", {id: q.id, page: page, num: 10}, function(res2) {
                        var j2 = JSON.parse(res2);
                        for(var i2 in j2) {
                            if(side) $(".back > img:lt(10)")[i2].src = j2[i2];
                            else $(".back > img:gt(9)")[i2].src = j2[i2];
                        }
                        side = !side;
                    });
                    page += 10;
                    counter = 0;
                }
            }
        });
    });
});

function getQuery() {
    var tmp = new Array();
    var query = window.location.search.substring(1);
    var parms = query.split("&");
    for (var i=0; i<parms.length; i++) {
        var pos = parms[i].indexOf("=");
        if (pos > 0) {
            var key = parms[i].substring(0,pos);
            var val = parms[i].substring(pos+1);
            tmp[key] = val;
        }
    }
    return tmp;
}