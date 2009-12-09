package app.model.vo
{
	public class FieldVO
	{
		public var id:String;
		public var title:String;
		public var height:Number;
		public var regexValidation:String;
		
		public function FieldVO($json:Object):void
		{
			id 					= $json.id;
			title 				= $json.title;
			height: 			= $json.height;
			regexValitation 	= $json.regexValidation;
		}
	}
}