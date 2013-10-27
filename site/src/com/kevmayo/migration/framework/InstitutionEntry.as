package com.kevmayo.migration.framework
{

	public class InstitutionEntry
	{

		private var _color:uint;
		private var _name:String;
		private var _longitude:Number;
		private var _nodeIndex:int;
		private var _startDate:String;
		private var _endDate:String;
		private var _positions:Vector.<PositionEntry>=new Vector.<PositionEntry>();
		//private var position:Object = {name:String,startDate:String,endDate:String,title:String,bio:Array};
		private var movedTo:Array=new Array();
		private var movedFrom:Array=new Array();
		private var _frequency:int;

		/**
		 * Class defines data for an institution entry
		 *
		 * @param name
		 * @param startDate
		 * @param endDate
		 * @param latitude
		 * @param nodeIndex
		 *
		 */
		public function InstitutionEntry(name:String, startDate:String, endDate:String, longitude:Number, nodeIndex:int)
		{
			_name=name;
			_startDate=startDate;
			_endDate=endDate;
			_longitude=longitude;
			_nodeIndex=nodeIndex
			_color=Math.random() * 0xffffff;
		}

		public function get endDate():String
		{
			return _endDate;
		}

		public function get startDate():String
		{
			return _startDate;
		}

		public function get color():uint
		{
			return _color;
		}

		public function getPositionByName(name:String):PositionEntry
		{
			var position:PositionEntry;
			for each (var pos:PositionEntry in _positions)
			{
				if (pos.name == name)
				{
					position=pos;
					break;
				}
			}

			return position;
		}

		public function get positions():Vector.<PositionEntry>
		{
			return _positions;
		}

		public function set positions(value:Vector.<PositionEntry>):void
		{
			_positions=value;
			_frequency=_positions.length;
		}

		public function get name():String
		{
			return _name;
		}

		public function get nodeIndex():int
		{
			return _nodeIndex;
		}


		public function get latitude():Number
		{
			return _longitude;
		}

	}

}
