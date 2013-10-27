package com.kevmayo.migration.framework
{
	import flash.events.IEventDispatcher;
	
	public interface IContainer extends IEventDispatcher
	{
		function onMenuSelected():void;
		function get pos():Number;
		function set pos(value:Number):void;
		function animateToNode(node:Node):void;
	}
}