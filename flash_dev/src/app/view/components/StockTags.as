package app.view.components
{

import flash.display.Sprite;
import app.view.components.stock_tags.Search;
public class StockTags extends Sprite
{
	private var _search:Search = new Search_swc();;
	
	public function StockTags():void
	{
		this.addChild( _search );
		hide();
	}
	
	/** 
	*	Clear
	*/
	public function clear (  ):void
	{
		hide();
	}
	
	public function show (  ):void
	{
		this.visible = true;
	}
	
	public function hide (  ):void
	{
		this.visible = false;
	}
	
	public function disableFiltering (  ):void
	{
		_search.disableFiltering();
	}
	
	public function enableFiltering (  ):void
	{
		_search.enableFiltering();
	}
	
	public function displaySearchTagHints ( $array:Array ):void
	{
		_search.showHints( $array );
	}

}

}