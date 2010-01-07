package app.model.vo
{

public class StockDefaultCategoryVo
{
	public var text:String;
	public var src:String;
	public var tags:Array;
	
	public function StockDefaultCategoryVo( $json:Object ):void
	{
		text 	= $json.text;
		src		= $json.src;
		tags	= $json.tag.split( "," );
	}
	
	public function toString (  ):String
	{
		return text + '  :  ' + tags + '  :  ' + src;
	}
}

}