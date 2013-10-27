package com.kevmayo.migration.framework
{
	import flash.geom.Point;

	public interface ITrajectoryContainer
	{
		function addTrajectory(start:Point, end:Point, color:uint = 0xfff):void;
		function clear():void;
	}
}