package app.model.vo
{

public class StockPhotoSetVo
{
	public var stack:Vector.<StockPhotoVo>;			// The stack of photos
	public var setName:String;						// Usually the tag these photos share in common	
	public var dictionary:Object = {};				// Holds a reference to all the photovo's by id
	
	public function StockPhotoSetVo( $json:Object ):void
	{
		stack 		= new Vector.<StockPhotoVo>();
		
		if( $json.items != null ) {
			setName		= $json.term;

			var len:uint = $json.items.length;
			for ( var i:uint=0; i<len; i++ ) 
			{
				var stockPhotoVo:StockPhotoVo = new StockPhotoVo( $json.items[i] );
				stockPhotoVo.parentSet = this;
				this.addStockPhotoToSet( stockPhotoVo );
			}
		}
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
		dictionary[$stockPhoto.id] = $stockPhoto;
		stack.unshift($stockPhoto);
	}
	
	public function removeStockPhotoFromSet ( $id:String ):void{
		delete dictionary[$id];
		var len:uint = stack.length;
		for ( var i:uint=0; i<len; i++ ) {
			if( stack[i].id == $id ){
				stack.splice(i, 1);
				break;
			}
		}
	}
	
	public function toString (  ):String
	{
		return setName;
	}
	
	/** 
	*	Gets a list of StockPhotoVos that have the "doShowInParentSet" var set to true
	*/
	public function get displayStack (  ):Vector.<StockPhotoVo>
	{
		var returnStack:Vector.<StockPhotoVo> = new Vector.<StockPhotoVo>();
		var len:uint = stack.length;
		for ( var i:uint=0; i<len; i++ ) 
		{
			// Only add to the display stack if this is active 
			if( stack[i].doShowInParentSet )
				returnStack.push( stack[i] );
		}
		
		return returnStack;
	}
}

}