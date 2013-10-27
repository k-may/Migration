package com.kevmayo.migration
{
	import com.kevmayo.migration.view.Container;
	import com.kevmayo.migration.view.NodeFactory;
	import com.kevmayo.migration.view.Preloader;
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
		private var preloader:Preloader;

		public static const BUTTON_COLOR:uint = 0x808080;
		public static const LINE_COLOR:uint = 0xcccccc;
		public static const TITLE_COLOR:uint = 0X4D4D4D;
		
		public static const STAGE_HEIGHT=650;
		public static const NODES_PADDING_TOP=305;
		public static const NODE_SIZE:int=15;
		public static const NODE_LINE_WIDTH=2;
		public static const NAV_HEIGHT:int=100;
		public static const MAX_MENU_WIDTH:int=350;
		public static const MENU_PADDING_TOP = 70;
		public static const MENU_PADDING_HOR = 50;
		public static const CONT_PADDING_TOP = 55;
		public static const CONT_PADDING_RIGHT = 20;

		//padding
		public static var PADDING_TOP:int=10;
		public static var PADDING_BOTTOM:int=10;
		public static var GUTTER_WIDTH:int=40;
		public static var COLUMN_WIDTH:int=135;
		public static var MAIN_NODE_SIZE:int=25;
		public static var BORDER_RADIUS:int = 25;
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
			controller=new Controller(model);
			
			preloader = new Preloader();
			addChild(preloader);
			preloader.width= stage.stageWidth;
			preloader.height = stage.stageHeight;

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
			
			container=new Container(model, controller);
			container.registerNodeFactory(new NodeFactory());

			removeChild(preloader);
			
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
			container.resize(stage.stageWidth, stage.stageHeight);
			
			if(!container.stage)
				addChild(container);

		}

	}
}
