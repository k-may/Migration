package com.kevmayo.migration.events
{
	import flash.events.Event;
	
	public class NodesUpdateEvent extends Event
	{
		public function NodesUpdateEvent()
		{
			super(EventTypes.NODES_UPDATED, bubbles, cancelable);
		}
	}
}