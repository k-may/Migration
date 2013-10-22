package com.kevmayo.migration
{
	import com.kevmayo.migration.events.ClickNodeEvent;
	import com.kevmayo.migration.events.EventTypes;
	import com.kevmayo.migration.events.OverNodeEvent;
	import com.kevmayo.migration.framework.IDetailsContainer;
	import com.kevmayo.migration.framework.INodeContainer;
	import com.kevmayo.migration.framework.ITrajectoryContainer;
	import com.kevmayo.migration.framework.InstitutionEntry;
	import com.kevmayo.migration.framework.PositionEntry;
	import com.kevmayo.migration.view.Node;
	import com.kevmayo.migration.view.Trajectory;
	
	import flash.events.EventDispatcher;
	import flash.geom.Point;

	public class Controller extends EventDispatcher
	{
		private var _currentNode:Node;
		private var _nodeContainer:INodeContainer;
		private var _trajContainer:ITrajectoryContainer;
		private var _detailsContainer:IDetailsContainer;
		
		private var _hasTrajectories:Boolean = false;

		public function Controller()
		{

		}

		public function registerNodeContainer(container:INodeContainer):void
		{
			_nodeContainer=container;
			_nodeContainer.addEventListener(EventTypes.OVER_NODE, overNodeHandler);
			_nodeContainer.addEventListener(EventTypes.CLICK_NODE, clickNodeHandler);
			
		}
		
		private function clickNodeHandler(evt:ClickNodeEvent){
			if(_currentNode == evt.node){
				if(_hasTrajectories){
					_detailsContainer.showInstitution(_currentNode.entry, new Point(_currentNode.x, 0));
				}
			}
		}

		private function overNodeHandler(evt:OverNodeEvent):void
		{
			if (_currentNode == evt.node)
				return;

			_currentNode=evt.node;
			_nodeContainer.showNode(_currentNode.entry.name, _currentNode.x, _currentNode.y);

			createTrajectories();

		}

		private function createTrajectories():void
		{
			var previousNodes:Vector.<Node>=getPreviousNodes();
			var laterNodes:Vector.<Node>=getLaterNodes();
			
			if(previousNodes.length == 0 && laterNodes.length == 0){
				_hasTrajectories = false;
				return;
			}
			
			_hasTrajectories = true;
			
			_trajContainer.clear();

			for each(var node:Node in previousNodes){
				_trajContainer.addTrajectory(new Point(node.x + node.width/2, node.y),
					new Point(_currentNode.x + _currentNode.width/2, _currentNode.y));
			}
			
			for each(var node:Node in laterNodes){
				_trajContainer.addTrajectory(new Point(_currentNode.x + _currentNode.width/2, _currentNode.y),
					new Point(node.x+ node.width/2, node.y));
			}
			//dispatchEvent(new ShowTrajectoriesEvent(ShowTrajectoriesEvent.SHOW_TRAJECTORY, _current));
			//show text
		}

		private function getLaterNodes():Vector.<Node>
		{
			var laterNodes:Vector.<Node> = new Vector.<Node>();
			var positions:Vector.<PositionEntry>=_currentNode.entry.positions;

			for each (var pos:PositionEntry in positions)
			{
				//get previous position
				var previousNode:Node=getLaterNodeForPosition(pos);
				if (previousNode != null)
					laterNodes.push(previousNode);
			}
			return laterNodes;
		}
		
		private function getLaterNodeForPosition(pos:PositionEntry):Node
		{
			var laterPos:PositionEntry;
			var laterNode:Node;
			var nodes:Array=_nodeContainer.findNodesByPosition(pos);
			for each (var node:Node in nodes)
			{
				var tempPos:PositionEntry=node.entry.getPositionByName(pos.name);
				if (tempPos.startTime > pos.endTime)
				{
					if (laterPos == null || tempPos.startTime > laterPos.startTime)
					{
						laterPos=tempPos;
						laterNode=node;
					}
				}
			}
			
			return laterNode;
		}
		
		public function getPreviousNodes():Vector.<Node>
		{
			var previousNodes:Vector.<Node> = new Vector.<Node>();
			var positions:Vector.<PositionEntry>=_currentNode.entry.positions;

			for each (var pos:PositionEntry in positions)
			{
				//get previous position
				var previousNode:Node=getPreviousNodeForPosition(pos);
				if (previousNode != null)
					previousNodes.push(previousNode);
			}
			return previousNodes;
		}

		public function getPreviousNodeForPosition(pos:PositionEntry):Node
		{
			var previousPos:PositionEntry;
			var previousNode:Node;
			var nodes:Array=_nodeContainer.findNodesByPosition(pos);
			for each (var node:Node in nodes)
			{
				if(node == _currentNode)
					continue;
				
				var tempPos:PositionEntry=node.entry.getPositionByName(pos.name);
				if (tempPos.endTime < pos.startTime)
				{
					if (previousPos == null || tempPos.endTime > previousPos.endTime)
					{
						previousPos=tempPos;
						previousNode=node;
					}
				}
			}

			return previousNode;
		}

		public function registerTrajectoryContainer(container:ITrajectoryContainer)
		{
			_trajContainer=container;
		}
		
		public function registerDetailsContainer(container:IDetailsContainer){
			_detailsContainer = container;
		}

	}
}
