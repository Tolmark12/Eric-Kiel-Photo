package app.view.components
{

import flash.display.Sprite;
import app.model.vo.StockDefaultCategoryVo;
import delorum.loading.ImageLoader;
import caurina.transitions.Tweener;
import flash.events.*;

public class StockLandingMainCat extends Sprite
{
	private var _imageHolder:Sprite;
	public var tags:Array;
	
	public function StockLandingMainCat( $vo:StockDefaultCategoryVo ):void
	{
		// Build / set vars
		_loadImage( $vo.src )
		_addText( $vo.text );
		tags = $vo.tags;

		// init
		this.alpha = 0;
		this.buttonMode = true;
		
		// RollOver Events
		this.addEventListener( MouseEvent.MOUSE_OVER, _onMouseOver, false,0,true );
		this.addEventListener( MouseEvent.MOUSE_OUT, _onMouseOut, false,0,true );
	}
	
	// _____________________________ Helpers
	
	// Load the main image
	private function _loadImage ( $image:String ):void
	{
		_imageHolder = new Sprite();
		var ldr:ImageLoader = new ImageLoader( $image, _imageHolder );
		ldr.addEventListener( Event.COMPLETE, _onImageLoad );
		ldr.loadItem();
		this.addChild(_imageHolder);
	}
	
	// Add the title
	private function _addText ( $title:String ):void
	{
		var txt:FuturaBoldItalic_swc = new FuturaBoldItalic_swc();
		txt.titleTxt.text = $title.toUpperCase();
		txt.y = -22;
		this.addChild(txt);
	}
	
	public function clear (  ):void
	{
		this.removeEventListener( MouseEvent.MOUSE_OVER, _onMouseOver )
		this.removeEventListener( MouseEvent.MOUSE_OUT, _onMouseOut );
		_imageHolder.visible = false;
		_imageHolder = null
	}
	
	// _____________________________ Event Handlers
	
	private function _onImageLoad ( e:Event ):void {
		Tweener.addTween( this, { alpha:1, time:1, transition:"EaseInOutQuint"} );
	}

	private function _onMouseOver ( e:Event ):void{
		Tweener.removeTweens(this, "alpha");
		Tweener.addTween( this, { alpha:0.9, time:0.2, transition:"EaseInOutQuint"} );
	}
	
	private function _onMouseOut ( e:Event ):void{
		Tweener.removeTweens(this, "alpha");
		Tweener.addTween( this, { alpha:1, time:0.4, transition:"EaseInOutQuint"} );
	}
}

}