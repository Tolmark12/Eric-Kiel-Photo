package app.model.vo
{

public class StockPhotoSetVo
{
	public var stack:Vector.<StockPhotoVo>;
	public function StockPhotoSetVo( $json:Object ):void
	{
		stack = new Vector.<StockPhotoVo>();
	}
	
	// _____________________________ API
	
	public function getStockPhotoById ( $id:String ):StockPhotoVo
	{
		var len:uint = stack.length;
		for ( var i:uint=0; i<len; i++ ) 
		{
			if( stack[i].id == $id )
				return stack[i];
		}
		return null;
	}
}

}