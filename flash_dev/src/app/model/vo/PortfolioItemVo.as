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
	public var isOnlyVideo:Boolean;
	
	public function PortfolioItemVo( $json:Object ):void
	{
		name				= $json.name;
		tags				= $json.photo_tags;
		title 				= "";
		src					= $json.src;
		lowResSrc			= $json.low_res_src;
		isActive			= true;
		
		videoEmbedTag		= $json.video_embed_tag;
		isOnlyVideo			= Boolean($json.is_only_video);
	}
	
	public function toString (  ):String
	{
		return name + '  :  ' + src;
	}

}

}