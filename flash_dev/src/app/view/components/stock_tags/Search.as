package app.view.components.stock_tags
{

import app.view.components.swc.RadioBtn;
import flash.display.Sprite;
import flash.text.TextField;
import flash.events.*;
import app.view.components.events.StockTagEvent;
import app.view.components.events.TagBrowserEvent;

public class Search extends Sprite
{
	private var _txt:TextField;
	private var _tagSuggestions:TagBrowser 		= new TagBrowser();
	private var _newSearchRadeioBtn:RadioBtn	= new RadioBtn_swc();
	private var _filterSearchRadioBtn:RadioBtn	= new RadioBtn_swc();
	
	public function Search():void
	{
		_txt = this.getChildByName( "txt" ) as TextField;
		_txt.addEventListener( FocusEvent.FOCUS_IN, _onFocusIn, false,0,true );
		_txt.addEventListener( FocusEvent.FOCUS_OUT, _onFocusOut, false,0,true );
		_txt.addEventListener( Event.CHANGE, _onChange, false,0,true );
		_txt.addEventListener( KeyboardEvent.KEY_DOWN, _onKeyDown );
		_tagSuggestions.addEventListener( TagBrowserEvent.HINT_HIGHLIGHTED, _onHintHighlighted, false,0,true );
		_tagSuggestions.addEventListener( TagBrowserEvent.HINT_SELECTED, _onHintSelected, false,0,true );
		
		_tagSuggestions.y = 28;
		
		// Radio Buttons
		_newSearchRadeioBtn.build("filter", "New Search");
		_filterSearchRadioBtn.build("filter", "Filter Results");
		_newSearchRadeioBtn.activate();
		
		// Position Radio Buttons
		_filterSearchRadioBtn.x = _newSearchRadeioBtn.x + _newSearchRadeioBtn.width + 10;
		_filterSearchRadioBtn.y = _newSearchRadeioBtn.y = _tagSuggestions.y + _tagSuggestions.height + 10;
		
		// Add all Children
		this.addChild( _newSearchRadeioBtn );
		this.addChild( _filterSearchRadioBtn );
		this.addChild( _tagSuggestions );
		
	}
	
	public function showHints ( $ar:Array ):void
	{
		if( $ar.length != 0 ) {
			_tagSuggestions.show();
			_tagSuggestions.showTags( $ar );
		}else{
			_tagSuggestions.hide();
		}
		
	}
	
	public function enableFiltering (  ):void
	{
		_filterSearchRadioBtn.visible = true;
	}
	
	public function disableFiltering (  ):void
	{
		_newSearchRadeioBtn.activate();
		_filterSearchRadioBtn.visible = false;
	}
	
	// _____________________________ Helpers
	
	public function submit ( $str:String=null ):void
	{
		if( $str != null ) 
			_txt.text = $str;
		
		var ev:StockTagEvent = new StockTagEvent(StockTagEvent.SUBMIT_SEARCH_TERM, true);
		ev.searchTerm = _txt.text;
		ev.clearPreviousSearch = _newSearchRadeioBtn.isActive;
		dispatchEvent( ev );
		
		_tagSuggestions.hide();
	}
	
	// _____________________________ Event Handlers
	
	private function _onFocusIn ( e:Event ):void {
		if( _txt.text == "Search" )
			_txt.text = "";
	}
	
	private function _onFocusOut ( e:Event ):void
	{
		if( _txt.text == "" )
			_txt.text = "Search";
	}
	
	private function _onChange ( e:Event ):void {
		var ev:StockTagEvent = new StockTagEvent(StockTagEvent.SEARCH_TERM_CHANGE, true);
		ev.searchTerm = _txt.text;
		dispatchEvent( ev );
	}
	
	private function _onKeyDown ( e:KeyboardEvent ):void {
		switch (e.keyCode)
		{
			case 13 : 			// ENTER
				submit()
			break;
		}
	}
	
	// Tag hints
	
	private function _onHintHighlighted ( e:TagBrowserEvent ):void {
		_txt.text = e.hint;
		this.stage.focus = null;
	}
	
	private function _onHintSelected ( e:TagBrowserEvent ):void {
		submit();
	}
	
}

}