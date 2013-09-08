package com.kevmayo.migration{

	import flash.events.*;

	public class ScrollEvent extends Event {

		static public const OVER_ARROW="OVER_ARROW";
		static public const OUT_ARROW="OUT_ARROW";

		public var dir:int;


		public function ScrollEvent(type:String, dir:int = 0, bubles:Boolean = false) {
			
			super(type, bubbles);
			this.dir = dir;
			
		}
	}
}