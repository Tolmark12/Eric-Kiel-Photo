package app.model.vo
{

public class PathVo
{
	/* An Array of objects ex:
	[
		{ id:"/services", hasChanged:false 			}
		{ id:"/services/safety", hasChanged: true	}
	]
	
	*/
	public var path:Array;			
	public var fullPath:String;
	
	public function PathVo ( $oldPath:String, $newPath:String ):void
	{
		fullPath = $newPath;
		var oldAr:Array = _splitIntoCanonicalArray( $oldPath );
		var newAr:Array = _splitIntoCanonicalArray( $newPath );
		path = _compare(oldAr, newAr);
	}
	
	// _____________________________ Helpers
	
	private function _splitIntoCanonicalArray ( $path:String ):Array
	{
		if( $path == null )
			return [];
			
		var returnAr:Array = new Array()
		var ar:Array 	= $path.split("/");
		var len:uint 	= ar.length;
		var str:String	= "";
		for ( var i:uint=1; i<len; i++ ) {
			str += "/" + ar[i];
			returnAr.push( str );
		}
		return returnAr;
	}
	
	private function _compare ( $old:Array, $new:Array ):Array
	{
		var returnAr:Array = new Array();
		var len:uint = $new.length;
		for ( var i:uint=0; i<len; i++ ) {
			returnAr.push( { id:$new[i], hasChanged:$new[i] != $old[i] } );
		}
		return returnAr;
	}
}

}