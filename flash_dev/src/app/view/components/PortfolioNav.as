package app.view.components
{
	import flash.display.*;
	import flash.events.*;
	
	import app.view.components.events.NavEvent;
	
	public class PortfolioNav extends Sprite
	{
		private static const _PADDING:Number = 10;
		
		private var _controller:Sprite;
		private var _controllerArray:Array;
		
		private var _start:NavText_swc;
		private var _end:NavText_swc;
		private var _left:PortfolioBtn_swc;
		private var _right:PortfolioBtn_swc;
		
		private var _navEvent:NavEvent;		
			
		public function PortfolioNav(  ):void
		{		
			_controller = new Sprite();
			this.addChild(_controller);
			
			_controllerArray = new Array();
		}
		
		public function build():void
		{
			_start 		= new NavText_swc();
			_end 		= new NavText_swc();
			_left 		= new PortfolioBtn_swc();
			_right 		= new PortfolioBtn_swc();
			
			_start.titleTxt.autoSize 		= "left";
			_end.titleTxt.autoSize 			= "left";
			_start.titleTxt.text 	= "start";
			_end.titleTxt.text 		= "end";
			
			_controllerArray.push(_start);
			_controllerArray.push(_end);
			_controllerArray.push(_left);
			_controllerArray.push(_right);
			
			_controller.addChild(_start);
			_controller.addChild(_end);
			_controller.addChild(_left);
			_controller.addChild(_right);
			
			for each(var $button in _controllerArray)
			{
				$button.useHandCursor 	= true;
//				$button.buttonMode 		= true;
			}
			
			_positionElements();
			_addEvents();
		}
		
		private function _positionElements():void
		{
			_controller.x 		= 0;
			_controller.y 		= 0;
			                
			_start.x 			= 0;
			                
			_left.x 			= (_start.x + _start.width) + _PADDING;
			_left.y 			= 5;
			_right.x 			= (_left.x + _left.width*2) + _PADDING;
			_right.y			= _right.height + 5;
			_right.rotation 	= 180;
			_end.x 				= (_right.x + _right.width) + _PADDING-6;			
		}
		
		private function _addEvents():void
		{
			_start.addEventListener(MouseEvent.CLICK, _onClick, false, 0, true);
			_end.addEventListener(MouseEvent.CLICK, _onClick, false, 0, true);
			_right.addEventListener(MouseEvent.CLICK, _onClick, false, 0, true);
			_left.addEventListener(MouseEvent.CLICK, _onClick, false, 0, true);
		}
		
		private function _onClick(e:MouseEvent):void
		{
			switch(e.currentTarget)
			{
				case _controllerArray[0]:
					//trace("start");					
					_navEvent = new NavEvent(NavEvent.PORTFOLIO_START, true);
					dispatchEvent(_navEvent);
				break;       
				case _controllerArray[1]:
					//trace("end");
					_navEvent = new NavEvent(NavEvent.PORTFOLIO_END, true);
					dispatchEvent(_navEvent);
				break;       
				case _controllerArray[2]:
					//trace("prev");
					_navEvent = new NavEvent(NavEvent.PORTFOLIO_PREV, true);
					dispatchEvent(_navEvent);
				break;       
				case _controllerArray[3]:
					//trace("next");
					_navEvent = new NavEvent(NavEvent.PORTFOLIO_NEXT, true);
					dispatchEvent(_navEvent);
				break;
			}
		}
	}
}