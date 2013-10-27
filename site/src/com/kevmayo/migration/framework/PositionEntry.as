package com.kevmayo.migration.framework
{

	public class PositionEntry
	{
		private var _name:String;
		private var _startDate:String;
		private var _startTime:int;
		private var _endTime:int;
		private var _endDate:String;
		private var _type:PositionType;
		private var _color:uint;
		private var _numPositions:int;
		/**
		 * Class defines position entry for either curator or director
		 *  
		 * @param Entry name
		 * @param startDate
		 * @param endDate
		 * @param type
		 * 
		 */		
		public function PositionEntry(name:String, startDate:String, endDate:String, type:PositionType)
		{
			_name = name;
			_startDate = startDate;
			
			_startTime = parseInt(startDate.split("-")[0]);
			
			_endDate = endDate;
			_endTime = parseInt(endDate.split("-")[0]);
			
			if(_endTime == 0)
				_endTime = int.MAX_VALUE;
			
			_type = type;
			
			_color = Math.random() * 0xffffff;
		}

		public function get color():uint
		{
			return _color;
		}

		public function get endTime():int
		{
			return _endTime;
		}

		public function get startTime():int
		{
			return _startTime;
		}

		public function get endDate():String
		{
			return _endDate;
		}

		public function get startDate():String
		{
			return _startDate;
		}

		public function get name():String
		{
			return _name;
		}

		public function get type():PositionType
		{
			return _type;
		}

	}
	

}