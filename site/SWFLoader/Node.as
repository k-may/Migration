package SWFLoader{

	import flash.display.Shape;
	import flash.display.Sprite;

	public class Node extends Sprite {

		private var shape:Shape;
		private var size:int;

		var w:uint;
		private var fillColor:int;
		private var hoverColor:int;

		public function Node(_w, _fillColor, _hoverColor:int = 0) {
			this.fillColor=_fillColor;
			this.w = _w;
			this.hoverColor = _hoverColor;

			//trace("Node: name =" + list.instName);
			init();
		}

		public function init() {
			shape=new Shape();
			shape.graphics.lineStyle(1, 0x000fff);
			shape.graphics.beginFill(fillColor);
			shape.graphics.moveTo(w/2,0);
			shape.graphics.lineTo(0,w/2);
			shape.graphics.lineTo(w/2,w);
			shape.graphics.lineTo(w,w/2);
			shape.graphics.lineTo(w/2,0);
			shape.graphics.endFill();

			addChild(shape);
			//trace("Node: shape = " + shape + ", stage = " + this.stage);

		}

		public function fillNode(_case:String) {
			switch (_case) {
				case "over" :
					fillColor=hoverColor;
					init();
					break;
				case "out" :
					fillColor=fillColor;
					init();
					break;
			}
		}
		
		public function get _size(){
			return w;
		}
	}
}