package app.view.components
{

import flash.display.Sprite;
import flash.events.*;
import delorum.loading.*;
import app.view.components.events.ImageLoadEvent;

public class PortfolioImage extends Sprite
{
	public var highResLoaded:Boolean	= false;
	public var lowResLoaded:Boolean		= false;	
	public var shrinkPercentage:Number 	= 1;
	public var index:Number;
	public var isHidden:Boolean = false;
	
	private var _lowResHolder:Sprite 	= new Sprite();
	private var _highResHolder:Sprite	= new Sprite();
	private var _highResImagePath:String;
	
	private var _bigWidth:Number;
	private var _smallWidth:Number;
	
	private var _budgeId:String;
	private var _loadImmediately:Boolean = false;
	
	public function PortfolioImage($index:Number):void
	{
		index = $index;
		_drawTempBox();
	}
	
	public function loadImages ( $lowResSrc:String, $src:String, $loadImmediately:Boolean=false  ):void
	{
		_highResImagePath = $src;
		var ldr:ImageLoader = new ImageLoader( $lowResSrc, _lowResHolder );
		ldr.addEventListener( Event.INIT, _onLowResLoaded );
		ldr.addItemToLoadQueue( "low" );
		
		var ldr2:ImageLoader = new ImageLoader( _highResImagePath, _highResHolder );
		ldr2.addEventListener( Event.INIT, _onHighResLoaded );
		_budgeId = ldr2.addItemToLoadQueue("high");
		_loadImmediately = $loadImmediately;
	}
	
	public function loadLargeImage (  ):void
	{
		if( !highResLoaded )
			BaseLoader.loadItemNow( _budgeId, "high" )
	}

	public function get activeWidth (  ):Number
	{
		if( highResLoaded || lowResLoaded )
			return _bigWidth;
		else
			return super.width * shrinkPercentage;
	}
	
	public function get inactiveWidth (  ):Number
	{
		if( highResLoaded || lowResLoaded )
			return _smallWidth;
		else
			return 50;
	}
	// _____________________________ Image load Handlers
	
	private function _onLowResLoaded ( e:Event ):void
	{
		// Remove loading graphic
		this.graphics.clear();
		
		// Find widths
		_lowResHolder.height 	= 500;
		shrinkPercentage 		= _lowResHolder.scaleY/10;
		_lowResHolder.scaleX 	= shrinkPercentage * 10;
		_bigWidth 				= _lowResHolder.width;
		_lowResHolder.scaleX 	= _lowResHolder.scaleY = shrinkPercentage * 10;		
		this.addChild( _lowResHolder );
		lowResLoaded = true;
		
		var snap:Number			= this.scaleX;
		this.scaleX				= shrinkPercentage;
		_smallWidth 			= this.width;
		this.scaleX				= snap;
		
		_highResImagePath = null;
		var imgEv:ImageLoadEvent = new ImageLoadEvent( ImageLoadEvent.LOW_RES_IMAGE_LOADED, true );
		
		if( !isHidden )
			dispatchEvent( imgEv );
			
		if( _loadImmediately )
			loadLargeImage();
	}
	
	private function _onHighResLoaded ( e:Event ):void {
		_bigWidth 				= _highResHolder.width;
		_smallWidth				= _bigWidth * shrinkPercentage;
		this.removeChild(_lowResHolder);
		this.addChild( _highResHolder );
		
		var imgEv:ImageLoadEvent = new ImageLoadEvent( ImageLoadEvent.HIGH_RES_IMAGE_LOADED, true );
		
		if( !isHidden )
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