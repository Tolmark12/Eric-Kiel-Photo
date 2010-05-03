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
import flash.net.URLRequestMethod;
import app.view.components.events.ModalEvent;

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
		_currentStockPhotoVo = $modalEvent.vo;
		var stockProxy:StockProxy = facade.retrieveProxy( StockProxy.NAME ) as StockProxy;
		var form:FormVO = stockProxy.stockConfigVo.getFormById( $modalEvent.type );
		form.updateFieldValues();
		sendNotification( AppFacade.CREATE_NEW_MODAL, form );
	}
	
	private var _currentStockPhotoVo:StockPhotoVo;
	public function submitForm ( $modalEvent:ModalEvent ):void
	{
		trace( _currentStockPhotoVo.name );
		trace( _currentStockPhotoVo.lowResSrc );
		
		FormVO.updateGlobalVars( $modalEvent.urlVars );
		
		var stockProxy:StockProxy = facade.retrieveProxy( StockProxy.NAME ) as StockProxy;
		var form:FormVO = stockProxy.stockConfigVo.getFormById( $modalEvent.formId );
		
		// Pull out the form data
		var formData:String = "";
		var emailFormData:String = "";
		for( var i:String in $modalEvent.urlVars ){
			formData 		+= i + ':' + $modalEvent.urlVars[i] + "|";
			emailFormData 	+= "<b>" + i  + "</b>"  + '  :  <i>' + $modalEvent.urlVars[i] + "</i><br>";
		}
		// Chomp of the trailing pipe (|)
		formData = formData.substr(0,formData.length-1);
		var imageData = "<b>Image Info:</b><br>" + 
		 				"<i>" + _currentStockPhotoVo.name + "</i><br>" + 
						"<img src='" + _currentStockPhotoVo.lowResSrc + "' />";
		
		var urlVars:URLVariables 	= new URLVariables();
		//var urlVars:Object	 		= new Object();
		urlVars.targetEmail 		= form.targetEmail;
		urlVars.formType	 		= form.id;
		urlVars.emailSubject		= form.emailSubject;
		urlVars.body		 		= form.emailBody + "<br><br>" + emailFormData  + "<br><br>" + imageData;
		urlVars.formData			= formData;

		
	   
	   var daLoader:URLLoader = new URLLoader();
       daLoader.addEventListener( Event.COMPLETE, _onComplete, false,0,true );
	   daLoader.addEventListener( IOErrorEvent.IO_ERROR, _onIoError, false,0,true );
	   
	   //var feed:String = "http://www.kielphoto.dev/crossdomain.xml";
	   var feed:String = "http://www.kielphoto.com/client/index/postdata";
	   //var feed:String = ( facade.retrieveProxy( ExternalDataProxy.NAME ) as ExternalDataProxy ).server + "client/index/postdata";
	   
	   var daRequest:URLRequest = new URLRequest(feed);
	   daRequest.data = urlVars;
	   daRequest.method = URLRequestMethod.POST;
	   
	   try {
	       daLoader.load(daRequest);
	   } catch (error:Error) {
	       trace("Unable to load requested document.");
	   }
	}
	
	private function _onComplete ( e:Event ):void {
		trace( "Form Submission response" + '  :  ' + e.target.data );
	}
	
	private function _onIoError ( e:Event ):void {
		trace( "IO Error in Form submission :'(. Too bad, so sad. ");
	}
	

}
}