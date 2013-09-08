package {

	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.display.Stage;
	import untitled.*;

	public class Main extends Sprite {
		private var sW,sH:Number;
		var nW:uint;
		var nH:uint;
		private var graphWidth:uint;
		private var render:Render;
		private var listArray:Array = new Array();
		private var textBox:TextContainer;
		private var nodeRef:Node;
		private var nodes:Sprite = new Sprite();
		private var posList:Array = new Array();
		private var trajectories:Sprite = new Sprite();
		private var trajectory:MovieClip;
		private var yPos:int=120;

		function Main() {
			trace("Main");
			init();
			stage.addEventListener(Event.RESIZE,resizeEvent);
		}

		function init() {
			dispatchEvent(new Event(Event.RESIZE));
			sW=stage.stageWidth;
			sH=stage.stageHeight;
			trace("this.stage" + this.stage);
			addStage();
		}//init

		function addStage() {
			render=new Render(sW,yPos);
			render.name="render";
			render.addEventListener("NODES_CREATED", renderScreen);
			render.init();
		}

		function resizeEvent(e:Event) {
			sW=stage.stageWidth;
			sH=stage.stageHeight;
		}

		private function renderScreen(e:Event) {
			trace("Main: add redner to stage");
			e.target.removeEventListener("NODES_CREATED", renderScreen);
			nodes=e.target.nodeContainer;
			nodes.addChild(trajectories);
			nodes.addEventListener(MouseEvent.MOUSE_OVER, overNode);
			posList=render.getListArray();
			addChild(render);
		}

		private function overNode(e:MouseEvent) {
			trace("Main: overNode ---> e.target = " + e.target.name);
			if (e.target.name=="node") {
				nodes.removeEventListener(MouseEvent.MOUSE_OVER, overNode);
				textBox=new TextContainer(e.target.list,sH,15);
				textBox.x=e.target.x;
				textBox.y=yPos-5;
				textBox.name="textBox";
				textBox.addEventListener(MouseEvent.MOUSE_OUT, outCont);
				textBox.addEventListener(MouseEvent.ROLL_OUT, outNode, false);
				textBox.addEventListener("OVER_FIELD", overField, false);
				nodes.addChild(textBox);

			}
		}

		function overField(e:Event) {
			trace("main: eventlistener: overField" + e.target);
			visualizeField(e);
		}

		function outField(e:Event) {
			trace("outField");
		}

		function outCont(e:MouseEvent) {
			//render.outCont();//clear graphics of nodes
		}

		function outNode(e:MouseEvent) {
			trace("outNode");
			nodes.addEventListener(MouseEvent.MOUSE_OVER, overNode);
			e.currentTarget.removeEventListener(MouseEvent.ROLL_OUT, outNode);
			textBox.removePos();
			textBox.addEventListener(Event.ENTER_FRAME, fadeText);
		}

		public function visualizeField(e:Event) {
			textBox.addEventListener("OUT_FIELD", outField);
			var fieldName:String=e.currentTarget.fieldName;
			var xPos=e.target.x+5;
			var latArray:Array = new Array();
			var xPosArray:Array = new Array();
			var indexNum:uint;
			var count=1;
			for (var i =0; i < posList.length; i ++) {//search for instences of field name in positions list
				if (fieldName==posList[i].name) {
					latArray=posList[i].latArray;
					trace("===> " +fieldName + ":  latArray.length = " + posList[i].latArray.length);
					break;
				}
			}

			if (latArray.length>1) {//if more than one instance
				trace("lat.length (number of positions) = " + latArray.length);
				var curveArray:Array = new Array();
				for (var j = 0; j < latArray.length; j ++) {
					indexNum=render.nodes.getIndex(latArray[j]);
					if (j==0) {
						xPosArray[0]=nodes.getChildAt(indexNum).x;//first position
					} else {
						if (xPosArray[count-1]!=nodes.getChildAt(indexNum).x) {// remove duplicate instances??
							xPosArray[count]=nodes.getChildAt(indexNum).x;
							var curveObject:Object = {x1:(xPosArray[count -1]+5-textBox.x), x2:(xPosArray[count]+5-textBox.x)};
							count++;
							curveArray.push(curveObject);
						}//if
					}//else
				}//for
				trace("curveArray length = " +curveArray.length);
				textBox.drawCurve(e.target as Sprite, curveArray);
				//trace("Render: xpositions = " + count);
			}//if
		}

		function fadeText(e:Event) {
			e.target.alpha = (e.target.alpha > 0.1)? e.target.alpha * 0.999:0;
			if (e.target.alpha==0) {
				trace("--->stop fading");
				e.target.removeEventListener(Event.ENTER_FRAME, fadeText);
				nodes.removeChild(e.target as Sprite);
			}
		}

		/*function overStage(e:MouseEvent) {
		stage.removeEventListener(MouseEvent.MOUSE_OVER, overStage);
		trace("Main : overStage");
		}*/

		/*function enterFrame(e:Event) {
		var vpX=stage.stageWidth/2;
		var vpY=stage.stageHeight/2;
		}//enterFrame*/


	}//class
}//package;