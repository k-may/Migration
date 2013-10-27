package com.kevmayo.migration.view
{

	import com.kevmayo.migration.Migration;
	import com.kevmayo.migration.events.ClickNodeEvent;
	import com.kevmayo.migration.events.OverNodeEvent;
	import com.kevmayo.migration.framework.INode;
	import com.kevmayo.migration.framework.INodeContainer;
	import com.kevmayo.migration.framework.InstitutionEntry;
	import com.kevmayo.migration.framework.Node;
	import com.kevmayo.migration.framework.PositionEntry;

	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class NodeContainer extends Sprite implements INodeContainer
	{

		private var _nodeCont:Sprite=new Sprite();
		private var _width:int;
		private var _height:int;
		private var _nodePadding:int=23;
		private var _invalidated:Boolean=false;

		public function NodeContainer()
		{
			trace("hello from NodeContainer");
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

		}

		protected function onAddedToStage(event:Event):void
		{
			// TODO Auto-generated method stub
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		public function set nodes(_val:Vector.<Node>)
		{
			//trace("\nNode Container : set nodes : " + _val.length);

			_nodeCont=new Sprite();
			addChild(_nodeCont);

			var x:int=0;
			//var y:int=Migration.NODES_PADDING_TOP;
			var count:int=0;

			for each (var node:Node in _val)
			{
				_nodeCont.addChild(node);
				node.x=x;
				//node.y=y;
				count++;
				node.setRotation(count % 2 == 0 ? 45 : 0);
				x+=_nodePadding;
			}
			_width=x;

			this.graphics.beginFill(0xeeeeee);
			this.graphics.drawRect(0, 0, width, height);
			this.graphics.endFill();

			this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);

			_nodeCont.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			_nodeCont.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			_nodeCont.addEventListener(MouseEvent.CLICK, onMouseClick);

			//_nodeCont.addChild(trajContainer);
		}

		public function update()
		{
			if (_invalidated)
			{
				_invalidated=false;

				var y:int=_height / 2;
				for (var i:int=0; i < _nodeCont.numChildren; i++) // node:Node in _val)
				{
					var node:Node=_nodeCont.getChildAt(i) as Node;
					node.y=y;
				}
			}
		}

		protected function onMouseClick(event:MouseEvent):void
		{
			if (event.target is Node)
			{
				dispatchEvent(new ClickNodeEvent(event.target as Node));
			}
		}

		protected function onMouseMove(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			//trace("moues move");
		}

		protected function onMouseOut(event:MouseEvent):void
		{
			// TODO Auto-generated method stub

		}

		private function onMouseOver(e:MouseEvent)
		{

			if (e.target is Node)
			{
				dispatchEvent(new OverNodeEvent(e.target as Node));
			}
		}

		public function findNodeByInstitution(entry:InstitutionEntry):Node
		{
			var node:Node;
			for (var i:int=0; i < _nodeCont.numChildren; i++)
			{
				node=_nodeCont.getChildAt(i) as Node;
				if (node.entry.name == entry.name)
					return node;
			}

			return node;
		}

		public function findNodesByPosition(entry:PositionEntry):Array
		{
			var nodes:Array=new Array();
			for (var i:int=0; i < _nodeCont.numChildren; i++)
			{
				var node:Node=_nodeCont.getChildAt(i) as Node;
				var positions:Vector.<PositionEntry>=node.entry.positions;
				var contains:Boolean=false;
				for each (var pos:PositionEntry in positions)
				{
					if (pos.name == entry.name)
					{
						nodes.push({node: node, startTime: pos.startTime, pos: new Point(node.x, node.y), color: node.entry.color});
						break;
					}
				}
			}

			return nodes;
		}


		override public function get height():Number
		{
			return _height;
		}

		override public function set height(value:Number):void
		{
			_height=value;
			_invalidated=true;
		}

		override public function get width():Number
		{
			return _width;
		}


		public function showNode(text:String, x:int, y:int)
		{
			// TODO Auto Generated method stub
			return null;
		}

	}
}
