package app.view.components
{
	import flash.display.Sprite;
	import flash.net.URLVariables;
	
	public class ModalForm extends Modal
	{
		private static const _WIDTH:Number 		= 330;
		
		private var _id:String;
		private var _vars:URLVariables;
		
		private var _contentHolder:Sprite		= new Sprite();
		private var _icon:FormIcons_swc 		= new FormIcons_swc();
		private var _title:FormText_swc 		= new FormText_swc();
		private var _description:FormText_swc 	= new FormText_swc();
		
		public function ModalForm()
		{
			// 330 is a pre-determined fixed width for this (ModalForm) modal. The height is arbitrarily set to 330.
			super(_WIDTH, 330);
			
			this.addChild(_contentHolder);
			_contentHolder.addChild(_icon);
			_contentHolder.addChild(_title);
			_contentHolder.addChild(_description);
		}
		
		//$formVO:FormVO
		public function build():void
		{
			_icon.gotoAndStop('$door');
			_title.htmlText	 		= "Door Form";
			_description.htmlText 	= "This is the door form...";
			
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
			
			_contentHolder.x = this.PADDING;
			_contentHolder.y = this.PADDING;
			updateHeight(_contentHolder.height + this.PADDING*2);
		}
	}
}