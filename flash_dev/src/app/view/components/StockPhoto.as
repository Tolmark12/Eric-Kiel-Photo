package app.view.components
{

import flash.display.Sprite;
import app.model.vo.StockPhotoVo;
import flash.events.*;
import app.view.components.events.StockEvent;
import delorum.loading.ImageLoader;

public class StockPhoto extends Sprite
{
	public var id:String;
	private var _sPhotoVo:StockPhotoVo;
	private var _imageHolder:Sprite = new Sprite();
	
	public function StockPhoto( $vo:StockPhotoVo ):void
	{
		_sPhotoVo = $vo;
		id 	= $vo.id;
		this.buttonMode = true;
		this.addEventListener( MouseEvent.CLICK, _onClick, false,0,true );
		this.addEventListener( MouseEvent.MOUSE_OVER, _onMouseOver, false,0,true );
		this.addEventListener( MouseEvent.MOUSE_OUT, _onMouseOut, false,0,true );
	}
	
	// _____________________________ API
	
	public function clear (  ):void
	{
		
	}
	
	/** 
	*	Build
	*/
	public function build ( $width:Number ):void
	{
		// TEMP
		this.graphics.clear();
		this.graphics.beginFill(0xDDDDDD, 1);
		this.graphics.drawRect(0,0,$width, 200);
		unHighlight();
	}
	
	/** 
	*	load Thumbnail
	*/
	public function loadThumbnail (  ):void
	{
		this.addChild(_imageHolder);
		var ldr:ImageLoader = new ImageLoader( _sPhotoVo.lowResSrc, _imageHolder );
		ldr.addEventListener( Event.COMPLETE, _onImageLoaded );
		ldr.loadItem();
	}
	
	
	public function highlight (  ):void
	{
		//this.alpha = 0.7;
	}
	
	public function unHighlight (  ):void
	{
		//this.alpha = 0.3;
	}
	
	// _____________________________ Event Handlers
	
	private function _onClick ( e:Event ):void {
		var stockEvent:StockEvent = new StockEvent( StockEvent.STOCK_PHOTO_CLICK, true );
		stockEvent.id = this.id;
		dispatchEvent( stockEvent );
	}
	
	private function _onMouseOver ( e:Event ):void {
		var stockEvent:StockEvent = new StockEvent( StockEvent.STOCK_PHOTO_OVER, true );
		stockEvent.id = this.id;
		dispatchEvent( stockEvent );
	}
	
	private function _onMouseOut ( e:Event ):void {
		var stockEvent:StockEvent = new StockEvent( StockEvent.STOCK_PHOTO_OUT, true );
		stockEvent.id = this.id;
		dispatchEvent( stockEvent );
	}
	
	private function _onImageLoaded ( e:Event ):void {
		this.graphics.clear();
	}
	
	// _____________________________ Helpers
	
	override public function toString (  ):String
	{
		return id + '  :  ' + this.width + '  :  ' + this.x + '  :  ' + this.y + '  :  ' + this.visible + '  :  ' + this.parent + '  :  ' + this.alpha; // + '  :  ' + this.parent.x + '  :  ' + this.parent.y + '  :  ' + this.parent.parent.x;
	}
	
	

}

}