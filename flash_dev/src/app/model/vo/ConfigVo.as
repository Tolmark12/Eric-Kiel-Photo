package app.model.vo
{

public class ConfigVo
{
	// Services
	public var getNav:String;
	
	// Other vars
	public var background:String;
	public var availableFilters:Array;
	
	public function ConfigVo($json:Object):void
	{
		getNav 				= $json.get_nav;
		background 			= $json.background_image;
		availableFilters 	= $json.available_filters.split(",");
	}
}

}