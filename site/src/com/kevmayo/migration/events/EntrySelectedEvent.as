package com.kevmayo.migration.events
{
	import flash.events.Event;
	
	public class EntrySelectedEvent extends Event
	{
		private var _name:String;
		
		public function EntrySelectedEvent(name:String)
		{
			_name = name;
			super(EventTypes.ENTRY_SELECTED,false, false);
		}

		public function get name():String
		{
			return _name;
		}

	}
}