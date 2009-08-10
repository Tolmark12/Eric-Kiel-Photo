package app.view.components
{
import flash.display.Sprite;
import app.model.vo.ContactVo;

public class Contact extends Sprite
{
	public function Contact( $contactVo:ContactVo ):void
	{
		this.graphics.beginFill(0xFFFF00);
		this.graphics.drawRect(0,0,40,40)
	}
}
}