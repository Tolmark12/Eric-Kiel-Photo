package app.view.components
{

import flash.display.Sprite;
import app.model.vo.StockPhotoVo;

public class StockPhoto extends Sprite
{
	public var id:String;
	
	public function StockPhoto( $vo:StockPhotoVo ):void
	{
		id 	= $vo.id;
	}
	
	public function clear (  ):void
	{
		
	}
	
	public function build ( $width:Number ):void
	{
		// TEMP
		this.graphics.clear();
		this.graphics.beginFill(0xDDDDDD, 0.3);
		this.graphics.drawRect(0,0,$width, 200);
	}
	
	override public function toString (  ):String
	{
		return this.width + '  :  ' + this.x + '  :  ' + this.y + '  :  ' + this.visible + '  :  ' + this.parent + '  :  ' + this.alpha + '  :  ' + this.parent.x + '  :  ' + this.parent.y + '  :  ' + this.parent.parent.x;
	}

}

}