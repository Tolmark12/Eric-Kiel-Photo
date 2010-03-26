package app.view.components.swc
{

import flash.display.*;
import flash.events.*;
import flash.text.TextField;

public class RadioBtn extends Sprite
{
	private var _dot:MovieClip;
	private var _titleTxt:TextField;
	public var setName:String;
	public var isActive:Boolean;
	
	public function RadioBtn( ):void
	{
		_dot = this.getChildByName( "dot" ) as MovieClip;
		_titleTxt = this.getChildByName( "titleTxt" ) as TextField;
		_titleTxt.autoSize = "left";
		this.graphics.beginFill(0xFF0000, 0);
		this.graphics.drawRect(0,0,this.width, this.height+3);
		this.buttonMode = true;
		this.mouseChildren = false;
	}
	
	public function build ( $setName:String, $text:String  ):void
	{
		this.addEventListener( MouseEvent.CLICK, _onClick, false,0,true );
		this.addEventListener( MouseEvent.MOUSE_OVER, _onMouseOver, false,0,true );
		this.addEventListener( MouseEvent.MOUSE_OUT, _onMouseOut, false,0,true );
		
		// Add this button to its set
		setName = $setName;
		RadioBtn._addToSet(this);
		// init
		_titleTxt.text = $text;
		deactivate();
	}
	
	public function activate (  ):void
	{
		isActive = true;
		_dot.visible = true;
		_deselectOtherItems(this);
	}
	
	public function deactivate (  ):void
	{
		isActive = false;
		_dot.visible = false;
	}
	
	// _____________________________ Event Handlers
	
	private function _onMouseOver ( e:Event ):void {
		
	}
	
	private function _onMouseOut ( e:Event ):void {
		
	}
	
	private function _onClick ( e:Event ):void {
		if( !isActive )
			activate();
	}
	
	
	// _____________________________ Static Members
	
	private static var _SETS:Object = {};
	
	private static function _addToSet ( $radioBtn:RadioBtn ):void {
		
		if( _SETS[$radioBtn.setName] == null )
			_SETS[$radioBtn.setName] = new Vector.<RadioBtn>();
			
		_SETS[$radioBtn.setName].push( $radioBtn );
	}
	
	private static function _deselectOtherItems ( $newRadioBtn:RadioBtn ):void {
		var ar:Vector.<RadioBtn> = _SETS[$newRadioBtn.setName];
		var len:uint = ar.length;
		for ( var i:uint=0; i<len; i++ ) 
		{
			if( ar[i] != $newRadioBtn )
				ar[i].deactivate();
		}
	}

}

}