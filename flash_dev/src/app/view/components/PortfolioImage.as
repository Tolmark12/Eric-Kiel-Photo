package app.view.components
{

import flash.display.Sprite;
import flash.events.*;
import delorum.loading.*;
import app.view.components.events.ImageLoadEvent;

public class PortfolioImage extends Sprite
{
	public var loadQueueNumber:Number;
	private var _lowResLoaded:ImageLoader;
	private var _highResLoader:ImageLoader;
	
	private static const _LOAD_IN_SEQUENCE:Boolean = false;
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
	
	
	// _____________________________ API
	
	public function PortfolioImage($index:Number):void
	{
		index = $index;
		_drawTempBox();
	}
	
	public function loadImages ( $lowResSrc:String, $src:String, $loadImmediately:Boolean=false  ):void
	{
		_highResImagePath = $src;
		_lowResLoaded = new ImageLoader( $lowResSrc, _lowResHolder );
		_lowResLoaded.addEventListener( Event.INIT, _onLowResLoaded, false, 0, true );
		//if( !$loadImmediately )
			_lowResLoaded.addItemToLoadQueue( "low" + loadQueueNumber );
		//else
		//	_lowResLoaded.loadItem();
		
		//if( _LOAD_IN_SEQUENCE ) {
			_highResLoader = new ImageLoader( _highResImagePath, _highResHolder );
			_highResLoader.addEventListener( Event.INIT, _onHighResLoaded, false, 0, true );
			_budgeId = _highResLoader.addItemToLoadQueue( "high" + loadQueueNumber);
		//}
		_loadImmediately = $loadImmediately;
	}
	
	public function loadLargeImage (  ):void
	{
		if( !highResLoaded )
			BaseLoader.loadItemNow( _budgeId, "high" + loadQueueNumber )
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
	
	public function clear (  ):void
	{
		if( _lowResLoaded != null ) {
			_lowResLoaded.cancelLoad();
			_lowResLoaded.removeEventListener( Event.INIT, _onLowResLoaded)
			_highResLoader.cancelLoad();
			_highResLoader.removeEventListener( Event.INIT, _onHighResLoaded)
			
			if( _lowResHolder != null)
				if( _lowResHolder.parent != null )
					this.removeChild(_lowResHolder);
				
			if( _highResHolder.parent != null )
				this.removeChild(_highResHolder);

			_lowResHolder  = null;
			_highResHolder = null;	
		}
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
		
		//if( !_LOAD_IN_SEQUENCE ) {
		//	var _highResLoader:ImageLoader = new ImageLoader( _highResImagePath, _highResHolder );
		//	_highResLoader.addEventListener( Event.INIT, _onHighResLoaded );
		//	_budgeId = _highResLoader.addItemToLoadQueue("high");
		//}
		
		_highResImagePath = null;
		var imgEv:ImageLoadEvent = new ImageLoadEvent( ImageLoadEvent.LOW_RES_IMAGE_LOADED, true );
		
		if( !isHidden )
			dispatchEvent( imgEv );
			
		if( _loadImmediately )
			loadLargeImage();
			
		var loader = new LoadingSymbol_swc();
		loader.cacheAsBitmap = true;
		loader.x = 20;
		loader.y = 20;
		_lowResHolder.addChild(loader);
		

	}
	
	private function _onHighResLoaded ( e:Event ):void {
		_bigWidth 				= _highResHolder.width;
		_smallWidth				= _bigWidth * shrinkPercentage;
		
		if( _lowResHolder != null )
			this.removeChild(_lowResHolder);
			
		_lowResHolder = null;
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