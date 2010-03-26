package app.view.components
{

import flash.display.Sprite;
import flash.geom.ColorTransform;
import caurina.transitions.Tweener;

public class LoadingDisplay extends Sprite
{
	public static const WIDTH:Number 	= 1000;
	private static const _LIGHT_COLOR:Number = 0xFFFFFF;
	private static const _DARK_COLOR:Number = 0x222222;
	private var _txt:NavText_swc 		= new NavText_swc();
	private var _loadingBg:Sprite 		= new Sprite();
	private var _loadingBar:Sprite  	= new Sprite();
	
	public function LoadingDisplay():void
	{
		this.addChild( _txt );
		_txt.y = 10;
		// Changes mc's color to red.
		var newColorTransform:ColorTransform = this.transform.colorTransform;
		newColorTransform.color = _LIGHT_COLOR;
		_txt.transform.colorTransform = newColorTransform;
		
		_drawLoadingBar()
	}
	
	
	// _____________________________ API
	
	/** 
	*	Update the display
	*	@param		Total items that have loaded
	*	@param		Total items
	*/
	public function update ( $loaded:Number, $total:Number, $stageWidth:Number ):void
	{
		var perc:Number = Math.round( ($loaded / $total)*100 )
		_loadingBg.width = $stageWidth;
		Tweener.addTween( _loadingBar, { width:perc/100 * _loadingBg.width, time:0.3, transition:"EaseOutQuint"} );
		
		if( $loaded >= $total ){
			hide();
			_txt.htmlText = "<font size='10'>All images loaded</font>";
		}else
			_txt.htmlText = "<font size='10'>Pre-Loading Images: " + perc +  "%</font>";
			
		_txt.x = $stageWidth/2 - _txt.titleTxt.textWidth/2;
	}
	
	/** 
	*	Reset the display
	*/
	public function reset (  ):void
	{
		_txt.text = "";
		Tweener.removeTweens( this, "alpha" );
	}
	
	// _____________________________ Helpers
	
	public function hide ( $hideFast:Boolean = false ):void
	{
		Tweener.removeTweens( this, "alpha" );
		if( $hideFast )
			Tweener.addTween( this, { alpha:0, time:1, transition:"EaseInOutQuint", onComplete:_makeInvisible} );
		else
			Tweener.addTween( this, { alpha:0, delay:1, time:4, transition:"EaseInOutQuint", onComplete:_makeInvisible} );
	}
	
	private function _makeInvisible (  ):void
	{
		this.visible = false
	}
	
	public function show (  ):void
	{
		Tweener.removeTweens( this, "alpha" );
		this.alpha = 1;
		this.visible = true;
	}
	
	private function _drawLoadingBar (  ):void
	{
		_loadingBg.graphics.beginFill(_DARK_COLOR);
		_loadingBg.graphics.drawRect(0,0,WIDTH,3);
		_loadingBar.graphics.beginFill(_LIGHT_COLOR);
		_loadingBar.graphics.drawRect(0,0,WIDTH,3);
		_loadingBar.scaleX = 0;
		_loadingBar.alpha = 0.8;
		
		this.addChild(_loadingBg);
		this.addChild(_loadingBar);
	}

}

}