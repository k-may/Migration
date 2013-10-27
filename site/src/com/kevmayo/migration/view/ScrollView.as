package com.kevmayo.migration.view
{
	import com.kevmayo.migration.Migration;
	import com.kevmayo.migration.framework.Node;

	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class ScrollView extends Sprite
	{
		private var _invalidated:Boolean=false;
		private var _btn:Sprite;
		private var _width:Number;
		private var _height:Number;
		private var _ratio:Number;
		private var _paddingTop:int=20;
		private var _paddingBottom:int=20;
		private var _cb:Function;

		private var _isMouseDown:Boolean=false;

		public function ScrollView(cb:Function)
		{
			super();
			this._cb=cb;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		protected function onAddedToStage(event:Event):void
		{
			// TODO Auto-generated method stub
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseHandler);
			this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseHandler);
			this.addEventListener(MouseEvent.ROLL_OUT, onMouseHandler);

			_btn=new Sprite();
			addChild(_btn);
			_btn.mouseEnabled = false;
			var g:Graphics=_btn.graphics;

			this.buttonMode = true;
			
			Node.DrawDiamond(g, 7, Migration.BUTTON_COLOR);
		}

		public function update()
		{
			if (_invalidated)
			{
				_invalidated=false;

				var g:Graphics=this.graphics;
				g.clear();

				g.beginFill(0x00ffffff, 0);
				g.drawRect(0, _paddingTop, _width, getLength());
				g.endFill();

				g.lineStyle(1, Migration.LINE_COLOR);
				g.moveTo(_width / 2, _paddingTop);
				g.lineTo(width / 2, _paddingTop + getLength());


				_btn.x=width / 2;
				setRatio(0);
			}
		}

		protected function onMouseHandler(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			switch (event.type)
			{
				case MouseEvent.MOUSE_DOWN:
					_isMouseDown=true;
				case MouseEvent.MOUSE_MOVE:
					if (_isMouseDown)
					{
						setRatio((event.localY - _paddingTop) / getLength());
					}
					break;
				case MouseEvent.ROLL_OUT:
				case MouseEvent.MOUSE_UP:
					_isMouseDown=false;
					break;
			}
		}

		public function setRatio(value:Number)
		{
			_ratio=Math.min(Math.max(0,value), 1);

			var pos=_ratio * getLength();
			_btn.y=pos + _paddingTop;

			_cb(_ratio);
		}

		private function getLength()
		{
			return _height - _paddingTop - _paddingBottom;
		}

		public override function get height():Number
		{
			return _height;
		}

		public override function set height(value:Number):void
		{
			_height=value;
			_invalidated=true;
		}

		public override function get width():Number
		{
			return _width;
		}

		public override function set width(value:Number):void
		{
			_width=value;
			_invalidated=true;
		}

	}
}
