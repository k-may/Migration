package com.kevmayo.migration.framework
{
	import flash.geom.Point;

	public interface IDetailsContainer
	{
		function showInstitution(entry:InstitutionEntry, position:Point):void;
		function clear():void;
	}
}
