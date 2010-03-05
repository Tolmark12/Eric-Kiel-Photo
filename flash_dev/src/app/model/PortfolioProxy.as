package app.model
{
import org.puremvc.as3.multicore.interfaces.IProxy;
import org.puremvc.as3.multicore.patterns.proxy.Proxy;
import app.model.vo.*;
import app.AppFacade;
import delorum.utils.Sequence;

public class PortfolioProxy extends Proxy implements IProxy
{
	public static const NAME:String = "portfolio_proxy";
	
	private var _navProxy:NavProxy;
	private var _portfolioVo:PortfolioVo;
	private var _sequence:Sequence;
	private var _allFilters:Array;
	private var _filters:Array = new Array();
	private var _configVo:ConfigVo;
	private var _totalLoaded:Number;
	
	// Constructor
	public function PortfolioProxy( ):void { 
		super( NAME );
	 }
	
	public function parseNewPortfolio ( $json:Object ):void
	{
		_sequence = null;
		_navProxy = facade.retrieveProxy( NavProxy.NAME ) as NavProxy;
		_totalLoaded = 0;
		_portfolioVo = new PortfolioVo( $json );
		sendNotification( AppFacade.PORTFOLIO_DATA_PARSED, _portfolioVo );
		addFilter("all");
		_sequence = new Sequence( _portfolioVo.items );
		_sequence.deselect();
		first();
//		_sendNewIndex();
	}
	
	// _____________________________ API
	
	public function config ( $configVo:ConfigVo ):void{
		_allFilters 	= new Array();
		_filters 		= $configVo.availableFilters;
		var len:uint = _filters.length;
		for ( var i:uint=0; i<len; i++ ) 
		{
			_allFilters[i] = _filters[i]
		}
	}
	
	public function changeActiveItemByIndex ( $index:uint ):void{
		if( _sequence.changeItemByIndex($index) )
			_sendNewIndex();
		else{
			_sequence.deselect();
			sendNotification( AppFacade.DEACTIVATE_ACTIVE_PORTFOLIO_ITEM, new DeactivateVo($index, "center") );
		}
		trace( _sequence.currentItem );
	}
	
	public function next (  ):void{
		if( _sequence.currentIndex != -1 ) {
			if( _sequence.changeItemByIndex(_nextActiveItem.index) )
				_sendNewIndex();
		}else{
			if( _sequence.changeItemByIndex(0) )
				_sendNewIndex();
		}
	}
	
	public function prev (  ):void{
		if( _sequence.currentIndex != -1 ) {
			if( _sequence.changeItemByIndex(_prevActiveItem.index) )
				_sendNewIndex()
		}else{
			if( _sequence.changeItemByIndex(0) )
				_sendNewIndex();
		}
	}
	
	public function first (  ):void{
		_sequence.deselect();
		sendNotification( AppFacade.DEACTIVATE_ACTIVE_PORTFOLIO_ITEM, new DeactivateVo(_firstActiveItem.index, "left") );
	}
	
	public function last (  ):void{
		_sequence.deselect();
		sendNotification( AppFacade.DEACTIVATE_ACTIVE_PORTFOLIO_ITEM, new DeactivateVo(_lastActiveItem.index, "right") );
	}
	
	public function addFilter ( $filter:String ):Boolean{
		deactivateActiveItem();
		if( $filter != "all" ) {
			var len:uint = _filters.length;
			for ( var i:uint=0; i<len; i++ ) {
				if( _filters[i] == $filter ){
					return false;
				}
			}
			
			//_filters.push($filter);
			// UNCOMMENT ABOVE AND DELETE BELOW
			// FOR TAG FILTERING
			_filters = [$filter];
			///////////////////////////////////
			
		}else{
			_filters = new Array();
			var len2:uint = _allFilters.length;
			for ( var k:uint=0; k<len2; k++ ) 
			{
				if( _allFilters[k] != "all" )
					_filters.push(_allFilters[k]);
			}
		}
		_sendFilters();
		
		return false;
	}
	
	public function removeFilter ( $filter:String ):void{
		deactivateActiveItem();
		//var len:uint = _filters.length;
		//for ( var i:uint=0; i<len; i++ ) {
		//	if( _filters[i] == $filter ){
		//		_filters.splice(i,1)
		//		_sendFilters();
		//	}
		//}
		
		//_filters.push($filter);
		
		// UNCOMMENT ABOVE AND DELETE BELOW
		// FOR TAG FILTERING
		_filters = [$filter];
		_sendFilters()
		///////////////////////////////////
		
		if( _sequence.currentIndex != -1 ) {
			if( !_sequence.currentItem.isActive )
				_sequence.deselect();
		}
	}
	
	public function deactivateActiveItem (  ):void
	{
		if( _sequence != null )
			_sequence.deselect();
		if( _sequence != null )
			sendNotification( AppFacade.DEACTIVATE_ACTIVE_PORTFOLIO_ITEM, new DeactivateVo(_firstActiveItem.index, "left") );
		else
			sendNotification( AppFacade.DEACTIVATE_ACTIVE_PORTFOLIO_ITEM, new DeactivateVo(0, "left"))
	}
	
	public function imageLoaded ( $index:uint ):void
	{
		sendNotification( AppFacade.UPDATE_TOTAL_LOADED, {loaded:++_totalLoaded, total:_sequence.totalItems*2} );
	}
	
	
	// _____________________________ Helpers
	
	private function _sendNewIndex (  ):void
	{
		_navProxy.navigationOnCurrentPage("photo"+_sequence.currentItem.index);
		sendNotification( AppFacade.ACTIVATE_PORTFOLIO_ITEM, _sequence.currentIndex );
	}
	
	
	private var _firstFilterApplied:Boolean = false;
	private function _sendFilters (  ):void
	{
		if( _sequence != null )
			_sendActiveItems();
		
		
		if( _firstFilterApplied )
			_navProxy.navigationOnCurrentPage("activate_filters:"+_filters.join(","));
			
		_firstFilterApplied = true;
		
		sendNotification( AppFacade.ACTIVE_PORTFOLIO_TAGS, _filters );
	}
	
	private function _sendActiveItems (  ):void
	{
		var len:uint 			= _sequence.items.length;
		var len2:uint			= _filters.length;
		var returnArray:Array 	= new Array()
		var activate:Boolean
		
		for ( var i:uint=0; i<len; i++ ) 
		{
			var portfolioItemVo:PortfolioItemVo = _sequence.items[i];
			activate = false;
			filtersLoop : for ( var j:uint=0; j<len2; j++ ) {
				if( portfolioItemVo.tags.indexOf(_filters[j]) != -1 ){
					activate = true;
					break filtersLoop;
				}
			}
			
			portfolioItemVo.isActive = activate;
			
			if( activate )
				returnArray.push(true);
			else
				returnArray.push(false);
		}
		
		sendNotification( AppFacade.APPLY_PORTFOLIO_FILTERS, returnArray );
	}
	
	private function get _lastActiveItem (  ):PortfolioItemVo{
		var len:uint = _sequence.items.length;
		for ( var i:int=len-1; i>-1; i-- ) 
		{
			if(_sequence.items[i].isActive )
				return _sequence.items[i]  as PortfolioItemVo;
		}
		return null;
	}
	
	private function get _firstActiveItem (  ):PortfolioItemVo{
		var len:uint = _sequence.items.length;
		for ( var i:int=0; i<len; i++ ) 
		{
			if(_sequence.items[i].isActive )
				return _sequence.items[i] as PortfolioItemVo;
		}
		return null;
	}
	
	private function get _prevActiveItem (  ):PortfolioItemVo{
		var len:uint = _sequence.items.length;
		for ( var i:int=_sequence.currentIndex-1; i>-1; i-- ) 
		{
			if(_sequence.items[i].isActive )
				return _sequence.items[i]  as PortfolioItemVo;
		}
		return null;
	}
	
	private function get _nextActiveItem (  ):PortfolioItemVo{
		var len:uint = _sequence.items.length;
		for ( var i:int=_sequence.currentIndex+1; i<len; i++ ) 
		{
			if(_sequence.items[i].isActive )
				return _sequence.items[i] as PortfolioItemVo;
		}
		return null;
	}
}
}
