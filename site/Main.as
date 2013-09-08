package {

	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.display.Stage;
	import untitled.*;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;

	public class Main extends Sprite {


		private var render:Render;
		private var controller:Controller;

		//set static variables!!
		private var sW=1250;
		private var sH=650;
		private var nodesYPos=305;
		private var nodeSize:int=15;

		var margin_top:int=10;
		var margin_bottom:int=10;
		var gutter:int=40;
		var column:int=135;

		function Main() {
			//trace("Main" + stage);
			//init();
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}

		function init() {

			controller=new Controller(sW,sH,nodesYPos,nodeSize,gutter,column);


			render=new Render(sW,sH,nodeSize,margin_top,margin_bottom,gutter,column);
			render.addEventListener("NODES_COMPLETE", renderScreen);
			render.init();
		}

		function addedToStage(e:Event) {
			//trace("add to stage");
			controller=new Controller(sH,nodesYPos,nodeSize,gutter,column);
			render=new Render(sH,nodeSize,margin_top,margin_bottom,gutter,column);
			render.addEventListener("NODES_COMPLETE", renderScreen);
			render.init();
			            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;

			stage.addEventListener(Event.RESIZE,resizeHandler);
			stage.dispatchEvent(new Event(Event.RESIZE));
			//addChild(controller);
		}
		
		private function resizeHandler(e:Event) {
			//trace("Resize");
			sW=stage.stageWidth;
			//sH=stage.stageHeight;
			controller._w = sW;
			
		}

		private function renderScreen(e:Event) {
			//trace("main renderscreen");
			e.target.removeEventListener("NODES_COMPLETE", renderScreen);
			e.stopImmediatePropagation();
			//trace("main posList.length = " + render.getPosListArray().length);

			controller._nodes=render._nodes;
			controller._posList=render.getPosListArray();
			controller._instList=render.getInstListArray();
			controller._posCont=render._posContainer;
			controller._instCont=render._instContainer;

			controller.render();

			addChild(controller);
		}

	}//class
}//package;