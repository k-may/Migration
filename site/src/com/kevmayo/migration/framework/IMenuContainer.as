package com.kevmayo.migration.framework
{
	import flash.events.IEventDispatcher;

	public interface IMenuContainer extends IEventDispatcher
	{
		function setState(state:String):void;
		function set isOpen(value:Boolean):void;
		function get isOpen():Boolean;
		function update():void;
		function get state():String;
		function setActive(name:String):void;
	}
}