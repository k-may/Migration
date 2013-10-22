package com.kevmayo.migration.view
{

	import com.kevmayo.migration.Migration;
	import com.kevmayo.migration.events.OverNodeEvent;
	import com.kevmayo.migration.framework.PositionEntry;
	import com.kevmayo.migration.framework.INodeContainer;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class NodeContainer extends Sprite implements INodeContainer
	{

		private var _nodeCont:Sprite=new Sprite();
		private var _width:int;
		private var _height:int;

		/*
		private var nodesMask:Shape = new Shape();
		private var textBox:TextContainer;
		private var posList:Array = new Array();
		private var instList:Array = new Array();
		private var instLatArray:Array = new Array();
		private var trajArray:Array = new Array();
		private var cArray:Array = new Array();
		private var dirArray:Array = new Array();
		private var color:uint;
		private var dir:int;
		private var spacing:int;
		private var traj:TrajectoryController;
		public var trajContainer:Sprite = new Sprite();
		private var nodesWidth:int;
*/
		public function NodeContainer()
		{
			trace("hello from NodeContainer");
		}


		public function set nodes(_val:Array)
		{
			trace("\nNode Container : set nodes : " + _val.length);

			_nodeCont=new Sprite();

			var x:int=0;
			var y:int=Migration.NODES_PADDING_TOP;

			for each (var node:Sprite in _val)
			{
				_nodeCont.addChild(node);
				node.x=x;
				node.y=y;
				x+=node.width;
			}
			_width=x;

			this.graphics.beginFill(0xeeeeee);
			this.graphics.drawRect(0, 0, width, height);
			this.graphics.endFill();

			this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);

			addChild(_nodeCont);
			_nodeCont.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			_nodeCont.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);

			//_nodeCont.addChild(trajContainer);
		}

		protected function onMouseMove(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			trace("moues move");
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

		public function findNodesByPosition(entry:PositionEntry):Array
		{
			var nodes:Array=new Array();
			for (var i:int=0; i < _nodeCont.numChildren; i++)
			{
				var node:Node=_nodeCont.getChildAt(i) as Node;
				var positions:Vector.<PositionEntry>=node.entry.positions;
				var contains:Boolean=false;
				for each(var pos:PositionEntry in positions){
					contains = contains || pos.name == entry.name; 
				}
				
				if(contains)
					nodes.push(node);
			}

			return nodes;
		}



		/*function addTextBox(e:Event) {
			textBox.addEventListener(MouseEvent.ROLL_OUT, outNode);
			textBox.addEventListener("OVER_FIELD", overField, false);
			_nodeCont.addChild(textBox);
		}*/

		///events
		/*
		function overField(e:Event) {
			//trace("NODE CONTROLLER: overField: e.currentTaerget.name = " + e.currentTarget.name + " textBox._dir = " + textBox._dir);
			e.target.removeEventListener("OVER_FIELD", overField);
			e.target.addEventListener("OUT_FIELD", outField);
			if (e.currentTarget.name=="textBox") {
				//trace("overField: " + e.currentTarget.getChildAt(e.currentTarget.numChildren-1).name);
				if (e.currentTarget.getChildAt(e.currentTarget.numChildren-1).name=="trajectory") {
					e.currentTarget.removeChild(e.currentTarget.getChildAt(e.currentTarget.numChildren-1));
				}
			}
			visualizeField(e);
		}

		function outField(e:Event) {
			textBox.removeEventListener("OUT_FIELD", outField);
			textBox.addEventListener("OVER_FIELD", overField);
		}

		function outNode(e:MouseEvent) {
			e.target.removeEventListener(MouseEvent.ROLL_OUT, outNode);
			e.target.removePos();
			e.target.setBarColor(0xD6C8C1);
			e.target.addEventListener("OVER_NODE", overTextBox);
			e.target.addEventListener(Event.ENTER_FRAME, fadeText);
			_nodeCont.addEventListener(MouseEvent.MOUSE_OVER, overNode);
		}

		function fadeText(e:Event) {
			e.target.alpha = (e.target.alpha > 0.1)? e.target.alpha * 0.999:0;
			if (e.target.alpha==0) {
				e.target.removeEventListener(Event.ENTER_FRAME, fadeText);
				textBox.removeEventListener("OVER_NODE", overTextBox);
				textBox.removeEventListener("OVER_FIELD", overField, false);
				_nodeCont.removeChild(e.target as Sprite);
			}
		}

		function overTextBox(e:Event) {
			_nodeCont.removeEventListener(MouseEvent.MOUSE_OVER, overNode);
			e.target.removeEventListener(Event.ENTER_FRAME, fadeText);
			e.target.alpha=1;
			_nodeCont.setChildIndex(e.target as DisplayObject, _nodeCont.numChildren-1);
			e.target.addEventListener(MouseEvent.ROLL_OUT, outNode, false);
			e.target.addEventListener("OVER_FIELD", overField, false);
			e.target.addPos();
		}

		public function visualizeField(e:Event) {
			var fieldName:String=e.currentTarget.fieldName;
			var latArray:Array = new Array();
			var count=1;
			for (var i =0; i < posList.length; i ++) {//search for instence of field name in positions list
				if (fieldName==posList[i].name) {
					latArray=posList[i].latArray;
					break;
				}
			}
			if (latArray.length>1) {//if more than one instance
				var cArray:Array = new Array();
				var xPosArray:Array = new Array();
				var indexNum:uint;
				var indexArray:Array = new Array();
				var _dirArray:Array = new Array();
				for (var i:int = 0; i < latArray.length; i ++) {
					var lat:Number=latArray[i].latitude;
					indexArray[i]=instLatArray.indexOf(lat);
					_dirArray.push(textBox._dir);
				}
				addTrajectory(textBox, indexArray,_dirArray, 0x000ff0, "linear");
				traj.x-=textBox.x;
			}//if
		}

		public function addTrajectory(_cont:Sprite, indexArray:Array, _dirArray:Array, _color:uint, type:String) {
			//trace("NODE CONTROLLER: addTrajectory : " + _dirArray);
			color=_color;
			cArray = new Array();
			dirArray = new Array();
			var xPosArray:Array = new Array();
			var count=1;
			for (var j = 0; j < indexArray.length; j ++) {
				if (j==0) {
					xPosArray[j]=_nodeCont.getChildAt(indexArray[j]).x;//load first position
					dirArray[0]=_dirArray[0];
				} else {
					if (_nodeCont.getChildAt(indexArray[j]).x!=xPosArray[count-1]) {//skip reoccurance of postion
						xPosArray[count]=_nodeCont.getChildAt(indexArray[j]).x;
						dirArray[count]=_dirArray[j];
						var curveObject:Object = {x1:(xPosArray[count -1]), x2:(_nodeCont.getChildAt(indexArray[j]).x)};//{fromX, toX}
						count++;
						cArray.push(curveObject);
					}//if
				}//else
			}
			traj=new TrajectoryController(cArray,dirArray,color,type);
			_cont.addChild(traj);
		}

		public function clearTrajectory() {
			for (var i:int = trajContainer.numChildren; i > 0; i --) {
				trajContainer.removeChild(trajContainer.getChildAt(i-1));
			}
		}

		public function drawFlag(index:int, dir:int, color:uint) {
			trace("   	--->drawFlag: " + dir)
			var xPos=_nodeCont.getChildAt(index).x;
			var flag:Sprite = new Sprite();
			trajContainer.addChild(flag);
			flag.graphics.beginFill(color);
			flag.graphics.lineStyle(1,color);
			flag.graphics.moveTo(xPos+ spacing/2,(dir == 1)?spacing:0);

			flag.graphics.lineTo(xPos+ spacing/2,(dir == 1)?40+ spacing : -40);
			flag.graphics.lineTo((dir == 1)?xPos+ spacing/2-5:xPos+spacing/2+5,(dir == 1)?35+spacing :-35);
			flag.graphics.lineTo(xPos+spacing/2,(dir == 1)?30 + spacing:-30);
			flag.graphics.endFill();

		}

		public function removeTrajectories() {
			for (var i:int = 0; i < trajArray.length; i ++) {
				_nodeCont.removeChild(trajArray[i]);
			}
			trajArray = new Array();
		}

		public function savePosition(type:String) {
			var _traj:Sprite=new Sprite();
			for (var i:int = trajContainer.numChildren; i > 0; i --) {
				_traj.addChild(trajContainer.getChildAt(i-1));
			}
			trajArray.push(_traj);
			_nodeCont.addChild(trajArray[trajArray.length-1]);
		}*/

		override public function get height():Number
		{
			return _height;
		}

		override public function set height(value:Number):void
		{
			_height=value;
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
