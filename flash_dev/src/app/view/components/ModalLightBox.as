package app.view.components
{
	public class ModalLightBox extends Modal
	{
		private var _lightBoxVO:LightBoxVO 	= new LightBoxVO();
		
		private var _images:Array 			= new Array();
		
		public function ModalLightBox($lightBoxVO:LightBoxVO)
		{
			trace('new modallightbox');
			super(this.width, this.height);
		}
	}
}