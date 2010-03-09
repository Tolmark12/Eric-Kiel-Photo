package app.model.vo
{

public class StockPhotoSetVo
{
	public var stack:Vector.<StockPhotoVo>;			// The stack of photos
	public var setName:String;						// Usually the tag these photos share in common
	
	public function StockPhotoSetVo( $json:Object ):void
	{
		stack = new Vector.<StockPhotoVo>();
	}
	
	// _____________________________ API
	
	/** 
	*	Returns a StockPhotoVo with the supplied id
	*	@param		The id
	*	@param		If true, deletes this vo from the set
	*/
	public function getStockPhotoById ( $id:String, $doRemoveFromSet:Boolean=false ):StockPhotoVo
	{
		var len:uint = stack.length;
		for ( var i:uint=0; i<len; i++ ) 
		{
			if( stack[i].id == $id ){
				if( $doRemoveFromSet )
					return stack.slice(i,1)[0];
				else
					return stack[i];
			}
		}
		return null;
	}
	
	public function addStockPhotoToSet ( $stockPhoto:StockPhotoVo ):void{
		stack.unshift($stockPhoto);
	}
	
	public function toString (  ):String
	{
		return setName;
	}
}

}