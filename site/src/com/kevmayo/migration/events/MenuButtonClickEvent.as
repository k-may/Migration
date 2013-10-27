package com.kevmayo.migration.events
{
	import flash.events.Event;
	
	public class MenuButtonClickEvent extends Event
	{
		public function MenuButtonClickEvent()
		{
			super(EventTypes.MAIN_BTN_CLICK, false, false);
		}
	}
}