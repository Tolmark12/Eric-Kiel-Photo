package app.view.components
{
	import flash.display.Sprite;
	import flash.events.*;
	
	import caurina.transitions.Tweener;
	
	import app.view.components.events.NavEvent;
	
	public class SubNavItem extends Sprite
	{
		private var _txt:NavText_swc;
		private var _isSelected:Boolean = false;
		
		private var _id:String;
	
		public function SubNavItem( $text:String, $id:String ):void
		{
			_id = $id;
			
			// Text
			_txt = new NavText_swc();
			this.addChild( _txt );
			
			_txt.titleTxt.autoSize = "left";
			_txt.titleTxt.text = $text;
			
			// Create hit area and add event listeners to that
			var hit:Sprite 			= new Sprite();
			var hitPadding:Number  	= 5;
			hit.graphics.beginFill(0xFFDEAD, 0);
			hit.graphics.drawRect( 0, 0, this.width, this.height );
			hit.buttonMode = true;
			
			hit.addEventListener( MouseEvent.MOUSE_OVER, _onMouseOver, false, 0, true );
			hit.addEventListener( MouseEvent.MOUSE_OUT, _onMouseOut, false, 0, true );
			hit.addEventListener( MouseEvent.CLICK, _onClick, false, 0, true );
			
			this.addChild(hit)
			
			_onMouseOut( null );
		}
		
		// _____________________________ Events

		private function _onMouseOver ( e:Event ):void
		{
			if( !_isSelected && _txt != null)
				Tweener.addTween(_txt, {_color: 0x99E6F9, time:0});
		}

		private function _onMouseOut ( e:Event ):void
		{
			if( !_isSelected && _txt != null )
				Tweener.addTween(_txt, {_color: 0xFFFFFF, time:0});
		}

		private function _onClick ( e:Event ):void
		{			
			var navBtnClick:NavEvent = new NavEvent( NavEvent.NAV_BTN_CLICK, true );
			navBtnClick.id = _id;
			dispatchEvent( navBtnClick );
		}
		
	}
}