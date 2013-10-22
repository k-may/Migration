package com.kevmayo.migration.Trajectory
{
	import flash.geom.Point;

	public class TrajectoryItem
	{
		private var _startPoint:Point;
		private var _endPoint:Point;
	
		public function TrajectoryItem(startPoint:Point, endPoint:Point)
		{
			_startPoint = startPoint;
			_endPoint = endPoint;
		}

		public function get startPoint():Point
		{
			return _startPoint;
		}

		public function get endPoint():Point
		{
			return _endPoint;
		}

	}
}