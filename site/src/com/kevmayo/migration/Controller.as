package com.kevmayo.migration
{
	import com.kevmayo.migration.events.ClickNodeEvent;
	import com.kevmayo.migration.events.EntrySelectedEvent;
	import com.kevmayo.migration.events.EventTypes;
	import com.kevmayo.migration.events.OverNodeEvent;
	import com.kevmayo.migration.framework.IContainer;
	import com.kevmayo.migration.framework.IDetailsContainer;
	import com.kevmayo.migration.framework.IFlagContainer;
	import com.kevmayo.migration.framework.IMenuContainer;
	import com.kevmayo.migration.framework.INodeContainer;
	import com.kevmayo.migration.framework.ITitleView;
	import com.kevmayo.migration.framework.ITrajectoryContainer;
	import com.kevmayo.migration.framework.InstitutionEntry;
	import com.kevmayo.migration.framework.Node;
	import com.kevmayo.migration.framework.PositionEntry;
	import com.kevmayo.migration.view.Container;
	import com.kevmayo.migration.view.Trajectory;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;

	public class Controller extends EventDispatcher
	{
		private var _titleView:ITitleView;
		private var _flagContainer:IFlagContainer;
		private var _currentNode:Node;
		private var _nodeContainer:INodeContainer;
		private var _trajContainer:ITrajectoryContainer;
		private var _detailsContainer:IDetailsContainer;
		private var _menuContainer:IMenuContainer;
		private var _container:IContainer;
		private var _hasTrajectories:Boolean=false;
		private var _model:Model;

		public function Controller(model:Model)
		{
			_model=model;
		}

		public function registerContainer(container:IContainer)
		{
			_container=container;
		}

		public function registerMenuContainer(container:IMenuContainer):void
		{
			_menuContainer=container;
			_menuContainer.addEventListener(EventTypes.MAIN_BTN_CLICK, onHandleMenuClicked);
			_menuContainer.addEventListener(EventTypes.ENTRY_SELECTED, onEntrySelectedEvent);
		}

		public function registerNodeContainer(container:INodeContainer):void
		{
			_nodeContainer=container;
			_nodeContainer.addEventListener(EventTypes.OVER_NODE, overNodeHandler);
			_nodeContainer.addEventListener(EventTypes.CLICK_NODE, clickNodeHandler);

		}

		private function onHandleMenuClicked(e):void
		{
			// TODO Auto Generated method stub
			trace("menu clicked");
			_menuContainer.isOpen=!_menuContainer.isOpen;
			_container.onMenuSelected();

			if (_menuContainer.isOpen)
				_menuContainer.setState("positions");
		}

		private function clickNodeHandler(evt:ClickNodeEvent)
		{
			_detailsContainer.clear();

			if (_currentNode == evt.node)
			{
				institutionSelected(evt.node);
			}
		}

		private function overNodeHandler(evt:OverNodeEvent):void
		{
			if (_currentNode == evt.node)
				return;


			_flagContainer.clear();
			_trajContainer.clear();

			_currentNode=evt.node;
			_nodeContainer.showNode(_currentNode.entry.name, _currentNode.x, _currentNode.y);

			createNodeTrajectories();

		}

		private function onEntrySelectedEvent(e:Event)
		{
			var evt:EntrySelectedEvent=e as EntrySelectedEvent;

			_flagContainer.clear();
			_trajContainer.clear();

			if (_menuContainer.state == "positions")
			{
				var pos:PositionEntry=_model.getPositionByName(evt.name);
				positionSelected(pos);
			}else{
				var inst:InstitutionEntry = _model.getInstitutionByName(evt.name);
				var node:Node = _nodeContainer.findNodeByInstitution(inst);
				institutionSelected(node);
			}
				

			_menuContainer.setActive(evt.name);
		}

		private function positionSelected(pos:PositionEntry)
		{
			if (pos != null)
			{
				var nodes:Array=_nodeContainer.findNodesByPosition(pos);
				if (nodes.length > 1)
					createTrajectoriesForPositionNodes(nodes, pos.color);

				createFlagsForPositionNodes(nodes, pos.color);
				_container.animateToNode(nodes[nodes.length - 1].node);


			}
			else
				trace("wierd, no position for name!");
		}

		private function createFlagsForPositionNodes(nodes:Array, color:uint):void
		{
			// TODO Auto Generated method stub
			for each (var obj:Object in nodes)
			{
				_flagContainer.addFlag(obj.pos, color);
			}
			//_flagContainer.addFlags(nodes);
		}

		private function institutionSelected(node:Node)
		{
			_container.animateToNode(node);
			_detailsContainer.showInstitution(node.entry, new Point(node.x, 0));
		}

		private function createTrajectoriesForPositionNodes(nodes:Array, color:uint)
		{
			var positions:Array=getTrajectoriesForPositions(nodes);
			for each (var traj:Object in positions)
			{
				_trajContainer.addTrajectory(traj.start, traj.end, color);
			}
		}

		private function createNodeTrajectories():void
		{
			var previousNodes:Array=getPreviousNodeTargets();
			var laterNodes:Array=getLaterNodeTargets();

			if (previousNodes.length == 0 && laterNodes.length == 0)
			{
				_hasTrajectories=false;
				return;
			}

			_hasTrajectories=true;

			_trajContainer.clear();
			var currentPoint=new Point(_currentNode.x, _currentNode.y);

			for each (var node:Object in previousNodes)
			{
				_trajContainer.addTrajectory(node.point, currentPoint, node.color);
			}

			for each (var node:Object in laterNodes)
			{
				_trajContainer.addTrajectory(currentPoint, node.point, node.color);
			}

			//dispatchEvent(new ShowTrajectoriesEvent(ShowTrajectoriesEvent.SHOW_TRAJECTORY, _current));
			//show text
		}

		private function getLaterNodeTargets():Array
		{
			var laterNodes:Array=new Array();
			var positions:Vector.<PositionEntry>=_currentNode.entry.positions;

			for each (var pos:PositionEntry in positions)
			{
				//get previous position
				var previousNode:Node=getLaterNodeForPosition(pos);
				if (previousNode != null)
					laterNodes.push({point: new Point(previousNode.x, previousNode.y), color: pos.color});
			}
			return laterNodes;
		}

		private function getLaterNodeForPosition(pos:PositionEntry):Node
		{
			var laterPos:PositionEntry;
			var laterNode:Node;
			var nodes:Array=_nodeContainer.findNodesByPosition(pos);
			for each (var obj:Object in nodes)
			{
				var node=obj.node;
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

		private function getTrajectoriesForPositions(nodes:Array):Array
		{
			nodes.sortOn("startTime");

			var posNodes:Array=new Array();

			var node:Node=nodes[0].node;
			var startPos:Point=new Point(node.x, node.y);
			var endPos:Point;
			for (var i:int=1; i < nodes.length; i++)
			{
				node=nodes[i].node;
				endPos=new Point(node.x, node.y);
				var traj={start: startPos, end: endPos};
				posNodes.push(traj);
			}

			return posNodes;
		}


		public function getPreviousNodeTargets():Array
		{
			var previousNodes:Array=new Array();
			var positions:Vector.<PositionEntry>=_currentNode.entry.positions;

			for each (var pos:PositionEntry in positions)
			{
				//get previous position
				var previousNode:Node=getPreviousNodeForPosition(pos);
				if (previousNode != null)
					previousNodes.push({point: new Point(previousNode.x, previousNode.y), color: pos.color});
			}
			return previousNodes;
		}

		public function getPreviousNodeForPosition(pos:PositionEntry):Node
		{
			var previousPos:PositionEntry;
			var previousNode:Node;
			var nodes:Array=_nodeContainer.findNodesByPosition(pos);
			for each (var obj:Object in nodes)
			{
				var node:Node=obj.node;
				if (node == _currentNode)
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

		public function registerDetailsContainer(container:IDetailsContainer)
		{
			_detailsContainer=container;
		}

		public function registerFlagContainer(container:IFlagContainer)
		{
			_flagContainer=container;
		}

		public function registerTitleView(titleView:ITitleView)
		{
			_titleView=titleView;
			_titleView.setText("Migration Patterns of Curators and Directors of Canadian Art Institutions, 1900 - 2012");
		}
	}
}
