package app.view.components
{

import flash.display.Sprite;
import app.view.components.stock_tags.*;

public class StockTags extends Sprite
{
	private var _search:Search_swc = new Search_swc();;
	
	public function StockTags():void
	{
		this.addChild( _search );
	}
	
	/** 
	*	Clear
	*/
	public function clear (  ):void
	{
		
	}
	
	public function displaySearchTagHints ( $array:Array ):void
	{
		_search.showHints( $array );
	}

}

}