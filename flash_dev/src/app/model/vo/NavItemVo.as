package app.model.vo
{

public class NavItemVo
{
	public var id:String;					// The id EX: /portfolio
	public var text:String;					// The button text to display
	public var dataFeed:String;				// The datafeed to load when this is clicked
	public var isLogo:Boolean;				// Is this the logo?
	public var subNav:SubNavVo;				// The sub nav vo if there is one
	public var parentNavItemId:String;		// If this is a sub nav item, include a ref to the parent id
	public var pageType:String;
	
	public function NavItemVo ( $json:Object ):void
	{
		id			= $json.id;
		text 		= $json.text;
		dataFeed	= $json.dataFeed;
		isLogo		= $json.isLogo;
		pageType	= $json.pageType;
		
		if( $json.sub != null ) {
			if( $json.sub.kind == "subNav" )
				subNav = new SubNavVo( $json.sub, id );
		}
	}
}

}