package app.view.components
{

import flash.display.Sprite;
import flash.events.*;
import app.view.components.events.StockEvent;

public class AddToLightboxBtn extends Sprite
{
	public var id:String;
	
	public function AddToLightboxBtn():void
	{
		this.buttonMode = true;
		this.mouseChildren = false;
		this.addEventListener( MouseEvent.CLICK, _onClick, false,0,true );
		this.addEventListener( MouseEvent.MOUSE_OVER, _onMouseOver, false,0,true );
		this.addEventListener( MouseEvent.MOUSE_OUT, _onMouseOut, false,0,true );
		_onMouseOut(null);
		_drawBg()
	}
	
	// _____________________________ Helpers
	
	private function _drawBg (  ):void {
		this.graphics.beginFill(0x222222, 1);
		this.graphics.drawRect(0,0,this.width + 5, this.height);
	}
	
	// _____________________________ Event Handlers
	
	private function _onClick ( e:Event ):void {
		var ev:StockEvent = new StockEvent(StockEvent.ADD_TO_LIGHTBOX, true);
		ev.id = id;
		dispatchEvent( ev );
	}
	
	private function _onMouseOver ( e:Event ):void {
		this.alpha = 1;
	}
	
	private function _onMouseOut ( e:Event ):void {
		this.alpha = 0.9;
	}
	
}

}