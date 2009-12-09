package app.view.components
{
	import flash.net.URLVariables;
	
	public class ModalForm extends Modal
	{
		private var _formVO:FormVO 	= new FormVO();
		
		private var _id:String;
		private var _postURL:String;
		private var _vars:URLVariables;
		private var _title:String;
		private var _description:String;
		private var _icon:String;
		private var _fields:Array 	= new Array();
		
		public function ModalForm($formVO:FormVO)
		{
			trace('new modalform');
			super(this.width, this.height);
		}
	}
}