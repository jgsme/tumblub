var page = 20;
var q = new getQuery();
$(document).ready(function() {
    $.get("/x", {id: q.id, page: 0, num: 20}, function(res) {
        var j = JSON.parse(res);
        for(var i in j) $("#main").append($("<div />", {
            class: "back",
            css: {
                width: $(window).width(),
                height: $(window).height(),
                left: $(window).width()
            }
        }).append($("<img />").attr("src", j[i])).hide());
        $(".back:eq(0)").show().animate({"left": "-="+$(window).width()+"px"}, "slow");
        setInterval("slideshow()", 4000);
    });
});

function slideshow() {
    $(".back:eq(0)").animate({"left": "-="+$(window).width()+"px"}, {complete: function() {$(this).remove()}}, "slow");
    $(".back:eq(1)").show().animate({"left": "-="+$(window).width()+"px"}, "slow");
    if($(".back").size() < 10) $.get("/x", {id: q.id, page: page, num: 20}, function(res) {
        var j = JSON.parse(res);
        for(var i in j) $("#main").append($("<div />", {
            class: "back",
            css: {
                width: $(window).width(),
                height: $(window).height(),
                left: $(window).width()
            }
        }).append($("<img />").attr("src", j[i])).hide());
        page += 20;
    });
}

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
