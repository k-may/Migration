package com.kevmayo.migration.view{

	//import flash.display.Shape;
	import flash.display.Sprite;
	import com.kevmayo.migration.DashedLine;

	//import com.senocular.drawing.DashedLine;

	public class Border extends Sprite {

		//private var shape:Shape = new Shape();
		private var w,h:int;
		private var thickness:int;
		private var color=0;
		var myDashedDrawing:DashedLine;

		public function Border(thickness) {
			this.thickness=thickness;
			//addChild(shape);
			myDashedDrawing=new DashedLine(this.graphics,1,2);
		}

		public function render(_w,_h) {
			this.w=_w;
			this.h=_h;
			myDashedDrawing.clear();
			myDashedDrawing.lineStyle(1, 0, 0.3);
			myDashedDrawing.moveTo(0, 0);
			myDashedDrawing.lineTo(w, 0);
			myDashedDrawing.lineTo(w,h);
			myDashedDrawing.lineTo(0,h);
			myDashedDrawing.lineTo(0, 0);
		}

		public function get _w() {
			return w;
		}

		public function get _h() {
			return h;
		}
	}
}