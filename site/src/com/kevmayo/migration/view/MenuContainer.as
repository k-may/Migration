package com.kevmayo.migration.view
{
	import com.kevmayo.migration.Migration;
	import com.kevmayo.migration.Model;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;

	public class MenuContainer extends Sprite
	{
		private var _height:int;
		private var _width:Number;
		private var _model:Model;
		private var _invalidated:Boolean=false;
		
		private var _padding:int = 50;
		private var _openButton:MenuButton;

		public function MenuContainer(model:Model)
		{
			super();
			_model=model;

			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		protected function onAddedToStage(event:Event):void
		{
			// TODO Auto-generated method stub
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			_openButton = new MenuButton();
			addChild(_openButton);
			_openButton.x = _padding;
			_openButton.y = _padding;
			
			
		}

		public override function get width():Number
		{
			return _width;
		}

		public override function set width(value:Number):void
		{
			_width=value;
			_invalidated = true;
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
		
		public function isOpen():Boolean{
			return _openButton.isOpen();
		}

		public function update():void
		{
			if (_invalidated)
			{
				var g:Graphics = this.graphics;
				g.clear();
				g.lineStyle(1, Migration.LINE_COLOR);
				g.drawRect(0,0, _width, _height);
				
				_invalidated=false;
				
				g.drawRect(Migration.MENU_PADDING_HOR, Migration.MENU_PADDING_TOP, _width - Migration.MENU_PADDING_HOR*2, _height - Migration.MENU_PADDING_TOP*2);
			}
		}
		

	}
}
