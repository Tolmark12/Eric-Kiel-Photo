package app.view.components
{
	import flash.display.Sprite;
	import flash.events.*;
	import caurina.transitions.Tweener;
	import app.view.components.events.NavEvent;
	import app.model.vo.NavItemVo;
	
	public class SubNavItem extends Sprite
	{
		private var _txt:NavText_swc;
		private var _isSelected:Boolean = false;
		private var _isDeactivated:Boolean = false;
		
		public var kind:String;
		public var id:String;
		public var tag:String;
	
		public function SubNavItem( $navItemVo:NavItemVo ):void
		{
			id 		= $navItemVo.id;
			kind	= $navItemVo.pageType;
			tag		= $navItemVo.tag;
			
			// Text
			_txt = new NavText_swc();
			this.addChild( _txt );
			
			_txt.text = $navItemVo.text;
			
			// Create hit area and add event listeners to that
			var hit:Sprite 			= new Sprite();
			var hitPadding:Number  	= 5;
			hit.graphics.beginFill(0xFFDEAD, 0);
			hit.graphics.drawRect( 0, 0, this.width, this.height );
//			hit.buttonMode = true;
			
			hit.addEventListener( MouseEvent.MOUSE_OVER, _onMouseOver, false, 0, true );
			hit.addEventListener( MouseEvent.MOUSE_OUT, _onMouseOut, false, 0, true );
			hit.addEventListener( MouseEvent.CLICK, _onClick, false, 0, true );
			
			this.addChild(hit)
			
			_onMouseOut( null );
		}
		
		// _____________________________ API

		public function activate (  ):void
		{
			_isDeactivated = false;
			_onMouseOver(null);
			_isSelected = true;
		}

		public function deactivate (  ):void
		{
			_isSelected = false;
			_isDeactivated = true;
			_onMouseOut(null);
		}
		
		// _____________________________ Events

		private function _onMouseOver ( e:Event ):void
		{
			if( !_isSelected && _txt != null)
				if( _isDeactivated )
					Tweener.addTween(_txt, {_color: 0x777777, time:0});
				else
					Tweener.addTween(_txt, {_color: 0xFFFFFF, time:0});
			
			//blue - 0x99E6F9
		}

		private function _onMouseOut ( e:Event ):void
		{
			if( !_isSelected && _txt != null )
				if( _isDeactivated )
					Tweener.addTween(_txt, {_color: 0x555555, time:0});
				else
					Tweener.addTween(_txt, {_color: 0xFFFFFF, time:0});
		}

		private function _onClick ( e:Event ):void
		{
			var navBtnClick:NavEvent;
			
			if( kind != "filter" ) {
				navBtnClick = new NavEvent( NavEvent.NAV_BTN_CLICK, true );
				navBtnClick.id = id;
			} else {
				if( _isSelected )
					navBtnClick = new NavEvent( NavEvent.REMOVE_FILTER, true );
				else
					navBtnClick = new NavEvent( NavEvent.ADD_FILTER, true );
					navBtnClick.tag = tag;
			}
			
			dispatchEvent( navBtnClick );
			

		}
	}
}