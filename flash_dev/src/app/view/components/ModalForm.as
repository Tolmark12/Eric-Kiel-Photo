package app.view.components
{
	import flash.display.Sprite;
	import flash.net.URLVariables;
	import app.model.vo.FormVO;
	import app.model.vo.FieldVO;
	import flash.filters.GlowFilter;
	import app.view.components.events.ModalEvent;
	import flash.events.*;
	
	public class ModalForm extends Modal
	{
		private static const _WIDTH:Number 		= 330;
		
		private var _id:String;
		private var _vars:URLVariables;
		
		private var _contentHolder:Sprite			= new Sprite();
		private var _formHolder:Sprite 				= new Sprite();
		private var _icon:FormIcons_swc 			= new FormIcons_swc();
		private var _title:FuturaBoldItalic_swc 	= new FuturaBoldItalic_swc();
		private var _description:FormText_swc 		= new FormText_swc();
		private var _submitBtn:GreenBtn				= new GreenBtn_swc();
		
		public function ModalForm()
		{
			// 330 is a pre-determined fixed width for this (ModalForm) modal. The height is arbitrarily set to 330.
			super(_WIDTH, 330);
			
			this.addChild(_contentHolder);
			_contentHolder.addChild(_icon);
			_contentHolder.addChild(_title);
			_contentHolder.addChild(_description);
			_contentHolder.addChild(_formHolder);
			_contentHolder.addChild(_submitBtn);
			_createGlowFilter();
			
			_submitBtn.addEventListener( MouseEvent.CLICK, _onSubmitClick, false,0,true );
		}
		
		public function build( $formVo:FormVO ):void
		{
			_title.titleTxt.htmlText	= $formVo.title;
			_description.htmlText 		= $formVo.description;
			
			_icon.x        		= 30;
			_icon.y        		= 10;
			_title.x       		= (_icon.x + _icon.width) + this.PADDING;
			_title.y       		= _icon.y;
			_description.x 		= _title.x;
			_description.y 		= (_title.y + _title.height) + this.PADDING;
			_contentHolder.x 	= this.PADDING;
			_contentHolder.y 	= this.PADDING;

			_icon.gotoAndStop( $formVo.icon );			
			_buildForm( $formVo.fields );
			
			_submitBtn.x = _formHolder.x+_formHolder.width - _submitBtn.width;
			_submitBtn.y = _formHolder.y + _formHolder.height + 20;

			updateHeight(this.height + this.PADDING*2);
			_description.textWidth		= 200;
			_onInputChange(null);
		}
		
		public function extractVars (  ):URLVariables
		{
			_vars = new URLVariables();
			var len:uint = _formHolder.numChildren;
			for ( var i:uint=0; i<len; i++ ) 
			{
				var formItem:FormItem = _formHolder.getChildAt(i) as FormItem;
				_vars[formItem.varName] = formItem.userInput;
			}
			return _vars;
		}
		
		// _____________________________ Helpers
		
		private function _buildForm ( $formItems:Array ):void {
			var len:uint = $formItems.length;
			var yPos:Number = 0;
			_formHolder.y = _description.y + _description.height + 30;
			for ( var i:uint=0; i<len; i++ ) 
			{
				var fieldVo:FieldVO 	= $formItems[i];
				var formItem:FormItem 	= new FormItem_swc();
				formItem.addEventListener( ModalEvent.INPUT_CHANGE, _onInputChange, false,0,true );
				formItem.inputField.tabIndex = i;
				formItem.build( fieldVo );
			 	formItem.y = yPos;
				_formHolder.addChild( formItem );
				yPos += formItem.height + 10;
			}
		}
		
		private function _createGlowFilter (  ):void {
			var color:Number = 0xFFFFFF;
			var alpha:Number = 0.7;
			var blurX:Number = 5;
			var blurY:Number = 5;
			var strength:Number = 1;
			var inner:Boolean = false;
			var knockout:Boolean = false;
			var quality:Number = 3;
            
			_icon.filters = [new GlowFilter(color,alpha,blurX,blurY,strength,quality,inner,knockout)];
		}
		
		private function _allFormItemsAreValid (  ):Boolean {
			var len:uint = _formHolder.numChildren;
			for ( var i:uint=0; i<len; i++ ) {
				var formItem:FormItem = _formHolder.getChildAt(i) as FormItem;
				if( !formItem.isValid )
					return false;
			}
			return true;
		}
		
		// _____________________________ Event Handlers
		
		private function _onInputChange ( e:Event ):void {
			if( _allFormItemsAreValid() ){
				_submitBtn.alpha = 1;
				_submitBtn.mouseEnabled = true;
			}else{
				_submitBtn.alpha = 0.3
				_submitBtn.mouseEnabled = false;
			}
		}
		
		private function _onSubmitClick ( e:Event ):void {
			var ev:ModalEvent = new ModalEvent(ModalEvent.SUBMIT_FORM, true);
			ev.urlVars = extractVars();
			dispatchEvent( ev );
		}
		
	}
}