package untitled{

	import flash.events.*;
	import flash.events.EventDispatcher;
	import flash.display.*;

	public class NodeCreator extends Sprite {

		private var node:Node;
		public var nArray:Array;
		private var gWidth:uint;
		private var nodeNum:uint=0;
		private var bG:Shape;
		//private var textContainer:TextContainer;
		private var nodeMask:Shape = new Shape();
		public var nodeContainer:Sprite = new Sprite();
		private var listArray:Array = new Array();
		public var latArray:Array = new Array();
		private var sW,sH:Number;
		private var shape:Shape;
		private var margin:int=10;
		private var spacing=15;

		public function NodeCreator(_nodeNum:uint, _listArray:Array, _spacing:int) {
			this.spacing=_spacing;
			this.nodeNum=_nodeNum;//number of nodes
			this.listArray=_listArray;
			init();
		}

		private function init() {
			nArray=new Array(nodeNum);
		}

		public function createNodes() {
			var fillColor:int;
			//alternate fill color every 5th node for visual clarity
			for (var i:uint =0; i < nodeNum; i ++) {
				if (i%5==0) {
					fillColor=0xDEE9FE;
				} else {
					fillColor=0xffffff;
				}
				node=new Node(spacing,fillColor,0xffffff,0x7E7F81);
				node._list=listArray[i];
				nArray[i]=node;
				nArray[i].x=i*spacing+margin;
				gWidth=nArray[i].x+spacing;
				latArray[i]=nArray[i]._lat;// whats lat?
				nodeContainer.addChild(nArray[i]);
			}
			dispatchEvent(new Event("NODES_CREATED"));//dispatched to main
		}

		public function get _width():uint {
			return gWidth+margin;
		}

		public function get _nodeContainer():Sprite {
			return nodeContainer;
		}
	}
}