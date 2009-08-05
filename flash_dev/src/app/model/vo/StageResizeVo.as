package app.model.vo
{

import flash.display.Stage;

public class StageResizeVo
{
	public static const MIN_WIDTH:Number = 960;
	public static const CENTER:Number = 512;
	public static var lastResize:StageResizeVo;
	
	public var left:Number;
	public var right:Number;
	public var width:Number;
	public var height:Number;
	public var halfWid:Number;
	public var isSmallerThanMinWidth:Boolean;
	
	public function StageResizeVo ( $stage:Stage ):void
	{
		width 	= $stage.stageWidth;
		height	= $stage.stageHeight;
		halfWid = width/2;
		left	= Math.round(CENTER - halfWid );
		right	= Math.round(CENTER + halfWid );			
		lastResize = this;
		isSmallerThanMinWidth = width<MIN_WIDTH;
	}
}

}