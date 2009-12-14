package app.model.vo
{

public class StockDefaultCategoryVo
{
	public var text:String;
	public var src:String;
	public var tag:String;
	
	public function StockDefaultCategoryVo( $json:Object ):void
	{
		text 	= $json.text;
		src		= $json.src;
		tag		= $json.tag;
	}
	
	public function toString (  ):String
	{
		return text + '  :  ' + tag + '  :  ' + src;
	}
}

}