package com.kevmayo.migration.framework
{
	import flash.geom.Point;

	public interface ITrajectoryContainer
	{
		function addTrajectory(start:Point, end:Point):void;
		function clear():void;
	}
}