package app.view
{
import org.puremvc.as3.multicore.interfaces.*;
import org.puremvc.as3.multicore.patterns.mediator.Mediator;
import app.AppFacade;
import app.model.vo.*;
import app.view.components.*;
import flash.events.*;
import app.view.components.events.*;
import flash.display.Sprite;

public class ContentMediator extends Mediator implements IMediator
{	
	public static const NAME:String = "content_mediator";
	
	private var _background:Background 	= new Background();
	
	public function ContentMediator( $root:Sprite ):void
	{
		super( NAME );
		_background.alignCenter = true;
		$root.addChild( _background );
	}
	
	// PureMVC: List notifications
	override public function listNotificationInterests():Array
	{
		return [ AppFacade.STAGE_RESIZE,
		 		 AppFacade.CONFIG_LOADED_AND_PARSED];
	}
	
	// PureMVC: Handle notifications
	override public function handleNotification( note:INotification ):void
	{
		switch ( note.getName() )
		{
			case AppFacade.STAGE_RESIZE :
				_background.onStageResize( note.getBody() as StageResizeVo )
			break;
//			case AppFacade.CREATE_PAGE:
				// Background
				//_background.alignCenter = pageVo.bgAlign == "center";
				//_background.loadSet( pageVo.lowResBg, pageVo.highResBg );
//			break;
			case AppFacade.CONFIG_LOADED_AND_PARSED :
				var configVo:ConfigVo = note.getBody() as ConfigVo;
				_background.loadSet( configVo.background, configVo.background );
			break;

		}
	}
	
}
}