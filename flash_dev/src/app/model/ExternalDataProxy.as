package app.model
{
import org.puremvc.as3.multicore.interfaces.IProxy;
import org.puremvc.as3.multicore.patterns.proxy.Proxy;
import app.model.vo.*;
import app.AppFacade;
import flash.display.Stage;
import delorum.loading.DataLoader;
import flash.events.*;
import com.adobe.serialization.json.JSON;


public class ExternalDataProxy extends Proxy implements IProxy
{
	public static const NAME:String = "external_data_proxy";
	
	private var _configVo:ConfigVo;
	
	// Constructor
	public function ExternalDataProxy( ):void { super( NAME ); };

	/** 
	*	Get Config Data
	*	@param		Reference to the stage
	*/
	public function getConfigData ( $stage:Stage ):void
	{
		var configData:String = ( $stage.loaderInfo.parameters.configData != null )? $stage.loaderInfo.parameters.configData : 'http://kiel.delorum.com/vladmin/api/' ;
		var ldr:DataLoader = new DataLoader( configData );
		ldr.addEventListener( Event.COMPLETE, _onConfigLoad, false,0,true );
		ldr.loadItem();
	}
	
	/** 
	*	Load Navigation data
	*/
	public function loadNavData (  ):void
	{
		var ldr:DataLoader = new DataLoader( _configVo.getNav );
		ldr.addEventListener( Event.COMPLETE, _onNavLoad, false,0,true );
		ldr.loadItem();
	}
	
	public function loadPortfolioData ( $feed:String ):void
	{
		var ldr:DataLoader = new DataLoader( $feed );
		ldr.addEventListener( Event.COMPLETE, _onPortfolioDataLoad, false,0,true );
		ldr.loadItem();
	}
	
	// _____________________________ Data Load Handlers
	
	private function _onConfigLoad ( e:Event ):void {
		_configVo = new ConfigVo( JSON.decode( e.target.data ) );
		sendNotification( AppFacade.CONFIG_LOADED_AND_PARSED, _configVo );
	}
	
	private function _onNavLoad ( e:Event ):void{
		sendNotification( AppFacade.NAV_DATA_LOADED, JSON.decode( e.target.data ) );
	}
	
	private function _onPortfolioDataLoad ( e:Event ):void{
		sendNotification( AppFacade.PORTFOLIO_DATA_LOADED, JSON.decode( e.target.data ) );
	}
	
}
}