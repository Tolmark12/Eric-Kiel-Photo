package app.view.components
{

import flash.display.*;
import app.model.vo.NavItemVo;
import flash.events.*;
import app.view.components.events.NavEvent;
import caurina.transitions.Tweener;
	
public class NavItemComingSoon extends NavItem
{
	
	private var _comingSoon:ComingSoon;
	
	public function NavItemComingSoon( $navItemVo:NavItemVo ):void
	{
		super($navItemVo);
	}
	
	// _____________________________ Build
	
	override protected function _build ( $navItemVo:NavItemVo ):void
	{
		super._build($navItemVo);
		
		// Build the contact
		_comingSoon 	= new ComingSoon($navItemVo.sub)
		_comingSoon.y 	= Math.round( this.y + this.height + 20 );
		_comingSoon.deactivate();
		this.addChild(_comingSoon);
		
		// Remove the rollout handler since we're
		// handling that below with enterframe
		_hitArea.removeEventListener( MouseEvent.MOUSE_OUT, _onMouseOut );
	}
	
	// _____________________________ Events
	
	private function _onEnterFrame ( e:Event ):void {
		if( _hitArea.mouseX < 0 || _hitArea.mouseY < 0 || _hitArea.mouseX > _hitArea.width ||  _hitArea.mouseY > _hitArea.height/_hitArea.scaleY )
			_onMouseOut(null);
	}
	
	override protected function _onMouseOver ( e:Event ):void {
		if( !_comingSoon.isActive ){
			
			// Resize hit area
			_hitAreaWidth 		= _hitArea.width;
			_hitAreaHeight		= _hitArea.height;
			_hitAreaX			= _hitArea.x;
			_hitArea.height 	= _comingSoon.y + _comingSoon.height;
			_hitArea.width 		= _comingSoon.x + _comingSoon.width;
			_hitArea.x 			= 0 - _comingSoon.width + 50;
			_comingSoon.activate();

			this.stage.addEventListener( Event.ENTER_FRAME, _onEnterFrame, false,0,true );
			super._onMouseOver(e);
		}
	}
	
	override protected function _onMouseOut ( e:Event ):void {
		if( _comingSoon.isActive )
			_comingSoon.deactivate();
		
		_hitArea.x			= _hitAreaX;
		_hitArea.height 	= _hitAreaHeight;
		_hitArea.width 		= _hitAreaWidth;
		this.stage.removeEventListener( Event.ENTER_FRAME, _onEnterFrame );
		super._onMouseOut(e);
	}
	
	override protected function _onClick ( e:Event ):void {
	}

}

}