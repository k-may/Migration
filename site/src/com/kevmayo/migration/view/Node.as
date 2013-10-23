package com.kevmayo.migration.view
{
	import com.kevmayo.migration.Migration;
	import com.kevmayo.migration.framework.InstitutionEntry;

	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;

	public class Node extends Sprite
	{
		private var shape:Shape=new Shape();

		private var _entry:InstitutionEntry;

		private var color:int;
		private var fillColor:int;
		private var hoverColor:int;
		private var lineColor:uint;
		private const lineWeight:int=2
		public var lineVisible:Boolean;
		private var _width:int;

		public function Node(_fillColor, _hoverColor:int, _lineColor:uint, data:InstitutionEntry)
		{

			this.fillColor=_fillColor;
			this.hoverColor=_hoverColor;

			this.lineVisible=true;

			this.buttonMode=true;

			this.lineColor=_lineColor;
			this.color=fillColor

			this.width=15;
			_entry=data;

			addChild(shape);
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

		}


		protected function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			// TODO Auto-generated method stub
			render();
		}

		public function get entry():InstitutionEntry
		{
			return _entry;
		}


		public function render()
		{
			shape.graphics.clear();
			if (lineVisible)
			{
				shape.graphics.lineStyle(Migration.NODE_LINE_WIDTH, lineColor);
				shape.graphics.beginFill(0xffffff);
			}
			else
			{
				shape.graphics.beginFill(color);
			}
			shape.graphics.moveTo(width / 2, 0);
			shape.graphics.lineTo(0, width / 2);
			shape.graphics.lineTo(width / 2, width);
			shape.graphics.lineTo(width, width / 2);
			shape.graphics.lineTo(width / 2, 0);
			shape.graphics.endFill();
		}


		public static function DrawDiamond(g:Graphics, radius:int, color:uint, lineWeight:int=-1)
		{
			g.clear();
			if (lineWeight != -1)
				g.lineStyle(3, color);
			else
				g.beginFill(color);
			g.moveTo(0, -radius);
			g.lineTo(radius, 0);
			g.lineTo(0, radius);
			g.lineTo(-radius, 0);
			g.lineTo(0, -radius);

			if (lineWeight == -1)
				g.endFill();
		}

		public function hover(h:Boolean)
		{
			switch (h)
			{
				case true:
					color=hoverColor;
					render();
					break;
				case false:
					color=fillColor;
					render();
					break;
			}
		}

		public function _mouseDown(h:Boolean)
		{
			lineVisible=h;
			render();
		}

		public function fillNode(_case:String)
		{
			switch (_case)
			{
				case "over":
					color=0x000fff;
					render();
					break;
				case "out":
					color=0xffffff;
					render();
					break;
			}
		}

		override public function set width(value:Number):void
		{
			_width=value;
		}

		override public function get width():Number
		{
			// TODO Auto Generated method stub
			return _width;
		}


	}
}
