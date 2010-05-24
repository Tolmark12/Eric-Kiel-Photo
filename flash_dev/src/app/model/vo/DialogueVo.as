package app.model.vo
{
public class DialogueVo
{
	public var message;
	public var hideButtons:Boolean;
	
	public function DialogueVo( $message:String, $hideButtons:Boolean = false ):void
	{
		message = $message;
		hideButtons = $hideButtons;
	}
	public function toString (  ):String
	{
		return message;
	}
}

}