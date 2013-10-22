package com.kevmayo.migration.events
{
	import com.kevmayo.migration.view.Node;
	
	import flash.events.Event;
	
	public class OverNodeEvent extends Event
	{	
		private var _node:Node;
		
		public function OverNodeEvent(node:Node)
		{
			_node = node;	
			super(EventTypes.OVER_NODE, false, false);
		}

		public function get node():Node
		{
			return _node;
		}

	}
}