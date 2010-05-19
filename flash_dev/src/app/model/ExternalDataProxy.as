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
import delorum.utils.echo;
import flash.external.ExternalInterface;


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
//		_server = ( $stage.loaderInfo.parameters.server != null )? $stage.loaderInfo.parameters.server : 'http://www.kielphoto.com/' ;
		_server = ( $stage.loaderInfo.parameters.server != null )? $stage.loaderInfo.parameters.server : 'http://staging.kielphoto.com/' ;
		var ldr:DataLoader = new DataLoader( _server + "vladmin/api/" );
		ldr.addEventListener( Event.COMPLETE, _onConfigLoad, false,0,true );
		ldr.addEventListener( IOErrorEvent.IO_ERROR, _onError)
		ldr.loadItem();
	}
	
	private function _onError ( e:IOErrorEvent ):void {
		echo( "Error" + '  :  ' + e );
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
//		if( $feed == _server + "vladmin/api/index/template/3" )
//			$feed = _server + "prototype/content/json/tempPortfolio.json"
			
		var ldr:DataLoader = new DataLoader( $feed );
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
	private var _lastSearchTerm:String;
	public function loadStockDataSet ( $searchTerm:String ):void
	{
		sendNotification( AppFacade.DIALOGUE_MESSAGE, new DialogueVo("Searching for "+$searchTerm+"...", true) );
		_lastSearchTerm = $searchTerm;
		var ldr:DataLoader = new DataLoader( _server + "stock/api/getStockPhotosByTag/text/" + $searchTerm );
		ldr.addEventListener( Event.COMPLETE, _onStockDataSetLoaded, false,0,true );
		ldr.loadItem();
	}
	
	/** 
	*	Loads all of the stock tag options on the site
	*/
	public function loadAllStockTags (  ):void
	{
		var ldr:DataLoader = new DataLoader( _server + "stock/api/getAllStockTags" );
		ldr.addEventListener( Event.COMPLETE, _onStockTagsLoaded, false,0,true );
		ldr.loadItem();
	}
	
	/** 
	*	Load the lightbox items
	*	@param		comma delimited list of ids to load
	*/
	public function loadLightBoxItems ( $items:String ):void
	{
		var ldr:DataLoader = new DataLoader( _server + "stock/api/getStockPhotosByIds/ids/" + $items );
		ldr.addEventListener( Event.COMPLETE, _onLightBoxItemsLoaded, false,0,true );
		ldr.loadItem();
	}

	/************ VIDEO **********/
	/** 
	*	Calls a javascirpt that opens a video modal window
	*	@param		The entire embed tag for showing the video
	*/
	public function loadAjaxVideo ( $videoEmbedTag:String ):void{
		if (ExternalInterface.available) {
			ExternalInterface.call("playVideo", $videoEmbedTag);
		}
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
	
	private function _onStockTagsLoaded ( e:Event ):void {
		sendNotification( AppFacade.STOCK_TAGS_LOADED, JSON.decode( '{ "tags" : ' +  e.target.data + '}' ) );
	}
	
	private function _onStockDataSetLoaded ( e:Event ):void {
		sendNotification( AppFacade.HIDE_DIALOGUE );
		var json:Object = JSON.decode( e.target.data );
		sendNotification( AppFacade.STOCK_DATA_SET_LOADED, {term:_lastSearchTerm, items:json });
	}
	
	private function _onLightBoxItemsLoaded ( e:Event ):void {
		var json:Object = JSON.decode( e.target.data );
		sendNotification( AppFacade.LIGHTBOX_ITEMS_LOADED, {items:json, term:"lightbox" } );
	}
	
	// _____________________________ Getters / Setters
	
	public function get server (  ):String{ return _server; };
	
	
	
}
}