package 
{

import flash.display.Sprite;
import flash.display.Stage;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import delorum.utils.EchoMachine;
import app.AppFacade;
import delorum.utils.KeyTrigger;

public class Kiel09 extends Sprite
{
	public function Kiel09():void
	{
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