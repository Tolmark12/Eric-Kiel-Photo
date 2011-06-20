var popstateLoaded = false;
function moveToPane(href) {
	var pane = $('div.view-port-container > div[data-path="'+href+'"]:first');
	if (pane.length > 0) {
		$('.buttons').hide();
		$('.buttons > div:not(div[data-path="'+href+'"]:first)').hide();
		$('.buttons > div[data-path="'+href+'"]:first').nextAll('div').remove();
		$('.buttons > div[data-path="'+href+'"]:first').show();
		$('.buttons').fadeIn('slow'); // **MP** Changed to Fadein

		var width = $('.view-port-container:first').width();
		pane.prevAll('.view-port-container>div').each( function(index, value) {
			$(value).animate({marginLeft:"-"+(width-(index*1014))+"px"},{easing:"easeInOutQuint",duration:400});
		});
		pane.animate({marginLeft:"0px"},{easing:"easeInOutQuint",duration:400});
		var nextPanes = pane.nextAll('.view-port-container>div');
		$('.view-port-container:first').width(width-1014*(nextPanes.length-1));
		nextPanes.remove();
		$('.bread-crumb ul').hide();
		$('.bread-crumb ul[data-path="'+href+'"]:first').nextAll('ul').remove();
		$('.bread-crumb ul[data-path="'+href+'"]:first').show();
		return true;
	} else {
		return false;
	}
}
function ajaxClick(href, title) {
		(href.match(/\?/g) != null) ? jsonLink = href.replace(/\?/g, ".json?") : jsonLink = href + '.json';
		windowId = (href.indexOf('?') > 0) ? href.substring(0,href.indexOf('?')) : href;
		if (!moveToPane(windowId)) {
			if ($('.bread-crumb a[rel="address:'+windowId+'"] > span').length > 0) {
				document.location.reload(true);
			} else {			
				if(!popstateLoaded) {
					popstateLoaded = true;
				} else {
					$(window).bind('popstate', function(event) {
						var link = (document.location.pathname.indexOf('?') > 0) ? document.location.pathname.substring(0,document.location.pathname.indexOf('?')) : document.location.pathname;
						if (!moveToPane(link)) {
							document.location.reload(true);
						}
						return true;
					});
				}
        		$.get(jsonLink,
        		function(data) {
					// Adding new buttons
					$('.buttons').hide();
					$('.buttons').append("<div data-path='"+windowId+"'><input type=\"submit\" class=\"button-thin cancel back\" value=\"Back\">"+((data["toolbar"] != null) ? data["toolbar"] : "")+"</div>");
					$('.buttons > div:not(div:last)').hide();
					// End adding new buttons
					// Adding content pane
					var content = data["content"];
	    		    var lastViewDiv = $('.view-port-container > div:last');
        		    var width = $('.view-port-container:first').width();
	    		    var divCount = $('.view-port-container > div').length;
        		    lastViewDiv.after($(content).attr('data-path',windowId));
				    $('.view-port-container > div').width(1005);
	    		    $('.view-port-container > div:last').css('float','left');
					// End adding content pane
					// Adding breadcrumb
					$('.buttons > div:last > .back').unbind('click');
					$('.buttons > div:last > .back').click(function(e) {
						history.back();
						e.preventDefault();
        		        return false;
        		    });
        		    $('.bread-crumb ul').hide();
        		    $('.bread-crumb ul:last').after($(data["breadcrumb"]).attr('data-path',windowId));
					
					if (moveToPane(windowId)) {
						history.pushState({'isBento':true}, '', href);
					}
            		
					// End adding breadcrumb
					eval(data["javascript"]);
        		},
        		'json');
			}
		}
        return false;
}
function attachEvents() {
    $('.view-port-container > div').width(1005);
	$('.selector-wrapper .button').unbind('toggle');
    $('.selector-wrapper .button').toggle(
    function() {
        $(this).addClass('active');
        $(this).parent().next('.grid-container').show();
        var span = $(this).children().filter('span');
        span.removeClass('light');
        span.addClass('dark');
        return false;
    },
    function() {
        $(this).removeClass('active');
        $(this).parent().next('.grid-container').hide();
        var span = $(this).children().filter('span');
        span.removeClass('dark');
        span.addClass('light');
        return false;
    });
    $('a[rel^="address:"]').unbind('click');
    $('a[rel^="address:"]').click(function(e) {
    	ajaxClick(this.href.replace(/[A-Za-z]+\:\/\/[:.\-\_A-Za-z0-9]+/gi, ""));
    	e.preventDefault();
    	return false; 
    });
   $('.hidden').hide();
}
$(document).ready(function() {
    attachEvents();
    $(this).ajaxStop(function() {
        attachEvents();
    });
});