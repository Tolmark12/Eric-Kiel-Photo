package app.view.components
{

import flash.display.Sprite;
import app.model.vo.PortfolioItemVo;
import delorum.loading.ImageLoader;
import flash.events.*;
import app.view.components.events.NavEvent;
import caurina.transitions.Tweener;
import app.view.components.events.ImageLoadEvent;
import flash.filters.BitmapFilter;
import flash.filters.BitmapFilterQuality;
import flash.filters.GlowFilter;
import app.view.components.swc.SeeFilmBtn;
import caurina.transitions.Tweener;

public class PortfolioItem extends Sprite
{
	private static const _LOWER_Y:Number = 100;
	private static const _TIME:Number = 0.8;
	
	public var isActive:Boolean = false;
	private var _portfolioItemVo:PortfolioItemVo;
	private var _portfolioImages:PortfolioImage;
	public var targetX:Number;
	private var _isTweening:Boolean = false;
	public var isHidden:Boolean = false;
	public var index:uint;

	// Video Btns, I should probably move these into a sub class at some point..
	private var _viewVideoBtn:SeeFilmBtn;
	private var _playBtn:FilmPlayButton_swc;
	private var _descriptiveVideoText:NavText_swc;
	
	public function PortfolioItem():void
	{
		this.cacheAsBitmap = true;
		this.visible = false;
		this.y = _LOWER_Y;
		this.addEventListener( MouseEvent.CLICK, _onClick, false,0,true );
		this.addEventListener( MouseEvent.MOUSE_OVER, _onMouseOver, false,0,true );
		this.addEventListener( MouseEvent.MOUSE_OUT, _onMouseOut, false,0,true );
//		this.buttonMode = true;
	}
	
	// _____________________________ API
	
	/** 
	*	Initialize - also load images
	*	@param		Data for portfolio (image paths, index)
	*/
	public function buildAndLoad ( $portfolioItemVo:PortfolioItemVo, $loadQueueNumber:Number ):void
	{
		index = $portfolioItemVo.index;
		
		_portfolioItemVo = $portfolioItemVo;
		_portfolioImages = new PortfolioImage(_portfolioItemVo.index);
		_portfolioImages.addEventListener( ImageLoadEvent.LOW_RES_IMAGE_LOADED, _onLowResImageLoaded, false,0,true );
		_portfolioImages.addEventListener( ImageLoadEvent.HIGH_RES_IMAGE_LOADED, _onHighResImageLoaded, false,0,true );
		this.addChild(_portfolioImages);

		_portfolioImages.loadQueueNumber = $loadQueueNumber;
		_portfolioImages.loadImages( _portfolioItemVo.lowResSrc, _portfolioItemVo.src, index < 9 );
		
		// If this has video...
		if( _portfolioItemVo.videoEmbedTag != null ){
			
			// If this is a photo with video associated with it...
			if( !_portfolioItemVo.isOnlyVideo )
				_viewVideoBtn = new SeeFilmBtn_swc();
			// this is a photo with only video...	
			else{
				_playBtn = new FilmPlayButton_swc();
				_descriptiveVideoText = new NavText_swc();
			}
		}
			
	}
	
	/** 
	*	Make this item selected
	*/
	public function activate (  ):void
	{
		_showVideoBtn();
		_portfolioImages.isHidden = false;
		_portfolioImages.loadLargeImage()
		
		// Only grow if this is a normal button
		if( _portfolioItemVo.isOnlyVideo ) {
			_sendActivationEvent()
		}else{
			_removeTweens();
			Tweener.addTween( super, { y:0, scaleX:1, scaleY:1, time:_TIME, transition:"EaseInOutQuint", onComplete:_sendActivationEvent} );
			blur = 0;
			Tweener.addTween( this, { blur:30, time:0.6, delay:0.3, transition:"EaseInOutQuint", onUpdate:_updateGlow} );
		}
		
		_onMouseOver(null);
		this.isActive = true;
	}
	
	/** 
	*	Return this item to its previous state
	*/
	public function deactivate ( $doTween:Boolean = true ):void
	{
		_hideVideoBtn();
		_removeTweens();
		if( $doTween ){
			Tweener.removeTweens( this, "blur" );
			Tweener.addTween( this, { y:_LOWER_Y, scaleX:_portfolioImages.shrinkPercentage, scaleY:_portfolioImages.shrinkPercentage, time:_TIME, transition:"EaseInOutQuint", onComplete:_fadeBack} );
			Tweener.addTween( this, { blur:0, time:0.3, transition:"EaseInOutQuint", onUpdate:_updateGlow} );
		}else{
			if( _portfolioImages != null )
				this.scaleX = this.scaleY = _portfolioImages.shrinkPercentage;
			filters = [];
		}
		this.isActive = false;
		this.filters = [];
	}
	
	public function hide (  ):void
	{
		_portfolioImages.isHidden = false;
		isHidden = true;
		if( isActive ){
			this.isActive = false;
			_onMouseOut(null);
			this.filters = [];
			this.scaleX = this.scaleY = _portfolioImages.shrinkPercentage;
			this.y = _LOWER_Y;
		}
		Tweener.addTween( this, { alpha:0, time:0.3, transition:"EaseInOutQuint", onComplete:_makeInvisible} );
	}
	
	public function show (  ):void
	{
		_portfolioImages.isHidden = false;
		Tweener.addTween( this, { alpha:0.8, time:0.3, transition:"EaseInOutQuint"} );
		isHidden = false;
		this.visible = true;
		deactivate();
	}
	
	/** 
	*	Tween this item to a new x position
	*/
	public function moveTo ( $x:Number, $doTween:Boolean, $speed:Number=_TIME ):void
	{
			if( targetX != $x ){
				if( $doTween || isActive ){
					if( !_isTweening || targetX != $x ){
						_isTweening = true
						Tweener.removeTweens( this, "x" );
						Tweener.addTween( this, { x:$x, time:$speed, transition:"EaseInOutQuint", onComplete:_arrivedAtTarget} );
					}
				}else{
					if( !isActive ){
						_isTweening = false;
						Tweener.removeTweens( this, "x" );
					}
				}
			}
			else{
				this.x = $x;
			}
			targetX = $x;
	}
	
	public function clear (  ):void
	{
		this.removeEventListener( MouseEvent.CLICK, _onClick );
		this.removeEventListener( MouseEvent.MOUSE_OVER, _onMouseOver );
		this.removeEventListener( MouseEvent.MOUSE_OUT, _onMouseOut );
		
		_portfolioImages.clear();
		this.removeChild(_portfolioImages);
		_portfolioImages = null;
	}
	
	// _____________________________ Event Handlers
	
	private function _onClick ( e:Event ):void
	{
		trace( "hi" + '  :  ' + _portfolioItemVo );
		
		var navEvent:NavEvent = new NavEvent( NavEvent.PORTFOLIO_ITEM_CLICK, true );
		navEvent.portfolioItemIndex = _portfolioItemVo.index;
		dispatchEvent( navEvent );
	
		if( _portfolioItemVo.isOnlyVideo ) {
			var ev:NavEvent = new NavEvent(NavEvent.SHOW_VIDEO, true);
			dispatchEvent( ev );
		}
	}
	
	private function _onMouseOver ( e:Event ):void {
		if( !isActive )
			this.alpha = 1;
		
		//trace( _portfolioItemVo.src );
	}
	
	private function _onMouseOut ( e:Event ):void {
		if( !isActive )
			this.alpha = 0.8;
	}
	
	private function _onLowResImageLoaded ( e:ImageLoadEvent ):void
	{
		this.visible = true;
		e.imageIndex = index;
		if( !isActive )
			deactivate(false);
	}
	
	private function _onHighResImageLoaded ( e:ImageLoadEvent ):void
	{
		e.imageIndex = index;
		if( !isActive )
			deactivate(false);
		else
			dispatchEvent( new ImageLoadEvent(ImageLoadEvent.RECENTER_STRIP, true) );
			
		if( _viewVideoBtn != null ){
			this.addChild( _viewVideoBtn );
			_viewVideoBtn.addEventListener( MouseEvent.CLICK, _onVideoClick, false,0,true );
			_viewVideoBtn.x =  Math.round( _portfolioImages.activeWidth - _viewVideoBtn.width );
			_viewVideoBtn.y = 505;
		}
		
		if( _playBtn != null ) {
			// If it's a video, add a play button
			this.addChild( _playBtn );
			_playBtn.scaleX = _playBtn.scaleY = 1/_portfolioImages.shrinkPercentage;
			_playBtn.x = _portfolioImages.activeWidth/2 - _playBtn.width/2;
			_playBtn.y = 250-_playBtn.height/2;
			
			// Also add title text
			this.addChild( _descriptiveVideoText );
			_descriptiveVideoText.text = _portfolioItemVo.name;
			_descriptiveVideoText.y = 505;
			var tFormat = _descriptiveVideoText.tField.getTextFormat();
			tFormat.size = 38;
			_descriptiveVideoText.tField.setTextFormat( tFormat );
			//Tweener.addTween(_descriptiveVideoText, {_color: 0xFFFFFF, time:0});  // Uncomment this text to change the color to white
			
		}
	}
	
	private function _onVideoClick ( e:Event ):void {
		e.stopPropagation();
		var ev:NavEvent = new NavEvent(NavEvent.SHOW_VIDEO, true);
		dispatchEvent( ev );
	}
	
	
	private function _arrivedAtTarget (  ):void
	{
		_isTweening = false;
	}
	
	// _____________________________ Tween completes
	
	private function _sendActivationEvent (  ):void
	{
		dispatchEvent( new Event("madeBig", true) );
	}
	
	private function _fadeBack (  ):void
	{
		_onMouseOut(null);
	}
	
	// _____________________________ Getters + Setters
	
	override public function get width (  ):Number
	{
		if( this.isHidden )
			return 0;
		else if( this.isActive && !_portfolioItemVo.isOnlyVideo ) 
			return _portfolioImages.activeWidth;
		else
			return _portfolioImages.inactiveWidth;
	}
	
	// _____________________________ Helprs
	
	private function _removeTweens (  ):void
	{
		Tweener.removeTweens( this, "scaleX", "scaleY", "blur" );
	}
	
	private function _makeInvisible (  ):void
	{
		if( isHidden )
			this.visible = false;
	}
	
	// _____________________________ Glow
	
	public var blur:Number = 0;
	
	private function _getGlow (  ):GlowFilter
	{
		var color:Number = 0x000000;
		var alpha:Number = 0.3;
		var strength:Number = 2;
		var inner:Boolean = false;
		var knockout:Boolean = false;
		var quality:Number = BitmapFilterQuality.MEDIUM;
        
		return new GlowFilter(color,
		                      alpha,
		                      blur,
		                      blur,
		                      strength,
		                      quality,
		                      inner,
		                      knockout);
	}
	
	private function _updateGlow (  ):void
	{
		this.filters = [_getGlow()];
	}
	
	// _____________________________ Helpers
	private function _showVideoBtn (  ):void {
		if( _viewVideoBtn != null ) {
			_viewVideoBtn.visible = true;
		}
	}
	
	private function _hideVideoBtn (  ):void {
		if( _viewVideoBtn != null ) {
			_viewVideoBtn.visible = false;
		}
	}
}

}