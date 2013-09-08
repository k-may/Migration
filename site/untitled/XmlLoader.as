package untitled{

	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.*;
	import flash.display.Sprite;

	internal class XmlLoader extends Sprite {

		private var xmlLoader:URLLoader = new URLLoader();
		private var xmlData:XML = new XML();
		private var file:String;

		var dispatcher:CustomDispatcher = new CustomDispatcher();

		public function XmlLoader(_file="text.xml") {
			//trace("XmlData");
			this.file=_file;
			init();

		}

		private function init() {
			var xmlLoader:URLLoader = new URLLoader();
			var xmlData:XML = new XML();
			//xmlLoader.addEventListener(ProgressEvent.PROGRESS, progressListener);
			xmlLoader.addEventListener(Event.COMPLETE, loadComplete);
			xmlLoader.load(new URLRequest(file));
		}

		private function progressListener(e:ProgressEvent) {
			//trace("XML Loader : Downloaded " + e.bytesLoaded + " out of " + e.bytesTotal + " bytes");
		}

		private function loadComplete(e:Event):void {
			//trace("XMLLoader: loadComplete, dispatch");
			xmlData=new XML(e.target.data);
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