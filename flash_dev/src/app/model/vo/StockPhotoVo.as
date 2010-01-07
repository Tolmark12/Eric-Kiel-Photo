package app.model.vo
{

public class StockPhotoVo
{
	public var id:String			// the id saved by light box and server
	public var name:String 			// Used for display purposes
	public var lowResSrc:String		// Url to find the thumbnail
	public var highResSrc:String	// Url to the full size image
	public var tags:Array			// The tags associated with this image
	public var width:Number;		// The width of the photo
	
	public function StockPhotoVo( $json:Object ):void
	{
		id 			= $json.id;
		name		= $json.name;
		lowResSrc	= $json.low_res_src;
		highResSrc	= $json.high_res;
		tags		= $json.tags;
		width		= $json.width;
	}
}

}