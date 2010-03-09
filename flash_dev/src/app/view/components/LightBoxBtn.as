package app.view.components
{

import flash.display.Sprite;
import flash.text.TextField;
import app.model.vo.StageResizeVo;

public class LightBoxBtn extends Sprite
{
	
	private var _titleTxt:TextField;
	private var _lightBoxIcon:Sprite;
	
	public function LightBoxBtn():void
	{
		_lightBoxIcon 	= this.getChildByName( "lightBoxIcon" ) as Sprite;
		_titleTxt 		= this.getChildByName( "titleTxt" ) as TextField;
		this.buttonMode = true;
		this.mouseChildren = false;
		build();
		updateItemsInLightbox(0);
		clear();
	}
	
	
	/** 
	*	Update the total Items in the lightbox
	*/
	public function updateItemsInLightbox ( $total:Number ):void
	{
		var item:String = ($total == 1)? "item" : "items" ;
		_titleTxt.text = $total + " " + item + " in Lightbox";
	}
	
	public function position ( $stageResizeVo:StageResizeVo ):void
	{
		this.x = $stageResizeVo.left + 7;
		this.y = $stageResizeVo.height - this.height+7;
	}
	
	public function build (  ):void
	{
		this.graphics.beginFill( 0xFF0000, 0 );
		this.graphics.drawRect( -7, -7, this.width + 14, this.height + 14 );
	}
	
	public function init (  ):void
	{
		this.visible = true;
	}
	
	public function clear (  ):void
	{
		this.visible = false;
	}
	
}

}