package 
{

import flash.display.Sprite;
import delorum.loading.DataLoader;
import flash.events.*;
import com.adobe.serialization.json.JSON;
import delorum.utils.echo;
import delorum.utils.EchoMachine;


public class TagsTester extends Sprite
{
	private var _myData:Object = {};
	private var _count:Number = 0;
	private var _total:Number = 0;
	
	public function TagsTester():void
	{
		EchoMachine.register( this.stage );
		this.stage.addEventListener( MouseEvent.CLICK, _onClick, false,0,true );	
	}
	
	// _____________________________ Events
	
	private function _onClick ( e:Event ):void
	{
		_loadTestData();
	}
	
	private function _loadTestData (  ):void
	{
		
		var ldr:DataLoader = new DataLoader( "../content/json/SampleTags.json" );
		ldr.addEventListener( Event.COMPLETE, _handleImageLoaded );
		ldr.loadItem();
	}
	
	private function _handleImageLoaded ( e:Event ):void
	{
		_myData[_count] = JSON.decode( e.target.data );
		echo( _total += _myData[_count].tags.length );
	   // var len:uint = _myData[_count].tags.length;
	   // for ( var i:uint=0; i<len; i++ ) 
	   // {
	   // 	_myData[_count][i] = _myData[_count].tags[i];
	   // }
	}

}

}