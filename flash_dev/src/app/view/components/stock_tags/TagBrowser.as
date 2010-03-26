package app.view.components.stock_tags
{

import flash.display.*;
import app.model.TagsProxy;
import delorum.utils.Sequence;
import flash.events.*;
import app.view.components.events.TagBrowserEvent;

public class TagBrowser extends Sprite
{
	private var _tagHolder:Sprite = new Sprite();
	private var _bg:Shape = new Shape();
	private var _sequence:Sequence;
	
	public function TagBrowser():void
	{
		this.addChild( _bg );
		this.addChild( _tagHolder );
		this.addEventListener( Event.ADDED_TO_STAGE, _onAddedToStage, false,0,true );
	}
	
	/** 
	*	Display an array of clickable tags
	*/
	public function showTags ( $tags:Array ):void
	{
		_clearOldTags();
		var len:uint = $tags.length;
		var sequenceAr:Array = new Array()
		for ( var i:uint=0; i<len; i++ ) 
		{
			var clickableTag:ClickableTag_swc = new ClickableTag_swc(  );
			clickableTag.addEventListener( MouseEvent.MOUSE_OVER, _onHintHover, false,0,true );
			clickableTag.addEventListener( MouseEvent.CLICK, _onTagClick, false,0,true );
			sequenceAr.push(clickableTag);
			clickableTag.build( $tags[i] );
			_tagHolder.addChild(clickableTag);
			clickableTag.y = i*21;
		}
		
		_sequence = new Sequence( sequenceAr );
		_sequence.deselect();
		_drawBg();
	}

	/** 
	*	Hide
	*/
	public function hide (  ):void
	{
		this.visible = false;
		this.stage.removeEventListener( KeyboardEvent.KEY_DOWN, _onKeyDown );
	}
	
	/** 
	*	Show
	*/
	public function show (  ):void
	{
		this.visible = true;
		this.stage.addEventListener( KeyboardEvent.KEY_DOWN, _onKeyDown );
	}
	
	// _____________________________ Helpers
	
	private function _drawBg ():void {
		_bg.graphics.clear();
		_bg.graphics.beginFill( 0x343737, 1 );
		_bg.graphics.drawRect( 0, 0, _tagHolder.width, _tagHolder.height - 10 );	
		_bg.graphics.endFill();
		// Add rounded bottom edge
		_bg.graphics.beginFill( 0x343737, 1 );
		_bg.graphics.drawRoundRect( 0, _tagHolder.height -15, _tagHolder.width, 20, 10, 10 );
	}
	
	private function _clearOldTags (  ):void {
		var len:uint = _tagHolder.numChildren;
		for ( var i:uint=0; i<len; i++ ) 
		{
			var clickableTag:ClickableTag_swc = _tagHolder.getChildAt(0) as ClickableTag_swc;
			clickableTag.clear();
			_tagHolder.removeChild( clickableTag );
		}
	}
	
	// _____________________________ Event Handlers
	
	private function _onAddedToStage ( e:Event ):void {
		
	}
	
	private function _onTagClick ( e:Event ):void {
		var ev:TagBrowserEvent = new TagBrowserEvent(TagBrowserEvent.HINT_SELECTED, true);
		dispatchEvent( ev );
	}
	
	private function _onKeyDown ( e:KeyboardEvent ):void {
		
		if( e.keyCode == 13 ){
			_sequence.currentItem.dispatchEvent( new MouseEvent(MouseEvent.CLICK, true) );
		}
		else if( e.keyCode == 40 || e.keyCode == 38){
			
			// Unhighlight current item if it exists
			if( _sequence.currentItem != null )
				_sequence.currentItem.dispatchEvent( new MouseEvent(MouseEvent.MOUSE_OUT, true) );
				
			// Advance sequence
			if( e.keyCode == 40 ) 	// Down
				_sequence.next();
			else 					// UP
				_sequence.prev()
				
			// Highlight new item
			_sequence.currentItem.dispatchEvent( new MouseEvent(MouseEvent.MOUSE_OVER, true) );
		}
	}
	
	private function _onHintHover ( e:MouseEvent ):void {
		var ev:TagBrowserEvent = new TagBrowserEvent(TagBrowserEvent.HINT_HIGHLIGHTED, true);
		
		// If this is a bona-fide rollover...
		if( e != null ) 
			_sequence.changeItemByItem(e.currentTarget)
			
		ev.hint = _sequence.currentItem.text;
		dispatchEvent( ev );
	}

}

}