package untitled{

	import flash.display.Shape;
	import flash.display.Sprite;

	public class Node extends Sprite {

		private var shape:Shape=new Shape();;
		private var lat:Number;
		private var list:InstObject = new InstObject();
		private var size:int;
		private var w:uint;
		private var color:int;
		private var fillColor:int;
		private var hoverColor:int;
		private var lineColor:uint;
		private var lineWeight:int;
		public var lineVisible:Boolean;

		public function Node(_w, _fillColor, _hoverColor:int = 0, _lineColor:uint = 0x000fff, _lineWeight:int =2, _lineVisible:Boolean = true) {
			this.fillColor=_fillColor;
			this.hoverColor=_hoverColor;
			this.lineVisible=_lineVisible;
			this.lineColor=_lineColor;
			this.lineWeight=_lineWeight;
			this.w=_w;
			this.name="node";
			this.color = fillColor
			addChild(shape);
			render();
		}

		public function render() {
			shape.graphics.clear();
			if (lineVisible) {
				shape.graphics.lineStyle(lineWeight, lineColor);
				shape.graphics.beginFill(0xffffff);
			} else {
				shape.graphics.beginFill(color);
			}
			shape.graphics.moveTo(w/2,0);
			shape.graphics.lineTo(0,w/2);
			shape.graphics.lineTo(w/2,w);
			shape.graphics.lineTo(w,w/2);
			shape.graphics.lineTo(w/2,0);
			shape.graphics.endFill();
		}

		public function hover(h:Boolean) {
			switch (h) {
				case true :
					color=hoverColor;
					render();
					break;
				case false :
					color=fillColor;
					render();
					break;
			}
		}

		public function _mouseDown(h:Boolean) {
			lineVisible=h;
			render();
		}

		public function fillNode(_case:String) {
			switch (_case) {
				case "over" :
					color=0x000fff;
					render();
					break;
				case "out" :
					cColor=0xffffff;
					render();
					break;
			}
		}

		public function get _size() {
			return w;
		}

		public function set _list(_val) {
			this.list=_val;
			this.lat=list.latitude;
		}

		public function get _list():InstObject {
			trace("NODE: inst name = " + list.name);
			return list;
		}

		public function get _lat():Number {
			return lat;
		}
	}
}