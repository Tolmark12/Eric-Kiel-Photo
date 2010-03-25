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
		public var fields:Vector.<FieldVO> = new Vector.<FieldVO>();
		
		public function FormVO($json:Object):void
		{
			id 				= $json.form_id;
			postURL 		= $json.post_url;
			URLVars 		= new URLVariables();
			title 			= $json.title;
			description 	= $json.description;
			icon 			= $json.form_icon;
			
			// Create Fields
			var len:uint = $json.fields.length;
			for ( var i:uint=0; i<len; i++ ) 
			{
				fields[i] = new FieldVO( $json.fields[i] );
			}
		}
	}
}