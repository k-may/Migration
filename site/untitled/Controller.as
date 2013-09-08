package untitled{

	import flash.events.*;
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import flash.display.*;
	import flash.text.*;

	public class Controller extends Sprite {

		private var nodeController:NodeController;
		private var nodeBorder:Border;
		private var nodesWidth:int;
		private var nodesYPos:int;
		var menuController:MenuController;
		private var posList:Array;
		private var instList:Array;

		private var w,h:int;
		var scrollSpeed:Number=1;
		var accel:Number=1.1;

		var posCont:Sprite;
		var instCont:Sprite;

		var nodeBorderExtents:int=410;
		var mainNodeSize:int=25;

		var subMenuBorder:Border;

		var gutter:int=40;
		var column:int=120;
		var mainW:int;

		var topTitle:TextField = new TextField();
		var bottomTitle:TextField = new TextField();
		var instTitle:TextField = new TextField();
		var sideTitle:TextField = new TextField();
		var tFormat:TextFormat;
		private var myFont:Font = new ArialReg();

		var titleCont:Sprite = new Sprite();
		var titleMask:Shape = new Shape();

		public function Controller(_h, _nodesYPos, nodeSize, _gutter:int, _column:int) {
			//trace("hello from Controller");
			this.h=_h;
			this.gutter=_gutter;
			this.column=_column;
			this.nodesYPos=_nodesYPos;
			var speed:Number=10;

			mainW=column+gutter;

			nodeController=new NodeController(nodesYPos,h,nodeSize);
			nodeBorder=new Border(0.25);

			menuController=new MenuController(h-20,mainNodeSize);
			subMenuBorder=new Border(0.25);

		}

		public function render() {
addChild(instTitle);
			addChild(menuController);
			menuController.y=10;
			menuController.addEventListener(MenuEvent.EXPAND_MAIN_MENU, mainMenuHandler);
			menuController.mainMaskXPos=Math.floor(mainNodeSize/2);
			menuController.addEventListener(MenuEvent.OVER_NAME, overName);
			menuController.addEventListener(MenuEvent.CLICK_NAME, clickName);
			addChild(nodeController);
			addChild(nodeBorder);
			nodeBorder.x=30;
			nodeBorder.y=10;
			nodeBorder.render(w-60, h-20);
			nodeController.border(nodeBorder.x+15,10,nodeBorder._w-30,h-20);
			
			scrollLeft=new ScrollWall("left",12,nodesYPos-117);
			addChild(scrollLeft);
			scrollLeft.addEventListener(ScrollEvent.OVER_ARROW, overArrow);
			scrollRight=new ScrollWall("right",w-12,nodesYPos-117);
			addChild(scrollRight);
			scrollRight.addEventListener(ScrollEvent.OVER_ARROW, overArrow);
			addChild(subMenuBorder);
			subMenuBorder.x=gutter+column;
			subMenuBorder.y=nodeBorder.y;
			subMenuBorder.render(0,h-20);
			subMenuBorder.visible=false;

			tFormat=new TextFormat(myFont.fontName,13,0X7E7F81);

			//titleCont.graphics.lineStyle(1,0X000fff);
			titleCont.graphics.drawRect(0,0,mainW,h);
			addChild(titleCont);
			titleCont.x=w;
			titleCont.y=10;
			titleMask.graphics.lineStyle(1,0X000fff);
			titleMask.graphics.beginFill(0,0);
			titleMask.graphics.drawRect(0,0,mainW-40,h);
			addChild(titleMask);
			titleMask.x=w-mainW;
			titleCont.mask = titleMask

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
			bottomTitle.y=h-43;
			titleCont.addChild(bottomTitle);
			
			var sFormat:TextFormat=new TextFormat(myFont.fontName,11,0);
			instTitle.embedFonts=true;
			instTitle.defaultTextFormat=sFormat;
			instTitle.setTextFormat(sFormat);
			instTitle.selectable=false;
			instTitle.mouseEnabled = false;
			instTitle.autoSize="left";
			instTitle.text = "Select arrows to access filter and scroll window"
			instTitle.x=0;
			instTitle.y=280;
			instTitle.rotation=-90;
			
			addEventListener(Event.ENTER_FRAME, fadeInst);
		}
		
		private function fadeInst(e:Event){
			instTitle.alpha = (instTitle.alpha > 0.1)?instTitle.alpha*0.999:0;
			if(instTitle.alpha == 0){
				addEventListener(Event.ENTER_FRAME, fadeInst);
				//removeChild(instTitle);
			}
		}

		private function overName(e:Event) {
			menuController.addEventListener(MenuEvent.OUT_NAME, outName);
			if (e.listType=="position") {
				var tempPosIndex:Array = new Array();
				tempPosIndex=posList[e.id].indexArray;

				var tempPosDir:Array = new Array();
				for (var i:int = 0; i < posList[e.id].latArray.length; i ++) {
					tempPosDir[i] = (posList[e.id].latArray[i].position == "curator")?1:-1;
				}
				var nodeColor:uint=e.target.parent.getColor(e.id);

				nodeController.addTrajectory(nodeController.trajContainer, tempPosIndex,tempPosDir, nodeColor, "linear");
				for (var i:int  = 0; i < tempPosIndex.length; i ++) {
					nodeController.drawFlag(tempPosIndex[i], tempPosDir[i], nodeColor);
				}

			} else if (e.listType =="institution") {
				var nodeColor:uint=e.target.parent.getColor(e.id);
				var movedTo:Array=instList[e.id].movedTo;
				for (var mT:int= 0; mT< movedTo.length; mT ++) {
					nodeController.addTrajectory(nodeController.trajContainer, new Array(movedTo[mT], instList[e.id].nodeIndex), new Array(-1,-1), nodeColor, "eccentric");
				}
				var movedFrom:Array=instList[e.id].movedFrom;

				for (var mF:int= 0; mF< movedFrom.length; mF ++) {
					nodeController.addTrajectory(nodeController.trajContainer, new Array(instList[e.id].nodeIndex,movedFrom[mF]), new Array(1,1), nodeColor,"eccentric");
				}
				if (movedTo.length>0) {
					trace("movedTo");
					nodeController.drawFlag(instList[e.id].nodeIndex, -1, nodeColor);
				}
				if (movedFrom.length>0) {
					trace("movedFrom");
					nodeController.drawFlag(instList[e.id].nodeIndex, 1, nodeColor);
				}
				trace("Controller: movedTo length = " + instList[e.id].movedTo.length + " movedFrom lenfgth = " + instList[e.id].movedFrom.length);
			}
		}

		private function outName(e:Event) {
			menuController.removeEventListener(MenuEvent.OUT_NAME, outName);
			if (e.listType=="position") {
				nodeController.clearTrajectory();
			} else {
				nodeController.clearTrajectory();
			}
		}

		private function clickName(e:Event) {
			trace("clickName");
			if (e.listType=="position") {
				nodeController.savePosition("linear");
			} else if (e.listType=="institution") {
				nodeController.savePosition("eccentric");
			}
		}

		public function set _nodes(_val) {
			nodeController._nodes=_val;
		}

		public function set _nodesWidth(_val) {
			nodesWidth=_val;
			nodeController._nodesWidth=_val;
		}

		public function set _posList(_val) {
			posList=_val;
			nodeController._posList=_val;
		}

		public function set _instList(_val) {
			instList=_val;
			nodeController._instList=_val;
		}

		public function set _w(_val) {
			this.w=_val;
			nodeController._w=w;
		}

		public function set _instCont(_val) {
			menuController._instCont=_val;
		}

		public function set _posCont(_val) {
			menuController._posCont=_val;
		}

		private function mainMenuHandler(e:Event) {
			switch (e.type) {
				case "expandMainMenu" :
					speed=10;
					menuController.removeEventListener(MenuEvent.EXPAND_MAIN_MENU, mainMenuHandler);
					menuController.addEventListener(MenuEvent.COLLAPSE_MAIN_MENU, mainMenuHandler);
					menuController.addEventListener(MenuEvent.EXPAND_SUB_MENU, mainMenuHandler);
					menuController.addEventListener(MenuEvent.EXPAND_SORT_MENU, sortMenuHandler);
					removeEventListener(Event.ENTER_FRAME, collapseMainMenu);
					addEventListener(Event.ENTER_FRAME, expandMainMenu);
					break;
				case "collapseMainMenu" :
					menuController.removeEventListener(MenuEvent.COLLAPSE_MAIN_MENU, mainMenuHandler);
					menuController.removeEventListener(MenuEvent.EXPAND_SUB_MENU, mainMenuHandler);
					menuController.removeEventListener(MenuEvent.EXPAND_SORT_MENU, sortMenuHandler);
					menuController.addEventListener(MenuEvent.EXPAND_MAIN_MENU, mainMenuHandler);
					removeEventListener(Event.ENTER_FRAME, expandMainMenu);
					addEventListener(Event.ENTER_FRAME, collapseMainMenu);
					break;
				case "expandSubMenu" :
					speed=20;
					menuController.removeEventListener(MenuEvent.EXPAND_SUB_MENU, mainMenuHandler);
					menuController.addEventListener(MenuEvent.COLLAPSE_SUB_MENU, mainMenuHandler);
					removeEventListener(Event.ENTER_FRAME, collapseSubMenu);
					addEventListener(Event.ENTER_FRAME, expandSubMenu);
					if (e.id==0) {
						topTitle.text="DIRECTORS";
						bottomTitle.text="CURATORS";
					} else if (e.id == 1) {
						topTitle.text="MIGRATE TO";
						bottomTitle.text="MIGRATE FROM";
					}
					addEventListener(Event.ENTER_FRAME, expandTitleCont);
					break;
				case "collapseSubMenu" :
					nodeController.removeTrajectories();
					menuController.removeEventListener(MenuEvent.COLLAPSE_SUB_MENU, mainMenuHandler);
					menuController.addEventListener(MenuEvent.EXPAND_SUB_MENU, mainMenuHandler);
					removeEventListener(Event.ENTER_FRAME, expandSubMenu);
					addEventListener(Event.ENTER_FRAME, collapseSubMenu);
					addEventListener(Event.ENTER_FRAME, collapseTitleCont);
					break;
			}
		}

		private function sortMenuHandler(e:Event) {
			switch (e.type) {
				case "expandSortMenu" :
					menuController.removeEventListener(MenuEvent.EXPAND_SORT_MENU, sortMenuHandler);
					menuController.addEventListener(MenuEvent.COLLAPSE_SORT_MENU, sortMenuHandler);
					addEventListener(Event.ENTER_FRAME, expandSortMenu);
					trace("expand sort menu");
					break;
				case "collapseSortMenu" :
					menuController.removeEventListener(MenuEvent.COLLAPSE_SORT_MENU, sortMenuHandler);
					menuController.addEventListener(MenuEvent.EXPAND_SORT_MENU, sortMenuHandler);
					addEventListener(Event.ENTER_FRAME, collapseSortMenu);
					trace("collapse sort Menu");
					break;
			}
		}

		private function collapseTitleCont(e:Event) {
			titleCont.x= (titleCont.x < w)? titleCont.x * 1.01+ 5:w;
			if (titleCont.x==w) {
				removeEventListener(Event.ENTER_FRAME, collapseTitleCont);
			}
		}

		private function expandTitleCont(e:Event) {
			titleCont.x= (titleCont.x > titleMask.x)? titleCont.x * 0.99 - 5:titleMask.x;
			if (titleCont.x==titleMask.x) {
				removeEventListener(Event.ENTER_FRAME, expandTitleCont);
			}
		}
		private function expandSortMenu(e:Event) {
			menuController.subMenuMaskXPos = (menuController.subMenuMaskXPos < mainW -50)?menuController.subMenuMaskXPos*1.3+10:mainW-15;
			menuController.listMaskXPos = menuController.subMenuMaskXPos+mainW*2 +40
			
			if (subMenuBorder.visible) {
				subMenuBorder.x=menuController.listMaskXPos-200;
				subMenuBorder.render(nodeBorder.x-subMenuBorder.x-gutter, h-20);
			} else {
				nodeBorder.x=(subMenuBorder.visible)?nodeBorder.x:menuController.subMenuMaskXPos+mainW+15;
				nodeBorder.render(w-(menuController.subMenuMaskXPos+mainW +15 )- 30, h-20);
				nodeController.border(nodeBorder.x+15,10,nodeBorder._w-30,h-20);
				scrollLeft.x=menuController.subMenuMaskXPos+mainW-10;
			}
			if (menuController.subMenuMaskXPos==mainW-15) {
				removeEventListener(Event.ENTER_FRAME, expandSortMenu);
				//menuController.addEventListener(MenuEvent.SORT_LIST, sortList);
			}
		}

		private function collapseSortMenu(e:Event) {
			menuController.subMenuMaskXPos = (menuController.subMenuMaskXPos > menuController.mainMaskXPos - mainW+40)?menuController.subMenuMaskXPos *0.7 - 15:menuController.mainMaskXPos-mainW;
			menuController.listMaskXPos = menuController.subMenuMaskXPos+mainW*2 +40
			;
			if (subMenuBorder.visible) {
				subMenuBorder.x=menuController.listMaskXPos-200;
				subMenuBorder.render(nodeBorder.x-subMenuBorder.x-gutter, h-20);
			} else {
				nodeBorder.x=(subMenuBorder.visible)?nodeBorder.x:menuController.subMenuMaskXPos+mainW+15;
				nodeBorder.render(w-(menuController.subMenuMaskXPos +mainW+15 )- 30, h-20);
				nodeController.border(nodeBorder.x+15,10,nodeBorder._w-30,h-20);
				scrollLeft.x=menuController.subMenuMaskXPos+mainW-10;
			}
			if (menuController.subMenuMaskXPos==menuController.mainMaskXPos-mainW) {
				removeEventListener(Event.ENTER_FRAME, collapseSortMenu);
								//menuController.removeEventListener(MenuEvent.SORT_LIST, sortList);
			}
		}
		
		//private function sortList

		private function expandMainMenu(e:Event) {
			menuController.mainMaskXPos = (menuController.mainMaskXPos <gutter+column-30)?menuController.mainMaskXPos*1.2+5:(gutter+column-15);
			nodeBorder.x=menuController.mainMaskXPos+15;
			nodeBorder.render(w-(menuController.mainMaskXPos +15 )- 30, h-20);
			nodeController.border(nodeBorder.x+15,10,nodeBorder._w-30,h-20);
			menuController.filterMaskXPos=nodeBorder.x-menuController._mainW;
			scrollLeft.x=menuController.mainMaskXPos-10;
			nodeController._nodeXPos+=5;
			if (menuController.mainMaskXPos==gutter+column-15) {
				removeEventListener(Event.ENTER_FRAME, expandMainMenu);

			}
		}

		private function collapseMainMenu(e:Event) {
			menuController.mainMaskXPos = (menuController.mainMaskXPos > menuController._mainNodeSize/2+10)?menuController.mainMaskXPos *0.8 - 5: Math.floor(menuController._mainNodeSize/2);
			nodeBorder.x=menuController.mainMaskXPos+15;
			nodeBorder.render(w-(menuController.mainMaskXPos +15 )- 30, h-20);
			nodeController.border(nodeBorder.x+15,10,nodeBorder._w-30,h-20);
			menuController.filterMaskXPos=nodeBorder.x-menuController._mainW;
			scrollLeft.x=menuController.mainMaskXPos-10;
			nodeController._nodeXPos-=5;
			if (menuController.mainMaskXPos==Math.floor(menuController._mainNodeSize/2)) {
				removeEventListener(Event.ENTER_FRAME, collapseMainMenu);
			}
		}

		private function expandSubMenu(e:Event) {
			nodeBorder.x=(nodeBorder.x < (gutter*4 + column*2)-10)? nodeBorder.x+10:(gutter*4 + column*2);
			nodeBorder.render(w-nodeBorder.x- 30, h-20);
			nodeController.border(nodeBorder.x+15,10,nodeBorder._w-30,h-20);
			menuController.listMaskXPos=nodeBorder.x-gutter-15;//equal to mainW?


			if (nodeBorder.x>gutter*2+column) {
				subMenuBorder.visible=true;
				subMenuBorder.render(nodeBorder.x-subMenuBorder.x-gutter, h-20);
			}
			scrollLeft.x=nodeBorder.x-25;
			nodeController._nodeXPos+=10;
			if (nodeBorder.x == (gutter*4 + column*2)) {
				removeEventListener(Event.ENTER_FRAME, expandSubMenu);
			}
		}

		private function collapseSubMenu(e:Event) {
			nodeBorder.x=(nodeBorder.x > gutter+column+10)? nodeBorder.x - 10:(gutter+column);
			nodeBorder.render(w-nodeBorder.x- 30, h-20);
			nodeController.border(nodeBorder.x+15,10,nodeBorder._w-30,h-20);
			menuController.listMaskXPos=nodeBorder.x-gutter-15;

			if (nodeBorder.x-gutter>subMenuBorder.x) {

				subMenuBorder.render(nodeBorder.x-subMenuBorder.x-gutter, h-20);
			} else {
				subMenuBorder.visible=false;

			}
			scrollLeft.x=nodeBorder.x-25;
			nodeController._nodeXPos-=10;
			if (nodeBorder.x==gutter+column) {
				removeEventListener(Event.ENTER_FRAME, collapseSubMenu);
			}
		}

		private function overArrow(e:ScrollEvent) {
			e.target.addEventListener(ScrollEvent.OUT_ARROW, outArrow);
			e.target._arrowColor=0XDDFFF8;
			scrollDir=- e.dir;
			addEventListener(Event.ENTER_FRAME, scrollNodes);
		}

		private function outArrow(e:ScrollEvent) {
			e.target.removeEventListener(ScrollEvent.OUT_ARROW, outArrow);
			removeEventListener(Event.ENTER_FRAME, scrollNodes);
			scrollSpeed=1;
			e.target._arrowColor=0xDEE9FE;
		}

		private function scrollNodes(e:Event) {
			if (nodeController._nodeXPos+(scrollDir*scrollSpeed) <= nodeBorder.x +300 && nodeController. _nodeXPos + (scrollDir*scrollSpeed) > (nodesWidth-(w+300))) {
				nodeController._nodeXPos+=scrollDir*scrollSpeed;
			}
			if (scrollSpeed<10) {
				scrollSpeed=scrollSpeed*accel;
			}
		}
	}
}