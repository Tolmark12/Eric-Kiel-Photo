package app.model.vo
{

public class StockPhotoVo
{
	public var id:String					// the id saved by light box and server
	public var name:String 					// Used for display purposes
	public var lowResSrc:String				// Url to find the thumbnail
	public var highResSrc:String			// Url to the full size image
	public var compImgSrc:String;			// Url to the comp
	public var tags:Array					// The tags associated with this image
	public var width:Number;				// The width of the photo
	public var parentSet:StockPhotoSetVo;	// The set this VO belongs to. This is stored so it
											// can be returned to its parent after having been
											// in the "match" PhotoSetVo
	
	public function StockPhotoVo( $json:Object ):void
	{
		id 			= $json.id;
		name		= $json.name;
		lowResSrc	= $json.low_res_src;
		highResSrc	= $json.high_res;
		tags		= $json.tags;
		width		= $json.width;
		compImgSrc	= $json.compImgSrc;
	}
}

}