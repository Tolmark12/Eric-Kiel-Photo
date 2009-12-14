package app.model
{
import org.puremvc.as3.multicore.interfaces.IProxy;
import org.puremvc.as3.multicore.patterns.proxy.Proxy;
import app.model.vo.*;
import app.AppFacade;

public class StockProxy extends Proxy implements IProxy
{
	public static const NAME:String = "stock_proxy";
	
	private var _configVo:StockConfigVo;
	
	// Constructor
	public function StockProxy( ):void { super( NAME ); };
	
	public function parseConfigData ( $json:Object ):void
	{
		_configVo = new StockConfigVo( $json );
		sendNotification( AppFacade.STOCK_INIT, _configVo );
	}

}
}