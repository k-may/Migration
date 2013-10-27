package com.kevmayo.migration.framework
{
	import flash.geom.Point;

	public interface IFlagContainer
	{
		function clear():void;
		function addFlags(pos:Array):void;
		function addFlag(pos:Point, color:uint):void;
	}
}