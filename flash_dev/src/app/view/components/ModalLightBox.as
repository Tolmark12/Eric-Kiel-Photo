package app.view.components
{
	public class ModalLightBox extends Modal
	{
		private var _lightBoxVO	:LightBoxVO 	= new LightBoxVO();
		
		public function ModalLightBox($lightBoxVO:LightBoxVO)
		{
			trace('new modallightbox');
			
			_loadImages($lightBoxVO.images);
			
			super(600, 600);
		}
		
		private function ($images:Array):void
		{
			trace($images);
		}
	}
}