package app.model.vo
{
import delorum.utils.echo;
public class NavVo
{
	public var pages:Array = new Array();
	
	public function NavVo ( $json:Object ):void
	{
		// Create nav Item vo
		var navItemVo:NavItemVo
		var len:uint = $json.pages.length;
		for ( var i:uint=0; i<len; i++ ) 
		{
			navItemVo = new NavItemVo( $json.pages[i] );
			// Add all sub nav items to the pages list:
			if( navItemVo.subNav != null ) 
				pages = pages.concat( navItemVo.subNav.pages );
			
			// Add the parent nav item to the pages list:
			pages.push( navItemVo );
		}
		
		// Order the pages
		pages.sortOn("sortVal");
	}
	
	/** 
	*	Get the nav item that has this id/
	*	@param		id of the nav item to find
	*/
	public function getNavItemById ( $id:String ):NavItemVo
	{
		var navItemVo:NavItemVo;
		var len:uint = pages.length;
		for ( var i:uint=0; i<len; i++ ) 
		{
			navItemVo = pages[i];
			if( navItemVo.id == $id )
				return navItemVo;
		}
		return null;
	}
	
	public function get defaultNavItem (  ):NavItemVo{ 
		var len:uint = pages.length;
		for ( var i:uint=0; i<len; i++ ) 
		{
			var navItem:NavItemVo = pages[i];
			if( navItem.isDefault )
				return navItem;
		}
		return null;
	};
}

}