package untitled{

	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.*;
	import flash.text.Font;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.*;
	import flash.display.Graphics;
	import flash.display.Shape;


	public class TextContainer extends Sprite {
		trace("TextContainer");
		var posCont:Sprite;
		var cCont:Sprite = new Sprite();
		var dCont:Sprite = new Sprite();

		var bar:Sprite = new Sprite();
		//private var titleField:TextField;
		private var posField:TextField;
		private var dField:TextField;
		private var fName:String;
		private var fieldH:int;
		var myFont:Font = new Font1();
		var myPosFont:Font = new Font2();

		var tFormat:TextFormat;
		var pFormat:TextFormat;
		var lFormat:TextFormat;
		var pTFormat:TextFormat;
		
		var titleField:TextField = new TextField()
		var latField:TextField = new TextField();
		
		var trajActive:Boolean=false;
		var fieldColor:int=0xD6C8C1;
		
					private var aniF:Array = new Array('fadeBar','addLat_Title','animatePositions');
		var aniCount:int=0;

		var sW:int;
		var sH:int;

		var spacing:int=15;
		var titleYPos:int=40;
		var dYPos:int=10;
		var yOffSet:int=-100;
		public var list:InstObject = new InstObject();
		var posText:String;
		var posTextObject:Object={name:String,cont:Sprite};
		private var textContainer:TextContainer;
		var posContMaxW:int;
		var posTitleMaxW:int;

		var trajectory:Sprite;

		public function TextContainer() {
			this.x=stage.stageWidth/2;
			this.y=stage.stageHeight/2;
			init();

		}

		private function init() {
			sW=stage.stageWidth;
			sH=stage.stageHeight;
			pFormat=new TextFormat(myFont.fontName,11,0);
			//pFormat.font=myFont.fontName;
			pFormat.align="left";
			//pFormat.size=11;
			trace("PTForamt =" + myFont.fontName);

			pTFormat=new TextFormat(myFont.fontName,14,0);
			pTFormat.align="center";

			lFormat=new TextFormat(myFont.fontName,36,0);
			lFormat.align="left";

			tFormat=new TextFormat(myFont.fontName,18);


			
			createLat();
			createBar();
			createPositions();
			createTitle();
			addEventListener(Event.ENTER_FRAME, animate);


			var shape:Shape=new Shape();//draw filled node
			shape.graphics.lineStyle(3,0x000fff);
			shape.graphics.beginFill(0x000fff);
			shape.graphics.moveTo(spacing/2,0);
			shape.graphics.lineTo(0,spacing/2);
			shape.graphics.lineTo(spacing/2,spacing);
			shape.graphics.lineTo(spacing,spacing/2);
			shape.graphics.lineTo(spacing/2,0);
			shape.graphics.endFill();
			addChild(shape);


			/*var g=this.graphics;
			g.lineStyle(1, 0x000fff);
			g.moveTo(5,yOffSet);
			g.lineTo(5,0);
			
			g.lineStyle(1,0);
			
			g.moveTo(5,-sH);
			g.lineTo(5,sH);
			
			g.moveTo(0,-sH);
			g.lineTo(0,sH);
			
			g.moveTo(-sW,0);
			g.lineTo(sW,0);
			
			g.moveTo(-sW,titleYPos);
			g.lineTo(sW, titleYPos);*/


			/*this.graphics.
			this.graphics.this.graphics.
			this.graphics.
			this.graphics.
			*/
		}

		private function animate(e:Event) {
			trace("animate");
			if (aniCount<=aniF.length) {
				this[aniF[aniCount]]();
			}
		}

		private function fadeBar() {
			//trace("--->fadeBar "+ bar.alpha)
			bar.alpha = (bar.alpha < 1)?bar.alpha *1.1:1;
			if (bar.alpha==1) {
				aniCount++;
			}
		}

		private function addLat_Title() {
			trace("-->addLat_Title");
			addChild(titleField);
						this.graphics.lineStyle(1,0,0.5);
			this.graphics.moveTo(titleField.x, titleYPos);
			this.graphics.lineTo(0,titleYPos);
			addChild(latField);
			aniCount++;
		}

		private function animatePositions() {
			trace("animatePosisiotns" + dCont.x);
			cCont.x = (cCont.x < -1)?cCont.x*0.9:0;
			dCont.x=cCont.x;
			if (cCont.x==0) {
				removeEventListener(Event.ENTER_FRAME,animate);
			}
		}


		private function createBar() {
			bar.graphics.beginFill(0xC9DD9E,0.5);
			bar.graphics.drawRect(0,-sH,spacing,sH*2);
			bar.alpha=0.1;
			addChild(bar);
		}
		private function createTitle() {

			var titleText:String=list.instName;
			
			titleField = new TextField();
			titleField.text=titleText;
			titleField.embedFonts=true;
			titleField.defaultTextFormat=tFormat;
			titleField.setTextFormat(tFormat);
			titleField.selectable=false;
			titleField.autoSize="left";

			titleField.x=- titleField.width;
			titleField.y=titleYPos-titleField.height;

			trace("titleField.h = "+ titleField.height + " titleField.width = " + titleField.width);
			//addChild(titleField);

		}

		private function createLat() {
			var latText:Number=list.instLat;
			lFormat.leading=-8;
			latField.text=latText.toString();
			latField.embedFonts=true;
			latField.defaultTextFormat=lFormat;
			latField.setTextFormat(lFormat);
			latField.selectable=false;
			latField.autoSize="left";
			//latField.y = -latField.height;
			latField.x=- latField.height;
			trace("latField.h = "+ latField.height + " latField.width = " + latField.width);
			//addChild(latField);
			latField.rotation=-90;
		}


		private function createPositions() {
			var posNum=list.posArray.length;
			var curators:Array = new Array();
			var directors:Array = new Array();
			for (var i =0; i < posNum; i ++) {
				if (list.posArray[i].title=="curator") {
					curators.push(list.posArray[i]);
				} else {
					directors.push(list.posArray[i]);
				}
			}
			if (curators.length>0) {
				var cont:Sprite = new Sprite();
				cont=createList(curators,"CURATORS");
				cCont.addChild(cont);
				cCont.y=titleYPos;
				addChild(cCont);
				trace("cCont.w = "+ cCont.width + " cCont.h = " + cCont.height);
			}
			if (directors.length>0) {
				var cont:Sprite = new Sprite();
				cont=createList(directors,"DIRECTORS");
				dCont.addChild(cont);
				dCont.y=- dCont.height-spacing;
				addChild(dCont);
				trace("dCont.w = "+ dCont.width + " dCont.h = " + dCont.height);
			}
			posContMaxW = (posContMaxW < posTitleMaxW)?posTitleMaxW:posContMaxW;
			
			if (curators.length>0) {
				fieldBackground(cCont);
				cCont.x=- posContMaxW;
				fieldTempMask(cCont);
			}
			if (directors.length>0) {
				fieldBackground(dCont);
				dCont.x-= posContMaxW;
				fieldTempMask(dCont);
			}
		}

		private function fieldBackground(_cont:Sprite) {
			_cont.graphics.beginFill(fieldColor, 0.35);
			_cont.graphics.drawRect(0,0,posContMaxW, _cont.height);
			_cont.graphics.endFill();
						_cont.graphics.lineStyle(1,0,0.5);
			_cont.graphics.moveTo(0,0);
			_cont.graphics.lineTo(posContMaxW,0);
		}
		private function fieldTempMask(_cont:Sprite) {
			var myMask:Shape = new Shape();
			myMask.graphics.beginFill(0);
			myMask.graphics.drawRect(0,-15,posContMaxW,_cont.height);
			myMask.y = _cont.y;
			addChild(myMask);
			_cont.mask=myMask;
		}

		private function createList(c:Array, title:String):Sprite {
			if (c.length>0) {
				posCont = new Sprite();
				posCont.name="posCont";

				var posTitle:TextField = new TextField();
				posTitle.autoSize="left";
				posTitle.defaultTextFormat=pTFormat;
				posTitle.embedFonts=true;
				posTitle.text=title;
				posTitle.mouseEnabled=false;
				fieldH=posTitle.height;
				posCont.addChild(posTitle);
				posTitle.y=- posTitle.height;
				posTitleMaxW = (posTitleMaxW < posTitle.width)?posTitle.width:posTitleMaxW;

				for (var i = 0; i < c.length; i ++) {
					var cField:TextField = new TextField();
					cField.autoSize="left";
					pFormat.align="left";

					cField.defaultTextFormat=pFormat;
					cField.embedFonts=true;
					cField.text=c[i].name;
					/*cField.background=true;
					cField.backgroundColor = fieldColor;*/
					cField.selectable=false;

					var titleContainer:Sprite = new Sprite();
					titleContainer.buttonMode=true;
					titleContainer.name="titleContainer"+c[i].name;
					titleContainer.addChild(cField);
					titleContainer.y=i*cField.height;
					//trace("height: = " +(i+1)*cField.height);
					titleContainer.addEventListener(MouseEvent.MOUSE_OVER, overField);
					posCont.addChild(titleContainer);
					posContMaxW = (posContMaxW <cField.width)?cField.width:posContMaxW;

				}
			}
			return posCont;
		}

		public function removePos() {
			removeChild(cCont);
			removeChild(dCont);
		}

		private function overField(e:MouseEvent) {
			trace("overfield: " + e.currentTarget.name);
			e.currentTarget.removeEventListener(MouseEvent.MOUSE_OVER, overField);
			e.currentTarget.addEventListener(MouseEvent.MOUSE_OUT, outField);
			fName=e.target.text;
			e.target.background=true;
			e.target.backgroundColor=0XDDFFF8;
			e.currentTarget.dispatchEvent(new Event("OVER_FIELD", true));
		}

		private function outField(e:MouseEvent) {
			trace("outfield: " + e.currentTarget.name);
			e.currentTarget.removeEventListener(MouseEvent.MOUSE_OUT, outField);
			e.currentTarget.addEventListener(MouseEvent.MOUSE_OVER, overField);
			e.target.background=false;
			if (e.currentTarget.numChildren>1) {
				if (e.currentTarget.contains(trajectory)) {
					trace("remove trajectory");
					e.currentTarget.addEventListener(Event.ENTER_FRAME, outTrajectory);
					//trajActive=false;
				}
			}
			e.target.backgroundColor=0Xffffff;
			e.currentTarget.dispatchEvent(new Event("OUT_FIELD", true));
		}

		private function outTrajectory(e:Event) {

			var traj:Sprite=e.currentTarget.getChildAt(1);
			traj.scaleY = (traj.scaleY > 0.1)?traj.scaleY *0.9:0;
			traj.alpha=traj.scaleY;
			if (traj.scaleY==0) {
				e.currentTarget.removeEventListener(Event.ENTER_FRAME, outTrajectory);
				e.currentTarget.removeChild(traj);

			}
		}

		public function get fieldName():String {
			return fName;
		}

		private function checkDate(date:String) {
			var endDate=date;
			if (endDate=="0000-00-00") {
				endDate="present";
			}
			return endDate;
		}

		public function drawCurve(container:Sprite, n2X:int, n1X:int, magnitude:int, dir:int) {
			//trajectory = 
			trace("drawCurve : " + container.parent.x);
			if (container.numChildren==1) {
				trajectory = new Sprite();
				trajectory.name="trajectory";
				container.addChild(trajectory);
				trajectory.y=- container.parent.y-container.y;
				trajectory.x=- container.parent.x;
			}
			//trajActive=true;
			trajectory.graphics.lineStyle(1,0x000ff0);
			trajectory.graphics.moveTo(n1X,0);
			trajectory.graphics.curveTo(n1X + Math.pow(magnitude, 2)*dir,-40*magnitude-40,n2X,0);
		}

		function drawRoundedCornerRectangle(g:Graphics, boxWidth:Number, boxHeight:Number, cornerRadius:Number, fillColor:Number, fillAlpha:Number) {
			g.beginFill(fillColor, fillAlpha);
			//g.lineStyle(lineThickness, lineColor, lineAlpha);
			g.moveTo(cornerRadius, 0);
			g.lineTo(boxWidth - cornerRadius, 0);
			g.lineTo(boxWidth, cornerRadius);
			g.lineTo(boxWidth, boxHeight - cornerRadius);
			g.curveTo(boxWidth, 0, boxWidth, cornerRadius);
			g.curveTo(boxWidth, boxHeight, boxWidth - cornerRadius, boxHeight);
			g.lineTo(boxWidth - cornerRadius, boxHeight);
			g.lineTo(cornerRadius, boxHeight);
			g.curveTo(0, boxHeight, 0, boxHeight - cornerRadius);
			g.lineTo(0, boxHeight - cornerRadius);
			g.lineTo(0, cornerRadius);
			g.curveTo(0, 0, cornerRadius, 0);
			g.lineTo(cornerRadius, 0);
			g.endFill();


		}
	}
}