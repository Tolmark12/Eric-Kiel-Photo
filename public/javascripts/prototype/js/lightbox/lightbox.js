"use strict";

var $,
	$w,
	$$,
	lightbox,
	LightboxOptions,
	Builder,
	Class,
	Effect;

// -----------------------------------------------------------------------------------
//
//	Lightbox v2.04
//	by Lokesh Dhakar - http://www.lokeshdhakar.com
//	Last Modification: 2/9/08
//
//	For more information, visit:
//	http://lokeshdhakar.com/projects/lightbox2/
//
//	Licensed under the Creative Commons Attribution 2.5 License - http://creativecommons.org/licenses/by/2.5/
//  - Free for use in both personal and commercial projects
//	- Attribution requires leaving author name, author link, and the license info intact.
//	
//  Thanks: Scott Upton(uptonic.com), Peter-Paul Koch(quirksmode.com), and Thomas Fuchs(mir.aculo.us) for ideas, libs, and snippets.
//  Artemy Tregubenko (arty.name) for cleanup and help in updating to latest ver of proto-aculous.
//
// -----------------------------------------------------------------------------------

//
//  Configuration
//
LightboxOptions = Object.extend({

    overlayOpacity: 0.8,   // controls transparency of shadow overlay
    animate: true          // toggles resizing animations

}, window.LightboxOptions || {});

// -----------------------------------------------------------------------------------

var Lightbox = Class.create();

Lightbox.prototype = {
    imageArray: [],
    activeImage: undefined,
    
    // initialize()
    // Constructor runs on completion of the DOM loading. Calls updateImageList and then
    // the function inserts html at the bottom of the page which is used to display the shadow 
    // overlay and the image container.
	//
    initialize: function () {

	    this.overlayDuration = LightboxOptions.animate ? 0.2 : 0;  // shadow fade in/out duration
       
        // Modified by Delorum - Domino
		var objBody = $$('body')[0],
			th = this;

		objBody.appendChild(Builder.node('div', {id: 'overlay'}));
        objBody.appendChild(Builder.node('div', {id: 'lightbox'}));

		// added $('video-player').hide() by Delorum - Domino
		$('overlay').hide().observe('click', (function () {this.end(); $('video-player').hide()}).bind(this));

        (function () {
            var ids = 
                'overlay lightbox';   
            $w(ids).each(function (id) { th[id] = $(id); });
        }).defer();
    },
    
    //
    //  start()
    //  Display overlay and lightbox. If image is part of a set, add siblings to imageArray.
    //
    start: function () { 
	
		// this.overlay changed to $('overlay') (l.82) by Delorum - Domino
		var arrayPageSize = this.getPageSize(),
			effect = new Effect.Appear($('overlay'), { duration: this.overlayDuration, from: 0.0, to: LightboxOptions.overlayOpacity });
		
		// Removed 'object' by Delorum - Domino
        $$('select', 'embed').each(function (node) { node.style.visibility = 'hidden'; });

        // stretch overlay to fill page and fade in	
        $('overlay').setStyle({ width: arrayPageSize[0] + 'px', height: arrayPageSize[1] + 'px' }); 
    },

    //
    //  end()
    //
    end: function () {
        this.lightbox.hide();
		// this.overlay changed to $('overlay') by Delorum - Domino
        var effect = new Effect.Fade($('overlay'), { duration: this.overlayDuration });
        
		// Removed 'object' by Delorum - Domino
		$$('select', 'embed').each(function (node) { node.style.visibility = 'visible'; });
		
		// Added a callback to flash for when the window closes - Mark
		var flashRef;
		if (navigator.appName.indexOf("Microsoft") != -1) {
		    flashRef = window["kiel_swf"];
		} else {
		    flashRef = document["kiel_swf"];
		}
		flashRef.showRoot();
    },

    //
    //  getPageSize()
    //
    getPageSize: function () {
	
		var xScroll, yScroll, windowWidth, windowHeight, pageWidth, pageHeight;
		
		if (window.innerHeight && window.scrollMaxY) {	
			xScroll = window.innerWidth + window.scrollMaxX;
			yScroll = window.innerHeight + window.scrollMaxY;
		} else if (document.body.scrollHeight > document.body.offsetHeight) { // all but Explorer Mac
			xScroll = document.body.scrollWidth;
			yScroll = document.body.scrollHeight;
		} else { // Explorer Mac...would also work in Explorer 6 Strict, Mozilla and Safari
			xScroll = document.body.offsetWidth;
			yScroll = document.body.offsetHeight;
		}
		
		if (this.innerHeight) {	// all except Explorer
			if (document.documentElement.clientWidth) {
				windowWidth = document.documentElement.clientWidth; 
			} else {
				windowWidth = this.innerWidth;
			}
			windowHeight = this.innerHeight;
		} else if (document.documentElement && document.documentElement.clientHeight) { // Explorer 6 Strict Mode
			windowWidth = document.documentElement.clientWidth;
			windowHeight = document.documentElement.clientHeight;
		} else if (document.body) { // other Explorers
			windowWidth = document.body.clientWidth;
			windowHeight = document.body.clientHeight;
		}	
		
		// for small pages with total height less then height of the viewport
		if (yScroll < windowHeight) {
			pageHeight = windowHeight;
		} else { 
			pageHeight = yScroll;
		}
	
		// for small pages with total width less then width of the viewport
		if (xScroll < windowWidth) {	
			pageWidth = xScroll;		
		} else {
			pageWidth = windowWidth;
		}

		return [pageWidth, pageHeight];
	}
};

//document.observe('dom:loaded', function () { lightbox = new Lightbox(); });