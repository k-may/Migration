package com.kevmayo.migration
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	public class Migration extends Sprite {

		private var render:Render;
		private var container:Container;

		public static const STAGE_HEIGHT=650;
		public static const NODES_PADDING_TOP=305;
		public static const NODE_SIZE:int=15;
		
		//padding
		public static var PADDING_TOP:int=10;
		public static var PADDING_BOTTOM:int=10;
		public static var GUTTER_WIDTH:int=40;
		public static var COLUMN_WIDTH:int=135;
		public static var MAIN_NODE_SIZE:int = 25;
		
		public function Migration() {
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		private function addedToStage(e:Event) {
			
			render=new Render(STAGE_HEIGHT,NODE_SIZE,PADDING_TOP,PADDING_BOTTOM,GUTTER_WIDTH,COLUMN_WIDTH);

			container=new Container(STAGE_HEIGHT,NODES_PADDING_TOP,NODE_SIZE,GUTTER_WIDTH,COLUMN_WIDTH);
			
			render.addEventListener("NODES_COMPLETE", renderScreen);
			render.init();
			
			//initStage
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			stage.addEventListener(Event.RESIZE,resizeHandler);
			stage.dispatchEvent(new Event(Event.RESIZE));

		}
		
		private function resizeHandler(e:Event) {
			container.width = stage.stageWidth			
		}
		
		private function renderScreen(e:Event) {
			e.target.removeEventListener("NODES_COMPLETE", renderScreen);
			e.stopImmediatePropagation();

			//this is wierd, sharing references?
			container.nodes=render._nodes;
			container.positionList=render.getPosListArray();
			container.instList=render.getInstListArray();
			container._posCont=render._posContainer;
			container._instCont=render._instContainer;
			
			container.render();
			
			addChild(container);
		}
	}
}