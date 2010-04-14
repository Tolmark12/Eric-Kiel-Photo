package app.view.components
{

import flash.display.*;
import app.model.vo.StageResizeVo;
import app.model.vo.StockPhotoVo;
import app.view.components.events.StockEvent;
import flash.events.*;
import delorum.loading.ImageLoader;
import caurina.transitions.Tweener;
import app.model.vo.StageResizeVo;
import app.view.components.events.ModalEvent;

public class StockDetailView extends Sprite
{
	private var _display:Sprite = new Sprite();
	// Image
	private var _imageHolder:Sprite = new Sprite();
	// Background
	private var _darkBackground:Sprite = new Sprite();	
	// Ask A question
	private var _askQuestionBtn:TextIconBtn = new TextIconBtn_swc();
	// Download Comp
	private var _downloadCompBtn:TextIconBtn = new TextIconBtn_swc();
	// Add to Lightbox
	private var _addToLightBoxBtn:TextIconBtn = new TextIconBtn_swc();;
	// Terms	
	private var _termsBtn:TextIconBtn_swc = new TextIconBtn_swc();;
	// Close Btn
	private var _closeBtn:CloseBtn_swc = new CloseBtn_swc();
	// Buy Button
	private var _buyBtn:GreenBtn = new GreenBtn_swc();
	
	
	// Title (number)
	// Buy Now
	// Related Photos
	
	// State
	private var _isHidden:Boolean;
	private var _id:String;
	
	public function StockDetailView():void
	{
		this.mouseEnabled = false;
		this.mouseChildren = true;
		
		_drawBackgroundBlocker();
		this.addChild(_display);
		_display.addChild( _imageHolder );
		_display.alpha = 0;
		_imageHolder.y  = 50;
		
		// Create the buttons
		_askQuestionBtn.build(  "Ask A Question", "_ask");
		_downloadCompBtn.build( "Downlad Comp", "_download");
		_termsBtn.build( "Terms", "_terms" );
		changeDisplayLightboxStatus(true);
		_downloadCompBtn.y = _askQuestionBtn.y = _termsBtn.y = _imageHolder.y - 20;
		
		_display.addChild( _askQuestionBtn );
		_display.addChild( _downloadCompBtn );
		_display.addChild( _addToLightBoxBtn );
		_display.addChild( _closeBtn );
		_display.addChild( _buyBtn );
		_display.addChild( _termsBtn );
		
		_closeBtn.buttonMode = true;
		_closeBtn.mouseChildren = false;
		
		_buyBtn.setTitle("Buy Now");
		
		
		// Events
		_askQuestionBtn.addEventListener( MouseEvent.CLICK, _onAskQuestionClick, false,0,true );
		_downloadCompBtn.addEventListener( MouseEvent.CLICK, _onDownloadClick, false,0,true );
		_addToLightBoxBtn.addEventListener( MouseEvent.CLICK, _onAddToLightBoxClick, false,0,true );
		_closeBtn.addEventListener( MouseEvent.CLICK, _onCloseClick, false,0,true );
		// Set initial state to hidden
		hide();		
	}
	
	/** 
	*	Load the image...
	*/
	public function displayImage ( $stockPhotoVo:StockPhotoVo ):void
	{
		_id = $stockPhotoVo.id;
		show();
		if( _isHidden ) // if hidden, show..
			show();
		
		if( _imageHolder.numChildren != 0 )
			_imageHolder.removeChildAt(0);
		
		changeDisplayLightboxStatus($stockPhotoVo.isInLightBox);
		
		var ldr:ImageLoader = new ImageLoader( $stockPhotoVo.highResSrc, _imageHolder );
		ldr.addEventListener( Event.COMPLETE, _onImageLoaded );
		ldr.loadItem();
	}
	
	/** 
	*	Show
	*/
	public function show (  ):void
	{
		_closeBtn.visible 		= false;
		_darkBackground.width 	= StageResizeVo.lastResize.width + 30;
		_darkBackground.height	= StageResizeVo.lastResize.height + 30;
		_darkBackground.x 		= StageResizeVo.CENTER - _darkBackground.width / 2;
		
		_darkBackground.mouseEnabled = true;
		Tweener.addTween( _darkBackground, { alpha:1, time:1, transition:"EaseInOutQuint"} );
		_display.alpha = 0;
		this.visible = true;
		_isHidden = false;
	}
	
	/** 
	*	Hide
	*/
	public function hide (  ):void
	{
		this.visible = false;
		_isHidden = true;
	}
	
	/** 
	*	Hide
	*/
	public function close (  ):void
	{
		_darkBackground.mouseEnabled = false;
		Tweener.addTween( _display, { alpha:0, time:0.3, transition:"EaseInOutQuint"} );
		Tweener.addTween( _darkBackground, { alpha:0, time:0.3, transition:"EaseInOutQuint", onComplete:hide} );
		dispatchEvent( new ModalEvent(ModalEvent.CLOSE_MODAL, true) );
	}
	
	/** 
	*	Ckear
	*/
	public function clear (  ):void
	{
		hide();
	}
	
	/** 
	*	Change whether the button on this says "Add" or "Remove" from the Lightbox
	*/
	private var _isInLightBox:Boolean;
	public function changeDisplayLightboxStatus ( $isInLightBox:Boolean ):void
	{
		_isInLightBox = $isInLightBox;
		if( !$isInLightBox )
			_addToLightBoxBtn.build( "Add To Lightbox", "_lightbox")
		else
			_addToLightBoxBtn.build( "Remove From Lightbox", "_lightbox")
	}
	
	// _____________________________ Helpers
	
	private function _drawBackgroundBlocker (  ):void {
		this.addChild( _darkBackground );
		_darkBackground.addEventListener( MouseEvent.CLICK, _onCloseClick, false,0,true );
		_darkBackground.graphics.beginFill( 0x000000, 0.8 );
		_darkBackground.graphics.drawRect( 0, 0, 1000, 1000 );
	}
	
	
	// _____________________________ Event Handlers
	
	private function _onAskQuestionClick ( e:Event ):void {
		var ev:ModalEvent = new ModalEvent(ModalEvent.ASK_A_QUESTION, true);
		dispatchEvent( ev );
	}
	
	private function _onDownloadClick ( e:Event ):void {
		var ev:ModalEvent = new ModalEvent(ModalEvent.DOWNLOAD_COMP, true);
		dispatchEvent( ev );
	}
	
	private function _onCloseClick ( e:Event ):void {
		dispatchEvent( new StockEvent(StockEvent.STOCK_PHOTO_CLOSE, true) );
		close();
	}
	
	private function _onAddToLightBoxClick ( e:Event ):void {
		var ev:StockEvent;
		
		if( !_isInLightBox )
			ev = new StockEvent(StockEvent.ADD_TO_LIGHTBOX, true);
		else
			ev = new StockEvent(StockEvent.REMOVE_FROM_LIGHTBOX, true);
			
		ev.id = _id;
		dispatchEvent( ev );
	}
	
	private function _onImageLoaded ( e:Event ):void {
		_imageHolder.x 			= StageResizeVo.CENTER - _imageHolder.width / 2;
		var right:Number 		= _imageHolder.x + _imageHolder.width;
		_closeBtn.visible 		= true;
		_closeBtn.x 			= Math.round( _imageHolder.x - 10 );
		_closeBtn.y				= Math.round( _imageHolder.y - 10 );
		_downloadCompBtn.x 		= right - _downloadCompBtn.width + 30;
		_askQuestionBtn.x  		= _downloadCompBtn.x - _askQuestionBtn.width + 20;
		_termsBtn.x 			= _askQuestionBtn.x - _termsBtn.width + 20;
		_addToLightBoxBtn.x 	= _imageHolder.x;
		_addToLightBoxBtn.y 	= _imageHolder.y + _imageHolder.height + 7;
		_buyBtn.y 				= _imageHolder.y + _imageHolder.height + 1;
		_buyBtn.x 				= _imageHolder.x + _imageHolder.width - _buyBtn.width + 13;
		Tweener.addTween( _display, { alpha:1, time:1, transition:"EaseInOutQuint"} );
	}
	

}

}