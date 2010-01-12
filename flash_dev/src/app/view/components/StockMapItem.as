package app.view.components
{

import flash.display.Sprite;

public class StockMapItem extends Sprite
{
	public function StockMapItem():void
	{
		
	}
	
	public function build ( $width:Number ):void
	{
		this.graphics.clear();
		this.graphics.beginFill(0xDDDDDD, 1);
		this.graphics.drawRect(0,0, Math.round( $width * StockMap.SHRINK_PERCENTAGE ), Math.round( 141 * StockMap.SHRINK_PERCENTAGE ));
	}
	
	public function clear (  ):void
	{
		
	}

}

}