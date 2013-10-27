package com.kevmayo.migration.view
{
	import com.kevmayo.migration.Migration;
	import com.kevmayo.migration.events.MenuButtonClickEvent;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.kevmayo.migration.framework.Node;

	public class MenuButton extends Sprite
	{
		private var _open:Boolean=false;
		private var _radius:int=20;
		private var _innerDiamond:Shape;
		private var _overColor:uint = Migration.BUTTON_COLOR;
		private var _outColor:uint;
		private var _currentColor:uint;

		public function MenuButton()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

		}

		protected function onAddedToStage(event:Event):void
		{
			// TODO Auto-generated method stub
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			this.buttonMode = true;
			this.mouseChildren = false;
			
			_innerDiamond=new Shape();
			addChild(_innerDiamond);
			

			_outColor = stage.color;
			_outColor += 255 << 24;
			_currentColor = _outColor;
			

			this.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			this.addEventListener(MouseEvent.ROLL_OUT, onMouseOver);
			update();
		}
		
		protected function onMouseOver(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			switch(event.type){
				case MouseEvent.ROLL_OUT:
					_currentColor = _outColor;
					break;
				case MouseEvent.ROLL_OVER:
					_currentColor = _overColor;
					break;
			}
			update();
		}
		
		public function open():void
		{
			_open=true;
			update();
		}

		public function close():void
		{
			_open=false;
			update();
		}

		public function update():void
		{
			Node.DrawDiamond(_innerDiamond.graphics, 7, _currentColor);
			Node.DrawDiamond(this.graphics, 9, Migration.BUTTON_COLOR, 3);
 
			if (_open)
			{
				this.rotation=45;
			}
			else
				this.rotation=0;
		}

		public function isOpen():Boolean
		{
			// TODO Auto Generated method stub
			return _open;
		}
	}
}
