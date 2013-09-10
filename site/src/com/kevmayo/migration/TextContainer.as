package com.kevmayo.migration{

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
		private var posCont:Sprite;
		private var cCont:Sprite = new Sprite();
		private var dCont:Sprite = new Sprite();
		var shape:Sprite=new Sprite();//draw filled node

		private var bar:Sprite = new Sprite();
		private var posField:TextField;
		private var dField:TextField;
		private var fName:String;
		private var fieldH:int;
		private var myFont:Font = new Font();//new ArialReg();
		//var myPosFont:Font = new Font2();

		private var tFormat:TextFormat;
		private var pIFormat:TextFormat;
		private var pIIFormat:TextFormat;
		private var lFormat:TextFormat;
		private var pTFormat:TextFormat;
		private var sFormat:TextFormat;

		private var titleField:TextField = new TextField();
		private var latField:TextField = new TextField();

		private var trajActive:Boolean=false;
		static public const fieldColor:int=0xD6C8C1;

		private var aniF:Array=new Array('fadeBar','addLat_Title','animatePositions');
		private var aniCount:int=0;

		private var h:int;

		private var spacing:int;
		private var titleYPos:int=40;
		private var dYPos:int=10;
		private var yOffSet:int=-100;
		public var list:InstObject = new InstObject();
		private var posText:String;
		private var posTextObject:Object={name:String,cont:Sprite};
		private var textContainer:TextContainer;
		private var posContMaxW:int;
		private var posTitleMaxW:int;
		private var dir:int;

		public var trajectory:Sprite = new Sprite();

		public function TextContainer(_list:InstObject, _h:int, _spacing:int) {
			this.spacing=_spacing;
			this.list=_list;
			this.h=_h;
		}

		public function init() {
			pIFormat=new TextFormat(myFont.fontName,11,0X7E7F81);
			pIFormat.align="left";

			pIIFormat=new TextFormat(myFont.fontName,11,0XB2B2B2);
			pIIFormat.align="left";

			pTFormat=new TextFormat(myFont.fontName,14,0X555555);
			pTFormat.align="center";

			lFormat=new TextFormat(myFont.fontName,30,0);
			lFormat.align="left";

			tFormat=new TextFormat(myFont.fontName,16);

			sFormat=new TextFormat(myFont.fontName,11,0);

			createLat();
			createBar();
			createPositions();
			createTitle();
			addEventListener(Event.ENTER_FRAME, animate);
			shape.graphics.beginFill(0x000fff);
			shape.graphics.moveTo(spacing/2,0);
			shape.graphics.lineTo(0,spacing/2);
			shape.graphics.lineTo(spacing/2,spacing);
			shape.graphics.lineTo(spacing,spacing/2);
			shape.graphics.lineTo(spacing/2,0);
			shape.graphics.endFill();
			shape.name="shape";
			addChild(shape);
			shape.addEventListener(MouseEvent.ROLL_OVER, overShape);
		}
		private function overShape(e:MouseEvent) {
			dispatchEvent(new Event("OVER_NODE"));
			setBarColor(0xC9DD9E);
		}
		private function animate(e:Event) {
			if (aniCount<=aniF.length) {
				this[aniF[aniCount]]();
			}
		}

		private function fadeBar() {
			bar.alpha = (bar.alpha < 1)?bar.alpha *1.5:1;
			if (bar.alpha==1) {
				aniCount++;
			}
		}

		private function addLat_Title() {
			titleField.visible=true;
			this.graphics.lineStyle(1,0,0.5);
			this.graphics.moveTo(titleField.x, titleYPos);
			this.graphics.lineTo(0,titleYPos);
			latField.visible=true;
			//dispatchEvent(new Event("LAT_ADDED"));
			aniCount++;
		}

		private function animatePositions() {
			cCont.x = (cCont.x< -1)?cCont.x*0.7:0;
			dCont.x=cCont.x;
			if (cCont.x==0) {
				removeEventListener(Event.ENTER_FRAME,animate);
			}
		}


		private function createBar() {
			bar.graphics.beginFill(0xC9DD9E,0.5);
			bar.graphics.drawRect(0,-h/2+30,spacing,h-20);
			bar.alpha=0.1;
			bar.name="bar";
			addChild(bar);
		}

		public function setBarColor(_color) {
			bar.graphics.clear();
			bar.graphics.beginFill(_color,0.5);
			bar.graphics.drawRect(0,-h/2+30,spacing,h-20);

		}

		private function createTitle() {
			var titleText:String=list.name;
			titleField = new TextField();
			titleField.text=titleText;
			titleField.embedFonts=true;
			titleField.defaultTextFormat=tFormat;
			titleField.setTextFormat(tFormat);
			titleField.selectable=false;
			titleField.autoSize="left";

			titleField.x=- titleField.width;
			titleField.y=titleYPos-titleField.height;
			titleField.visible=false;
			addChild(titleField);
			dispatchEvent(new Event("TEXT_COMPLETE"));
			//trace("dispatch completion");
		}

		private function createLat() {
			var latText:Number=list.latitude;
			lFormat.leading=-8;
			latField.text=latText.toString();
			latField.embedFonts=true;
			latField.defaultTextFormat=lFormat;
			latField.setTextFormat(lFormat);
			latField.selectable=false;
			latField.autoSize="left";
			latField.x=- latField.height;
			latField.rotation=-90;
			latField.visible=false;
			addChild(latField);
		}


		private function createPositions() {
			var posNum=list.posArray.length;
			//trace("createPositions: " + posNum);
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
				cCont=createList(curators,"CURATORS");
				cCont.y=titleYPos;
				cCont.name="curators";
				addChild(cCont);
			}
			if (directors.length>0) {
				dCont=createList(directors,"DIRECTORS");
				dCont.name="directors";
				dCont.y=- dCont.height-spacing;
				addChild(dCont);

			}

			posContMaxW = (posContMaxW < posTitleMaxW)?posTitleMaxW:posContMaxW;

			/*if (directors.length>0) {
				for (var i:int = 0; i < dCont.getChildAt(1).numChildren; i ++) {
					dCont.getChildAt(1).getChildAt(i).width=posContMaxW;
				}
			}
			if (curators.length>0) {
				for (var i:int = 0; i < cCont.getChildAt(1).numChildren; i ++) {
					cCont.getChildAt(1).getChildAt(i).width=posContMaxW;
				}
			}
			if (curators.length>0) {
				fieldBackground(cCont);
				cCont.x=- posContMaxW;
				fieldTempMask(cCont);
				addDashedLines(cCont.getChildAt(1),posContMaxW);
				if (cCont.numChildren==3) {
					cCont.getChildAt(2).x=posContMaxW-spacing;
				}
			}
			if (directors.length>0) {
				fieldBackground(dCont);
				dCont.x=- posContMaxW;
				fieldTempMask(dCont);
				addDashedLines(dCont.getChildAt(1),posContMaxW);
			}*/
		}

		private function fieldBackground(_cont:Sprite) {
			_cont.graphics.beginFill(fieldColor, 0.1);
			_cont.graphics.drawRect(0,0,posContMaxW, _cont.height);

			var cH=_cont.height;
			_cont.graphics.endFill();
			_cont.graphics.lineStyle(1,0,0.5);

			_cont.graphics.moveTo(0,0);
			_cont.graphics.lineTo(posContMaxW,0);


		}
		private function fieldTempMask(_cont:Sprite) {
			var myMask:Shape = new Shape();
			myMask.graphics.beginFill(0);
			myMask.graphics.drawRect(0,-15,posContMaxW,290);

			myMask.y=_cont.y;
			addChild(myMask);
			_cont.mask=myMask;


		}

		private function createList(c:Array, title:String):Sprite {
			//trace("createList" + c.length +" title = " + title);
			if (c.length>0) {
				posCont = new Sprite();
				//posCont.name="posCont";

				var posTitle:TextField = new TextField();
				posTitle.autoSize="left";
				posTitle.defaultTextFormat=pTFormat;
				posTitle.embedFonts=true;
				posTitle.text=title;
				posTitle.mouseEnabled=false;

				posCont.addChild(posTitle);
				posTitle.y=- posTitle.height;
				posTitleMaxW = (posTitleMaxW < posTitle.width)?posTitle.width:posTitleMaxW;

				var listCont:Sprite = new Sprite();
				var yPos:int;

				for (var i = 0; i < c.length; i ++) {
					//trace("name = " + c[i].name);
					var cField:TextField = new TextField();
					cField.autoSize="left";
					//pFormat.align="left";
					cField.multiline=true;
					cField.wordWrap=true;
					if (i%2==0) {
						cField.defaultTextFormat=pIFormat;
						cField.setTextFormat(pIFormat);

					} else {
						cField.defaultTextFormat=pIIFormat;
						cField.setTextFormat(pIIFormat);
					}
					cField.embedFonts=true;
					cField.text=c[i].name;
					cField.selectable=false;
					//cField.mouseEnabled = false;

					var titleContainer:Sprite = new Sprite();
					//titleContainer.buttonMode=true;
					titleContainer.name="titleContainer"+cField.text;
					titleContainer.addChild(cField);
					//titleContainer.y=i*cField.height;
					titleContainer.y=yPos;
					yPos=titleContainer.y+titleContainer.height;

					titleContainer.addEventListener(MouseEvent.MOUSE_OVER, overField);
					//posCont.addChild(titleContainer);
					listCont.addChild(titleContainer);
					posContMaxW = (posContMaxW <cField.width)?cField.width:posContMaxW;

				}
			}

			posCont.addChild(listCont);

			fieldH=cField.height;
			if (posCont.height>275) {

				var arrowCont:Sprite = new Sprite();
				//trace("too large");
				var listArrowDown = new Sprite();
				listArrowDown.name="up";
				listArrowDown.graphics.beginFill(0Xff0000);
				listArrowDown.graphics.moveTo(0,270);
				listArrowDown.graphics.lineTo(15,270);
				listArrowDown.graphics.lineTo(8, 262);
				listArrowDown.graphics.lineTo(0,270);
				arrowCont.addChild(listArrowDown);
				listArrowDown.addEventListener(MouseEvent.MOUSE_OVER, overListArrow);
				var listArrowUp = new Sprite();
				listArrowUp.name="down";
				listArrowUp.graphics.beginFill(0Xff0000);
				listArrowUp.graphics.moveTo(0,0);
				listArrowUp.graphics.lineTo(15,0);
				listArrowUp.graphics.lineTo(8,8);
				listArrowUp.graphics.lineTo(0,0);
				arrowCont.addChild(listArrowUp);
				listArrowUp.addEventListener(MouseEvent.MOUSE_OVER, overListArrow);
				posCont.addChild(arrowCont);
			}
			return posCont;
		}

		function overListArrow(e:MouseEvent) {
			e.target.removeEventListener(MouseEvent.MOUSE_OUT, overListArrow);
			e.target.addEventListener(MouseEvent.MOUSE_OUT, outListArrow);
			e.target.addEventListener(Event.ENTER_FRAME, scrollList);
		}

		function outListArrow(e:MouseEvent) {
			e.target.removeEventListener(MouseEvent.MOUSE_OUT, outListArrow);
			e.target.removeEventListener(Event.ENTER_FRAME, scrollList);
			e.target.addEventListener(MouseEvent.MOUSE_OUT, overListArrow);

		}

		private function scrollList(e:Event) {
			switch (e.target.name) {
				case "down" :
					//trace("scroll up " +e.target.parent.parent.getChildAt(1).y );
					e.target.parent.parent.getChildAt(1).y =(e.target.parent.parent.getChildAt(1).y < 0)?e.target.parent.parent.getChildAt(1).y + 2:e.target.parent.parent.getChildAt(1).y;
					//e.target.addEventListener(Event.ENTER_FRAME, scrollList);
					break;
				case "up" :
					//trace("scroll down");
					e.target.parent.parent.getChildAt(1).y =(e.target.parent.parent.getChildAt(1).y  > (280-e.target.parent.parent.getChildAt(1).height))?e.target.parent.parent.getChildAt(1).y - 2:e.target.parent.parent.getChildAt(1).y;

					break;
			}
		}

		private function addDashedLines(cont:Sprite, w:int) {
			var numLines:int=cont.numChildren-1;
			//trace("cont chilrder = " + cont.numChildren);
			for (var i:int = 0; i < numLines; i++) {
				var myDashedDrawing:DashedLine=new DashedLine(cont.graphics,3,2);
				myDashedDrawing.lineStyle(1, 0, 0.3);
				myDashedDrawing.moveTo(0, cont.getChildAt(i).y + cont.getChildAt(i).height);
				myDashedDrawing.lineTo(w, cont.getChildAt(i).y + cont.getChildAt(i).height);
			}
		}


		public function removePos() {

			if (cCont.parent) {
				cCont.visible=false;
			}
			if (dCont.parent) {
				dCont.visible=false;
			}
			//this.removeChild(latField);
			latField.visible=false;
			titleField.visible=false;
			this.graphics.clear();
			//trace("removePos " + titleField.text + " latF vis = " + latField.visible + " latF parent= " + latField.parent.name + " latfStage = " + latField.stage);
		}

		public function addPos() {
			if (cCont.parent) {
				cCont.visible=true;
			}
			if (dCont.parent) {
				dCont.visible=true;
			}
			latField.visible=true;
			titleField.visible=true;
		}

		private function overField(e:MouseEvent) {
			e.currentTarget.removeEventListener(MouseEvent.MOUSE_OVER, overField);
			e.currentTarget.addEventListener(MouseEvent.MOUSE_OUT, outField);
			fName=e.target.text;
			e.target.background=true;
			e.target.backgroundColor=0XDDFFF8;
			e.target.defaultTextFormat=sFormat;
			e.target.setTextFormat(sFormat);
			
			var contName:String=e.currentTarget.parent.parent.name;
			dir = (contName =="curators")?-1:1;
			e.currentTarget.dispatchEvent(new Event("OVER_FIELD", true));
			trace("TEXTBOX: overField: e.currentTarget.parent.name = " + e.currentTarget.parent.parent.name  + " dir = " + dir);
		}

		private function outField(e:MouseEvent) {
			e.currentTarget.removeEventListener(MouseEvent.MOUSE_OUT, outField);
			e.currentTarget.addEventListener(MouseEvent.MOUSE_OVER, overField);
			e.target.background=false;
			if (e.target.parent.getChildIndex(e.target)%2==0) {
				e.target.defaultTextFormat=pIFormat;
				e.target.setTextFormat(pIFormat);
			} else {
				e.target.defaultTextFormat=pIIFormat;
				e.target.setTextFormat(pIIFormat);
			}
			/*e.target.defaultTextFormat=pFormat;
			e.target.setTextFormat(pFormat);*/
			if (e.currentTarget.numChildren>1) {
				if (e.currentTarget.contains(trajectory)) {
					e.currentTarget.addEventListener(Event.ENTER_FRAME, outTrajectory);
				}
			}
			e.target.backgroundColor=0Xffffff;
			e.currentTarget.dispatchEvent(new Event("OUT_FIELD", true));
		}

		private function outTrajectory(e:Event) {
			//trace("outTraj" + e.currentTarget.getChildAt(1));
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

		public function get _dir():int {
			trace("get dir: " + dir);
			return dir;
		}

		private function checkDate(date:String) {
			var endDate=date;
			if (endDate=="0000-00-00") {
				endDate="present";
			}
			return endDate;
		}

		public function drawTrajectory(container:Sprite, cArray:Array) {
			if (container.numChildren==1) {
				var trajectory = new Sprite();
				trajectory.name="trajectory";
				addChild(trajectory);
				if (dir==1) {
					trajectory.y=spacing;
				}
			}
			for (var i:int = 0; i < cArray.length; i ++) {
				/*trajectory.graphics.lineStyle(1,0x000ff0);
				trajectory.graphics.moveTo(cArray[i].x1 + spacing/2,0);*/
				var linDir = (cArray[i].x2 - cArray[i].x1)/Math.abs(cArray[i].x2-cArray[i].x1);
				var contX=cArray[i].x2-Math.pow(i,2)*linDir;
				
				//todo: why is this broken?
				
				//var traj:TrajectoryController = new TrajectoryController(contX, dir*(i), cArray[i].x1 + spacing/2,0, cArray[i].x2+ spacing/2, 0,0x000ff0);
				//trajectory.addChild(traj);
			}
		}

		public function removeTrajectory() {
			trace("remove traj" + trajectory.stage)
			if (trajectory.stage) {
				removeChild(trajectory);
			}
		}

	}
}