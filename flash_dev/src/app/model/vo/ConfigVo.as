package app.model.vo
{

public class ConfigVo
{
	public var services:Object;
	public var background:String;
	
	public function ConfigVo($json:Object):void
	{
		services = $json.services;
		background = $json.background;
	}
}

}