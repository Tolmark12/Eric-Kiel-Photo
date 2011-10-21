package 
{

import flash.display.Sprite;
import flash.display.Stage;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import delorum.utils.EchoMachine;
import app.AppFacade;
import delorum.utils.KeyTrigger;
import flash.external.ExternalInterface;

public class Kiel09 extends Sprite
{
	public var urlLightboxItems:Array = new Array();
	//public var defaultPage:String = "/portfolio";
	public var defaultPage:String = "";
	
	public function Kiel09():void
	{
		var urlPath:String = ExternalInterface.call( "window.location.href.toString" );
		
		if( urlPath != null ){
			// Find out what the url is and specify a default page if none is specified
			if( urlPath.split("/#/").length == 1 ) {
				if( urlPath.indexOf("kielphotofilms") != -1 )
					defaultPage = "/films";

				if( urlPath.indexOf("kielphotostock") != -1)
					defaultPage = "/stock";
			}else{
				defaultPage = "there is sub page"
			}

			// Grab any lightbox vars
			var tempAr:Array = urlPath.split("?");
			if( tempAr.length > 1 )
				urlLightboxItems = tempAr[1].split("/");
		}
		
		// Init echo
		EchoMachine.register( this.stage );
		KeyTrigger.stage = this.stage;
		
		// Init display mode
		this.stage.scaleMode 	= StageScaleMode.NO_SCALE;
		this.stage.align 		= StageAlign.TOP;
		
		// Start App
		var facade:AppFacade = AppFacade.getInstance( 'app_facade' );
		facade.startup( this );
	}

}

}