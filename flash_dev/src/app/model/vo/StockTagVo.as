package app.model.vo
{

public class StockTagVo
{
	public var id:String;
	public var tag:String;
	public var rank:int;
	
	public function StockTagVo( $json:Object ):void{
		id		= $json.id;
		tag		= $json.name;
		rank	= Number( $json.rank );
	}
	
	public function toString (  ):String{
		return tag;
	}
	
	
}

}