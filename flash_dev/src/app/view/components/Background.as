package app.view.components
{

import flash.display.*;
import delorum.loading.ImageLoader;
import flash.events.*;
import caurina.transitions.Tweener;
import app.model.vo.StageResizeVo;

public class Background extends Sprite
{
	public var alignCenter:Boolean;
	private var _lowResMc:Sprite;
	private var _highResMc:Sprite;
	private var _highResPath:String;
	
	private var _oldLowRes:Sprite;
	private var _oldHighRes:Sprite;
	
	private var _lowResLoader:ImageLoader;
	private var _highResLoader:ImageLoader;
	
	public function Background():void
	{
	}
	
	public function loadSet ( $lowRes:String, $highRes:String ):void
	{
		_createBgBitmap();
		_createShapShot();
		_addHolders();
		_highResPath = $highRes;
		
		// If the previous low res image has not yet loaded, cancel it
		if( _lowResLoader != null )
			_lowResLoader.cancelLoad();

		// Load the low res image
		_lowResLoader = new ImageLoader( $lowRes, _lowResMc );
		_lowResLoader.addEventListener( Event.COMPLETE, _onLowResComplete, false, 0, true );
		_lowResLoader.loadItem();
	}
	
	// _____________________________ Events
	
	private function _onLowResComplete ( e:Event ):void {
		// Center image if this is the first load.. 
		// though currently it calls this each load, 
		// not just the first time
		onStageResize( StageResizeVo.lastResize );
		
		// delete ref to the low res loader
		_lowResLoader = null;
		// Fade in the image
		Tweener.addTween( _lowResMc, { alpha:1, time:3, transition:"EaseInOutQuint", onComplete:_onLowResFadeIn} );

		// If previous high res image not loaded, cancel it
		if( _highResLoader != null )
			_highResLoader.cancelLoad();
		
		// Load the hig res image
		_highResLoader = new ImageLoader( _highResPath, _highResMc );
		_highResLoader.addEventListener( Event.COMPLETE, _onHighResComplete );
		_highResLoader.loadItem();
	}
	
	private function _onHighResComplete ( e:Event ):void {
		_highResLoader = null;
		Tweener.removeTweens( _highResMc, alpha )
		Tweener.addTween( _highResMc, { alpha:1, time:3, transition:"EaseInOutQuint"} );
	}
	
	public function onStageResize ( $stageResize:StageResizeVo ):void
	{
		if( alignCenter )
			this.x = StageResizeVo.CENTER - this.width/2;
		else
			this.x = $stageResize.left;
	}
	
	private function _onLowResFadeIn (  ):void
	{
	}
	
	// _____________________________ Helpers
	
	/** 
	*	Create the holders, initialize them, add to stage
	*/
	private function _addHolders (  ):void
	{
		_lowResMc			= new Sprite();
		_highResMc 			= new Sprite();
		_highResMc.alpha 	= 0;
		_lowResMc.alpha		= 0;
		this.addChild(_lowResMc);
		this.addChild(_highResMc);
	}
	
	
	// _____________________________ Background
	
	private var _bgBitmap:Bitmap;
	private var _bgBitmapData:BitmapData;
	
	/** 
	*	Create the background bitmap
	*/
	private function _createBgBitmap (  ):void
	{
		if( _bgBitmapData == null ) 
		{
			_bgBitmapData = new BitmapData(1450,700, false, 0x222222/*this.width, this.height*/);
			_bgBitmap = new Bitmap(_bgBitmapData);
			this.addChildAt(_bgBitmap, 0)
		}
	}
	
	/** 
	*	Take a snapshot of the image, set it as the background, 
	*	and remove the old sprites. 
	*/
	private function _createShapShot (  ):void
	{
		// Draw the background image
		_bgBitmapData.draw(this);
		
		// Remove the old images
		if( _lowResMc != null ) 
		{
			this.removeChild(_highResMc);
			this.removeChild(_lowResMc);
		}
		
	}
	

}

}