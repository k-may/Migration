package untitled{

	import flash.net.URLLoader;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.text.*;

	public class PosReader extends Sprite {

		private var xmlLoader:XmlLoader;
		private var xmlData:XML = new XML();
		private var fieldLength:uint;
		private var file:String;
		private var listArray:Array;
		private var listObject:PosObject;

		public function PosReader(_file) {
			this.file=_file;
			init();
		}

		private function init() {
			xmlLoader=new XmlLoader(file);
			xmlLoader.addEventListener("XML_LOADED",retrieveData);
		}

		private function retrieveData(e:Event) {
			xmlData=xmlLoader.getXmlData();
			this.addEventListener("LIST_COMPLETE", listComplete);
			parceData(xmlData);
		}

		private function parceData(list:XML) {
			listArray=new Array(nodeNum);
			for (var i:int = 0; i < nodeNum; i ++) {//go through every position
				var listXML:XML=list.Name[i];
				listObject = new PosObject();
				listObject.name=list.Name[i].last_name+", "+list.Name[i].first_name;
				var posLength=list.Name[i].Position.length();
				for (var j = 0; j < posLength; j ++) {
					if(j ==0){
						listObject.startDate =list.Name[i].Position[j].@start_date;
					}
					listObject.latArray[j]={position:list.Name[i].Position[j],latitude:list.Name[i].Position[j].@latitude};//data comes sorted by date!
				}
				listObject.frequency = posLength;
				listArray[i]=listObject;
			}
			dispatchEvent(new Event("LIST_COMPLETE"));
		}

		private function listComplete(e:Event) {
			dispatchEvent(new Event("POS_DATA_READ"));
		}

		public function get nodeNum():uint {
			return xmlData.Name.length();
		}

		public function getListArray():Array {
			return listArray;
		}
	}
}