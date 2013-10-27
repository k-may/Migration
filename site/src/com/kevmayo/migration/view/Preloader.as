package com.kevmayo.migration.view
{
	import com.kevmayo.migration.framework.Node;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Preloader extends Sprite
	{
		private var _width:Number;
		private var _height:Number;
		private var _invalidated:Boolean = false;
		private var _cont:Sprite;
		
		public function Preloader()
		{
			super();
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		protected function onAddedToStage(event:Event):void
		{
			// TODO Auto-generated method stub
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			this.addEventListener(Event.ENTER_FRAME, update);
			
			_cont = new Sprite();
			
			var node:Shape;
			for(var i:int = 0 ;i < 10; i ++){
				node = new Shape();
				var g:Graphics = node.graphics;
				Node.DrawDiamond(g, 7, 0xaaaaaa);
				_cont.addChild(node);
				
				var theta:Number = i * Math.PI*2 / 10
				node.x = Math.sin(theta) * 70;
				node.y = Math.cos(theta) * 70;
				
				if(i%2 == 0)
					node.rotation = 45;
			}
			
			
		}
		
		protected function onRemoved(event:Event):void
		{
			// TODO Auto-generated method stub
			this.removeEventListener(Event.ENTER_FRAME, update);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			
		}
		
		public function update(event:Event){
			if(_invalidated){
				_invalidated = false;
				
				_cont.x = _width / 2;
				_cont.y = _height / 2;
				
				if(!_cont.stage)
					addChild(_cont);
			}
			
			_cont.rotation += 2;
		}
		public override function get width():Number
		{
			return _width;
		}

		public override function set width(value:Number):void
		{
			_width = value;
			_invalidated = true;
		}

		public override function get height():Number
		{
			return _height;
		}

		public override function set height(value:Number):void
		{
			_height = value;
			_invalidated = true;
		}


	}
}