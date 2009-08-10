package app.view.components
{

import flash.display.*;
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
		if( !$navItemVo.isLogo ) {
			// Text
			_txt = new NavText_swc();
			this.addChild( _txt );
			_txt.titleTxt.autoSize = "left";
			_txt.titleTxt.text = $navItemVo.text.toLowerCase();
			_txt.y = 24;
			
			// Create hit area and add event listeners to that
			var hitAreaMc:Sprite 	= new Sprite();
			var hitPadding:Number  	= 5;
			hitAreaMc.graphics.beginFill(0x99FF00, 0);
			hitAreaMc.graphics.drawRect( -hitPadding, 19,this.width + hitPadding*3, this.height + hitPadding );
			hitAreaMc.buttonMode = true;
			
			hitAreaMc.addEventListener( MouseEvent.MOUSE_OVER, _onMouseOver, false,0,true );
			hitAreaMc.addEventListener( MouseEvent.MOUSE_OUT, _onMouseOut, false,0,true );
			hitAreaMc.addEventListener( MouseEvent.CLICK, _onClick, false,0,true );
			
			this.addChild(hitAreaMc)
			
			if( $navItemVo.subNav != null ) {
				_subNav = new SubNav();
				_subNav.build( $navItemVo.subNav );
				_subNav.y = this.y + this.height + 34;
				this.addChild( _subNav );
			}
		}else{
			var logo:Logo_swc = new Logo_swc();
			this.addChild(logo);
		}
	}
	
	// _____________________________ Events
	
	private function _onMouseOver ( e:Event ):void {
		if( !_isSelected && _txt != null)
			Tweener.addTween(_txt, {_color: 0xFFFFFF, time:0});
	}
	
	private function _onMouseOut ( e:Event ):void {
		if( !_isSelected && _txt != null )
			Tweener.addTween(_txt, {_color: 0x000000, time:0});
	}
	
	private function _onClick ( e:Event ):void {
		if( _subNav != null ) {
			if( _subNav.isActive )
				_subNav.deactivate();
			else
				_subNav.activate();
			
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