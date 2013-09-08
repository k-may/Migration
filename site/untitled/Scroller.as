package tangaParty{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.display.Shape;

	public class Scroller extends Sprite {
		private var dir:String;
		private var l:int;
		private var barW:int=10;
		private var buttonW:int=16;
		private var bar:Sprite = new Sprite();
		private var button:Sprite = new Sprite();
		private var buttonOver:Shape = new Shape();
		private var offY:int;
		private var offX:int;
		private var margin:int=5;
		private var sB:Rectangle;

		public function Scroller(_dir:String, _length:int) {
			this.l=_length;
			this.dir=_dir;
			drawBar(l);
			drawButton();
			addChild(bar);
			addChild(button);
			button.buttonMode=true;
			button.addEventListener(MouseEvent.MOUSE_DOWN, dragButton);
		}

		private function drawBar(_length) {
			bar.graphics.clear();
			bar.graphics.lineStyle(1,0Xffffff, 0.5);
			bar.graphics.beginFill(0,0);
			if (dir=="vertical") {
				bar.graphics.drawRect(3,3,barW,_length);
				sB=new Rectangle(0,0,0,_length);
			} else if (dir =="horizontal") {
				bar.graphics.drawRect(3,3,_length, barW);
				sB=new Rectangle(0,0,_length,0);
			}
			bar.graphics.endFill();
		}
		private function drawButton() {

			button.graphics.lineStyle(1,0Xffffff, 0.5);
			button.graphics.beginFill(0,0);
			button.graphics.drawRect(0,0,buttonW, buttonW);
			//button.graphics.endFill();
			
			//buttonOver.graphics.lineStyle(1,0Xffffff, 0.5);
			buttonOver.graphics.beginFill(0xffffff);
			buttonOver.graphics.drawRect(0,0,buttonW, buttonW);
			buttonOver.graphics.endFill();
			buttonOver.visible = false;
			button.addChild(buttonOver);
			
		}

		private function dragButton(e:MouseEvent) {
			button.removeEventListener(MouseEvent.MOUSE_DOWN, dragButton);
			button.startDrag(false,sB);
			buttonOver.visible = true;
			this.stage.addEventListener(MouseEvent.MOUSE_UP, releaseButton);
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, moveButton);
			/*offY=mouseY-button.y;
			offX=mouseX-button.x;*/
		}

		private function releaseButton(e:MouseEvent) {
			button.stopDrag();
			buttonOver.visible = false;
			button.addEventListener(MouseEvent.MOUSE_DOWN, dragButton);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, releaseButton);
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, moveButton);
		}

		private function moveButton(e:MouseEvent) {
			if (dir=="vertical") {
				if (mouseY>=0&&mouseY<l-buttonW) {
					//button.y=mouseY+offY;
dispatchEvent(new Event("SCROLL_TEXT"));
				}
			} else if (dir == "horizontal") {
				//button.x=mouse;
				dispatchEvent(new Event("SCROLL_TEXT"));
			}
		}


		public function get _ratio():Number {
			if (dir=="vertical") {

				var ratio:Number=button.y/l;
			} else {
				var ratio:Number=button.x/l;
				//trace("ratio =" + ratio);
			}
			return ratio;
		}

		public function get _length():int {
			return l;
		}

		public function set _length(_l) {
			if(_l >0){
			l=_l;
			}
			drawBar(l);
		}

		public function get _width():int {
			return buttonW + margin*2;
		}

		public function get _height():int {
			return buttonW + margin*2;
		}

	}
}