package app.model
{
import org.puremvc.as3.multicore.interfaces.IProxy;
import org.puremvc.as3.multicore.patterns.proxy.Proxy;
import app.model.vo.*;
import app.AppFacade;
import app.view.components.events.ModalEvent;
import flash.net.URLVariables;
import flash.net.URLRequest;
import flash.events.*;
import flash.net.URLLoader;

public class FormProxy extends Proxy implements IProxy
{
	public static const NAME:String = "form_proxy";
	
	// Constructor
	public function FormProxy( ):void { super( NAME ); };
	
	public function createNewModal ( $modalEvent:ModalEvent ):void
	{Event
		/*
		// Flix, don't populate this manually... :-)
		var newModal:FormVO 	= new FormVO(null);
				
		newModal.id           	= "";
		newModal.postURL      	= "";
		newModal.title        	= "An Awesome Modal";
		newModal.description  	= "Talk to one of our representatives by calling <white>1.888.888.8888</white><br/> ~ OR ~ <br/>Complete the email form below.";
		newModal.icon         	= "_download";
		
		var fieldVo:FieldVO		= new FieldVO(null);
		fieldVo.id				= "email";
		fieldVo.urlVarName		= "email";
		fieldVo.title			= "Email"
		fieldVo.lines			= 1;
		fieldVo.defaultText		= "Jon Doe"
		fieldVo.regexValidation	= new RegExp( "(\\w|[_.\\-])+@((\\w|-)+\\.)+\\w{2,4}+" );
											   (\\w|[_.\\-])+@((\\w|-)+\\.)+\\w{2,4}+
		
		newModal.fields       	= [ fieldVo, fieldVo, fieldVo ];
		*/
		var stockProxy:StockProxy = facade.retrieveProxy( StockProxy.NAME ) as StockProxy;
		var form:FormVO = stockProxy.stockConfigVo.getFormById( $modalEvent.type );
		form.updateFieldValues();
		sendNotification( AppFacade.CREATE_NEW_MODAL, form );
	}
	
	public function submitForm ( $urlVars:URLVariables ):void
	{
		FormVO.updateGlobalVars($urlVars);
		
		var daLoader:URLLoader = new URLLoader();
        daLoader.addEventListener( Event.COMPLETE, _onComplete, false,0,true );
		daLoader.addEventListener( IOErrorEvent.IO_ERROR, _onIoError, false,0,true );
		
		var daRequest:URLRequest = new URLRequest("http://kielphoto.dev/crossdomain.xml");
		try {
		    daLoader.load(daRequest);
		} catch (error:Error) {
		    trace("Unable to load requested document.");
		}

		trace( "URL VARS::" );
		for( var i:String in $urlVars )
		{
			trace( "  "+ i + '  :  ' + $urlVars[i] );
		}
		trace( "::" );

	}
	
	private function _onComplete ( e:Event ):void {
		trace( "Form Submission response" + '  :  ' + e.target.data );
	}
	
	private function _onIoError ( e:Event ):void {
		trace( "IO Error in Form submission :'(. Too bad, so sad. ");
	}
	

}
}