package app.view.components
{

import flash.display.Sprite;
import app.model.vo.StageResizeVo;
import app.model.vo.StockPhotoVo;
import app.view.components.events.StockEvent;
import flash.events.*;

public class StockDetailView extends Sprite
{
	private var _isHidden:Boolean;
	// Ask A question
	private var _askQuestionBtn:TextIconBtn_swc = new TextIconBtn_swc();
	// Download Comp
	private var _downloadCompBtn:TextIconBtn_swc = new TextIconBtn_swc();
	
	// Title (number)
	// Buy Now
	// Related Photos
	// Image
	// Close Btn
	
	public function StockDetailView():void
	{
		// Create the buttons
		var right:Number = 512; // Temp..
		_askQuestionBtn.build(  "Ask A Question", "_ask");
		_downloadCompBtn.build( "Downlad Comp", "_download");
		_downloadCompBtn.x = right - _downloadCompBtn.width;
		_askQuestionBtn.x  = _downloadCompBtn.x - 30 - _askQuestionBtn.width;
		_downloadCompBtn.y = _askQuestionBtn.y = 20;
		
		this.addChild( _askQuestionBtn );
		this.addChild( _downloadCompBtn );
		
		// Set initial state to hidden
		hide();
		
		// Events
		_askQuestionBtn.addEventListener( MouseEvent.CLICK, _onAskQuestionClick, false,0,true );
		_downloadCompBtn.addEventListener( MouseEvent.CLICK, _onDownloadClick, false,0,true );
	}
	
	/** 
	*	Load the image...
	*/
	public function displayImage ( $stockPhotoVo:StockPhotoVo ):void
	{
		if( _isHidden ) // if hidden, show..
			show();
	}
	
	/** 
	*	Show
	*/
	public function show (  ):void
	{
		this.visible = true;
		_isHidden = false;
	}
	
	/** 
	*	Hide
	*/
	public function hide (  ):void
	{
		this.visible = false;
		_isHidden = true;
	}
	
	/** 
	*	Ckear
	*/
	public function clear (  ):void
	{
		hide();
	}
	
	// _____________________________ Event Handlers
	
	private function _onAskQuestionClick ( e:Event ):void {
		var ev:StockEvent = new StockEvent(StockEvent.ASK_A_QUESTION, true);
		dispatchEvent( ev );
	}
	
	private function _onDownloadClick ( e:Event ):void {
		var ev:StockEvent = new StockEvent(StockEvent.DOWNLOAD_COMP, true);
		dispatchEvent( ev );
	}

}

}