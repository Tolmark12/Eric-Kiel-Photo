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
	
	public function PortfolioItemVo( $json:Object, $index:uint ):void
	{
		tags		= $json.tags;
		title 		= $json.title;
		src			= $json.src;
		lowResSrc	= $json.lowResSrc;
		index		= $index;
		isActive	= true;
	}

}

}