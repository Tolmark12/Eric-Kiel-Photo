package app.view.components
{

import flash.display.Sprite;
import app.model.vo.StageResizeVo;
import caurina.transitions.Tweener;
import flash.events.*;
import app.model.vo.StockPhotoSetVo;
import app.view.components.events.LightboxEvent;

public class LightBox extends Sprite
{
	private var _bg:Sprite = new Sprite();
	private var _isHidden:Boolean = false;
	private var _openYPos:Number = 0;
	private var _dictionary:Object = {};
	private var _photoHolder:Sprite = new Sprite();
	private var _emailBtn:EmailLightBoxBtn_swc = new EmailLightBoxBtn_swc();
	private var _closeBtn:CloseLightboxBtn_swc = new CloseLightboxBtn_swc();
	
	public function LightBox():void
	{
		_setInvisible();
		hide();
		this.addChild(_bg);
		this.addChild(_photoHolder);
		this.addChild(_emailBtn)
		this.addChild(_closeBtn);
		_photoHolder.scaleX = _photoHolder.scaleY = 0.2;
		_photoHolder.x 	= 200
		_photoHolder.y 	= 5;
		_emailBtn.y		= -20;
		_closeBtn.y		= -20;
		_emailBtn.buttonMode = true;
		_closeBtn.buttonMode = true;
		_drawBg();
		_emailBtn.addEventListener( MouseEvent.CLICK, _onEmailClick, false,0,true );
		_closeBtn.addEventListener( MouseEvent.CLICK, _onCloseClick, false,0,true );
		_bg.addEventListener( MouseEvent.CLICK, _onCloseClick, false,0,true );
	}
	
	public function position ( $stageResizeVo:StageResizeVo ):void
	{
		this.x = $stageResizeVo.left;
		this.y = _openYPos = $stageResizeVo.height - _bg.height;
		_closeBtn.x	= _bg.width - _closeBtn.width - 8;
//		_emailBtn.x = _closeBtn.x - _emailBtn.width - 8;
		_emailBtn.x = 12;
		_bg.width = $stageResizeVo.width;
	}
	
	public function hide (  ):void
	{
		if( !_isHidden ) {
			_isHidden = true;
			Tweener.addTween( this, { alpha:0, y:_openYPos + 10, time:0.5, transition:"EaseInOutQuint", onComplete:_setInvisible} );
		}
	}
	
	public function show (  ):void
	{
		if( _isHidden ) {
			_isHidden = false;			
			Tweener.addTween( this, { alpha:1, y:_openYPos, time:1, transition:"EaseInOutQuint"} );
			this.visible = true;
		}
	}
	
	/** 
	*	Add the photos to the display
	*	@param		The lightbox stockphoto set
	*/
	public function populate ( $set:StockPhotoSetVo ):void
	{
		var newDictionary = {};
		var xPos:Number = 0
		var len:uint = $set.stack.length;
		for ( var i:uint=0; i<len; i++ ) 
		{
			var photo:LightboxStockPhoto;
			// If this photo doesn't exist, create it
			if( _dictionary[$set.stack[i].id] == null ) {
				photo = new LightboxStockPhoto( $set.stack[i] );
				_photoHolder.addChild( photo );
				photo.build($set.stack[i].width)
				photo.loadThumbnail();
			}
			// else retrieve a reference to it
			else{
				photo = _dictionary[$set.stack[i].id];
				delete _dictionary[$set.stack[i].id];
			}
			
			photo.x = xPos;
			xPos += $set.stack[i].width + 30;
			newDictionary[photo.id] = photo;
		}
		
		// DELETE any photos that have been removed her
		for( var j:String in _dictionary )
		{
			_dictionary[j].hide();
		}
		
		
		_dictionary = newDictionary;
	}
	
	
	// _____________________________ Helpers
	
	private function _drawBg (  ):void {
		_bg.graphics.beginFill( 0x030303, 0.7 );
		_bg.graphics.drawRect( 0, 0, 100, 50 );
	}
	
	private function _setInvisible (  ):void {
		this.visible = false;
	}
	
	// _____________________________ Event Handlers	
	private function _onCloseClick ( e:Event ):void {
		//hide();
		dispatchEvent( new LightboxEvent(LightboxEvent.OPEN_OR_CLOSE, true) );
	}
	
	private function _onEmailClick ( e:Event ):void {
		dispatchEvent( new LightboxEvent(LightboxEvent.EMAIL_LIGHTBOX, true) );
	}

}

}