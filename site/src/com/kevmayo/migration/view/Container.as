﻿package com.kevmayo.migration.view
{

	import com.kevmayo.migration.Migration;
	import com.kevmayo.migration.Model;
	import com.kevmayo.migration.framework.INodeFactory;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class Container extends Sprite
	{
		private var _factory:INodeFactory;
		private var _navigationContainer:NavigationContainer;
		private var _trajContainer:TrajectoryContainer;
		private var _nodesContainer:NodeContainer;
		private var _detailsContainer:DetailsContainer;

		private var _mainWindow:Sprite;
		//padding			
		private var _menuWidth:int;
		private var _nodesWidth:int;

		private var _width:int;
		private var _height:int;

		private var _currentPos:Number = 0.5;
		
		private var _invalidated:Boolean=false;

		/*var menuContainer:MenuContainer;
		private var _nodeBorder:Border;
		private var _subMenuBorder:Border;
		private var _scrollLeft:ScrollWall;
		private var _scrollRight:ScrollWall;
*/


	//textfields
		private var topTitle:TextField=new TextField();
		private var bottomTitle:TextField=new TextField();
		private var instTitle:TextField=new TextField();
		private var sideTitle:TextField=new TextField();
		private var tFormat:TextFormat;

		private var myFont:Font;

		private var titleCont:Sprite=new Sprite();
		private var titleMask:Shape=new Shape();

		private var _scrollDir:int;
		private var _model:Model;

		public function Container(model:Model)
		{
			trace("hello from Container");

			this._model=model;

			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		public function get detailsContainer():DetailsContainer
		{
			return _detailsContainer;
		}

		public function get nodesContainer():NodeContainer
		{
			return _nodesContainer;
		}

		public function set nodesContainer(value:NodeContainer):void
		{
			_nodesContainer=value;
		}

		public function get trajectoryContainer():TrajectoryContainer
		{
			return _trajContainer;
		}

		public function registerNodeFactory(factory:INodeFactory):void
		{
			_factory=factory;
		}

		protected function onAddedToStage(event:Event):void
		{

			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			this.height=Migration.STAGE_HEIGHT;
			this.width=stage.stageWidth; //Stage.STAGE_WIDTH;
			_menuWidth=Migration.COLUMN_WIDTH + Migration.GUTTER_WIDTH;

			_mainWindow=new Sprite();
			addChild(_mainWindow);

			_nodesContainer=new NodeContainer();
			_nodesContainer.nodes=_factory.createNodes(_model.institutions);
			_mainWindow.addChild(_nodesContainer);

			_trajContainer=new TrajectoryContainer();
			_mainWindow.addChild(_trajContainer);

			_navigationContainer=new NavigationContainer();
			addChild(_navigationContainer);
			_navigationContainer.setLocations(_model.cities);

			createTextFields();

		}


		private function createTextFields()
		{
			myFont=new ArialReg();
			tFormat=new TextFormat(myFont.fontName, 13, 0X7E7F81);

			//titleCont.graphics.lineStyle(1,0X000fff);
			titleCont.graphics.drawRect(0, 0, _menuWidth, _height);
			addChild(titleCont);
			titleCont.x=_width;
			titleCont.y=10;

			titleMask.graphics.lineStyle(1, 0X000fff);
			titleMask.graphics.beginFill(0, 0);
			titleMask.graphics.drawRect(0, 0, _menuWidth - 40, _height);
			addChild(titleMask);

			titleMask.x=_width - _menuWidth;
			titleCont.mask=titleMask

			topTitle.embedFonts=true;
			topTitle.defaultTextFormat=tFormat;
			topTitle.setTextFormat(tFormat);
			topTitle.selectable=false;
			topTitle.autoSize="left";
			topTitle.x=10;
			topTitle.y=5;
			titleCont.addChild(topTitle);

			bottomTitle.embedFonts=true;
			bottomTitle.defaultTextFormat=tFormat;
			bottomTitle.setTextFormat(tFormat);
			bottomTitle.selectable=false;
			bottomTitle.autoSize="left";
			bottomTitle.x=10;
			bottomTitle.y=_height - 43;
			titleCont.addChild(bottomTitle);

			var sFormat:TextFormat=new TextFormat(myFont.fontName, 11, 0);
			instTitle.embedFonts=true;
			instTitle.defaultTextFormat=sFormat;
			instTitle.setTextFormat(sFormat);
			instTitle.selectable=false;
			instTitle.mouseEnabled=false;
			instTitle.autoSize="left";
			instTitle.text="Select arrows to access filter and scroll window"
			instTitle.x=0;
			instTitle.y=280;
			instTitle.rotation=-90;

			addChild(titleCont);
		}

		public override function set width(_val:Number):void
		{
			this._width=_val;
			_invalidated=true;
		}

		override public function get height():Number
		{
			return _height;
		}

		override public function set height(value:Number):void
		{
			_height=value;
			_invalidated=true;
		}

		override public function get width():Number
		{
			return _width;
		}

		/*
			private function createChilds()
			{
				//addChild(instTitle);
				addChild(_nodesContainer);

						addChild(menuContainer);

						menuContainer.y=10;
						menuContainer.addEventListener(MenuEvent.EXPAND_MAIN_MENU, mainMenuHandler);
						menuContainer.mainMaskXPos=Math.floor(Migration.MAIN_NODE_SIZE / 2);
						menuContainer.addEventListener(MenuEvent.OVER_NAME, overName);
						menuContainer.addEventListener(MenuEvent.CLICK_NAME, clickName);



						addChild(_nodeBorder);

						_nodeBorder.x=30;
						_nodeBorder.y=10;
						_nodeBorder.render(w - 60, height - 20);
						_nodesContainer.border(_nodeBorder.x + 15, 10, _nodeBorder._w - 30, height - 20);

						_scrollLeft=new ScrollWall("left", 12, nodesYPos - 117);
						addChild(_scrollLeft);
						_scrollLeft.addEventListener(ScrollEvent.OVER_ARROW, overArrow);

						_scrollRight=new ScrollWall("right", w - 12, nodesYPos - 117);
						addChild(_scrollRight);
						_scrollRight.addEventListener(ScrollEvent.OVER_ARROW, overArrow);

						addChild(_subMenuBorder);
						_subMenuBorder.x = _menuWidth;
						_subMenuBorder.y = _nodeBorder.y;
						_subMenuBorder.render(0, height - 20);
						_subMenuBorder.visible=false;
						*/

		public function update():void
		{
			// TODO Auto Generated method stub
			if (_invalidated)
			{
				_invalidated=false;

				var mainWindowWidth=_width - getMenuWidth();
				var mainWindowHeight=_height - Migration.NAV_HEIGHT;
				var mainWindowX=getMenuWidth();

				_trajContainer.width=_nodesContainer.width;
				_trajContainer.height=mainWindowHeight;

				_nodesContainer.height=mainWindowHeight;

				//mainwindow
				var mask:Shape=new Shape();

				mask.graphics.beginFill(0xffffff);
				mask.graphics.drawRect(mainWindowX, 0, mainWindowWidth, mainWindowHeight);
				mask.graphics.endFill();

				_mainWindow.mask=mask;
				_mainWindow.x=mainWindowX;
				var g:Graphics = _mainWindow.graphics;
				g.clear();
				g.beginFill(0xffffff);
				g.drawRect(0,0,mainWindowWidth, mainWindowHeight);
				

				this.graphics.clear();
				this.graphics.lineStyle(1, 0xff0000);
				this.graphics.drawRect(_mainWindow.x, _mainWindow.y, mainWindowWidth, mainWindowHeight); //_mainWindow.width, _mainWindow.height);

				//navigation
				_navigationContainer.width=mainWindowWidth;
				_navigationContainer.y=mainWindowHeight;
				_navigationContainer.x=mainWindowX;

				setPos(_currentPos);

			}

			_navigationContainer.update();
//			_nodesContainer.update();
//			_trajContainer.update();
		}


		public function getMenuWidth():int
		{
			return Migration.MAX_MENU_WIDTH;
		}

		public function resize(stageWidth:int, stageHeight:int):void
		{
			// TODO Auto Generated method stub
			this.width=stageWidth;

			_invalidated=true;
		}
		
		private function setPos(ratio:Number){
			_navigationContainer.setPos(ratio);
			var mainWindowWidth:Number = _width - getMenuWidth();
			var nodePos:int = mainWindowWidth/2 - _nodesContainer.width * ratio;
			_nodesContainer.x = nodePos;
			_trajContainer.x = nodePos;
		}
	}

/*	private function fadeInst(e:Event)
	{
		instTitle.alpha=(instTitle.alpha > 0.1) ? instTitle.alpha * 0.999 : 0;

		if (instTitle.alpha == 0)
			addEventListener(Event.ENTER_FRAME, fadeInst);
	}
*/
/*
		private function overName(e:Event)
		{
			menuContainer.addEventListener(MenuEvent.OUT_NAME, outName);
			var evt:MenuEvent=(e as MenuEvent);
			var listType:String=evt.listType;
			var id:int=evt.id;

			switch (listType)
			{
				case "position":
					var tempPosIndex:Array=new Array();
					var id=(e as MenuEvent).id;
					tempPosIndex=_positionList[id].indexArray;

					var tempPosDir:Array=new Array();
					for (var i:int=0; i < _positionList[id].latArray.length; i++)
					{
						tempPosDir[i]=(_positionList[id].latArray[i].position == "curator") ? 1 : -1;
					}
					var nodeColor:uint=e.target.parent.getColor(id);

					_nodesContainer.addTrajectory(_nodesContainer.trajContainer, tempPosIndex, tempPosDir, nodeColor, "linear");
					for (var i:int=0; i < tempPosIndex.length; i++)
					{
						_nodesContainer.drawFlag(tempPosIndex[i], tempPosDir[i], nodeColor);
					}
					break;
				case "institution":
					var nodeColor:uint=e.target.parent.getColor(id);
					var movedTo:Array=_instList[id].movedTo;
					for (var mT:int=0; mT < movedTo.length; mT++)
					{
						_nodesContainer.addTrajectory(_nodesContainer.trajContainer, new Array(movedTo[mT], _instList[id].nodeIndex), new Array(-1, -1), nodeColor, "eccentric");
					}
					var movedFrom:Array=_instList[id].movedFrom;

					for (var mF:int=0; mF < movedFrom.length; mF++)
					{
						_nodesContainer.addTrajectory(_nodesContainer.trajContainer, new Array(_instList[id].nodeIndex, movedFrom[mF]), new Array(1, 1), nodeColor, "eccentric");
					}
					if (movedTo.length > 0)
					{
						//trace("movedTo");
						_nodesContainer.drawFlag(_instList[id].nodeIndex, -1, nodeColor);
					}
					if (movedFrom.length > 0)
					{
						//trace("movedFrom");
						_nodesContainer.drawFlag(_instList[id].nodeIndex, 1, nodeColor);
					}
					//trace("Controller: movedTo length = " + instList[e.id].movedTo.length + " movedFrom lenfgth = " + instList[e.id].movedFrom.length);

					break;
			}
		}

		private function outName(e:Event)
		{
			menuContainer.removeEventListener(MenuEvent.OUT_NAME, outName);
			var evt:MenuEvent=(e as MenuEvent);
			var listType:String=evt.listType;
			switch (listType)
			{
				case "position":
					_nodesContainer.clearTrajectory();
					break;
				default:

					//todo : wft?
					_nodesContainer.clearTrajectory();
					break;
			}
		}

		private function clickName(e:Event)
		{
			//trace("clickName");
			var evt:MenuEvent=(e as MenuEvent);
			var listType:String=evt.listType;
			switch (listType)
			{
				case "position":
					_nodesContainer.savePosition("linear");
					break;
				case "institution":
					_nodesContainer.savePosition("eccentric");
					break;
			}
		}*/

/*public function set nodes(_val)
{
	_nodesContainer._nodes=_val;
}*/
/*
		public function set nodesWidth(_val)
		{
			_nodesWidth=_val;
			_nodesContainer._nodesWidth=_val;
		}

		public function set positionList(_val)
		{
			_positionList=_val;
			_nodesContainer._posList=_val;
		}

		public function set instList(_val)
		{
			_instList=_val;
			_nodesContainer._instList=_val;
		}




		/*
				public function set _instCont(_val)
				{
					menuContainer._instCont=_val;
				}

				public function set _posCont(_val)
				{
					menuContainer._posCont=_val;
				}

				private function mainMenuHandler(e:Event)
				{
					var evt:MenuEvent=(e as MenuEvent);
					var type:String=evt.type;
					var id:int=evt.id;

					switch (type)
					{
						case "expandMainMenu":
							scrollSpeed=10;
							menuContainer.removeEventListener(MenuEvent.EXPAND_MAIN_MENU, mainMenuHandler);
							menuContainer.addEventListener(MenuEvent.COLLAPSE_MAIN_MENU, mainMenuHandler);
							menuContainer.addEventListener(MenuEvent.EXPAND_SUB_MENU, mainMenuHandler);
							menuContainer.addEventListener(MenuEvent.EXPAND_SORT_MENU, sortMenuHandler);
							removeEventListener(Event.ENTER_FRAME, collapseMainMenu);
							addEventListener(Event.ENTER_FRAME, expandMainMenu);
							break;
						case "collapseMainMenu":
							menuContainer.removeEventListener(MenuEvent.COLLAPSE_MAIN_MENU, mainMenuHandler);
							menuContainer.removeEventListener(MenuEvent.EXPAND_SUB_MENU, mainMenuHandler);
							menuContainer.removeEventListener(MenuEvent.EXPAND_SORT_MENU, sortMenuHandler);
							menuContainer.addEventListener(MenuEvent.EXPAND_MAIN_MENU, mainMenuHandler);
							removeEventListener(Event.ENTER_FRAME, expandMainMenu);
							addEventListener(Event.ENTER_FRAME, collapseMainMenu);
							break;
						case "expandSubMenu":
							scrollSpeed=20;
							menuContainer.removeEventListener(MenuEvent.EXPAND_SUB_MENU, mainMenuHandler);
							menuContainer.addEventListener(MenuEvent.COLLAPSE_SUB_MENU, mainMenuHandler);
							removeEventListener(Event.ENTER_FRAME, collapseSubMenu);
							addEventListener(Event.ENTER_FRAME, expandSubMenu);
							if (id == 0)
							{
								topTitle.text="DIRECTORS";
								bottomTitle.text="CURATORS";
							}
							else if (id == 1)
							{
								topTitle.text="MIGRATE TO";
								bottomTitle.text="MIGRATE FROM";
							}
							addEventListener(Event.ENTER_FRAME, expandTitleCont);
							break;
						case "collapseSubMenu":
							_nodesContainer.removeTrajectories();
							menuContainer.removeEventListener(MenuEvent.COLLAPSE_SUB_MENU, mainMenuHandler);
							menuContainer.addEventListener(MenuEvent.EXPAND_SUB_MENU, mainMenuHandler);
							removeEventListener(Event.ENTER_FRAME, expandSubMenu);
							addEventListener(Event.ENTER_FRAME, collapseSubMenu);
							addEventListener(Event.ENTER_FRAME, collapseTitleCont);
							break;
					}
				}

				private function sortMenuHandler(e:Event)
				{
					switch (e.type)
					{
						case "expandSortMenu":
							menuContainer.removeEventListener(MenuEvent.EXPAND_SORT_MENU, sortMenuHandler);
							menuContainer.addEventListener(MenuEvent.COLLAPSE_SORT_MENU, sortMenuHandler);
							addEventListener(Event.ENTER_FRAME, expandSortMenu);
							//trace("expand sort menu");
							break;
						case "collapseSortMenu":
							menuContainer.removeEventListener(MenuEvent.COLLAPSE_SORT_MENU, sortMenuHandler);
							menuContainer.addEventListener(MenuEvent.EXPAND_SORT_MENU, sortMenuHandler);
							addEventListener(Event.ENTER_FRAME, collapseSortMenu);
							//trace("collapse sort Menu");
							break;
					}
				}

				private function collapseTitleCont(e:Event)
				{
					titleCont.x=(titleCont.x < w) ? titleCont.x * 1.01 + 5 : w;
					if (titleCont.x == w)
					{
						removeEventListener(Event.ENTER_FRAME, collapseTitleCont);
					}
				}

				private function expandTitleCont(e:Event)
				{
					titleCont.x=(titleCont.x > titleMask.x) ? titleCont.x * 0.99 - 5 : titleMask.x;
					if (titleCont.x == titleMask.x)
					{
						removeEventListener(Event.ENTER_FRAME, expandTitleCont);
					}
				}

				private function expandSortMenu(e:Event)
				{
					menuContainer.subMenuMaskXPos=(menuContainer.subMenuMaskXPos < _menuWidth - 50) ? menuContainer.subMenuMaskXPos * 1.3 + 10 : _menuWidth - 15;
					menuContainer.listMaskXPos=menuContainer.subMenuMaskXPos + _menuWidth * 2 + 40

					if (_subMenuBorder.visible)
					{
						_subMenuBorder.x=menuContainer.listMaskXPos - 200;
						_subMenuBorder.render(_nodeBorder.x - _subMenuBorder.x - Migration.GUTTER_WIDTH, height - 20);
					}
					else
					{
						_nodeBorder.x=(_subMenuBorder.visible) ? _nodeBorder.x : menuContainer.subMenuMaskXPos + _menuWidth + 15;
						_nodeBorder.render(w - (menuContainer.subMenuMaskXPos + _menuWidth + 15) - 30, height - 20);
						_nodesContainer.border(_nodeBorder.x + 15, 10, _nodeBorder._w - 30, height - 20);
						_scrollLeft.x=menuContainer.subMenuMaskXPos + _menuWidth - 10;
					}
					if (menuContainer.subMenuMaskXPos == _menuWidth - 15)
					{
						removeEventListener(Event.ENTER_FRAME, expandSortMenu);
							//menuController.addEventListener(MenuEvent.SORT_LIST, sortList);
					}
				}

				private function collapseSortMenu(e:Event)
				{
					menuContainer.subMenuMaskXPos=(menuContainer.subMenuMaskXPos > menuContainer.mainMaskXPos - _menuWidth + 40) ? menuContainer.subMenuMaskXPos * 0.7 - 15 : menuContainer.mainMaskXPos - _menuWidth;
					menuContainer.listMaskXPos=menuContainer.subMenuMaskXPos + _menuWidth * 2 + 40;
					if (_subMenuBorder.visible)
					{
						_subMenuBorder.x=menuContainer.listMaskXPos - 200;
						_subMenuBorder.render(_nodeBorder.x - _subMenuBorder.x - Migration.GUTTER_WIDTH, height - 20);
					}
					else
					{
						_nodeBorder.x=(_subMenuBorder.visible) ? _nodeBorder.x : menuContainer.subMenuMaskXPos + _menuWidth + 15;
						_nodeBorder.render(w - (menuContainer.subMenuMaskXPos + _menuWidth + 15) - 30, height - 20);
						_nodesContainer.border(_nodeBorder.x + 15, 10, _nodeBorder._w - 30, height - 20);
						_scrollLeft.x=menuContainer.subMenuMaskXPos + _menuWidth - 10;
					}
					if (menuContainer.subMenuMaskXPos == menuContainer.mainMaskXPos - _menuWidth)
					{
						removeEventListener(Event.ENTER_FRAME, collapseSortMenu);
							//menuController.removeEventListener(MenuEvent.SORT_LIST, sortList);
					}
				}

				//private function sortList

				private function expandMainMenu(e:Event)
				{
					menuContainer.mainMaskXPos=(menuContainer.mainMaskXPos < _menuWidth - 30) ? menuContainer.mainMaskXPos * 1.2 + 5 : (_menuWidth - 15);
					_nodeBorder.x=menuContainer.mainMaskXPos + 15;
					_nodeBorder.render(w - (menuContainer.mainMaskXPos + 15) - 30, height - 20);
					_nodesContainer.border(_nodeBorder.x + 15, 10, _nodeBorder._w - 30, height - 20);
					menuContainer.filterMaskXPos=_nodeBorder.x - menuContainer._mainW;
					_scrollLeft.x=menuContainer.mainMaskXPos - 10;
					_nodesContainer._nodeXPos+=5;
					if (menuContainer.mainMaskXPos == _menuWidth - 15)
					{
						removeEventListener(Event.ENTER_FRAME, expandMainMenu);

					}
				}

				private function collapseMainMenu(e:Event)
				{
					menuContainer.mainMaskXPos=(menuContainer.mainMaskXPos > menuContainer._mainNodeSize / 2 + 10) ? menuContainer.mainMaskXPos * 0.8 - 5 : Math.floor(menuContainer._mainNodeSize / 2);
					_nodeBorder.x=menuContainer.mainMaskXPos + 15;
					_nodeBorder.render(w - (menuContainer.mainMaskXPos + 15) - 30, height - 20);
					_nodesContainer.border(_nodeBorder.x + 15, 10, _nodeBorder._w - 30, height - 20);
					menuContainer.filterMaskXPos=_nodeBorder.x - menuContainer._mainW;
					_scrollLeft.x=menuContainer.mainMaskXPos - 10;
					_nodesContainer._nodeXPos-=5;
					if (menuContainer.mainMaskXPos == Math.floor(menuContainer._mainNodeSize / 2))
					{
						removeEventListener(Event.ENTER_FRAME, collapseMainMenu);
					}
				}

				private function expandSubMenu(e:Event)
				{
					_nodeBorder.x=(_nodeBorder.x < (Migration.GUTTER_WIDTH * 4 + Migration.COLUMN_WIDTH * 2) - 10) ? _nodeBorder.x + 10 : (Migration.GUTTER_WIDTH * 4 + Migration.COLUMN_WIDTH * 2);
					_nodeBorder.render(w - _nodeBorder.x - 30, height - 20);
					_nodesContainer.border(_nodeBorder.x + 15, 10, _nodeBorder._w - 30, height - 20);
					menuContainer.listMaskXPos=_nodeBorder.x - Migration.GUTTER_WIDTH - 15; //equal to mainW?


					if (_nodeBorder.x > Migration.GUTTER_WIDTH * 2 + Migration.COLUMN_WIDTH)
					{
						_subMenuBorder.visible=true;
						_subMenuBorder.render(_nodeBorder.x - _subMenuBorder.x - Migration.GUTTER_WIDTH, height - 20);
					}
					_scrollLeft.x=_nodeBorder.x - 25;
					_nodesContainer._nodeXPos+=10;
					if (_nodeBorder.x == (Migration.GUTTER_WIDTH * 4 + Migration.COLUMN_WIDTH * 2))
					{
						removeEventListener(Event.ENTER_FRAME, expandSubMenu);
					}
				}

				private function collapseSubMenu(e:Event)
				{
					_nodeBorder.x=(_nodeBorder.x > _menuWidth + 10) ? _nodeBorder.x - 10 : _menuWidth;
					_nodeBorder.render(w - _nodeBorder.x - 30, height - 20);
					_nodesContainer.border(_nodeBorder.x + 15, 10, _nodeBorder._w - 30, height - 20);
					menuContainer.listMaskXPos=_nodeBorder.x - Migration.GUTTER_WIDTH - 15;

					if (_nodeBorder.x - Migration.GUTTER_WIDTH > _subMenuBorder.x)
					{

						_subMenuBorder.render(_nodeBorder.x - _subMenuBorder.x - Migration.GUTTER_WIDTH, height - 20);
					}
					else
					{
						_subMenuBorder.visible=false;

					}
					_scrollLeft.x=_nodeBorder.x - 25;
					_nodesContainer._nodeXPos-=10;
					if (_nodeBorder.x == _menuWidth)
					{
						removeEventListener(Event.ENTER_FRAME, collapseSubMenu);
					}
				}

				private function overArrow(e:ScrollEvent)
				{
					e.target.addEventListener(ScrollEvent.OUT_ARROW, outArrow);
					e.target._arrowColor=0XDDFFF8;
					_scrollDir=-e.dir;
					addEventListener(Event.ENTER_FRAME, scrollNodes);
				}

				private function outArrow(e:ScrollEvent)
				{
					e.target.removeEventListener(ScrollEvent.OUT_ARROW, outArrow);
					removeEventListener(Event.ENTER_FRAME, scrollNodes);
					scrollSpeed=1;
					e.target._arrowColor=0xDEE9FE;
				}

				*/
/*
		private function scrollNodes(e:Event)
		{
			//if (_nodesContainer._nodeXPos + (_scrollDir * scrollSpeed) <= _nodeBorder.x + 300 && _nodesContainer._nodeXPos + (_scrollDir * scrollSpeed) > (_nodesWidth - (w + 300)))
			//{
			_nodesContainer._nodeXPos+=_scrollDir * scrollSpeed;
			//}
			if (scrollSpeed < 10)
			{
				scrollSpeed=scrollSpeed * accel;
			}
		}
	}*/
}