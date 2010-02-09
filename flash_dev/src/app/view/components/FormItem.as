package app.view.components
{

import flash.display.*;
import flash.text.*;
import app.model.vo.FieldVO;
import flash.events.*;
import flash.geom.ColorTransform;
import app.view.components.events.ModalEvent;

public class FormItem extends Sprite
{
	public static const INVALID:Number = 0x999999;
	public static const VALID:Number = 0x97D557;

	private var _inputTxt:TextField;
	private var _labelTxt:TextField;
	private var _txtBg:Sprite;
	private var _regex:RegExp;
	public var isValid:Boolean = true;
	
	public function FormItem():void
	{
		_inputTxt = this.getChildByName( "inputTxt" ) as TextField;
		_labelTxt = this.getChildByName( "labelTxt" ) as TextField;
		_txtBg = this.getChildByName( "txtBg" ) as MovieClip;
	}
	
	public function build ( $fieldVo:FieldVO ):void
	{
		_regex					= $fieldVo.regexValidation;
	//	_inputTxt.text 			= $fieldVo.defaultText;
		_labelTxt.text 			= $fieldVo.title;
		_inputTxt.height		= 18 * $fieldVo.lines;
		_inputTxt.multiline 	= true;
		_txtBg.height			= _inputTxt.height + 10;
		
		if( _regex != null ){
			_inputTxt.addEventListener( Event.CHANGE, _onChange, false,0,true );
			isValid = false;
		}	
		_updateValidationDisplay();
	}
	
	// _____________________________ Helpers
	
	private function _updateValidationDisplay (  ):void {
		var newColorTransform:ColorTransform = _txtBg.transform.colorTransform;
		if( isValid )
			newColorTransform.color = VALID;
		else
			newColorTransform.color = INVALID;
        
		_txtBg.transform.colorTransform = newColorTransform;
	}
	
	// _____________________________ Event Handlers
	
	private function _onChange ( e:Event ):void {
		if( _regex.exec( _inputTxt.text ) != null )
			isValid = true;
		else
			isValid = false;
		
		_updateValidationDisplay();
		dispatchEvent( new ModalEvent(ModalEvent.INPUT_CHANGE, true) );
	}
	
	
	public function get inputField (  ):TextField{ return _inputTxt; };

}

}