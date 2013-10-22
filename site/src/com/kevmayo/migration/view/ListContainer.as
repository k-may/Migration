package com.kevmayo.migration.view{

	import com.kevmayo.migration.Migration;
	import com.kevmayo.migration.events.MenuEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;


	public class ListContainer extends Sprite {
		
		private var listType:String;
		private var list:Array;
		private var cont:Sprite=new Sprite();
		
		private var tIFormat:TextFormat;
		private var tIIFormat:TextFormat;
		private var sFormat:TextFormat;
		private var myFont:Font=new new ArialReg();
		/*


		private var nodes:Sprite=new Sprite  ;
		//private var contMask:Sprite = new Sprite();

		private var fieldH:int;
		private var myFont:Font=new Font(); //new ArialReg  ;

		private var titleField:TextField;

		private var trajActive:Boolean=false;
		private var fieldColor:int=0xD6C8C1;

		private var h:int;
		private var nameArray:Array ;

		private var textContainer:TextContainer;
		private var posContMaxW:int;
		private var dir:int;
		var margin_top:int=10;
		var margin_bottom:int=10;
		var gutter:int=40;
		var column:int=120;
		var nodeSize:int;
		var sR:Rectangle;
		var scrollNode:Node;
		var scrollLine:Shape;
		var scrollLength:int;
		var customColor:Array=new Array  ;

		var yPos:int;
		var targetName:String;
		var targetIndex:int;


		var sideTitle:TextField=new TextField  ;
		var side:Sprite=new Sprite  ;
*/
		public function ListContainer(_listType:String,_list:Array) {
			trace("hello from ListContainer");
			this.list=_list;
			this.listType=_listType;
			this.height = Migration.STAGE_HEIGHT- Migration.PADDING_BOTTOM - Migration.PADDING_TOP;
			//this.gutter=Migration.GUTTER_WIDTH;
			//this.column=Migration.COLUMN_WIDTH;
			//this.nodeSize=Migration.NODE_SIZE;

			init();
			createChilds();
			//createList();
		}


		public function init() {

			this.name="listContainer";
		}
		
		private function createChilds(){
			tIFormat=new TextFormat(myFont.fontName,11,0X7E7F81);
			tIFormat.align="left";
			
			tIIFormat=new TextFormat(myFont.fontName,11,0XB2B2B2);
			tIIFormat.align="left";

			var sideTitle:TextField=new TextField();
			
			addChild(cont);
			cont.name="cont";
			cont.x= Migration.GUTTER_WIDTH;
			//cont.addEventListener(MouseEvent.MOUSE_OVER,overField);
			cont.graphics.beginFill(0,0);
			//cont.graphics.drawRect(0,0, Migration.COLUMN_WIDTH, cont.height);
			cont.buttonMode = true;
			cont.mouseChildren = false;
			
			/*
			scrollLine=new Shape();
			var myDashedDrawing:DashedLine=new DashedLine(scrollLine.graphics,1,2);
			myDashedDrawing.lineStyle(1,0,0.3);
			myDashedDrawing.moveTo(gutter+column+gutter/2,gutter/2);
			myDashedDrawing.lineTo(gutter+column+gutter/2,h-gutter/2);
			addChild(scrollLine);
			
			scrollNode=new Node(15,0xC9DD9E,0xCAFDAD,0,2,false);
			scrollNode.addEventListener(MouseEvent.MOUSE_DOWN,dragNode);
			scrollNode.addEventListener(MouseEvent.MOUSE_OVER,overNode);
			addChild(scrollNode);
			scrollNode.x=gutter+column+gutter/2-8;
			scrollNode.y=gutter/2;
			scrollNode.buttonMode=true;
			sR=new Rectangle(0,0,0,h-gutter);
			sR.x=scrollNode.x;
			sR.y=gutter/2;
			scrollLength=h-gutter;
			*/
			
			
			sFormat=new TextFormat(myFont.fontName,11,0);
			
			//addChild(side);
			sideTitle.embedFonts=true;
			sideTitle.text="Click name to save position / Close window to clear positions";
			sideTitle.defaultTextFormat=sFormat;
			sideTitle.setTextFormat(sFormat);
			sideTitle.selectable=false;
			sideTitle.autoSize="left";
			sideTitle.x=15;
			sideTitle.y=height-5;
			sideTitle.rotation=-90;
			//side.addChild(sideTitle);

		}
/*
		
		public function sortList(type:String,dir:uint=2) {
			list.sortOn(type);
			trace("sort list: " + type);
			nameArray = new Array();
			for (var i:int=0; i<list.length; i++) {
				nameArray[i]=list[i].name;
				//trace(" nameArray: " + nameArray[i] + "index = " + list[i].nodeIndex  + "lat = " + list[i].latitude);
			}
			trace("cont children = " + cont.numChildren);
			cont.graphics.clear();
			for(var i:int =cont.numChildren; i > 0; i--){ //everything but nodes!
				cont.removeChild(cont.getChildAt(i-1));
			}
			cont.addChild(nodes);
			clearNodes();
			trace("cont children = " + cont.numChildren);
			yPos =0;
			createList();
		}
		public function added() {
			trace("added");
			addEventListener(Event.ENTER_FRAME,clearSideTitle);
		}

		private function clearSideTitle(e:Event) {
			side.alpha*=0.9999;
			//trace("sideTitle.alpha= '"+side.alpha);
			if (side.alpha<0.1) {
				side.alpha=0;
				removeEventListener(Event.ENTER_FRAME,clearSideTitle);
			}
		}

		private function overNode(e:MouseEvent) {
			//trace("overNode " + cont.y);
			scrollNode.removeEventListener(MouseEvent.MOUSE_OVER,overNode);
			scrollNode.addEventListener(MouseEvent.MOUSE_OUT,outNode);
			scrollNode.hover(true);
		}
		private function outNode(e:MouseEvent) {
			scrollNode.removeEventListener(MouseEvent.MOUSE_OUT,outNode);
			scrollNode.addEventListener(MouseEvent.MOUSE_OVER,overNode);
			scrollNode.hover(false);
		}

		private function dragNode(e:MouseEvent) {
			scrollNode._mouseDown(true);
			scrollNode.removeEventListener(MouseEvent.MOUSE_DOWN,dragNode);
			scrollNode.startDrag(false,sR);
			this.stage.addEventListener(MouseEvent.MOUSE_UP,releaseNode);
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE,moveNode);
		}

		private function releaseNode(e:MouseEvent) {
			scrollNode.stopDrag();
			scrollNode._mouseDown(false);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP,releaseNode);
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,moveNode);
			scrollNode.addEventListener(MouseEvent.MOUSE_DOWN,dragNode);
		}

		private function moveNode(e:MouseEvent) {
			scrollNode.hover(true);
			//trace("scrollnode" + cont.y);
			if (mouseY>gutter/2&&mouseY<h-gutter/2) {
				cont.y=- Math.floor(ratio()*cont.height);
			}
		}

		public function ratio():Number {
			var ratio:Number=(scrollNode.y-(gutter*0.5))/scrollLength;
			return ratio;
		}

		private function createList() {
			var listLength=list.length;

			for (var i=0; i<listLength; i++) {
				titleField=new TextField  ;
				titleField.name=i;
				titleField.autoSize="left";
				titleField.multiline=true;
				titleField.wordWrap=true;
				titleField.width=column;
				titleField.embedFonts=true;
				titleField.text=list[i].name;
				titleField.selectable=false;
				if (listType=="institution") {
					//trace("create List: " + list[i].index);
				}
				if (i%2==0) {
					titleField.defaultTextFormat=tIFormat;
					titleField.setTextFormat(tIFormat);

				} else {
					titleField.defaultTextFormat=tIIFormat;
					titleField.setTextFormat(tIIFormat);
				}

				customColor[i]=Math.random()*0xffffff;

				cont.addChild(titleField);
				titleField.y=yPos;
				yPos=titleField.y+titleField.height;

				var myDashedDrawing:DashedLine=new DashedLine(cont.graphics,3,2);
				myDashedDrawing.lineStyle(1,0,0.3);
				myDashedDrawing.moveTo(0,titleField.y+titleField.height);
				myDashedDrawing.lineTo(column,titleField.y+titleField.height);
			}
			//fieldH=titleField.height;
		}

		private function fieldBackground(_cont:Sprite) {
			_cont.graphics.beginFill(fieldColor,0.1);
			_cont.graphics.drawRect(0,0,posContMaxW,_cont.height);
			_cont.graphics.endFill();

		}

		private function overField(e:MouseEvent) {
			if (e.target.name!="node") {
				e.target.addEventListener(MouseEvent.MOUSE_OUT,outField);
				e.target.addEventListener(MouseEvent.CLICK,clickField);
				//fName=e.target.text;
				e.target.background=true;
				e.target.backgroundColor=0xE4EECF;
				e.target.defaultTextFormat=sFormat;
				e.target.setTextFormat(sFormat);
				//this.targetName=e.target.name;
				targetIndex=nameArray.indexOf(e.target.text);
				//trace("list index = " + list[targetIndex].nodeIndex);
				trace("targetIndex = " + targetIndex + " e.target.text = '" + e.target.text);
				e.currentTarget.dispatchEvent(new MenuEvent(MenuEvent.OVER_NAME,targetIndex,true,listType));
			}
		}

		private function clickField(e:MouseEvent) {
			
			var node:Node=new Node(7,customColor[targetIndex],0,0x000fff,2,false);
			nodes.addChild(node);
			node.x=- gutter/2;
			node.y=e.target.y+e.target.height/2-3;
			trace("click field" + nodes.stage);
			//targetIndex=nameArray.indexOf(e.target.text);
			e.currentTarget.dispatchEvent(new MenuEvent(MenuEvent.CLICK_NAME,targetIndex,true,listType));
		}

		public function clearNodes() {
			for (var i:int=nodes.numChildren; i>0; i--) {
				nodes.removeChild(nodes.getChildAt(i-1));
			}
		}

		public function getColor(_i):uint {
			return customColor[_i];
		}

		public function getName(_i):String {//both pos and inst
			return list[_i].name;
		}

		public function getIndexArray(_i):Array {
			return list[_i].indexArray;
		}

		public function getIndex(_val):int {
			//trace("get index" +_val  + "  : " + list[_val]);
			return list[_val].nodeIndex;
		}

		public function getDir():Array {
			//wtf?
			return list;//return list[_i].dir;
		}

		private function outField(e:MouseEvent) {
			e.currentTarget.dispatchEvent(new MenuEvent(MenuEvent.OUT_NAME,targetIndex,true,listType));
			e.target.removeEventListener(MouseEvent.MOUSE_OUT,outField);
			e.target.background=false;
			if (cont.getChildIndex(e.target as DisplayObject)%2==1) {
				e.target.defaultTextFormat=tIFormat;
				e.target.setTextFormat(tIFormat);
			} else {
				e.target.defaultTextFormat=tIIFormat;
				e.target.setTextFormat(tIIFormat);
			}
			e.target.backgroundColor=0Xffffff;
		}
		*/
	}
}