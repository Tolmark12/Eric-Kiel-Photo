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
	
	private var _portfolioVo:PortfolioVo;
	private var _sequence:Sequence;
	private var _filters:Array = new Array();
	
	// Constructor
	public function PortfolioProxy( ):void { super( NAME ); };
	
	public function parseNewPortfolio ( $json:Object ):void
	{
		_portfolioVo = new PortfolioVo( $json );
		sendNotification( AppFacade.PORTFOLIO_DATA_PARSED, _portfolioVo );
		
		_sequence = new Sequence( _portfolioVo.items );
		_sequence.deselect();
//		_sendNewIndex();
	}
	
	// _____________________________ API
	
	public function config ( $configVo:ConfigVo ):void{
		_filters = $configVo.availableFilters;
	}
	
	public function changeActiveItemByIndex ( $index:uint ):void{
		if( _sequence.changeItemByIndex($index) )
			_sendNewIndex();
		else{
			_sequence.deselect();
			sendNotification( AppFacade.DEACTIVATE_ACTIVE_PORTFOLIO_ITEM, $index );
		}
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
		sendNotification( AppFacade.DEACTIVATE_ACTIVE_PORTFOLIO_ITEM, 0 );
	}
	
	public function last (  ):void{
		_sequence.deselect();
		sendNotification( AppFacade.DEACTIVATE_ACTIVE_PORTFOLIO_ITEM, _sequence.totalItems - 1 );
	}
	
	public function addFilter ( $filter:String ):Boolean{
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
		
		_sendFilters();
		return false;
	}
	
	public function removeFilter ( $filter:String ):void{
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
		sendNotification( AppFacade.DEACTIVATE_ACTIVE_PORTFOLIO_ITEM );
	}
	
	
	// _____________________________ Helpers
	
	private function _sendNewIndex (  ):void
	{
		sendNotification( AppFacade.ACTIVATE_PORTFOLIO_ITEM, _sequence.currentIndex );
	}
	
	private function _sendFilters (  ):void
	{
		sendNotification( AppFacade.ACTIVE_PORTFOLIO_TAGS, _filters );
		if( _sequence != null )
			_sendActiveItems();
			
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
