package app.model.vo
{

public class StockDefaultCategoryVo
{
	public var text:String;
	public var src:String;
	public var searchTerm:String;
	
	public function StockDefaultCategoryVo( $json:Object ):void
	{
		text 		= $json.text;
		src			= $json.src;
		searchTerm	= $json.search_term;
		trace( searchTerm );
	}
	
	public function toString (  ):String
	{
		return text + '  :  ' + searchTerm + '  :  ' + src;
	}
}

}