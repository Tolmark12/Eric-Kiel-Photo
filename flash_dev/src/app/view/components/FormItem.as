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
	public static const VALID:Number = 0xC7BC65;
	public static const IS_VALID_FOCUS_IN:Number = 0xF2E57B;
	public static const NOT_VALID_FOCUS_IN:Number = 0xCCCCCC;

	private var _urlVarName:String;
	private var _inputTxt:TextField;
	private var _labelTxt:TextField;
	private var _txtBg:Sprite;
	private var _regex:RegExp;
	private var _icon:Check_swc;
	public var isValid:Boolean = true;
	
	public function FormItem():void
	{
		_inputTxt = this.getChildByName( "inputTxt" ) as TextField;
		_labelTxt = this.getChildByName( "labelTxt" ) as TextField;
		_txtBg = this.getChildByName( "txtBg" ) as MovieClip;
		_icon = this.getChildByName( "icon" ) as Check_swc;
		_inputTxt.addEventListener( FocusEvent.FOCUS_IN, _onInputTxtFocusIn, false,0,true );
		_inputTxt.addEventListener( FocusEvent.FOCUS_OUT, _onInputTxtFocusOut, false,0,true );
	}
	
	public function build ( $fieldVo:FieldVO ):void
	{
		_regex					= $fieldVo.regexValidation;

		_labelTxt.text 			= $fieldVo.title;
		_labelTxt.autoSize 		= "left";
		_inputTxt.height		= 18 * $fieldVo.lines;
		_inputTxt.multiline 	= true;
		_txtBg.height			= _inputTxt.height + 10;
		_urlVarName				= $fieldVo.urlVarName;
		_labelTxt.x 			= 60 - _labelTxt.textWidth;
		
		if( _regex != null ){
			_inputTxt.addEventListener( Event.CHANGE, _onChange, false,0,true );
			isValid = false;
		}	
		
		if( $fieldVo.defaultText != null ){
			_inputTxt.text 		= $fieldVo.defaultText;
			_onChange(null);
		}
		
		_updateValidationDisplay();
	}
	
	// _____________________________ Helpers
	
	private function _updateValidationDisplay ( $focusIn:Boolean = false ):void {
		var newColorTransform:ColorTransform = _txtBg.transform.colorTransform;
		
		
		if( isValid && $focusIn ) {					// Is valid & received focus
			_icon.gotoAndStop("_valid");
			newColorTransform.color = IS_VALID_FOCUS_IN;
		} else if( isValid && !$focusIn ) {			// is valid, lose focus
			_icon.gotoAndStop("_valid");
			newColorTransform.color = VALID;
		} else if( !isValid && $focusIn ) {			// is not valid, gain focus
			_icon.gotoAndStop("_invalid");
			newColorTransform.color = NOT_VALID_FOCUS_IN;
		}else{
			_icon.gotoAndStop("_invalid")
			newColorTransform.color = INVALID;
        }

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
	
	private function _onInputTxtFocusIn ( e:Event ):void {
		_updateValidationDisplay(true);
		//_inputTxt.stage.focus = _inputTxt;
		//_inputTxt.setSelection(0,0);
	}
	
	private function _onInputTxtFocusOut ( e:Event ):void {
		_updateValidationDisplay(false);
		//_inputTxt.stage.focus = _inputTxt;
		//_inputTxt.setSelection(0,0);
	}
	
	
	public function get inputField (  ):TextField{ return _inputTxt; };
	public function get varName (  ):String{ return _urlVarName; };
	public function get userInput (  ):Object{ return _inputTxt.text; trace( _inputTxt.text ); };

}

}