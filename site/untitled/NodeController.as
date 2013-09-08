package untitled{

	import flash.events.*;
	import flash.events.EventDispatcher;
	import flash.display.*;

	public class NodeController extends Sprite {

		public var nodes:Sprite = new Sprite();
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
		private var h,w:int;
		private var yPos:int;
		private var traj:TrajectoryController;
		public var trajContainer:Sprite = new Sprite();
		private var nodesWidth:int;

		public function NodeController(_yPos:int, _h:int, _spacing:int) {
			//trace("hello from NodeController");
			this.yPos=_yPos;
			this.h=_h;
			this.spacing=_spacing;
		}

		public function border(x,y,w,h) {
			nodesMask.graphics.clear();
			nodesMask.graphics.beginFill(0);
			nodesMask.graphics.drawRect(x,y,w,h);
			nodesMask.graphics.endFill();
		}

		public function set _nodesWidth(_val) {
			nodesWidth=_val;
		}

		public function set _w(_val) {
			this.w=_val;
		}

		public function set _nodes(_val) {
			nodes=_val;
			//nodes.buttonMode=true;
			addChild(nodes);
			addChild(nodesMask);
			nodes.mask=nodesMask;
			nodes.y=yPos;
			nodes.addEventListener(MouseEvent.MOUSE_OVER, overNode);
			nodes.addChild(trajContainer);
		}

		public function set _posList(_val) {
			posList=_val;
		}

		public function set _instList(_val) {
			instList=_val;
			for (var i:int =0; i <  instList.length; i ++) {
				instLatArray[i]=instList[i].latitude;
			}
		}

		public function set _nodeXPos(_val) {
			nodes.x=_val;
		}

		public function get _nodeXPos():int {
			return nodes.x;
		}

		private function overNode(e:MouseEvent) {
			
			if (e.target.name=="node") {
				
				nodes.removeEventListener(MouseEvent.MOUSE_OVER, overNode);
				textBox=new TextContainer(e.target._list,h,spacing);
				textBox.addEventListener("TEXT_COMPLETE", addTextBox);
				textBox.init();
				textBox.x=e.target.x;
				textBox.name="textBox";
			}
		}

		function addTextBox(e:Event) {
			textBox.addEventListener(MouseEvent.ROLL_OUT, outNode);
			textBox.addEventListener("OVER_FIELD", overField, false);
			nodes.addChild(textBox);
		}

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
			nodes.addEventListener(MouseEvent.MOUSE_OVER, overNode);
		}

		function fadeText(e:Event) {
			e.target.alpha = (e.target.alpha > 0.1)? e.target.alpha * 0.999:0;
			if (e.target.alpha==0) {
				e.target.removeEventListener(Event.ENTER_FRAME, fadeText);
				textBox.removeEventListener("OVER_NODE", overTextBox);
				textBox.removeEventListener("OVER_FIELD", overField, false);
				nodes.removeChild(e.target as Sprite);
			}
		}

		function overTextBox(e:Event) {
			nodes.removeEventListener(MouseEvent.MOUSE_OVER, overNode);
			e.target.removeEventListener(Event.ENTER_FRAME, fadeText);
			e.target.alpha=1;
			nodes.setChildIndex(e.target, nodes.numChildren-1);
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
					xPosArray[j]=nodes.getChildAt(indexArray[j]).x;//load first position
					dirArray[0]=_dirArray[0];
				} else {
					if (nodes.getChildAt(indexArray[j]).x!=xPosArray[count-1]) {//skip reoccurance of postion
						xPosArray[count]=nodes.getChildAt(indexArray[j]).x;
						dirArray[count]=_dirArray[j];
						var curveObject:Object = {x1:(xPosArray[count -1]), x2:(nodes.getChildAt(indexArray[j]).x)};//{fromX, toX}
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
			var xPos=nodes.getChildAt(index).x;
			var flag:Sprite = new Sprite();
			trajContainer.addChild(flag);
			flag.graphics.beginFill(color);
			flag.graphics.lineStyle(1,color);
			flag.graphics.moveTo(xPos+ spacing/2,(dir == 1)?spacing:0);
			/*flag.graphics.lineTo(xPos+ spacing/2,(dir == 1)?40+ spacing - 5*flagArray.length: -40 +5*flagArray.length);
			flag.graphics.lineTo((dir == 1)?xPos+ spacing/2-5:xPos+spacing/2+5,(dir == 1)?35+spacing - 5*flagArray.length:-35+ 5*flagArray.length);
			flag.graphics.lineTo(xPos+spacing/2,(dir == 1)?30 + spacing- 5*flagArray.length:-30+ 5*flagArray.length);*/
			flag.graphics.lineTo(xPos+ spacing/2,(dir == 1)?40+ spacing : -40);
			flag.graphics.lineTo((dir == 1)?xPos+ spacing/2-5:xPos+spacing/2+5,(dir == 1)?35+spacing :-35);
			flag.graphics.lineTo(xPos+spacing/2,(dir == 1)?30 + spacing:-30);
			flag.graphics.endFill();

		}

		public function removeTrajectories() {
			for (var i:int = 0; i < trajArray.length; i ++) {
				nodes.removeChild(trajArray[i]);
			}
			trajArray = new Array();
		}

		public function savePosition(type:String) {
			var _traj:Sprite=new Sprite();
			for (var i:int = trajContainer.numChildren; i > 0; i --) {
				_traj.addChild(trajContainer.getChildAt(i-1));
			}
			trajArray.push(_traj);
			nodes.addChild(trajArray[trajArray.length-1]);
		}
	}
}