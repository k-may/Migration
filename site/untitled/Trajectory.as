package untitled{

	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.display.Shape;

	public class Trajectory extends Sprite {

		var trajectory:Sprite;
		var dir:int;
		var contX,contY:int;
		var cX1,cY1,cX2,cY2:int;
		var color:uint;
		var contM:int = 1;

		public function Trajectory(_contX:int, _contY:int, _cX1:int, _cY1:int, _cX2:int,_cY2:int, _color:uint) {
			this.contX=_contX;
			this.contY=_contY;
			this.cX1=_cX1;
			this.cY1=_cY1;
			this.cX2=_cX2;
			this.cY2=_cY2;
			this.color=_color;

			trajectory = new Sprite();
			this.name="trajectory";
			addChild(trajectory);
			render();

		}

		public function render() {
			trajectory.graphics.clear();
			trajectory.graphics.lineStyle(1,color);
			trajectory.graphics.moveTo(cX1,cY1);
			trajectory.graphics.curveTo(contX, contY*contM + 40, cX2, cY2);
		}

		public function set _contM(_val) {
			//contY=contY*_val;
			contM = _val;
			render();
		}
		
		public function get _contM():int{
			return contM;
		}


	}
}