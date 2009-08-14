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
	
	// Constructor
	public function PortfolioProxy( ):void { super( NAME ); };
	
	public function parseNewPortfolio ( $json:Object ):void
	{
		_portfolioVo = new PortfolioVo( $json );
		sendNotification( AppFacade.PORTFOLIO_DATA_PARSED, _portfolioVo );
		
		_sequence = new Sequence( _portfolioVo.items );
		_sendNewIndex();
	}
	
	public function changeActiveItemByIndex ( $index:uint ):void{
		if( _sequence.changeItemByIndex($index) )
			_sendNewIndex();
	}
	
	public function next (  ):void{
		if( _sequence.next() )
			_sendNewIndex();
	}
	
	public function prev (  ):void{
		if( _sequence.prev() )
			_sendNewIndex()
	}
	
	public function first (  ):void{
		if( _sequence.changeItemByIndex(0) )
			_sendNewIndex();
	}
	
	public function last (  ):void{
		if( _sequence.changeItemByIndex( _sequence.totalItems - 1 ) )
			_sendNewIndex();
	}
	
	// _____________________________ Helpers
	
	private function _sendNewIndex (  ):void
	{
		sendNotification( AppFacade.ACTIVATE_PORTFOLIO_ITEM, _sequence.currentIndex );
	}

}
}
