package app.model.vo
{

public class PortfolioItemVo
{
	public var title:String;
	public var src:String;
	public var lowResSrc:String;
	public var index:uint;
	public var tags:Array;
	public var isActive:Boolean;
	public var name:String;
	// Video
	public var videoEmbedTag:String;
	public var isOnlyVideo:Boolean = false;
	
	public var tempId:String;
	
	public function PortfolioItemVo( $json:Object ):void
	{
		// Used for tracint out photo ids				
		name				= $json.name;
		tags				= $json.photo_tags;
		title 				= "";
		src					= $json.src;
		lowResSrc			= $json.low_res_src;
		isActive			= true;
		
		/* TEMP - Live site
		videoEmbedTag		= $json.video_embed_tag;
		if( $json.is_only_video != null )
			isOnlyVideo			= new Boolean($json.is_only_video.toLowerCase() == "true");
		//*/

		//* TEMP - Staging
		videoEmbedTag		= $json.video_emved_code;
        
		if( $json.is_video_only != null )
			isOnlyVideo			= new Boolean($json.is_video_only.toLowerCase() == "true");
		//*/
	}
	
	public function toString (  ):String
	{
		var str:String = "";
		str += "name"  + '  :  ' + name;
		return str;
	}

}

}