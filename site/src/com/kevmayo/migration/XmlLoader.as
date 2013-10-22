package com.kevmayo.migration{

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class XMLLoader extends Sprite {

		private var xmlLoader:URLLoader = new URLLoader();
		private var xmlData:XML = new XML();
		private var file:String;

		var dispatcher:CustomDispatcher = new CustomDispatcher();

		private var _callBack:Function;
		
		public function XMLLoader(_file="text.xml", callBack:Function = null) {
			//trace("XmlData");
			this.file=_file;
			_callBack = callBack;
			init();

		}

		private function init() {
			var xmlLoader:URLLoader = new URLLoader();
			var xmlData:XML = new XML();
			//xmlLoader.addEventListener(ProgressEvent.PROGRESS, progressListener);
			xmlLoader.addEventListener(Event.COMPLETE, loadComplete);
			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			var request:URLRequest = new URLRequest(file);
			
			xmlLoader.load(new URLRequest(file));
		}
		
		protected function onError(event:IOErrorEvent):void
		{
			// TODO Auto-generated method stub
			trace("error : " + event.text);
		}
		
		private function progressListener(e:ProgressEvent) {
			//trace("XML Loader : Downloaded " + e.bytesLoaded + " out of " + e.bytesTotal + " bytes");
		}

		private function loadComplete(e:Event):void {
			//trace("XMLLoader: loadComplete, dispatch");
			xmlData=new XML(e.target.data);
			_callBack(xmlData);
			dispatchEvent(new Event("XML_LOADED"));
			dispatcher.doAction();
			//parseMessage(xmlData);
		}

		/*private function parseMessage(input:XML):void {
		trace("XMLLoader: XML Output");
		trace("------------------------");
		trace(input.institutions.length());
		//trace(input);
		}*/



		public function getXmlData():XML {
			return xmlData;
		}

	}
}