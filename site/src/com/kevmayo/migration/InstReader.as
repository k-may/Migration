package com.kevmayo.migration{

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;

	public class InstReader extends Sprite {

		private var xmlLoader:XmlLoader;
		private var xmlData:XML=new XML  ;
		private var file:String;
		private var listArray:Array;
		private var latArray:Array;
		public var posNum:int;


		public function InstReader(_file) {
			this.file=_file;
			init();
		}

		private function init() {
			xmlLoader=new XmlLoader(file);
			xmlLoader.addEventListener("XML_LOADED",retrieveData);
		}

		private function retrieveData(e:Event) {
			xmlData=xmlLoader.getXmlData();
			this.addEventListener("LIST_COMPLETE",listComplete);
			parceData(xmlData);
		}

		private function parceData(list:XML) {
			listArray=new Array(nodeNum);
			latArray=new Array(nodeNum);

			for (var i:int=0; i<nodeNum; i++) {//go through every inst
				var listXML:XML=list.institutions[i];
				var listObject:InstObject=new InstObject  ;
				listObject.latitude=listXML.inst_lat;
				listObject.name=listXML.inst_name;
				listObject.startDate=listXML.inst_start_date;
				listObject.endDate=listXML.inst_end_date;
				listObject.nodeIndex = i;
				posNum=listXML.positions.position.length();
				latArray[i]=Number(listXML.inst_lat);
				for (var j=0; j<posNum; j++) {//go through every pos
					var firstName=listXML.positions.position[j].first_name;
					var lastName=listXML.positions.position[j].last_name;
					var position:Object={name:String,startDate:String,endDate:String,title:String,bio:Array};
					position.name=lastName+", "+firstName;
					position.startDate=listXML.positions.position[j].start_date;
					position.endDate=listXML.positions.position[j].end_date;
					position.title=listXML.positions.position[j].title;
					listObject.posArray[j]=position;
				}
				listObject.frequency = posNum;
				listArray[i]=listObject;
			}
			dispatchEvent(new Event("LIST_COMPLETE"));
		}

		private function listComplete(e:Event) {
			dispatchEvent(new Event("INST_DATA_READ"));
		}

		public function get nodeNum():uint {
			return xmlData.institutions.length();
		}

		public function getListArray():Array {
			return listArray;
		}

		public function getLatArray():Array {
			return latArray;
		}
	}
}