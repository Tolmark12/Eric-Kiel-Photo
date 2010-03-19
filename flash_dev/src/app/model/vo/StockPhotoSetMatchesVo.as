package app.model.vo
{

public class StockPhotoSetMatchesVo extends StockPhotoSetVo
{
	public function StockPhotoSetMatchesVo( $json:Object ):void
	{
		super($json);
	}
	
	override public function get displayStack (  ):Vector.<StockPhotoVo>
	{
		return super.stack;
	}
	

}

}