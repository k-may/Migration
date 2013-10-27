package com.kevmayo.migration
{
	import com.kevmayo.migration.framework.CityEntry;
	import com.kevmayo.migration.framework.InstitutionEntry;
	import com.kevmayo.migration.framework.PositionEntry;
	import com.kevmayo.migration.framework.PositionType;

	import flash.utils.Dictionary;

	public class Model
	{
		private var _institutions:Vector.<InstitutionEntry>;
		private var _latitudeMap:Dictionary;

		private var _loadedCallBack:Function;

		private var _cities:Vector.<CityEntry>;
		public var startLong:Number;
		public var endLong:Number;

		private var _positions:Vector.<PositionEntry>;

		public function Model(callBack:Function)
		{
			trace("hello from model");
			_loadedCallBack=callBack
			endLong=Number.MIN_VALUE;
			startLong=Number.MAX_VALUE;
			init();
		}

		public function init()
		{
			new XMLLoader("../data/cities.xml", parceCities);
			new XMLLoader("../data/instList.xml", parceInstitutionData);
			//new XMLLoader("../posList.xml", parsePositionsData);
		}

		private function parceCities(list:XML):void
		{
			// TODO Auto Generated method stub
			var nodeCount:int=list.city.length();

			_cities=new Vector.<CityEntry>();
			var city:CityEntry;
			var longitude:Number;
			for (var i=0; i < nodeCount; i++)
			{
				city=new CityEntry();
				var xml=list.city[i];
				var name=xml.name;
				city.name=name.split("., Can")[0];
				longitude=parseLongitude(xml.longitude);
				updateStartEndLongitude(longitude);
				city.longitude=longitude;
				_cities.push(city);
			}
		}

		private function parseLongitude(str:String):Number
		{
			var vals:Array=str.split(", ");
			var deg:Number=parseFloat(vals[0]); //.toInt();
			var time:Number=parseFloat(vals[1]);
			//.toInt();
			time=time / 60;
			//time = time;
			return deg + time;


		}

		private function parsePositionsData(list:XML):void
		{
			// TODO Auto Generated method stub

		}

		private function parceInstitutionData(list:XML):void
		{
			var nodeCount:int=list.institutions.length();
			_institutions=new Vector.<InstitutionEntry>();
			_latitudeMap=new Dictionary();
			_positions=new Vector.<PositionEntry>();

			var institutionEntry:InstitutionEntry;
			var positionEntry:PositionEntry;
			var listXML:XML;
			var positions:Vector.<PositionEntry>;
			var posNum:int;
			var longitude:Number;
			for (var i:int=0; i < nodeCount; i++)
			{ //go through every inst
				listXML=list.institutions[i];

				longitude=Math.abs(listXML.inst_long);

				updateStartEndLongitude(longitude);

				institutionEntry=new InstitutionEntry(listXML.inst_name, listXML.inst_start_date, listXML.inst_end_date, longitude, i);
				posNum=listXML.positions.position.length();

				_latitudeMap[Number(listXML.inst_lat)]=institutionEntry;

				positions=new Vector.<PositionEntry>();
				var pos:PositionEntry;
				for (var j:int=0; j < posNum; j++)
				{
					pos=parsePosition(listXML.positions.position[j]);
					if (pos != null)
						positions.push(pos);
				}

				institutionEntry.positions=positions;

				_institutions.push(institutionEntry);
			}

			_loadedCallBack();
		}

		private function updateStartEndLongitude(longitude:Number):void
		{
			// TODO Auto Generated method stub
			if (longitude > endLong)
				endLong=longitude;

			if (longitude < startLong)
				startLong=longitude;

		}

		private function parsePosition(node:XML):PositionEntry
		{
			var firstName:String=node.first_name;
			var lastName:String=node.last_name;
			if (firstName == "" || lastName == "")
				return null;

			var name=lastName + ", " + firstName;
			var type:PositionType=parsePositionType(node);
			var startDate:String=node.start_date;
			var endDate:String=node.end_date;
			var posEntry:PositionEntry=new PositionEntry(name, startDate, endDate, type);

			addPosition(posEntry);

			return posEntry;
		}

		private function addPosition(posEntry:PositionEntry)
		{
			var contains:Boolean=false;
			for each (var pos:PositionEntry in _positions)
			{
				if (pos.name == posEntry.name)
				{
					contains=true;
					break;
				}
			}
			if (!contains)
				_positions.push(posEntry);
		}

		private function parsePositionType(node:XML):PositionType
		{
			return node.title == "curator" ? PositionType.Curator : PositionType.Director;
		}


		public function get institutions():Vector.<InstitutionEntry>
		{
			return _institutions;
		}


		public function get cities():Vector.<CityEntry>
		{
			return _cities;
		}

		public function getInstitutionNames():Array
		{
			var instNames:Array=new Array();
			for each (var inst:InstitutionEntry in _institutions)
			{
				instNames.push({text: inst.name, color: inst.color});
			}
			instNames.sortOn("text");
			return instNames;
		}

		public function getPositionNames():Array
		{
			var posNames:Array=new Array();
			for each (var posEntry:PositionEntry in _positions)
			{
				posNames.push({text: posEntry.name, color: posEntry.color});
			}
			posNames.sortOn("text");
			return posNames;

		}

		public function getPositionByName(name:String):PositionEntry
		{
			for each (var pos:PositionEntry in _positions)
			{
				if (pos.name == name)
					return pos;
			}
			return null;
		}

		public function getInstitutionByName(name:String):InstitutionEntry
		{
			for each (var inst:InstitutionEntry in _institutions)
			{
				if (inst.name == name)
					return inst;
			}
			return null;
		}

		public function getLocalEntryForLongitude(value:Number):Number
		{
			var minDiff:Number=Number.MAX_VALUE;
			var diff:Number;
			var index:int=-1;
			var inst:InstitutionEntry;
			for (var i:int=0; i < _institutions.length; i++)
			{
				inst=_institutions[i];
				diff=Math.abs(value - inst.latitude)
				if (diff < minDiff)
				{
					index=i;
					minDiff=diff;
				}
			}

			if (index != -1)
			{
				var nI:int=_institutions[index].nodeIndex;
				var l:int=_institutions.length;
				trace("nI : " + nI + " / " + l);
				return nI / l;

			}

			return 0;
		}
	}
}
