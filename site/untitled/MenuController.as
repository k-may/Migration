package untitled{

	import flash.events.*;
	import flash.display.*;
	import flash.text.*;

	public class MenuController extends Sprite {

		private var posList:Array = new Array();

		private var mainMenu:Sprite = new Sprite();
		private var filterMenu:Sprite = new Sprite();

		private var mainMask:Shape = new Shape();

		private var filterMask:Shape = new Shape();

		private var listMask:Shape = new Shape();

		private var mainNode:Node;
		private var helpNode:Node;

		private var positionsNode:Node;
		private var institutionsNode:Node;

		private var instCont:Sprite = new Sprite();
		private var posCont:Sprite= new Sprite();

		private var subMenuCont:Sprite = new Sprite();
		private var subMenuMask:Shape = new Shape();
		private var sortMenu:Sprite = new Sprite();
		private var sortMask:Shape = new Shape();
		private var sortNode:Node;

		var sub_filterCont:Sprite = new Sprite();

		var mainW:int=175;
		var subW:int=215;
		var gutter:int=40;
		var column:int=135;
		var nodeMargin:int=5;

		var mainNodeSize:int;
				var subNodeSize:int = 15

		var h:int;

		private var listMenu:Sprite = new Sprite();
		private var listMenuCont:Sprite = new Sprite();

		private var myFont:Font = new ArialReg();
		//var myPosFont:Font = new Font2();

		private var tFormat:TextFormat;
		private var sFormat:TextFormat;
		var titleField:TextField = new TextField();
		var posField:TextField = new TextField();
		var instField:TextField = new TextField();
		var helpField:TextField = new TextField();
		var sortField:TextField = new TextField();

		var sort_nameTitle:TextField = new TextField();

		var sort_dateTitle:TextField = new TextField();

		var sort_freqTitle:TextField = new TextField();

		public function MenuController(_h:int, _mainNodeSize:int) {
			this.h=_h;
			this.mainNodeSize=_mainNodeSize;
			init();
		}

		private function init() {
			tFormat=new TextFormat(myFont.fontName,16,0X7E7F81);
			sFormat=new TextFormat(myFont.fontName,16,0);

			subMenuCont.graphics.drawRect(0,0,mainW,150);
			addChild(subMenuCont);
			subMenuCont.x=mainW-25;

			//sortMenu.graphics.lineStyle(1,0X000fff);
			sortMenu.graphics.drawRect(0,0,mainW,150);
			addChild(sortMenu);
			sortMenu.x=mainW*2;
			sortMenu.y=mainNodeSize+nodeMargin;
			sortMask.graphics.lineStyle(1,0X000fff);
			sortMask.graphics.beginFill(0,0);
			sortMask.graphics.drawRect(0,0,mainW+25,150);
			addChild(sortMask);
			sortMask.x=mainW-25;
			sortMenu.mask=sortMask;

			subMenuMask.graphics.lineStyle(1,0X000fff);
			subMenuMask.graphics.beginFill(0X000fff,0.2);
			subMenuMask.graphics.drawRect(-17,-3,mainW+17,150);
			addChild(subMenuMask);

			subMenuCont.mask=subMenuMask;
			filterMenu.graphics.drawRect(0,0,mainW,200);
			addChild(filterMenu);
			filterMenu.y=mainNodeSize/2;
			filterMenu.x=mainW;

			sortNode=new Node(mainNodeSize,0XFDDFF4,0xCAFDAD,0,1,false);
			subMenuCont.addChild(sortNode);
			sortNode.buttonMode=true;
			sortNode.addEventListener(MouseEvent.ROLL_OVER, sortNodeHandler);
			sortNode.addEventListener(MouseEvent.CLICK,  sortNodeHandler);

			createTitle(sortField, "Sort");
			subMenuCont.addChild(sortField);
			sortField.x=gutter;
			sortField.y = sortNode.y +2;

			sort_nameNode=new Node(mainNodeSize,0XFDDFF4,0xCAFDAD,0X7E7F81,1,true);
			sort_nameNode.name="name";
			sort_nameNode.addEventListener(MouseEvent.MOUSE_OVER, sortHandler);
			sortMenu.addChild(sort_nameNode);
			sort_nameNode.buttonMode=true;

			sort_dateNode=new Node(mainNodeSize,0XFDDFF4,0xCAFDAD,0X7E7F81,1,false);
			sort_dateNode.name="startDate";
			sort_dateNode.addEventListener(MouseEvent.MOUSE_OVER, sortHandler);
			sort_dateNode.addEventListener(MouseEvent.CLICK, sortHandler);
			sortMenu.addChild(sort_dateNode);
			sort_dateNode.y=sort_nameNode.y+mainNodeSize+nodeMargin;
			sort_dateNode.buttonMode=true;
			
			sort_freqNode=new Node(mainNodeSize,0XFDDFF4,0xCAFDAD,0X7E7F81,1,false);
			sort_freqNode.name="frequency";
			sort_freqNode.addEventListener(MouseEvent.MOUSE_OVER, sortHandler);
			sort_freqNode.addEventListener(MouseEvent.CLICK, sortHandler);
			sortMenu.addChild(sort_freqNode);
			sort_freqNode.y=sort_dateNode.y+mainNodeSize+nodeMargin;
			sort_freqNode.buttonMode=true;
			
			
			createTitle(sort_nameTitle, "by Name");
			sortMenu.addChild(sort_nameTitle);
			sort_nameTitle.x=gutter;
			sort_nameTitle.y=sort_nameNode.y+2;
			createTitle(sort_dateTitle, "by Date");
			sortMenu.addChild(sort_dateTitle);
			sort_dateTitle.x=gutter;
			sort_dateTitle.y=sort_dateNode.y+2;
			createTitle(sort_freqTitle, "by Frequency");
			sortMenu.addChild(sort_freqTitle);
			sort_freqTitle.x=gutter;
			sort_freqTitle.y=sort_freqNode.y+2;

			addChild(mainMenu);

			createTitle(titleField, "Filter");
			mainMenu.addChild(titleField);
			titleField.x=gutter;
			titleField.y=2;

			mainMask.graphics.lineStyle(1,0X00ff00);
			mainMask.graphics.beginFill(0,0);
			mainMask.graphics.drawRect(0,-3,-(mainW+15),h+6);
			addChild(mainMask);
			mainMenu.mask=mainMask;

			positionsNode=new Node(mainNodeSize,0xE68A8A,0X829C74,0,1,false);
			filterMenu.addChild(positionsNode);
			positionsNode.y=mainNodeSize/2+nodeMargin;
			positionsNode.x=2;
			positionsNode.buttonMode=true;

			institutionsNode=new Node(mainNodeSize,0xE68A8A,0X829C74,0,1,false);
			filterMenu.addChild(institutionsNode);
			institutionsNode.y=positionsNode.y+mainNodeSize+nodeMargin;
			institutionsNode.x=2;
			institutionsNode.buttonMode=true;

			createTitle(posField, "by Title");
			filterMenu.addChild(posField);
			posField.x=gutter;
			posField.y=positionsNode.y+2;

			createTitle(instField, "by Institution");
			filterMenu.addChild(instField);
			instField.x=gutter;
			instField.y=institutionsNode.y+2;

			filterMenu.addEventListener(MouseEvent.MOUSE_OVER, subNodeHandler);
			filterMenu.addEventListener(MouseEvent.CLICK, subNodeHandler);
			filterMask.graphics.lineStyle(1,0Xff0000);
			filterMask.graphics.beginFill(0,0);
			filterMask.graphics.drawRect(0,0,mainW-15,h);
			addChild(filterMask);
			filterMask.x=- mainW;
			filterMenu.mask=filterMask;

			addChild(listMenu);
			listMenu.x=mainW;

			listMask.graphics.lineStyle(1,0Xff0000);
			listMask.graphics.beginFill(0,0);
			listMask.graphics.drawRect(15,0,-subW,h);
			addChild(listMask);
			listMask.x=mainW;
			listMenu.mask=listMask;

			mainNode=new Node(mainNodeSize,0xE68A8A,0X829C74,0,1,false);
			mainMenu.addChild(mainNode);
			mainNode.buttonMode=true;
			mainNode.x=2;

			mainNode.addEventListener(MouseEvent.ROLL_OVER, mainNodeHandler);
			mainNode.addEventListener(MouseEvent.CLICK, mainNodeHandler);

			helpNode=new Node(mainNodeSize,0XB1A38A,0x6E79BE,0,1,false);
			mainMenu.addChild(helpNode);
			helpNode.buttonMode=true;
			helpNode.y=h-mainNodeSize;
			helpNode.x=2;
			helpNode.visible=false;

			helpNode.addEventListener(MouseEvent.ROLL_OVER, helpNodeHandler);
			helpNode.addEventListener(MouseEvent.CLICK, helpNodeHandler);

			createTitle(helpField, "Help");

			helpField.x=gutter;
			helpField.y=helpNode.y+2;

			//mainMenu.addChild(helpField);

			addChild(listMenu);
		}

		private function createTitle(_textF:TextField, _text:String) {
			_textF.text=_text;
			_textF.embedFonts=true;
			_textF.defaultTextFormat=tFormat;
			_textF.setTextFormat(tFormat);
			_textF.selectable=false;
			_textF.autoSize="left";
		}

		private function sortHandler(e:Event) {

			switch (e.type) {
				case "mouseOver" :
					e.target.removeEventListener(MouseEvent.MOUSE_OVER, sortHandler);
					e.target.addEventListener(MouseEvent.MOUSE_OUT, sortHandler);
					e.target.hover(true);
					break;
				case "mouseOut" :
					//trace("mouseOut");
					e.target.removeEventListener(MouseEvent.MOUSE_OUT, sortHandler);
					e.target.addEventListener(MouseEvent.MOUSE_OVER, sortHandler);
					e.target.hover(false);
					break;
				case "click" :
					e.target.removeEventListener(MouseEvent.CLICK, sortHandler);
					trace("click");
					
					for(var i:int =0; i < 3; i ++){
						if(sortMenu.getChildAt(i).lineVisible){
							trace("sortMenu.getChildAt(i) = " + sortMenu.getChildAt(i));
							sortMenu.getChildAt(i)._mouseDown(false);
							sortMenu.getChildAt(i).addEventListener(MouseEvent.CLICK, sortHandler);
	//						sortMenu.getChildAt(i).render;
						}
					}
							
						e.target._mouseDown(true);
					//dispatchEvent(new MenuEvent.SORT_LIST, -1, true, e.target.name);
					
						posCont.sortList(e.target.name);
						instCont.sortList(e.target.name);
					

			}
		}


		private function subNodeHandler(e:MouseEvent) {
			switch (e.type) {
				case "mouseOver" :
					e.target.removeEventListener(MouseEvent.MOUSE_OVER, subNodeHandler);
					e.target.addEventListener(MouseEvent.MOUSE_OUT, subNodeHandler);
					if (e.target.name=="node") {
						e.target.hover(true);
					}
					break;
				case "mouseOut" :
					e.target.removeEventListener(MouseEvent.MOUSE_OUT, subNodeHandler);
					e.target.addEventListener(MouseEvent.MOUSE_OVER, subNodeHandler);
					if (e.target.name=="node") {
						e.target.hover(false);
					}
					break;
				case "click" :
					if (listMenu.numChildren==0) {
						if (! e.target.parent.getChildAt(0).lineVisible&&! e.target.parent.getChildAt(1).lineVisible) {
							dispatchEvent(new MenuEvent(MenuEvent.EXPAND_SUB_MENU, e.target.parent.getChildIndex(e.target)));

							if (e.target.parent.getChildIndex(e.target)==0) {
								listMenuCont=posCont;



							} else if (e.target.parent.getChildIndex(e.target) ==1) {
								listMenuCont=instCont;
							}
							listMenu.addChild(listMenuCont);
							listMenuCont.added();
							listMenuCont.sortList("name");
							filterMenu.removeEventListener(MouseEvent.MOUSE_OVER, subNodeHandler);
							e.target.lineVisible=true;
							e.target.buttonMode=true;
							e.target.parent.getChildAt(e.target.parent.getChildIndex(e.target) +2);
							e.target.parent.getChildAt(e.target.parent.getChildIndex(e.target)+2).defaultTextFormat=sFormat;
							e.target.parent.getChildAt(e.target.parent.getChildIndex(e.target)+2).setTextFormat(sFormat);
							helpNode.removeEventListener(MouseEvent.CLICK, helpNodeHandler);
							mainNode.removeEventListener(MouseEvent.CLICK, mainNodeHandler);
						}
					} else {
						if (e.target.lineVisible) {
							dispatchEvent(new MenuEvent(MenuEvent.COLLAPSE_SUB_MENU, e.target.parent.getChildIndex(e.target)));
							posCont.clearNodes();
							instCont.clearNodes();
							listMenu.removeChild(listMenu.getChildAt(0));
							filterMenu.addEventListener(MouseEvent.MOUSE_OVER, subNodeHandler);
							e.target.parent.getChildAt(e.target.parent.getChildIndex(e.target)+2).defaultTextFormat=tFormat;
							e.target.parent.getChildAt(e.target.parent.getChildIndex(e.target)+2).setTextFormat(tFormat);
							helpNode.addEventListener(MouseEvent.CLICK, helpNodeHandler);
							mainNode.addEventListener(MouseEvent.CLICK, mainNodeHandler);
							e.target.lineVisible=false;
							if (sortNode.lineVisible) {
								sortNode.buttonMode=true;
								sortNode.lineVisible=false;
								sortNode.render();
								sortField.defaultTextFormat=tFormat;
								sortField.setTextFormat(tFormat);
								addEventListener(Event.ENTER_FRAME, sortMenuHandler);
								sortNode.addEventListener(MouseEvent.ROLL_OVER, sortNodeHandler);
								sortNode.hover(false);
								dispatchEvent(new MenuEvent(MenuEvent.COLLAPSE_SORT_MENU));
							}
						}
					}
					break;
			}
		}

		private function helpNodeHandler(e:Event) {
			switch (e.type) {
				case "rollOver" :
					helpNode.removeEventListener(MouseEvent.ROLL_OVER, helpNodeHandler);
					helpNode.addEventListener(MouseEvent.ROLL_OUT, helpNodeHandler);
					helpNode.hover(true);
					dispatchEvent(new MenuEvent(MenuEvent.EXPAND_MAIN_MENU));
					break;
				case "rollOut" :
					helpNode.removeEventListener(MouseEvent.ROLL_OUT, helpNodeHandler);
					helpNode.addEventListener(MouseEvent.ROLL_OVER, helpNodeHandler);
					helpNode.hover(false);
					dispatchEvent(new MenuEvent(MenuEvent.COLLAPSE_MAIN_MENU));
					break;
				case "click" :
					if (! helpNode.lineVisible) {
						helpNode.removeEventListener(MouseEvent.ROLL_OUT, helpNodeHandler);
						helpNode.buttonMode=true;
						helpNode.lineVisible=true;
						helpNode.render();
						helpField.defaultTextFormat=sFormat;
						helpField.setTextFormat(sFormat);
						mainNode.removeEventListener(MouseEvent.ROLL_OVER, mainNodeHandler);
					} else {
						if (! mainNode.lineVisible) {
							helpNode.addEventListener(MouseEvent.ROLL_OUT, helpNodeHandler);
							mainNode.addEventListener(MouseEvent.ROLL_OVER, mainNodeHandler);
						}
						helpNode.buttonMode=true;
						helpNode.lineVisible=false;
						helpNode.render();
						helpField.defaultTextFormat=tFormat;
						helpField.setTextFormat(tFormat);
					}
					break;
				case "animationComplete" :
					helpNode.addEventListener(MouseEvent.ROLL_OVER, helpNodeHandler);
					helpNode.hover(false);
					break;
			}
		}

		private function sortNodeHandler(e:Event) {
			switch (e.type) {
				case "rollOver" :
					e.target.removeEventListener(MouseEvent.ROLL_OVER, sortNodeHandler);
					e.target.addEventListener(MouseEvent.ROLL_OUT, sortNodeHandler);
					e.target.hover(true);
					if (e.target==sortNode) {
						dispatchEvent(new MenuEvent(MenuEvent.EXPAND_SORT_MENU));
					}
					break;
				case "rollOut" :
					e.target.removeEventListener(MouseEvent.ROLL_OUT, sortNodeHandler);
					e.target.addEventListener(MouseEvent.ROLL_OVER, sortNodeHandler);
					e.target.hover(false);
					trace("dispatch collapse");
					if (e.target==sortNode) {
						dispatchEvent(new MenuEvent(MenuEvent.COLLAPSE_SORT_MENU));
					}
					break;
				case "click" :
					if (! sortNode.lineVisible) {
						sortNode.removeEventListener(MouseEvent.CLICK, sortNodeHandler);
						sortNode.removeEventListener(MouseEvent.ROLL_OUT, sortNodeHandler);
						sortNode.removeEventListener(MouseEvent.ROLL_OVER, sortNodeHandler);
						sortNode.buttonMode=true;
						sortNode.lineVisible=true;
						sortNode.render();
						sortField.defaultTextFormat=sFormat;
						sortField.setTextFormat(sFormat);
						helpNode.removeEventListener(MouseEvent.ROLL_OVER, helpNodeHandler);
						addEventListener(Event.ENTER_FRAME, sortMenuHandler);
						filterMenu.removeEventListener(MouseEvent.MOUSE_OVER, subNodeHandler);
						filterMenu.removeEventListener(MouseEvent.CLICK, subNodeHandler);
					} else {
						sortNode.buttonMode=true;
						sortNode.lineVisible=false;
						sortNode.render();
						sortField.defaultTextFormat=tFormat;
						sortField.setTextFormat(tFormat);
						addEventListener(Event.ENTER_FRAME, sortMenuHandler);
						sortNode.addEventListener(MouseEvent.ROLL_OUT, sortNodeHandler);
						filterMenu.addEventListener(MouseEvent.MOUSE_OVER, subNodeHandler);
						filterMenu.addEventListener(MouseEvent.CLICK, subNodeHandler);
					}
					break;
			}
		}

		private function mainNodeHandler(e:Event) {
			switch (e.type) {
				case "rollOver" :
					mainNode.removeEventListener(MouseEvent.ROLL_OVER, mainNodeHandler);
					mainNode.addEventListener(MouseEvent.ROLL_OUT, mainNodeHandler);
					mainNode.hover(true);
					dispatchEvent(new MenuEvent(MenuEvent.EXPAND_MAIN_MENU));
					break;
				case "rollOut" :
					mainNode.removeEventListener(MouseEvent.ROLL_OUT, mainNodeHandler);
					mainNode.addEventListener(MouseEvent.ROLL_OVER, mainNodeHandler);
					mainNode.hover(false);
					dispatchEvent(new MenuEvent(MenuEvent.COLLAPSE_MAIN_MENU));
					break;
				case "click" :
					if (! mainNode.lineVisible) {
						mainNode.removeEventListener(MouseEvent.CLICK, mainNodeHandler);
						mainNode.removeEventListener(MouseEvent.ROLL_OUT, mainNodeHandler);
						mainNode.buttonMode=true;
						mainNode.lineVisible=true;
						mainNode.render();
						titleField.defaultTextFormat=sFormat;
						titleField.setTextFormat(sFormat);
						helpNode.removeEventListener(MouseEvent.ROLL_OVER, helpNodeHandler);
						addEventListener(Event.ENTER_FRAME, subMainMenuHandler);
					} else {
						if (! helpNode.lineVisible) {
							mainNode.addEventListener(MouseEvent.ROLL_OUT, mainNodeHandler);
							helpNode.addEventListener(MouseEvent.ROLL_OVER, helpNodeHandler);
						}
						mainNode.buttonMode=true;
						mainNode.lineVisible=false;
						mainNode.render();
						titleField.defaultTextFormat=tFormat;
						titleField.setTextFormat(tFormat);
						addEventListener(Event.ENTER_FRAME, subMainMenuHandler);
					}
					break;
				case "animationComplete" :
					mainNode.addEventListener(MouseEvent.ROLL_OVER, mainNodeHandler);
					mainNode.hover(false);
					break;
			}
		}

		public function set _instCont(_val) {
			instCont=_val;
		}

		public function set _posCont(_val) {
			posCont=_val;
		}

		public function getName(target):String {
			return target.getName();
		}

		private function sortMenuHandler(e:Event) {
			if (sortNode.lineVisible) {
				sortMenu.x = (sortMenu.x > sortMask.x+15)?sortMenu.x - 15:sortMask.x;
				if (sortMenu.x==sortMask.x) {
					removeEventListener(Event.ENTER_FRAME, sortMenuHandler);
					sortNode.addEventListener(MouseEvent.CLICK, sortNodeHandler);
				}
			} else {
				sortMenu.x = (sortMenu.x < mainW*2)?sortMenu.x + 15:mainW*2;
				if (sortMenu.x==mainW*2) {
					removeEventListener(Event.ENTER_FRAME, sortMenuHandler);
				}
			}
		}

		public function subMainMenuHandler(e:Event) {
			if (mainNode.lineVisible) {
				filterMenu.x = (filterMenu.x > 10)?filterMenu.x -10:0;
				if (filterMenu.x==0) {
					removeEventListener(Event.ENTER_FRAME, subMainMenuHandler);
					mainNode.addEventListener(MouseEvent.CLICK, mainNodeHandler);
				}
			} else {
				filterMenu.x = (filterMenu.x < mainW)?filterMenu.x +10:mainW;

				if (filterMenu.x==mainW) {
					removeEventListener(Event.ENTER_FRAME, subMainMenuHandler);
					mainNode.addEventListener(MouseEvent.CLICK, mainNodeHandler);
				}
			}
		}

		public function set filterMaskXPos(_val) {
			filterMask.x=_val;
		}
		public function set listMaskXPos(_val) {
			listMask.x=_val;
		}
		public function get listMaskXPos():int {
			return listMask.x;
			//subMenuCont.x=listMask.x+subW-12;
		}
		public function set mainMaskXPos(_val) {
			mainMask.x=_val;
			subMenuMask.x=mainMask.x-mainW;
		}
		public function get mainMaskXPos():int {
			return mainMask.x;
		}

		public function set subMenuMaskXPos(_val) {
			subMenuMask.x=_val;
		}
		public function get subMenuMaskXPos():int {
			return subMenuMask.x;
		}
		public function aniComplete() {
			dispatchEvent(new Event("animationComplete"));
		}

		public function set listMenuWidth(_val) {
			listMenuMask.x=_val;
		}
		public function set listMenuXPos(_val) {
			listMenu.x=_val;
			listMask.x=_val+200;
		}
		public function get listMenuXPos():int {
			return listMenu.x;
		}
		public function get _mainW():int {
			return mainW;
		}

		public function get _mainNodeSize():int {
			return mainNodeSize;
		}

		public function set _posList(_val) {
			positionMenu._poslist=_val;
		}
	}
}