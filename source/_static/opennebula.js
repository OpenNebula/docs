$(document).ready(function(){

    /* Equalize the size of the divs in the front page */
    var rowdata = true;
    var row = 0;
    while ($(".ofp-box-row-"+row).length > 0){
        var boxes = $(".ofp-box-row-"+row);

        var h = [];
        boxes.each(function(i,e){h.push($(e).height())});
        var maxh = Math.max.apply(Math, h);

        boxes.height(maxh);

        row++;
    }

    /* Remove the "Guide" word from the sidebar titles */
    $("#sidebar > ul.current > li.current > a").each(function(i,e){
        var html = $(e).html();
        $(e).html(html.replace(/ guide/i, ""));
    });

});
