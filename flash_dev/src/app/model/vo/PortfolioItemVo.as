package app.model.vo
{

public class PortfolioItemVo
{
	public var title:String;
	public var src:String;
	public var lowResSrc:String;
	public var index:uint;
	
	public function PortfolioItemVo( $json:Object, $index:uint ):void
	{
		title 		= $json.title;
		src			= $json.src;
		lowResSrc	= $json.lowResSrc;
		index		= $index;
	}

}

}