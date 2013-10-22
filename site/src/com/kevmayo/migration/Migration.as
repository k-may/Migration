package com.kevmayo.migration
{
	import com.kevmayo.migration.view.Container;
	import com.kevmayo.migration.view.NodeFactory;
	import com.kevmayo.migration.view.TrajectoryContainer;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class Migration extends Sprite
	{

		private var _mouseDown:Boolean=false;
		private var _downPos:Point;
		private var controller:Controller;
		private var model:Model;
		private var container:Container;

		public static const STAGE_HEIGHT=650;
		public static const NODES_PADDING_TOP=305;
		public static const NODE_SIZE:int=15;
		public static const NODE_LINE_WIDTH=2;
		public static const NAV_HEIGHT:int=100;
		public static const MAX_MENU_WIDTH:int=100;

		//padding
		public static var PADDING_TOP:int=10;
		public static var PADDING_BOTTOM:int=10;
		public static var GUTTER_WIDTH:int=40;
		public static var COLUMN_WIDTH:int=135;
		public static var MAIN_NODE_SIZE:int=25;
		
		public static var Start_Long:Number;
		public static var End_Long:Number;

		public function Migration()
		{
			trace("its alive...");
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			//initStage
			stage.scaleMode=StageScaleMode.NO_SCALE;
			stage.align=StageAlign.TOP_LEFT;

			stage.addEventListener(Event.RESIZE, onResize);

		}

		private function addedToStage(e:Event)
		{

			model=new Model(dataLoaded);
			controller=new Controller();

			addEventListener(Event.ENTER_FRAME, onEnterFrame);

		}

		protected function onEnterFrame(event:Event):void
		{
			// TODO Auto-generated method stub
			if (container != null)
				container.update();

		}

		private function dataLoaded()
		{
			Start_Long = model.startLong;
			End_Long = model.endLong;
			
			trace("start long : " + Start_Long + " / end : " + End_Long);
			
			container=new Container(model);
			container.registerNodeFactory(new NodeFactory());
			container.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addChild(container);

			controller.registerNodeContainer(container.nodesContainer);
			controller.registerTrajectoryContainer(container.trajectoryContainer);
			controller.registerDetailsContainer(container.detailsContainer);

			stage.dispatchEvent(new Event(Event.RESIZE));
		}

		protected function onMouseDown(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			trace("mouse down");

			switch (event.type)
			{
				case MouseEvent.MOUSE_DOWN:
					_mouseDown=true;
				//_downPos = 
				case MouseEvent.MOUSE_MOVE:

					break;
				case MouseEvent.MOUSE_OUT:
				case MouseEvent.MOUSE_UP:

					break;
			}
		}

		private function onResize(e:Event)
		{
			//container.width=stage.stageWidth
			container.resize(stage.stageWidth, stage.stageHeight);
		}

	/*
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
	}*/
	}
}
