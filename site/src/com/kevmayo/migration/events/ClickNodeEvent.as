package com.kevmayo.migration.events
{
	import com.kevmayo.migration.view.Node;
	
	import flash.events.Event;
	
	public class ClickNodeEvent extends Event
	{
		private var _node:Node;
		
		public function ClickNodeEvent(node:Node)
		{
			_node = node;
			super(EventTypes.CLICK_NODE);
		}

		public function get node():Node
		{
			return _node;
		}

	}
}