package app.model.vo
{

public class SubNavVo extends NavVo
{
	public var kind:String;
	
	public function SubNavVo ( $json:Object, $parentNavId:String ):void
	{
		super( $json );
		kind = $json.kind;
		
		// Add the parent nav item id to all the
		// sub nav NavItems
		var navItemVo:NavItemVo;
		var len:uint = pages.length;
		for ( var i:uint=0; i<len; i++ ) 
		{
			navItemVo = pages[i];
			navItemVo.parentNavItemId = $parentNavId;
		}
	}
}

}