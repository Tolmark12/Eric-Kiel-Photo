function ajaxClick(href, title) {
		$.address.value(href);
		(href.match(/\?/g) != null) ? jsonLink = href.replace(/\?/g, ".json?") : jsonLink = href + '.json';
        $.get(jsonLink,
        function(data) {
			$('.buttons').hide();
			var previousToolbar = $('.buttons > div:last');
			var content = data["content"];
			$('.buttons').append("<div><input type=\"submit\" class=\"button-thin cancel back\" value=\"Back\">"+((data["toolbar"] != null) ? data["toolbar"] : "")+"</div>");
			$('.buttons > div:not(div:last)').hide();
			$('.buttons').fadeIn('slow'); // **MP** Changed to Fadein
	        var lastViewDiv = $('.view-port-container > div:last');
            var width = $('.view-port-container:first').width();
            $('.view-port-container').width(width+1014);
	        var divCount = $('.view-port-container > div').length;
            lastViewDiv.after(unescape(content));
		    $('.view-port-container > div').width(1005);
	        $('.view-port-container > div:last').css('float','left');
            $('.view-port-container > div').each( function(index, value) {
				$(value).animate({marginLeft:"-"+(width-(index*1014))+"px"},{easing:"easeInOutQuint",duration:400});
			});
            var lastLink = $('.bread-crumb a.last');
			lastLink.unbind('click');
            lastLink.click(function(e) {
                $('.view-port-container > div').each(function(index, value) {
					$(value).animate({marginLeft:"-"+(width-((index+1)*1014))+"px"},{easing:"easeInOutQuint",duration:400});
				});
				$('.buttons').hide();
				previousToolbar.nextAll('div').remove();
				$('.buttons > div:not(div:last)').hide();
				$('.buttons > div:last').show();
				$(this).children('span.arrow').remove();
				$(this).parent('li').nextAll('li').remove();
				$('.buttons').fadeIn('slow'); // **MP** Changed to Fadein
				lastViewDiv.nextAll('div').remove();
				$('.view-port-container').width($('.view-port-container > div').length * 1014);
				$('.view-port-container:first').width();
                $('.bread-crumb a.last').removeClass('last');
                $(this).addClass('last');
                $.address.value('');
				e.preventDefault();
                return false;
            });
			$('.buttons > div:last > .back').unbind('click');
			$('.buttons > div:last > .back').click(function(e) {
				lastLink.click();
				e.preventDefault();
                return false;
            });
            $('.bread-crumb a.last:not(a:has(span.arrow))').append('<span class="arrow"></span>');
            $('.bread-crumb a.last').removeClass('last');
            $('.bread-crumb ul').append($(data["breadcrumb"]).children('li:last'));
			eval(data["javascript"]);
        },
        'json');
        return false;
}
function attachEvents() {
	$('.selector-wrapper .button').unbind('toggle');
    $('.view-port-container > div').width(1005);
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
    	ajaxClick(this.href.replace(/[A-Za-z]+\:\/\/[:.A-Za-z0-9]+/gi, ""));
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
    if ($.address.value() != "/") {
    	ajaxClick($.address.value());
    }
});