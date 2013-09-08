package untitled{

import flash.events.EventDispatcher;
import flash.events.Event;



class CustomDispatcher extends EventDispatcher {
	
	public static var ACTION:String = "XML_LOADED";
	
	public function doAction():void {
		dispatchEvent(new Event(CustomDispatcher.ACTION));
	}
}
}