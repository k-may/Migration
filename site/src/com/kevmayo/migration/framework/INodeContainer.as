package com.kevmayo.migration.framework
{
	import flash.events.IEventDispatcher;

	public interface INodeContainer extends IEventDispatcher
	{
		function showNode(text:String, x:int, y:int);
		function findNodesByPosition(entry:PositionEntry):Array;
		function findNodeByInstitution(entry:InstitutionEntry):Node;
	}
}