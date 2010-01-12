package app.view.components
{

import flash.events.*;
import flash.display.*;
import flash.text.TextField;
import flash.display.Sprite;

public class StockMapMiniPage extends MovieClip
{
	private var _pageNumber:TextField;
	private var _hitArea:Sprite = new Sprite();
	
	public function StockMapMiniPage():void
	{
		_pageNumber = this.getChildByName( "titleTxt" ) as TextField;
		_pageNumber.autoSize = "left";
		
		this.addChild( _hitArea );
		_hitArea.buttonMode 	= true;
		_hitArea.alpha			= 0.3;
		
		_hitArea.addEventListener( MouseEvent.CLICK, _onClick, false,0,true );
		_hitArea.addEventListener( MouseEvent.MOUSE_OVER, _onMouseOver, false,0,true );
		_hitArea.addEventListener( MouseEvent.MOUSE_OUT, _onMouseOut, false,0,true );
		
		_onMouseOut(null);
	}
	
	/** 
	*	Draw the square shape used for highlighting / rollover
	*/
	public function build ( $text:String, $width:Number, $height:Number ):void
	{
		_pageNumber.text = $text;
		
		// If the text is empty, this is the last line, don't draw
		if( $text != "" ) {
			_hitArea.graphics.beginFill( 0xfff460, 1 );
			_hitArea.graphics.drawRect( 0, -this.parent.y - 6, $width, $height + 6 );
		}
	}
	
	// _____________________________ Event Handlers
	
	private function _onClick ( e:Event ):void {
		trace( "StockMapMiniPage : change page" );
		//var ev:StockEvent = new StockEvent(StockEvent.STOCK_PAGE_CLICK, true);
		//dispatchEvent( ev );
	}
	
	private function _onMouseOver ( e:Event ):void {
		_hitArea.alpha = 0.2;
	}
	
	private function _onMouseOut ( e:Event ):void {
		_hitArea.alpha = 0;
	}
}

}