package app.model.vo
{

public class MessageVo
{
	public var message;
	
	public function MessageVo( $message:String ):void
	{
		message = $message;
	}
	
	public function toString (  ):String
	{
		return message;
	}
}

}