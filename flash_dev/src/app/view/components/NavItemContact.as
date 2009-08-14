package app.view.components
{

import flash.display.*;
import app.model.vo.NavItemVo;
import flash.events.*;
import app.view.components.events.NavEvent;
import caurina.transitions.Tweener;
	
public class NavItemContact extends NavItem
{
	
	private var _contact:Contact;
	
	public function NavItemContact( $navItemVo:NavItemVo ):void
	{
		super($navItemVo);
	}
	
	// _____________________________ Build
	
	override protected function _build ( $navItemVo:NavItemVo ):void
	{
		super._build($navItemVo);
		
		// Build the contact
		_contact 	= new Contact($navItemVo.sub)
		_contact.y 	= this.y + this.height + 20;
		_contact.deactivate();
		this.addChild(_contact);
		
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
		if( !_contact.isActive ){
			
			// Resize hit area
			_hitAreaWidth 		= _hitArea.width;
			_hitAreaHeight		= _hitArea.height;
			_hitAreaX			= _hitArea.x;
			_hitArea.height 	= _contact.y + _contact.height;
			_hitArea.width 		= _contact.x + _contact.width;
			_hitArea.x 			= -_contact.width + 50;
			_contact.activate();

			this.stage.addEventListener( Event.ENTER_FRAME, _onEnterFrame, false,0,true );
			super._onMouseOver(e);
		}
	}
	
	override protected function _onMouseOut ( e:Event ):void {
		if( _contact.isActive )
			_contact.deactivate();
		
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