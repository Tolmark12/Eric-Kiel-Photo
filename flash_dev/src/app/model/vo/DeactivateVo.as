package app.model.vo
{

public class DeactivateVo
{
	public var index:Number;
	public var direction:String;
	
	public function DeactivateVo($index:Number, $direction:String):void
	{
		index = $index;
		direction = $direction;
	}
}

}