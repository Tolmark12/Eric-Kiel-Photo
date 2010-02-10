package app.model.vo
{
	public class FieldVO
	{
		public var id:String;
		public var urlVarName:String;
		public var title:String;
		public var lines:Number;
		public var defaultText:String;
		public var regexValidation:RegExp;
		
		public function FieldVO($json:Object):void
		{
			//id 					= $json.id;
			//title 				= $json.title;
			//height: 			= $json.height;
			//regexValitation 	= $json.regexValidation;
		}
	}
}