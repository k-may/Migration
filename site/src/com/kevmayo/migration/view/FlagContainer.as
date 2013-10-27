package com.kevmayo.migration.view
{
	import com.kevmayo.migration.framework.IFlagContainer;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Point;

	public class FlagContainer extends Sprite implements IFlagContainer
	{
		private var _width:int;
		private var _height:int;
		private var _invalidated:Boolean;

		public function FlagContainer()
		{
			super();

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

		public function clear():void
		{
			while (this.numChildren > 0)
				this.removeChildAt(0);
		}

		public function addFlags(pos:Array):void
		{
			for each (var obj:Object in pos)
			{
				addFlag(obj.pos, obj.color);
			}
		}

		public function addFlag(pos:Point, color:uint):void
		{
			var flag:Flag=new Flag(color);
			flag.x=pos.x;
			flag.y=pos.y;
			addChild(flag);
		}

		public function update()
		{
			if (_invalidated)
			{
				_invalidated=false;
				/*
				var g:Graphics = this.graphics;
				
				g.clear();
				g.beginFill(0xeeeeee);
				g.drawRect(100, 100, _width - 200, _height - 200);
				g.endFill();*/
			}
		}
	}
}
