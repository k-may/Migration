package com.kevmayo.migration.dump
{

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import com.kevmayo.migration.XMLLoader;
	import com.kevmayo.migration.data.PosObject;

	public class PositionsReader extends Sprite
	{
		private var xmlLoader:XMLLoader;
		private var xmlData:XML=new XML();
		private var fieldLength:uint;
		private var file:String;
		private var listArray:Array;
		private var listObject:PosObject;
		private var _callBack:Function;

		public function PositionsReader(_file, callBack:Function)
		{
			this.file=_file;
			_callBack=callBack;

			init();
		}

		private function init()
		{
			xmlLoader=new XMLLoader(file, parseData);
		}

		private function parseData(list:XML)
		{
			listArray=new Array(nodeNum);
			for (var i:int=0; i < nodeNum; i++)
			{ //go through every position
				var listXML:XML=list.Name[i];
				listObject=new PosObject();
				listObject.name=list.Name[i].last_name + ", " + list.Name[i].first_name;
				var posLength=list.Name[i].Position.length();
				for (var j=0; j < posLength; j++)
				{
					if (j == 0)
					{
						listObject.startDate=list.Name[i].Position[j].@start_date;
					}
					listObject.latArray[j]={position: list.Name[i].Position[j], latitude: list.Name[i].Position[j].@latitude}; //data comes sorted by date!
				}
				listObject.frequency=posLength;
				listArray[i]=listObject;
			}
			_callBack(listArray);
			dispatchEvent(new Event("POS_DATA_READ"));
		}

		public function get nodeNum():uint
		{
			return xmlData.Name.length();
		}

		public function getListArray():Array
		{
			return listArray;
		}
	}
}
