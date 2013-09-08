package untitled{

	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.*;
	import flash.events.*;

	public class ScrollWall extends Sprite {

		private var bar:Shape=new Shape  ;
		public var arrow:Sprite=new Sprite()  ;
		private var container:Sprite=new Sprite  ;
		private var side:String;
		private var dir:int=1;
		private var w:int=75;
		private var h:int=250;
		private var arrowH:int=25;
		private var arrowW:int=12;
		private var xPos:int;
		private var yPos:int;
		var cT:ColorTransform=new ColorTransform();


		public function ScrollWall(_side:String, _xPos:int, _yPos:int) {
			this.xPos=_xPos;
			this.yPos=_yPos;

			this.side=_side;
			if (side==" left") {
				dir=1;

			} else if (side =="right") {
				dir=-1;
			}

			arrow.graphics.beginFill(0xDEE9FE)
			arrow.graphics.moveTo(0, 125 - arrowH/2);
			arrow.graphics.lineTo((-arrowW)*dir, 125);
			arrow.graphics.lineTo(0, 125 + arrowH/2);
			arrow.graphics.lineTo(0,125 - arrowH/2);
			arrow.graphics.endFill();
			arrow.addEventListener(MouseEvent.ROLL_OVER, overArrow);
			//arrow.buttonMode = true;

			addChild(container);
			container.addChild(arrow);
			container.x=xPos;
			container.y=yPos;
		}

		private function overArrow(e:MouseEvent) {
			dispatchEvent(new ScrollEvent(ScrollEvent.OVER_ARROW, -dir));
			arrow.addEventListener(MouseEvent.ROLL_OUT, outArrow);
		}
		private function outArrow(e:MouseEvent) {
			dispatchEvent(new ScrollEvent(ScrollEvent.OUT_ARROW));
			arrow.removeEventListener(MouseEvent.ROLL_OUT, outArrow);
		}

		public function  set _arrowColor(_color:uint) {
			cT.color=_color;
			arrow.transform.colorTransform=cT;
		}
		
		public function get _width(){
			return w;
		}
		
		public function get _height(){
			return h;
		}

	}
}