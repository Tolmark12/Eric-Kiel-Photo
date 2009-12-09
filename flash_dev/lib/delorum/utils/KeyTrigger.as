package delorum.utils
{

import flash.display.Stage;
import flash.events.*;

public class KeyTrigger 
{
	public static var _stage:Stage;
	public static var keyListeners:Array = new Array();
	
	private static var _keys:Object = {
		"0" : 48,  "1" : 49, "2" : 50, "3" : 51, "4" : 52, "5" : 53, "6" : 54, "7" : 55, "8" : 56, "9" : 57, 
		"a" : 65,  "b" : 66, "c" : 67, "d" : 68, "e" : 69, "f" : 70, "g" : 71, "h" : 72, "i" : 73, "j" : 74,
		"k" : 75,  "l" : 76, "m" : 77, "n" : 78, "o" : 79, "p" : 80, "q" : 81, "r" : 82, "s" : 83, "t" : 84, 
		"u" : 85,  "v" : 86, "w" : 87, "x" : 88, "y" : 89, "z" : 90,
		";" : 186, "=" : 187, "," : 188, "-" : 189, "." : 190, "/" : 191, "`" : 192, "[" : 219, "]" : 221, "'" : 222
	};
	
	public function KeyTrigger():void
	{
	}
	
	public static function set stage ( $stage:Stage ):void
	{
		if( _stage == null ){
			_stage = $stage;
			_stage.addEventListener( KeyboardEvent.KEY_DOWN, _onKeyDown, false,0,true );
		}
	}
	
	public static function addKeyListener ( $function:Function, $keyCode:String, $shiftKey:Boolean=false ):void
	{
		keyListeners.push( { key:_keys[$keyCode], callBack:$function, shift:$shiftKey } )
	}
	
	private static function _onKeyDown ( e:KeyboardEvent ):void
	{
		var len:uint = keyListeners.length;
		for ( var i:uint=0; i<len; i++ ) 
		{
			if( keyListeners[i].key == e.keyCode && keyListeners[i].shift == e.shiftKey )
				keyListeners[i].callBack.call(null);
		}
	}
	
	

}

}