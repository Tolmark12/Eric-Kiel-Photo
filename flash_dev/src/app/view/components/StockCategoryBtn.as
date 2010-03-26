package app.view.components
{

import flash.display.*;
import flash.events.*;
import flash.text.TextField;
import flash.geom.ColorTransform;
import app.view.components.events.StockEvent;
public class StockCategoryBtn extends Sprite
{
	private var _id:String;
	private var _closeBtn:MovieClip;
	private var _titleTxt:TextField;
	
	public function StockCategoryBtn():void
	{
		_closeBtn = this.getChildByName( "closeBtn" ) as MovieClip;
		_titleTxt = this.getChildByName( "titleTxt" ) as TextField;
		_closeBtn.mouseChildren = false;
		_titleTxt.mouseEnabled	= false;
		_titleTxt.autoSize = "left";
		
		_closeBtn.buttonMode = true;
		this.addEventListener( MouseEvent.CLICK, _onClick, false,0,true );
	}
	
	public function build ( $text:String, $color:Number, $isFirst:Boolean = false ):void
	{
		_id = $text;
		_titleTxt.text = $text.toUpperCase();
		if( $isFirst ) 
			this.removeChild(_closeBtn);
		else{
			_titleTxt.appendText(" Only");
			_closeBtn.x = _titleTxt.textWidth;
			_closeBtn.graphics.beginFill( 0xFF0000, 0 );
			var hitArea:Number = 4
			_closeBtn.graphics.drawRect( -hitArea, -hitArea, hitArea*3, hitArea*3 );
		}
		
		var newColorTransform:ColorTransform = _titleTxt.transform.colorTransform;
		newColorTransform.color = $color;
		_titleTxt.transform.colorTransform = newColorTransform;
	}
	
	public function clear (  ):void
	{
		this.removeEventListener( MouseEvent.CLICK, _onClick )
	}
	
	// _____________________________ Event Handlers
	
	private function _onClick ( e:Event ):void {
		var ev:StockEvent = new StockEvent(StockEvent.REMOVE_CATEGORY, true);
		ev.id = _id;
		dispatchEvent( ev );
	}

}

}