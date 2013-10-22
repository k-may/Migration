package com.kevmayo.migration.framework
{

	public interface INodeFactory
	{
		function createNodes(institutions:Vector.<InstitutionEntry>):Array;
	}
}