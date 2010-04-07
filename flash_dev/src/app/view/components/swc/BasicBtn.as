package app.view.components.swc
{

import flash.display.Sprite;
import flash.events.*;

public class BasicBtn extends Sprite
{
	public function BasicBtn():void
	{
		this.addEventListener( MouseEvent.MOUSE_OVER, _onMouseOver, false,0,true );
		this.addEventListener( MouseEvent.MOUSE_OUT, _onMouseOut, false,0,true );
	}
	
	// _____________________________ Event Handlers
	
	private function _onMouseOver ( e:Event ):void {
		this.alpha = 0.8;
	}
	
	private function _onMouseOut ( e:Event ):void {
		this.alpha = 1;
	}

}

}