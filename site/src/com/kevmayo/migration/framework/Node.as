package com.kevmayo.migration.framework
{
	import com.kevmayo.migration.Migration;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;

	public class Node extends Sprite
	{
		private var shape:Shape;

		private var _entry:InstitutionEntry;

		private var color:int;
		private var fillColor:int;
		private var hoverColor:int;
		private var lineColor:uint;
		private const lineWeight:int=2
		public var lineVisible:Boolean;
		private var _width:int;
		private var _rotation:int;

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

			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

		}


		protected function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			// TODO Auto-generated method stub

			shape=new Shape();
			addChild(shape);
			shape.rotation = _rotation;

			render();
		}

		public function get entry():InstitutionEntry
		{
			return _entry;
		}

		

		public function render()
		{
			DrawDiamond(shape.graphics, width / 2, 0x000);
		}


		public static function DrawDiamond(g:Graphics, radius:int, color:uint, lineWeight:int=-1)
		{
			g.clear();
			if (lineWeight != -1)
				g.lineStyle(lineWeight, color);
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


		public function setRotation(angle:int):void
		{
			_rotation=angle;
			// TODO Auto Generated method stub
			if (shape != null)
				shape.rotation=angle;
		}

	}
}
