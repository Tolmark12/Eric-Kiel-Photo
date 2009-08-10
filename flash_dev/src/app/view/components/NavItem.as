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
	protected var _hitArea:Sprite = new Sprite();
	
	// Hit area size snapshot
	protected var _hitAreaWidth:Number;
	protected var _hitAreaHeight:Number;
	
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
	
	protected function _build ( $navItemVo:NavItemVo ):void
	{
		if( !$navItemVo.isLogo ) {
			
			// Text
			_txt = new NavText_swc();
			this.addChild( _txt );
			_txt.titleTxt.autoSize = "left";
			_txt.titleTxt.text = $navItemVo.text;
			_txt.y = 24;
			
			// Create hit area and add event listeners to that
			var hitPadding:Number  	= 5;
			_hitArea.graphics.beginFill(0x99FF00, 0);
			_hitArea.graphics.drawRect( 0,0,this.width + hitPadding*3, this.height + hitPadding );
			_hitArea.x = -hitPadding;
			_hitArea.y = 19;
			_hitArea.buttonMode = true;
			this.addChild(_hitArea)
			

			_hitArea.addEventListener( MouseEvent.MOUSE_OVER, _onMouseOver, false,0,true );
			_hitArea.addEventListener( MouseEvent.MOUSE_OUT, _onMouseOut, false,0,true );
			_hitArea.addEventListener( MouseEvent.CLICK, _onClick, false,0,true );
			
		}else{
			var logo:Logo_swc = new Logo_swc();
			this.addChild(logo);
		}
	}
	
	// _____________________________ Events
	
	protected function _onMouseOver ( e:Event ):void {
		// Change text color
		if( !_isSelected && _txt != null)
			Tweener.addTween(_txt, {_color: 0xFFFFFF, time:0});
	}
	
	protected function _onMouseOut ( e:Event ):void {
		// Change text Color
		if( !_isSelected && _txt != null )
			Tweener.addTween(_txt, {_color: 0x000000, time:0});
	}
	
	protected function _onClick ( e:Event ):void {
			var navBtnClick:NavEvent = new NavEvent( NavEvent.NAV_BTN_CLICK, true );
			navBtnClick.id = _id;
			dispatchEvent( navBtnClick );
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