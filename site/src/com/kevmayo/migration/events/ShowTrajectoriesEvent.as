package com.kevmayo.migration.events
{
	import com.kevmayo.migration.view.Trajectory;
	
	import flash.events.Event;
	import flash.geom.Point;
	
	public class ShowTrajectoriesEvent extends Event
	{
		private var _trajectories:Array;
		
		public function ShowTrajectoriesEvent(trajectories:Array)
		{
			super(EventTypes.SHOW_TRAJECTORY, bubbles, cancelable);
			
			_trajectories = trajectories;
		}

		public function get trajectories():Array
		{
			return _trajectories;
		}

	}
}