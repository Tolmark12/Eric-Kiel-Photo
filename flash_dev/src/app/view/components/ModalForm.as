package app.view.components
{
	import app.model.vo.FormVO;
	
	import flash.events.MouseEvent;
	import flash.net.URLVariables;
	
	public class ModalForm extends Modal
	{
		private var _id:String;
		private var _vars:URLVariables;
		
		public function ModalForm()
		{
			trace('new modalform');
			
			super(100, 100);
			
			// testing
			this.addEventListener(MouseEvent.CLICK, _onClick);
		}
		
		public function build($formVO:FormVO):void
		{
			trace($formVO.title);
			trace($formVO.description);
			trace($formVO.icon);
			trace($formVO.fields);
		}
		
		private function _onClick(e:MouseEvent)
		{
			this.updateWidth(200);
			this.updateHeight(200);
		}
	}
}