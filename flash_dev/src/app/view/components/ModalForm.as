package app.view.components
{
	import flash.net.URLVariables;
	
	public class ModalForm extends Modal
	{
		private var _formVO:FormVO 	= new FormVO();
		
		private var _id:String;
		private var _vars:URLVariables;
		
		public function ModalForm()
		{
			trace('new modalform');
			
			super(this.width, this.height);
		}
		
		public function build($formVO:FormVO):void
		{
			trace($formVO.title);
			trace($formVO.description);
			trace($formVO.icon);
			trace($formVO.fields);
		}
	}
}