package app.model.vo
{

public class PortfolioVo
{
	public var items:Array = new Array();
	public function PortfolioVo( $json:Object ):void
	{

// 		Used for tracing out photo ids		
		trace( $json.name );
		
		var len:uint = $json.images.length;
		var portfolioItemVo:PortfolioItemVo;
		for ( var i:uint=0; i<len; i++ ) 
		{
			items.push( new PortfolioItemVo( $json.images[i] ) );
		}



		// Temp - hopefully we'll introduce sorting via the admin, 
		// until then, we're sorting on a specific field
		if( $json.sort_on != "null" && $json.sort_on != null ){
			items.sortOn( $json.sort_on );
		}
			
		var len2:uint = items.length;
		for ( var j:uint=0; j<len2; j++ ) 
		{
			trace( items[j].isOnlyVideo );
			items[j].index = j;
		}

		// 		Used for tracint out photo ids		
		trace( "+++++++++++++++++++++++++++++++++ \n\n " );
	
	}

}

}