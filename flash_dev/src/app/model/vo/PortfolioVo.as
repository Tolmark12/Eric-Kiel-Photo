package app.model.vo
{

public class PortfolioVo
{
	public var items:Array = new Array();
	
	public function PortfolioVo( $json:Object ):void
	{
		var len:uint = $json.images.length;
		var portfolioItemVo:PortfolioItemVo;
		for ( var i:uint=0; i<len; i++ ) 
		{
			items.push( new PortfolioItemVo( $json.images[i], i ) );
		}
	}

}

}