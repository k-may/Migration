
package com.kevmayo.migration{

import flash.events.Event;
import flash.events.EventDispatcher;



class CustomDispatcher extends EventDispatcher {
	
	public static var ACTION:String = "XML_LOADED";
	
	public function doAction():void {
		dispatchEvent(new Event(CustomDispatcher.ACTION));
	}
}
}