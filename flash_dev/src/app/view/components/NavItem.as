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
	private var _hitArea:Sprite = new Sprite();
	
	// Hit area size snapshot
	private var _hitAreaWidth:Number;
	private var _hitAreaHeight:Number;
	
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
			var hitPadding:Number  	= 5;
			_hitArea.graphics.beginFill(0x99FF00, 0.4);
			_hitArea.graphics.drawRect( 0,0,this.width + hitPadding*3, this.height + hitPadding );
			_hitArea.x = -hitPadding;
			_hitArea.y = 19;
			_hitArea.buttonMode = true;
			


			this.addChild(_hitArea)
			
			if( $navItemVo.subNav != null ) {
				_subNav = new SubNav();
				_subNav.build( $navItemVo.subNav );
				_subNav.y = this.y + this.height + 34;
				this.addChild( _subNav );				
				_hitArea.addEventListener( MouseEvent.MOUSE_OVER, _onMouseOverWithSub, false,0,true );
			}else{
				_hitArea.addEventListener( MouseEvent.MOUSE_OVER, _onMouseOver, false,0,true );
				_hitArea.addEventListener( MouseEvent.MOUSE_OUT, _onMouseOut, false,0,true );
			}

			_hitArea.addEventListener( MouseEvent.CLICK, _onClick, false,0,true );
			
		}else{
			var logo:Logo_swc = new Logo_swc();
			this.addChild(logo);
		}
	}
	
	// _____________________________ Events
	
	private function _onMouseOver ( e:Event ):void {
		// Change text color
		if( !_isSelected && _txt != null)
			Tweener.addTween(_txt, {_color: 0xFFFFFF, time:0});
	}
	
	private function _onMouseOut ( e:Event ):void {
		// Change text Color
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
	
	// _____________________________ Events with sub menu
	
	private function _onMouseMove ( e:Event ):void {
		if( _hitArea.mouseX < 0 || _hitArea.mouseY < 0 || _hitArea.mouseX > _hitArea.width ||  _hitArea.mouseY > _hitArea.height )
			_onMouseOutWithSub(null);
	}
	
	private function _onMouseOverWithSub ( e:Event ):void {
		if( !_subNav.isActive ){
			
			// Resize hit area
			_hitAreaWidth 		= _hitArea.width;
			_hitAreaHeight		= _hitArea.height;
			_hitArea.height 	= _subNav.y + _subNav.height + 10;
			_hitArea.width 		= _subNav.x + _subNav.width + 10;
			
			_subNav.activate();
			this.stage.addEventListener( MouseEvent.MOUSE_MOVE, _onMouseMove, false,0,true );
		}
	}
	
	private function _onMouseOutWithSub ( e:Event ):void {
		if( _subNav.isActive )
			_subNav.deactivate();
		
		_hitArea.height 	= _hitAreaHeight;
		_hitArea.width 		= _hitAreaWidth;
		this.stage.removeEventListener( MouseEvent.MOUSE_MOVE, _onMouseMove );
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