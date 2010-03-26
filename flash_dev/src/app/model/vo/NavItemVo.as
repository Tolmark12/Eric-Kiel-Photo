package app.model.vo
{

public class NavItemVo
{
	public var id:String;					// The id EX: /portfolio
	public var text:String;					// The button text to display
	public var dataFeed:String;				// The datafeed to load when this is clicked
	public var isLogo:Boolean;				// Is this the logo?
	public var subNav:SubNavVo;
	public var sub:*;						// The sub nav vo if there is one
	public var parentNavItemId:String;		// If this is a sub nav item, include a ref to the parent id
	public var pageType:String;
	public var tag:String;
	public var isDefault:Boolean;
	public var kind:String;
	public var sortVal:String;				// Hopefully a temp var for sorting the nav items
	
	public function NavItemVo ( $json:Object ):void
	{
		id			= $json.url_id;
		text 		= $json.text;
		dataFeed	= $json.data_service;
		isLogo		= Boolean( $json.is_logo );
		pageType	= $json.page_type;
		tag			= $json.nav_filter_tag;
		isDefault	= Boolean( $json.is_default );
		sortVal		= $json.sort;
		
		if( $json.sub != null ) {
			kind	= $json.sub.kind;
			switch ($json.sub.kind)
			{
				case "subNav"  :
					subNav = new SubNavVo( $json.sub, id );
				break;
				case "contact" :
					sub = new ContactVo( $json.sub );
				break;
				case "coming_soon" : 
					sub = new ComingSoonVo( $json.sub );
				break
			}
		}
	}
	
	public function toString (  ):String
	{
		return text;
	}
}

}

