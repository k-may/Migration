package com.kevmayo.migration.view
{

	import com.kevmayo.migration.Controller;
	import com.kevmayo.migration.Migration;
	import com.kevmayo.migration.Model;
	import com.kevmayo.migration.framework.IContainer;
	import com.kevmayo.migration.framework.INodeFactory;
	import com.kevmayo.migration.framework.Node;

	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	import caurina.transitions.Tweener;

	public class Container extends Sprite implements IContainer
	{
		private var _flagsContainer:FlagContainer;
		private var _factory:INodeFactory;
		private var _navigationContainer:NavigationContainer;
		private var _trajContainer:TrajectoryContainer;
		private var _nodesContainer:NodeContainer;
		private var _detailsContainer:DetailsContainer;
		private var _menuContainer:MenuContainer;
		private var _mainWindow:Sprite;
		private var _titleView:TitleView;

		//padding			
		private var _menuWidth:int;
		private var _nodesWidth:int;

		private var _dragSamples:Array;

		private var _width:int;
		private var _height:int;

		private var _dragging:Boolean=false;
		private var _mouseDown:Boolean=false;
		private var _downPos:Point;
		private var _threshold:int=10;
		private var _downRatio:Number;
		private var _sampleSpeed:Number;
		private var _lastDown:int;

		private var _currentPos:Number=0.5;

		private var _invalidated:Boolean=false;


		private var titleCont:Sprite=new Sprite();
		private var titleMask:Shape=new Shape();

		private var _scrollDir:int;

		private var _model:Model;
		private var _controller:Controller;


		public function Container(model:Model, controller:Controller)
		{
			trace("hello from Container");

			this._model=model;
			this._controller=controller;
			_controller.registerContainer(this);


			_dragSamples=new Array();


			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		public function registerNodeFactory(factory:INodeFactory):void
		{
			_factory=factory;
		}

		protected function onAddedToStage(event:Event):void
		{

			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			_menuWidth=Migration.COLUMN_WIDTH + Migration.GUTTER_WIDTH;

			_mainWindow=new Sprite();
			addChild(_mainWindow);

			_detailsContainer=new DetailsContainer();
			_mainWindow.addChild(_detailsContainer);
			_controller.registerDetailsContainer(_detailsContainer);

			_trajContainer=new TrajectoryContainer();
			_mainWindow.addChild(_trajContainer);
			_controller.registerTrajectoryContainer(_trajContainer);

			_flagsContainer=new FlagContainer();
			_mainWindow.addChild(_flagsContainer);
			_controller.registerFlagContainer(_flagsContainer);

			_nodesContainer=new NodeContainer();
			_nodesContainer.nodes=_factory.createNodes(_model.institutions);
			_mainWindow.addChild(_nodesContainer);
			_controller.registerNodeContainer(_nodesContainer);

			_trajContainer.width=_nodesContainer.width;
			_flagsContainer.width=_nodesContainer.width;
			_detailsContainer.width=_nodesContainer.width;


			_mainWindow.addEventListener(MouseEvent.MOUSE_DOWN, onWindowTouchHandler);
			_mainWindow.addEventListener(MouseEvent.MOUSE_MOVE, onWindowTouchHandler);
			_mainWindow.addEventListener(MouseEvent.MOUSE_UP, onWindowTouchHandler);
			_mainWindow.addEventListener(MouseEvent.ROLL_OUT, onWindowTouchHandler);

			_navigationContainer=new NavigationContainer(_model, _nodesContainer);
			addChild(_navigationContainer);
			_navigationContainer.setLocations(_model.cities);


			_menuContainer=new MenuContainer(_model);
			_controller.registerMenuContainer(_menuContainer);
			addChild(_menuContainer);
			_menuContainer.width=getMinMenuWidth();

			_titleView=new TitleView();
			_controller.registerTitleView(_titleView);
			addChild(_titleView);
		}

		public function update():void
		{
			// TODO Auto Generated method stub
			if (_invalidated)
			{
				_invalidated=false;

				var menuWidth=getMenuWidth();
				var mainWindowWidth=_width - menuWidth;
				var mainWindowHeight=_height - Migration.NAV_HEIGHT;
				var mainWindowX=getMenuWidth();

				renderMainWindow(mainWindowX, mainWindowWidth, mainWindowHeight);

				//navigation
				_navigationContainer.width=mainWindowWidth;
				_navigationContainer.y=mainWindowHeight;
				_navigationContainer.x=mainWindowX;

				_menuContainer.height=mainWindowHeight;

				_titleView.x=30;
				_titleView.y=10;
				_titleView.width=_width - 200;


				pos=_currentPos;
			}

			updateChilds();
			updateTouch();
		}

		private function updateChilds():void
		{
			_navigationContainer.update();
			_menuContainer.update();
			_flagsContainer.update();
			_titleView.update();
			_detailsContainer.update();
			_nodesContainer.update();
		}



		private function renderMainWindow(x:int, w:int, h:int)
		{

			var paddingRight:int=Migration.CONT_PADDING_RIGHT;
			var paddingTop:int=Migration.CONT_PADDING_TOP;

			var contHeight:int=h - paddingTop;
			_trajContainer.height=contHeight;
			_nodesContainer.height=contHeight;
			_flagsContainer.height=contHeight;
			_detailsContainer.height=contHeight;


			//mainwindow
			var mask:Shape=new Shape();
			mask.y=paddingTop;
			mask.graphics.beginFill(0xffffff);
			mask.graphics.drawRect(x, 0, w - paddingRight + 1, h);
			mask.graphics.endFill();

			_mainWindow.mask=mask;
			_mainWindow.x=x;
			_mainWindow.y=paddingTop;


			var radius:int=Migration.BORDER_RADIUS;
			var g:Graphics=_mainWindow.graphics;
			g.clear();
			g.beginFill(0xffffff);
			g.drawRoundRect(0, 0, w - paddingRight, h - paddingTop, radius, radius);
			g.endFill();
			g.lineStyle(1, 0x000);

			renderDashedBorder(g, w - paddingRight, h - paddingTop, radius);

		}

		private function renderDashedBorder(g:Graphics, w:int, h:int, radius:int)
		{
			var dashedBorder:DashedLine=new DashedLine(g, 8, 8);
			dashedBorder.moveTo(radius, 0);
			dashedBorder.lineTo(w - radius, 0);
			dashedBorder.curveTo(w, 0, w, radius);
			dashedBorder.lineTo(w, h - radius);
			dashedBorder.curveTo(w, h, w - radius, h);
			dashedBorder.lineTo(radius, h);
			dashedBorder.curveTo(0, h, 0, h - radius);
			dashedBorder.lineTo(0, radius);
			dashedBorder.curveTo(0, 0, radius, 0);
		}

		protected function onWindowTouchHandler(event:MouseEvent):void
		{
			var distance:Number=0;
			var ratio:Number=0;
			switch (event.type)
			{
				case MouseEvent.MOUSE_OVER:

					break;
				case MouseEvent.MOUSE_DOWN:
					_mouseDown=true;
					_downRatio=_currentPos;
					_downPos=new Point(event.localX, event.localY);
					_lastDown=event.localX;
				case MouseEvent.MOUSE_MOVE:
					if (_mouseDown)
					{
						distance=event.localX - _downPos.x;

						_dragging=_dragging || Math.abs(distance) > _threshold;

						if (_dragging)
						{
							ratio=_downRatio - (distance / _nodesContainer.width);
							pos=ratio;
						}
						addSample(_lastDown - event.localX);
						_lastDown=event.localX;
					}

					break;
				case MouseEvent.ROLL_OUT:
				case MouseEvent.MOUSE_UP:
					if (_mouseDown)
					{
						_sampleSpeed=getSampleSpeed();
						_downRatio=_currentPos;
						_dragging=false;
						_mouseDown=false;
					}
					break;

			}
		}

		private function updateTouch():void
		{
			_sampleSpeed*=0.9;
			if (!_mouseDown)
			{
				if (Math.abs(_sampleSpeed) >= 1)
				{
					var ratio=_downRatio - (_sampleSpeed / _nodesContainer.width);
					this.pos=ratio;
				}
			}
		}

		public function getMenuWidth():int
		{
			return _menuContainer.width;
		}

		public function resize(stageWidth:int, stageHeight:int):void
		{
			// TODO Auto Generated method stub
			_width=stageWidth;
			_height=stageHeight;

			_invalidated=true;
		}

		public function set pos(value:Number):void
		{
			_currentPos= Math.min(Math.max(0, value), 1);
			_navigationContainer.setPos(_currentPos);
			var mainWindowWidth:Number=_width - getMenuWidth();
			var nodePos:int=mainWindowWidth / 2 - _nodesContainer.width * _currentPos;
			_nodesContainer.x=nodePos;
			_trajContainer.x=nodePos;
			_flagsContainer.x=nodePos;
			_detailsContainer.x = nodePos;
		}

		public function get pos():Number
		{
			return _currentPos;
		}

		/*
		private function setPos(ratio:Number)
		{
			_currentPos=ratio;

		}*/

		public function onMenuSelected():void
		{
			if (isMenuOpen())
			{
				Tweener.addTween(_menuContainer, {width: getMaxMenuWidth(), time: 1, onUpdate: function()
				{
					_invalidated=true;
				}});
			}
			else
			{
				Tweener.addTween(_menuContainer, {width: getMinMenuWidth(), time: 1, onUpdate: function()
				{
					_invalidated=true;
				}});
			}
			_invalidated=true;
		}


		private function getMaxMenuWidth()
		{
			return Migration.MAX_MENU_WIDTH + Migration.MENU_PADDING_HOR * 2;
		}

		private function getMinMenuWidth()
		{
			return Migration.MENU_PADDING_HOR * 2;
		}

		public function isMenuOpen():Boolean
		{
			return _menuContainer.isOpen;
		}

		private function addSample(dist:int)
		{
			if (_dragSamples.length >= 3)
				_dragSamples.pop();

			_dragSamples.push(dist);
		}

		private function getSampleSpeed():Number
		{
			var total:int;
			for each (var sample:int in _dragSamples)
			{
				total+=sample;
			}
			return total / _dragSamples.length;
		}

		public function animateToNode(node:Node):void
		{
			// TODO Auto Generated method stub
			var pos:Number=node.x / _nodesContainer.width;
			Tweener.addTween(this, {pos: pos, time: 1});
		}

	}
}
