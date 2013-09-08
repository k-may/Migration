package untitled{

	import flash.net.URLLoader;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.display.Sprite;

	internal class XmlReader extends Sprite {

		private var xmlLoader:XmlLoader;
		private var xmlData:XML = new XML();
		private var fieldLength:uint;
		private var file:String;

		private var listArray:Array;
		private var listObject:ListObject;
				public var posNum:int;
				var XMLdebug:TextField = new TextField();
		//private var xml:XML = new XML();

		public function XmlReader(_file) {
			this.file = _file;
			trace("XmlReader + file");
			addChild(XMLdebug);
			XMLdebug.text = "xmlDebug");
			
			init();
		}

		private function init() {
			xmlLoader = new XmlLoader(file);
			xmlLoader.addEventListener("XML_LOADED",retrieveData);
		}

		private function retrieveData(e:Event) {
			trace("XmlReader: load listener. retrieve data");
			xmlData = xmlLoader.getXmlData();
			this.addEventListener("LIST_COMPLETE", listComplete);
			parceData(xmlData);
		}

		private function parceData(list:XML) {
			listArray = new Array(nodeNum);
			for (var i:int = 0; i < nodeNum; i ++) { //go through every inst
				var listXML:XML = list.institutions[i];
				listObject = new ListObject();
				listObject.instLat = listXML.inst_lat;
				listObject.instName = listXML.inst_name;
				listObject.instStart = listXML.inst_start_date;
				listObject.instEnd = listXML.inst_end_date;
				posNum = listXML.positions.position.length();

				for (var j = 0; j < posNum; j ++) { //go through every pos
					var firstName = listXML.positions.position[j].first_name;
					var lastName = listXML.positions.position[j].last_name;
					listObject.position.name = firstName + " " + lastName;
					//trace("list Object: name= " + position.name);
					listObject.position.startDate = listXML.positions.position[j].start_date;
					//trace("list Object: start date = " + position.startDate);
					listObject.position.endDate = listXML.positions.position[j].end_date;
					//trace("list Object: end Date = " + position.endDate);
					listObject.position.title = listXML.positions.position[j].title;
					//trace("list Object: title= " + position.title);
				}

				listArray[i] = listObject;
			}
			dispatchEvent(new Event("LIST_COMPLETE"));
		}

		private function listComplete(e:Event) {
						trace("XmlReader: list complete. dispatch data read");
			dispatchEvent(new Event("DATA_READ"));
			XMLdebug.text = "list loaded";
		}

		public function get nodeNum():uint {
			return xmlData.institutions.length();
		}

		public function getListArray():Array {
			return listArray;
		}
	}
}