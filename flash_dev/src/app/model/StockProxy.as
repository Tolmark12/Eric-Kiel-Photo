package app.model
{
import org.puremvc.as3.multicore.interfaces.IProxy;
import org.puremvc.as3.multicore.patterns.proxy.Proxy;
import app.model.vo.*;
import app.AppFacade;

public class StockProxy extends Proxy implements IProxy
{
	public static const NAME:String = "stock_proxy";
	
	// Constructor
	public function StockProxy( ):void { super( NAME ); };

}
}