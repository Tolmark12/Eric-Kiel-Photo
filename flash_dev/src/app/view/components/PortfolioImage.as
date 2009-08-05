package app.view.components
{

import flash.display.Sprite;
import flash.events.*;
import delorum.loading.ImageLoader;
import app.view.components.events.ImageLoadEvent;

public class PortfolioImage extends Sprite
{
	public var highResLoaded:Boolean	= false;
	public var lowResLoaded:Boolean		= false;	
	public var shrinkPercentage:Number 	= 1;
	
	private var _lowResHolder:Sprite 	= new Sprite();
	private var _highResHolder:Sprite	= new Sprite();
	private var _highResImagePath:String;
	
	private var _bigWidth:Number;
	private var _smallWidth:Number;
	
	public function PortfolioImage():void
	{
		_drawTempBox();
	}
	
	public function loadImages ( $lowResSrc:String, $src:String  ):void
	{
		_highResImagePath = $src;
		var ldr:ImageLoader = new ImageLoader( $lowResSrc, _lowResHolder );
		ldr.addEventListener( Event.COMPLETE, _onLowResLoaded );
		ldr.addItemToLoadQueue();
	}

	public function get activeWidth (  ):Number
	{
		if( highResLoaded || lowResLoaded )
			return _bigWidth;
		else
			return super.width;
	}
	
	public function get inactiveWidth (  ):Number
	{
		if( highResLoaded || lowResLoaded )
			return _smallWidth;
		else
			return super.width;
	}
	// _____________________________ Image load Handlers
	
	private function _onLowResLoaded ( e:Event ):void
	{
		// Remove loading graphic
		this.graphics.clear();
		
		// Find widths
		_smallWidth 			= _lowResHolder.width;
		_lowResHolder.height 	= 500;
		shrinkPercentage 		= _lowResHolder.scaleY/10;
		_lowResHolder.scaleX 	= shrinkPercentage * 10;
		_bigWidth 				= _lowResHolder.width;
		trace( "Big" + '  :  ' + _bigWidth );
		trace( "Sml" + '  :  ' + _smallWidth );
		_lowResHolder.scaleX 	= _lowResHolder.scaleY = shrinkPercentage * 10;
		
		this.addChild( _lowResHolder );
		lowResLoaded = true;
		
		var ldr:ImageLoader = new ImageLoader( _highResImagePath, _highResHolder );
		ldr.addEventListener( Event.COMPLETE, _onHighResLoaded );
		ldr.loadItem();
		
		_highResImagePath = null;
		var imgEv:ImageLoadEvent = new ImageLoadEvent( ImageLoadEvent.LOW_RES_IMAGE_LOADED, true );
		dispatchEvent( imgEv );
	}
	
	private function _onHighResLoaded ( e:Event ):void {
		this.removeChild(_lowResHolder);
		this.addChild( _highResHolder );
		var imgEv:ImageLoadEvent = new ImageLoadEvent( ImageLoadEvent.HIGH_RES_IMAGE_LOADED, true );
		dispatchEvent( imgEv );
	}
	

	
	// _____________________________ Helpers
	
	private function _drawTempBox (  ):void
	{
		this.graphics.beginFill( 0x333333, 0.6 );
		this.graphics.drawRect( 0,0, 250, 250 );
		this.graphics.endFill();
	}

}

}