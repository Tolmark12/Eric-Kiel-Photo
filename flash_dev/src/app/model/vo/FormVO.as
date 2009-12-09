package app.model.vo
{
	import flash.net.URLVariables;
	
	public class FormVO
	{
		public var id:String;
		public var postURL:String;
		public var URLVars:URLVariables;
		public var title:String;
		public var description:String;
		public var icon:String;
		public var fields:Array;
		
		public function FormVO($json:Object):void
		{
			id 				= $json.id;
			postURL 		= $json.postURL;
			URLVars 		= $json.URLVars;
			title 			= $json.title;
			description 	= $json.description;
			icon 			= $json.icon;
			fields 			= $json.field;
		}
	}
}