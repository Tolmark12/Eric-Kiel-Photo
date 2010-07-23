package app.view.components
{
	public class ModalLightBox extends Modal
	{
		private static const _WIDTH:Number 		= 330;
		
		private var _lightBoxVO	:LightBoxVO 	= new LightBoxVO();
		
		public function ModalLightBox()
		{
			// 600 is a pre-determined fixed width for this (ModalForm) modal. The height is arbitrarily set to 600.
			super(_WIDTH, 600);
		}
		
		public function build($lightBoxVO:LightBoxVO):void
		{
			//trace($lightBoxVO);	
		}
	}
}