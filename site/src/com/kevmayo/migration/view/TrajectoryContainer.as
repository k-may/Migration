package com.kevmayo.migration.view
{

	import com.kevmayo.migration.framework.ITrajectoryContainer;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;


	public class TrajectoryContainer extends Sprite implements ITrajectoryContainer
	{

		//var dir:int;
		private var _width:int;
		private var _height:int;
		private var _trajectories:Vector.<Trajectory>;

		public function TrajectoryContainer()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}


		protected function onAddedToStage(event:Event):void
		{
			//init
		}

		public function addTrajectory(start:Point, end:Point):void
		{
			var traj:Trajectory=new Trajectory(new Point(0, start.y), new Point(end.x - start.x, start.y));
			addChild(traj);
			traj.x = start.x;
			_trajectories.push(traj);

			//if (_trajectories.length == 0)
				//addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		protected function onEnterFrame(event:Event):void
		{
			for each (var traj:Trajectory in _trajectories)
			{
				traj.update(1);
			}
		}

		public function clear():void
		{
			for each (var traj:Trajectory in _trajectories)
			{
				removeChild(traj);
			}

			_trajectories=new Vector.<Trajectory>();
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		public override function get height():Number
		{
			return _height;
		}

		public override function set height(value:Number):void
		{
			_height=value;
		}

		public override function get width():Number
		{
			return _width;
		}

		public override function set width(value:Number):void
		{
			_width=value;
		}
	}
}
