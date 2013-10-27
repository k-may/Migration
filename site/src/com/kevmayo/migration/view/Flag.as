package com.kevmayo.migration.view
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Flag extends Sprite
	{
		private var _color:uint;
		private var _radius:int = 5;
		private var _paddingVer:int = 25;
		public function Flag(color:uint)
		{
			super();
			_color = color;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		protected function onAddedToStage(event:Event):void
		{
			// TODO Auto-generated method stub
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			var g:Graphics = this.graphics;
			g.lineStyle(1, _color);
			g.moveTo(0,0);
			g.lineTo(0, -_paddingVer);
			
			g.beginFill(_color);
			g.moveTo(0, -_paddingVer);
			g.lineTo(_radius, -_paddingVer + _radius);
			g.lineTo(0, -_paddingVer + _radius*2);
			g.lineTo(0, -_paddingVer);
			g.endFill();
		}
	}
}