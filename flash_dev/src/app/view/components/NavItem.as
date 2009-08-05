package app.view.components
{

import flash.display.Sprite;
import app.model.vo.NavItemVo;
import flash.events.*;
import app.view.components.events.NavEvent;
import caurina.transitions.Tweener;

public class NavItem extends Sprite
{
	private var _txt:NavText_swc;
	private var _isSelected:Boolean = false;
	private var _id:String;
	private var _subNav:SubNav;
	
	public function NavItem( $navItemVo:NavItemVo ):void
	{
		this.buttonMode = true;
		this.mouseChildren = false;
		_id = $navItemVo.id;
		_build($navItemVo);
	}
	
	// _____________________________ API
	
	public function activate (  ):void
	{
		_onMouseOver(null);
		_isSelected = true;
	}
	
	public function deactivate (  ):void
	{
		_isSelected = false;
		_onMouseOut(null);
	}
	
	// _____________________________ Helpers
	
	private function _build ( $navItemVo:NavItemVo ):void
	{
		this.addEventListener( MouseEvent.MOUSE_OVER, _onMouseOver, false,0,true );
		this.addEventListener( MouseEvent.MOUSE_OUT, _onMouseOut, false,0,true );
		this.addEventListener( MouseEvent.CLICK, _onClick, false,0,true );
		
		if( !$navItemVo.isLogo ) {
			// Text
			_txt = new NavText_swc();
			this.addChild( _txt );
			_txt.titleTxt.autoSize = "left";
			_txt.titleTxt.text = $navItemVo.text.toLowerCase();
			_txt.y = 24;
			// Hit area
			this.graphics.beginFill(0xFF0000, 0);
			var hitPadding:Number  = 5;
			this.graphics.drawRect( -hitPadding, 19,this.width + hitPadding*3, this.height + hitPadding );
			if( $navItemVo.subNav != null ) {
				_subNav = new SubNav($navItemVo.subNav);
			}
		}else{
			var logo:Logo_swc = new Logo_swc();
			this.addChild(logo);
		}
	}
	
	// _____________________________ Events
	
	private function _onMouseOver ( e:Event ):void {
		if( !_isSelected && _txt != null)
			Tweener.addTween(this, {_color: 0xFFFFFF, time:0});
	}
	
	private function _onMouseOut ( e:Event ):void {
		if( !_isSelected && _txt != null )
			Tweener.addTween(this, {_color: 0x000000, time:0});
	}
	
	private function _onClick ( e:Event ):void {
		if( _subNav != null ) {
			
		}else {
			var navBtnClick:NavEvent = new NavEvent( NavEvent.NAV_BTN_CLICK, true );
			navBtnClick.id = _id;
			dispatchEvent( navBtnClick );
		}
	}
	
	// _____________________________ Getters / Setters
	
	override public function get width (  ):Number
	{
		if( _txt != null )
			return _txt.titleTxt.textWidth;
		else
			return super.width + 380;
	}
	
	public function get id (  ):String{ return _id; };

}

}