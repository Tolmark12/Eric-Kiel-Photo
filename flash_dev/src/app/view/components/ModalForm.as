package app.view.components
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLVariables;
	
	public class ModalForm extends Modal
	{
		private var _id:String;
		private var _vars:URLVariables;
		
		private var _contentHolder:Sprite		= new Sprite();
		private var _icon:FormIcons_swc 		= new FormIcons_swc();
		private var _title:FormText_swc 		= new FormText_swc();
		private var _description:FormText_swc 	= new FormText_swc();
		
		public function ModalForm()
		{
			trace('new modalform');
			
			this.addChild(_contentHolder);
			_contentHolder.addChild(_icon);
			_contentHolder.addChild(_title);
			_contentHolder.addChild(_description);
			
			// testing
			this.addEventListener(MouseEvent.CLICK, _onClick);
			
			super(100, 100);
		}
		
		//$formVO:FormVO
		public function build():void
		{
			_contentHolder.x = this.PADDING;
			_contentHolder.y = this.PADDING;
			
			_icon.gotoAndStop('question');
			_title.htmlText 		= "Title";
			_description.htmlText 	= "Description";
			
			_icon.x = 0;
			_icon.y = 0;
			
			_title.x = (_icon.x + _icon.width) + this.PADDING;
			_title.y = _icon.y;
			
			_description.x = _title.x;
			_description.y = (_title.y + _title.height) + this.PADDING;
			
			//trace($formVO.title);
			//trace($formVO.description);
			//trace($formVO.icon);
			//trace($formVO.fields);
		}
		
		private function _onClick(e:MouseEvent)
		{
			this.updateWidth(200);
			this.updateHeight(200);
		}
	}
}