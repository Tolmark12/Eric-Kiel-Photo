package app.model.vo
{

public class StockPhotoSetVo
{
	public var stack:Vector.<StockPhotoVo>;
	public function StockPhotoSetVo( $json:Object ):void
	{
		stack = new Vector.<StockPhotoVo>();
	}
}

}