package app.model.vo
{
	import flash.net.URLVariables;
	
	public class FormVO
	{
		private static var _urlVars:Object;
		public var id:String;
		public var postURL:String;
		public var URLVars:URLVariables;
		public var title:String;
		public var description:String;
		public var icon:String;
		public var fields:Vector.<FieldVO> = new Vector.<FieldVO>();
		
		// Email
		public var emailSubject:String;
		public var targetEmail:String;
		public var emailBody:String;
		
		public function FormVO($json:Object):void
		{
			if( _urlVars == null )
				_urlVars = new Object();
			
			id 				= $json.form_id;
			postURL 		= $json.post_url;
			title 			= $json.title;
			description 	= $json.description;
			icon 			= $json.form_icon;
			
			targetEmail		= $json.target_email;
			emailSubject	= $json.email_subject;
			emailBody		= $json.email_body;
			
			// Create Fields
			var len:uint = $json.fields.length;
			for ( var i:uint=0; i<len; i++ ) 
			{
				fields[i] = new FieldVO( $json.fields[i] );
			}
		}
		
		public function updateFieldValues (  ):void
		{
			var len:uint = fields.length;
			for ( var i:uint=0; i<len; i++ ) 
			{
				if( _urlVars[fields[i].urlVarName] != null )
					fields[i].defaultText = _urlVars[fields[i].urlVarName];
			}
		}
		
		public static function updateGlobalVars ( $urlVars:URLVariables ):void
		{
			for( var i:String in $urlVars )
			{
				_urlVars[i] = $urlVars[i];
			}
		}
	}
}