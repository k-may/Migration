package com.kevmayo.migration.view
{
	import com.kevmayo.migration.framework.Node;
	
	import flash.display.Shape;
	import flash.events.Event;

	public class EntryButton extends TextButton
	{
		private var _color:uint;
		private var _node:Shape;
		
		public function EntryButton(text:String, color:uint)
		{
			super(text);
			
			_color = color;
		
		}
		
		protected override function onAddedToStage(event:Event):void{
			super.onAddedToStage(event);
			
			_field.x = 15;
			_node = new Shape();
			addChild(_node);
			_node.x = 6;
			_node.y = 10;
			Node.DrawDiamond(_node.graphics, 4, _color);
		}
		
		public override function get name():String{
			return _text;
		}
	}
}