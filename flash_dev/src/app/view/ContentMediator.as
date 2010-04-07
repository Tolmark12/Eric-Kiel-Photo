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
	private var _currentMediator:PageMediator;
	private var _rootHider:RootHider = new RootHider();
	
	public function ContentMediator( $root:Sprite ):void
	{
		super( NAME );
		_rootHider.theRoot = $root;
		_background.alignCenter = true;
		_rootHider.addEventListener( MouseEvent.CLICK, _onRootHiderClick, false,0,true );
		$root.addChild( _background );
	}
	
	// PureMVC: List notifications
	override public function listNotificationInterests():Array
	{
		return [ AppFacade.STAGE_RESIZE,
		 		 AppFacade.CONFIG_LOADED_AND_PARSED,
				 AppFacade.REMOVE_CURRENT_PAGE, 
				 AppFacade.MEDIATOR_ACTIVATED,
				 AppFacade.HIDE_ROOT,
				 AppFacade.LOAD_VIDEO, ];
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
			case AppFacade.REMOVE_CURRENT_PAGE :
				if( _currentMediator != null ){
					_currentMediator.clear();
				}
			break;
			case AppFacade.MEDIATOR_ACTIVATED :
				if( _currentMediator != null )
					if( !_currentMediator.isClear )
						_currentMediator.clear();
				
				_currentMediator = note.getBody() as PageMediator;
			break;
			case AppFacade.LOAD_VIDEO :
				_rootHider.hideRoot();
			break;
			case AppFacade.HIDE_ROOT :
				_rootHider.showRoot();
			break;
		}
	}
	
	// _____________________________ Event Handlers
	
	private function _onRootHiderClick ( e:Event ):void {
		sendNotification( AppFacade.HIDE_ROOT );
	}
	
}
}