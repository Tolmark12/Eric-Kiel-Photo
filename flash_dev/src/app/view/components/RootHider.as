package app.view.components
{

import flash.display.*;
import flash.geom.*;
import app.model.vo.StageResizeVo;
import flash.filters.*;
import flash.utils.Timer;
import flash.events.*;
import flash.external.ExternalInterface;

public class RootHider extends Sprite
{
	public var theRoot:Sprite;
	
	public function RootHider():void
	{
		this.buttonMode = true;
		this.useHandCursor = false;
		this.filters = [ new BlurFilter(20, 5, BitmapFilterQuality.MEDIUM ) ];
		
		ExternalInterface.addCallback("showRoot", showRoot);
	}
	
	public function hideRoot (  ):void
	{
		var bmd:BitmapData = new BitmapData( StageResizeVo.lastResize.width, StageResizeVo.lastResize.height );
		var m:Matrix = new Matrix();
		m.tx = Math.abs( StageResizeVo.lastResize.left )
		bmd.draw(theRoot, m);
		var bm:Bitmap = new Bitmap( bmd );
		bm.x = StageResizeVo.lastResize.left;
		this.addChild( bm );
		theRoot.addChild(this);
	}
	
	public function showRoot (  ):void
	{
		this.removeChildAt(0);
		theRoot.removeChild(this);
	}

}

}