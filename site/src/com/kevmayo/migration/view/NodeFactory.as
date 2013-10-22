﻿package com.kevmayo.migration.view{
	import com.kevmayo.migration.framework.InstitutionEntry;
	import com.kevmayo.migration.framework.INodeFactory;

	public class NodeFactory implements INodeFactory {

		private const _fillOddColor:int = 0xDEE9FE
		private const _fillColor:int = 0xffffff;
		private const _hoverColor:int = 0xffffff;
		private const _lineColor:int = 0x7E7F81
		
		public function NodeFactory(){
			
		}
		
		public function createNodes(institutions:Vector.<InstitutionEntry>):Array {
			var fillColor:int;
			var node:Node;
			var nodeArray:Array = new Array(institutions.length);
			 
			//alternate fill color every 5th node for visual clarity
			for (var i:uint =0; i < institutions.length; i ++) {
				if (i%5==0) {
					fillColor=_fillOddColor;
				} else {
					fillColor=_fillColor;
				}
				node=new Node(fillColor,_hoverColor,_lineColor, institutions[i]);
				nodeArray.push(node);
			}
			return nodeArray;
		}

	}
}