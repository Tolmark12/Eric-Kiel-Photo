package app.model.vo
{

public class ComingSoonVo
{
	public var message:String;
	
	public function ComingSoonVo( $json:Object ):void
	{
		message = $json.text;
	}

}

}