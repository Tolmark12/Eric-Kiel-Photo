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
	private var _server:String;
	private var _configVo:ConfigVo;
	
	// Constructor
	public function ExternalDataProxy( ):void { super( NAME ); };

	/************ CONFIG / NAV **********/

	// Get Config Data
	public function getConfigData ( $stage:Stage ):void
	{
		_server = ( $stage.loaderInfo.parameters.server != null )? $stage.loaderInfo.parameters.server : 'http://staging.kielphoto.com/' ;
		//var configData:String = ( $stage.loaderInfo.parameters.configData != null )? $stage.loaderInfo.parameters.configData : 'http://www.kielphoto.com/vladmin/api/' ;
		var ldr:DataLoader = new DataLoader( _server + "vladmin/api/" );
		ldr.addEventListener( Event.COMPLETE, _onConfigLoad, false,0,true );
		ldr.loadItem();
	}
	
	// Load Navigation data
	public function loadNavData (  ):void
	{
		var ldr:DataLoader = new DataLoader( _configVo.getNav );
		ldr.addEventListener( Event.COMPLETE, _onNavLoad, false,0,true );
		ldr.loadItem();
	}
	
	/************ PORTFOLIO **********/
	
	// Load Portfolio data
	public function loadPortfolioData ( $feed:String ):void
	{
		// TEMP !!
		var ldr:DataLoader
		if( $feed != _server + "vladmin/api/index/template/3" )
			ldr = new DataLoader( $feed );
		else
			ldr = new DataLoader( _server + "prototype/content/json/tempPortfolio.json" );
		// TEMP !!
		
		ldr.addEventListener( Event.COMPLETE, _onPortfolioDataLoad, false,0,true );
		ldr.loadItem();
	}
	
	/************ STOCK **********/
	
	// Load Stock Config Data
	public function loadStockConfigData ( $feed:String ):void
	{
		var ldr:DataLoader = new DataLoader( $feed );
		ldr.addEventListener( Event.COMPLETE, _onStockConfigDataLoad, false,0,true );
		ldr.loadItem();
		
		loadAllStockTags();
	}
	
	/** 
	*	@param		A comma delimited list of tags
	*/
	public function loadStockDataSet ( $searchTerm:String ):void
	{

		// Send the $feed to vladmin here...
		
		// !! TEMP !!
		sendNotification( AppFacade.STOCK_DATA_SET_LOADED, {/* TEMP Empty object */ term:$searchTerm } );
		// !! TEMP !!
	}
	
	public function loadAllStockTags (  ):void
	{
		var ldr:DataLoader = new DataLoader( _server + "stock/api/getAllStockTags" );
		ldr.addEventListener( Event.COMPLETE, _onStockDataSetLoaded, false,0,true );
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
	
	private function _onStockConfigDataLoad ( e:Event ):void {
		sendNotification( AppFacade.STOCK_CONFIG_LOADED, JSON.decode( e.target.data ) );
	}
	
	private function _onStockDataSetLoaded ( e:Event ):void {
		sendNotification( AppFacade.STOCK_TAGS_LOADED, JSON.decode( '{ "tags" : ' +  e.target.data + '}' ) );
	}
	
	
	// _____________________________ Getters / Setters
	
	public function get server (  ):String{ return _server; };
	
	
	
}
}