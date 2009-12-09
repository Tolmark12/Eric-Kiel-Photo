package app.view.components
{
	import flash.net.URLVariables;
	
	public class ModalForm extends Modal
	{
		private var _formVO:FormVO 	= new FormVO();
		
		private var _id:String;
		private var _vars:URLVariables;
		
		public function ModalForm($formVO:FormVO)
		{
			trace('new modalform');
			
			_setTitle($formVO.title);
			_setDescription($formVO.description);
			_setIcon($formVO.icon);
			_createFormFields($formVO.fields);
			
			super(this.width, this.height);
		}
		
		private function _setTitle($title:String):void
		{
			trace($title);	
		}
		
		private function _setDescription($description:String):void
		{
			trace($description);	
		}
		
		private function _setIcon($icon:String):void
		{
			trace($icon);
		}
		
		private function _createFormFields($fields:Array):void
		{
			trace($fields);
		}
	}
}