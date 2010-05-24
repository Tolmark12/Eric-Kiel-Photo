package app.view.components
{

import flash.display.Sprite;
import app.model.vo.DialogueVo;
import app.view.components.swc.NavText;
import flash.geom.ColorTransform;
import flash.filters.*;
import caurina.transitions.Tweener;
import flash.events.*;

public class ModalDialogueBox extends Modal
{
	private var _navText:NavText = new NavText_swc();
	private var _okBtn:SimpleTextButton = new SimpleTextButton_swc();
	
	public function ModalDialogueBox($width:Number, $height:Number):void
	{
		this.alpha = 0;
		super($width, $height);
		
		_navText.x = _navText.y			= super.PADDING;
		_navText.titleTxt.width			= $width - super.PADDING*2;
		_navText.titleTxt.wordWrap	 	= true;
		_okBtn.build( "OK" );
		_okBtn.hideArrow();
		_okBtn.x = $width - 50;
		super._closeBtn.visible = false;
		
		this.addChild( _okBtn );
		
		var newColorTransform:ColorTransform = _navText.transform.colorTransform;
		newColorTransform.color = 0x88A0AB;
		_navText.transform.colorTransform = newColorTransform;
		
		this.filters = [ _getBitmapFilter() ];
		this.addChild(_navText);
		
		_okBtn.addEventListener( MouseEvent.CLICK, _onOkClick, false,0,true );
	}
	
	public function showMessage ( $dialogueMessageVo:DialogueVo ):void
	{
		this.visible = true;
		Tweener.addTween( this, { alpha:1, time:0.4, transition:"EaseInOutQuint"} );
		_navText.text = $dialogueMessageVo.message;
		_okBtn.y = _navText.y + _navText.height + super.PADDING;
		super.updateHeight(_okBtn.y + _okBtn.height + super.PADDING);
		if( $dialogueMessageVo.hideButtons )
			_okBtn.visible = false;
		else
			_okBtn.visible = true;
	}
	
	override public function clear (  ):void
	{
		Tweener.addTween( this, { alpha:0, time:0.2, transition:"EaseInOutQuint", onComplete:_hideForGood} );
	}
	
	private function _getBitmapFilter():BitmapFilter {
        var color:Number = 0x000000;
        var alpha:Number = 0.4;
        var blurX:Number = 35;
        var blurY:Number = 35;
        var strength:Number = 2;
        var inner:Boolean = false;
        var knockout:Boolean = false;
        var quality:Number = BitmapFilterQuality.HIGH;

        return new GlowFilter(color,
                              alpha,
                              blurX,
                              blurY,
                              strength,
                              quality,
                              inner,
                              knockout);
    }

	private function _hideForGood (  ):void {
		this.visible = false;
	}
	
	private function _onOkClick ( e:Event ):void {
		_onCloseClick(null);
	}
}

}