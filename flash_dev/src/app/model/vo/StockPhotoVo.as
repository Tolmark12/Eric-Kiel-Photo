package app.model.vo
{

public class StockPhotoVo
{
	public var id:String					// the id saved by light box and server
	public var name:String 					// Used for display purposes
	public var rank:uint;					// A non unique rank
	public var lowResSrc:String				// Url to find the thumbnail
	public var highResSrc:String			// Url to the full size image
	public var compImgSrc:String;			// Url to the comp
	public var tags:Array					// The tags associated with this image
	public var width:Number;				// The width of the photo
	public var parentSet:StockPhotoSetVo;	// The set this VO belongs to. This is stored so it
											// can be returned to its parent after having been
											// in the "match" PhotoSetVo
	public var doShowInParentSet:Boolean;	// Set to true if this is not in the matches set
	
	
	public function StockPhotoVo( $json:Object ):void
	{
		doShowInParentSet 	= true;
		rank				= $json.rank;
		id 					= $json.id;
		name				= $json.name;
		lowResSrc			= $json.small_image;
		highResSrc			= $json.mid_image;
		compImgSrc			= $json.image;
		width				= $json.small_image_width;
		tags				= new Array();
		
		var len:uint = $json.tags.length;
		for ( var i:uint=0; i<len; i++ ) {
			tags.push( new StockTagVo($json.tags[i]) );
		}
	}
}

}