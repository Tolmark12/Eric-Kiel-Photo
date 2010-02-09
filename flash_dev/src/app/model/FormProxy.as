package app.model
{
import org.puremvc.as3.multicore.interfaces.IProxy;
import org.puremvc.as3.multicore.patterns.proxy.Proxy;
import app.model.vo.*;
import app.AppFacade;
import app.view.components.events.ModalEvent;

public class FormProxy extends Proxy implements IProxy
{
	public static const NAME:String = "form_proxy";
	
	// Constructor
	public function FormProxy( ):void { super( NAME ); };
	
	public function createNewModal ( $modalEvent:ModalEvent ):void
	{
		
		// Flix, don't populate this manually... :-)
		var newModal:FormVO 	= new FormVO(null);
				
		newModal.id           	= "";
		newModal.postURL      	= "";
//		newModal.URLVars      	= "";
		newModal.title        	= "An Awesome Modal";
		newModal.description  	= "Talk to one of our representatives by calling <white>1.888.888.8888</white><br/> ~ OR ~ <br/>Complete the email form below.";
		newModal.icon         	= "_download";
		
		var fieldVo:FieldVO		= new FieldVO(null);
		fieldVo.id				= "email";
		fieldVo.title			= "Email"
		fieldVo.lines			= 1;
		fieldVo.defaultText		= "Jon Doe"
		fieldVo.regexValidation	= new RegExp( "(\\w|[_.\\-])+@((\\w|-)+\\.)+\\w{2,4}+" );
		
		newModal.fields       	= [ fieldVo, fieldVo, fieldVo ];
		sendNotification( AppFacade.CREATE_NEW_MODAL, newModal );
	}
	
	public function submitForm (  ):void
	{
		// Submit form to the backend
	}
	

}
}