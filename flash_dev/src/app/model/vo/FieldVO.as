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
			id 					= $json.field_id;
			title 				= $json.title;
			defaultText			= $json.default_text;
			lines				= $json.lines;
			urlVarName			= $json.url_var_name;
			
			if( $json.regex_pattern != null )
				regexValidation = new RegExp( $json.regex_pattern );
		}
	}
}