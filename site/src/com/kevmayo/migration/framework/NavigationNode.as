package com.kevmayo.migration.framework
{
	import flash.display.Sprite;
	import flash.text.TextField;

	public class NavigationNode
	{
		private var _entry:CityEntry;
		private var _ratio:Number;
		private var _nodePos:Number;
		private var _textPos:Number;
		private var _point:Sprite;
		private var _field:TextField;

		public function NavigationNode(entry:CityEntry, ratio:Number)
		{
			_entry=entry;
			_ratio=ratio;
			trace("new NavNode : " + entry.name + " / " + ratio);
		}

		public function get point():Sprite
		{
			return _point;
		}

		public function set point(value:Sprite):void
		{
			_point = value;
		}

		public function get field():TextField
		{
			return _field;
		}

		public function set field(value:TextField):void
		{
			_field = value;
		}

		public function get textPos():Number
		{
			return _textPos;
		}

		public function set textPos(value:Number):void
		{
			_textPos = value;
		}

		public function get nodePos():Number
		{
			return _nodePos;
		}

		public function set nodePos(value:Number):void
		{
			_nodePos = value;
		}

		public function get entry():CityEntry
		{
			return _entry;
		}

		public function get ratio():Number
		{
			return _ratio;
		}

	}
}
