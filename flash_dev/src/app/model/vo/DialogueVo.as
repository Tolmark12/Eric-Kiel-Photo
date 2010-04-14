package app.model.vo
{
public class DialogueVo
{
	public var message;
	
	public function DialogueVo( $message:String ):void
	{
		message = $message;
	}
	public function toString (  ):String
	{
		return message;
	}
}

}