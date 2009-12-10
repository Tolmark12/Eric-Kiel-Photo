package app.model
{
import org.puremvc.as3.multicore.interfaces.IProxy;
import org.puremvc.as3.multicore.patterns.proxy.Proxy;
import app.model.vo.*;
import app.AppFacade;

public class FormProxy extends Proxy implements IProxy
{
	public static const NAME:String = "form_proxy";
	
	// Constructor
	public function FormProxy( ):void { super( NAME ); };
	
	public function createForms (  ):void
	{
		
	}
	
	public function submitForm (  ):void
	{
		// Submit form to the backend
	}

}
}