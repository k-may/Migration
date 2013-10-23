package com.kevmayo.migration.view
{
	import com.kevmayo.migration.Migration;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;

	public class MenuButton extends Sprite
	{
		private var _open:Boolean=false;
		private var _radius:int=20;

		public function MenuButton()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

		}

		protected function onAddedToStage(event:Event):void
		{
			// TODO Auto-generated method stub
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			Node.DrawDiamond(this.graphics, 13, Migration.BUTTON_COLOR, 3);
			
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
			var g:Graphics=this.graphics;

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
