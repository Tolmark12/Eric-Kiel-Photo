package app.view.components
{

import flash.display.Sprite;
import app.model.vo.StockPhotoVo;
import flash.events.*;
import app.view.components.events.StockEvent;

public class StockPhoto extends Sprite
{
	public var id:String;
	
	public function StockPhoto( $vo:StockPhotoVo ):void
	{
		id 	= $vo.id;
		this.buttonMode = true;
		this.addEventListener( MouseEvent.CLICK, _onClick, false,0,true );
	}
	
	// _____________________________ API
	
	public function clear (  ):void
	{
		
	}
	
	public function build ( $width:Number ):void
	{
		// TEMP
		this.graphics.clear();
		this.graphics.beginFill(0xDDDDDD, 1);
		this.graphics.drawRect(0,0,$width, 200);
		unHighlight();
	}
	
	public function highlight (  ):void
	{
		this.alpha = 0.7;
	}
	
	public function unHighlight (  ):void
	{
		this.alpha = 0.3;
	}
	
	// _____________________________ Event Handlers
	
	private function _onClick ( e:Event ):void {
		var stockEvent:StockEvent = new StockEvent( StockEvent.STOCK_PHOTO_CLICK, true );
		stockEvent.id = this.id;
		dispatchEvent( stockEvent );
	}
	
	// _____________________________ Helpers
	
	override public function toString (  ):String
	{
		return id + '  :  ' + this.width + '  :  ' + this.x + '  :  ' + this.y + '  :  ' + this.visible + '  :  ' + this.parent + '  :  ' + this.alpha; // + '  :  ' + this.parent.x + '  :  ' + this.parent.y + '  :  ' + this.parent.parent.x;
	}
	
	

}

}