package app.view.components
{

import flash.display.Sprite;
import flash.events.*;
import app.view.components.events.StockEvent;
import flash.geom.ColorTransform;

public class StockMapItem extends Sprite
{
	public var id:String;
	private var _hasBeenViewed:Boolean = false;
	
	public function StockMapItem( $id:String ):void
	{
		id = $id;
		this.addEventListener( MouseEvent.CLICK, _onClick, false,0,true );
		//this.buttonMode = true
	}
	
	public function build ( $width:Number, $height:Number=141, $color:Number=0xDDDDDD ):void
	{
		this.graphics.clear();
		this.graphics.beginFill($color, 1);
		this.graphics.drawRect(0,0, $width , $height);
		deactivate();
	}
	
	public function clear (  ):void
	{
		this.removeEventListener( MouseEvent.CLICK, _onClick );
	}
	
	public function activate (  ):void
	{
		this.alpha = 1;
		_hasBeenViewed = true;
		var newColorTransform:ColorTransform = this.transform.colorTransform;
		newColorTransform.color = 0xFFFFFF;
		this.transform.colorTransform = newColorTransform;
	}
	
	public function deactivate (  ):void
	{
		if( _hasBeenViewed ){
			this.alpha = 1;
			this.transform.colorTransform = new ColorTransform();
		}
		else
			this.alpha = 0.66;
	}
	
	// _____________________________ Event Handlers
	
	private function _onClick ( e:Event ):void {
		var stockEvent:StockEvent = new StockEvent( StockEvent.STOCK_PHOTO_CLICK, true );
		stockEvent.id = this.id;
		dispatchEvent( stockEvent );
	}

}

}