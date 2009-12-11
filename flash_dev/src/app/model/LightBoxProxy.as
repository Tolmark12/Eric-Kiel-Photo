package app.model
{
import org.puremvc.as3.multicore.interfaces.IProxy;
import org.puremvc.as3.multicore.patterns.proxy.Proxy;
import app.model.vo.*;
import app.AppFacade;
import flash.external.ExternalInterface;
import delorum.utils.echo;
public class LightBoxProxy extends Proxy implements IProxy
{
	public static const NAME:String = "stock_proxy";
	
	// Constructor
	public function LightBoxProxy( ):void { super( NAME ); };
	
	// _____________________________ API
	
	public function initLightBox (  ):void
	{
		var urlPath:String = ExternalInterface.call( "window.location.href.toString" );
		
		if( urlPath != null )
		{
			var tempAr = urlPath.split("?");
			if( tempAr.length > 1 ) {
				echo( tempAr[0] + '  :  ' + tempAr[1] );
			}
		}
	}

}
}