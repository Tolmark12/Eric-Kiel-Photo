package app.view.components
{
	import flash.display.*;
	import flash.events.*;
	
	import app.view.components.events.NavEvent;
	
	import caurina.transitions.Tweener;
	
	public class PortfolioNav extends Sprite
	{
		public var hoverColor:uint	= 0xFFFFFF;
		public var color:uint		= 0x000000;
		
		private static const _PADDING:Number = 20;
		
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
			
			this.addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
		}
		
		private function _onAddedToStage(e:Event):void
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
		}
		
		public function build():void
		{
			_start 		= new NavText_swc();
			_end 		= new NavText_swc();
			_left 		= new PortfolioBtn_swc();
			_right 		= new PortfolioBtn_swc();
			
			_start.titleTxt.autoSize 		= "left";
			_end.titleTxt.autoSize 			= "left";
			_start.titleTxt.text 			= "start";
			_end.titleTxt.text 				= "end";
			
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
				//$button.buttonMode 		= true;
			}
			
			_positionElements();
			_addEvents();
		}
		
		private function _positionElements():void
		{
			_start.x 			= 0;
			_left.x 			= _start.x + _start.width + _PADDING-5;
			_right.x 			= _left.x + 3 + _PADDING;
			_left.y 			= 5;
			_right.y			= 5;
			_right.scaleX 		= -1;
			_end.x 				= _right.x + _PADDING-6;			
		}
		
		private function _addEvents():void
		{			
			_start.addEventListener(MouseEvent.MOUSE_OVER, _onMouseOver, false, 0, true);
			_end.addEventListener(MouseEvent.MOUSE_OVER, _onMouseOver, false, 0, true);
			_right.addEventListener(MouseEvent.MOUSE_OVER, _onMouseOver, false, 0, true);
			_left.addEventListener(MouseEvent.MOUSE_OVER, _onMouseOver, false, 0, true);
			
			_start.addEventListener(MouseEvent.MOUSE_OUT, _onMouseOut, false, 0, true);
			_end.addEventListener(MouseEvent.MOUSE_OUT, _onMouseOut, false, 0, true);
			_right.addEventListener(MouseEvent.MOUSE_OUT, _onMouseOut, false, 0, true);
			_left.addEventListener(MouseEvent.MOUSE_OUT, _onMouseOut, false, 0, true);
			
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
		
		private function _onKeyDown(e:KeyboardEvent):void
		{	
			switch(e.keyCode)
			{
				case 38:
					//trace("start");					
					_navEvent = new NavEvent(NavEvent.PORTFOLIO_START, true);
					dispatchEvent(_navEvent);
				break;       
				case 40:
					//trace("end");
					_navEvent = new NavEvent(NavEvent.PORTFOLIO_END, true);
					dispatchEvent(_navEvent);
				break;       
				case 37:
					//trace("prev");
					_navEvent = new NavEvent(NavEvent.PORTFOLIO_PREV, true);
					dispatchEvent(_navEvent);
				break;       
				case 39:
					//trace("next");
					_navEvent = new NavEvent(NavEvent.PORTFOLIO_NEXT, true);
					dispatchEvent(_navEvent);
				break;
			}
		}
		
		private function _onMouseOver ( e:Event ):void {
			// Change text color
			Tweener.addTween(e.currentTarget, {_color: hoverColor, time:0});
		}

		private function _onMouseOut ( e:Event ):void {
			// Change text Color
			Tweener.addTween(e.currentTarget, {_color: color, time:0});
		}
		
		private function _hideArrows():void
		{
			_left.visible = false;
			_right.visible = false;
		}

		private function _showArrows():void
		{
			_left.visible = true;
			_right.visible = true;
		}
	}
}