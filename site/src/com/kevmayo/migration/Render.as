package com.kevmayo.migration{

	import flash.events.*;
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import flash.display.*;
	import flash.text.*;

	public class Render extends Sprite {

		public var nodeCreator:NodeCreator;
		private var nodeData:InstReader;
		
		private var instList:Array = new Array();
		private var latList:Array = new Array();
		private var nodes:Sprite = new Sprite();
		private var positionContainer:ListContainer;
		private var instContainer:ListContainer;
		private var posData:PosReader;
		
		private var posList:Array = new Array();
		
		private var nodeWidth:int;
		private var nodeNum:int;
		//private var field:String;
		private var sH:Number;
		
		//padding
		private var marginWidth,marginHeight:Number=20;
		private var margin_top:int=10;
		private var margin_bottom:int=10;
		private var gutter:int=40;
		private var column:int=120;
		
		private var g:Graphics;
		
		private var spacing:int;
		
		private var debugText:TextField = new TextField();

		public function Render(_sH:int, _spacing:int,_mTop:int, _mBot:int, _gutter:int, _column:int) {
			this.spacing=_spacing;
			this.margin_top=_mTop;
			this.margin_bottom=_mBot;
			this.gutter=_gutter;
			this.column=_column;
			this.sH=_sH;

		}

		public function init() {
			nodeData=new InstReader("instList.xml");
			nodeData.addEventListener("INST_DATA_READ",instDataLoaded);
		}

		private function instDataLoaded(e:Event) {
			nodeData.removeEventListener("INST_DATA_READ",instDataLoaded);
			instList=nodeData.getListArray();
latList=nodeData.getLatArray();
			posData=new PosReader("posList.xml");
			posData.addEventListener("POS_DATA_READ",posDataLoaded);
		}

		private function posDataLoaded(e:Event) {
			posData.removeEventListener("POS_DATA_READ",posDataLoaded);
			posList=posData.getListArray();


			for (var i:int = 0; i < posList.length; i ++) {//create index array by cross ref. position lats with lat array
				for (var j:int = 0; j < posList[i].latArray.length; j ++) {
					posList[i].indexArray[j]=latList.indexOf(Number(posList[i].latArray[j].latitude));
				}
			}

			positionContainer =new ListContainer("position",posList,sH-margin_top-margin_bottom,5,gutter,column);

			for (var l:int = 0; l < posList.length; l ++) {
				var listLength = posList[l].latArray.length //iterate through every position held
					for (var p:int = 0; p < listLength; p ++) {
					if ( listLength>1) {//only lists of two or more
						for (var j:int = 0; j < latList.length; j ++) {
							if (latList[j]==posList[l].latArray[p].latitude) {
								if ((listLength-1)-p>0) {//if match is not last, match movedFrom
									instList[j].movedFrom.push(latList.indexOf(Number(posList[l].latArray[p+1].latitude)));
								}
								if (p>0) {//if match is not first, match movedTo
									instList[j].movedTo.push(latList.indexOf(Number(posList[l].latArray[p-1].latitude)));
								}

							}
						}
					}
				}
			}
			
			instContainer=new ListContainer("institution",instList,sH-margin_top-margin_bottom,5,gutter,column);
			nodeNum=nodeData.nodeNum;
			nodeCreator=new NodeCreator(nodeNum,instList,spacing);
			nodeCreator.addEventListener("NODES_CREATED", nodesCreated);
			nodeCreator.createNodes();
		}

		function nodesCreated(e:Event) {
			nodeCreator.removeEventListener("NODES_CREATED", nodesCreated);//switch to nodes??
			nodes=nodeCreator._nodeContainer;
			dispatchEvent(new Event("NODES_COMPLETE"));
		}

		public function getPosListArray():Array {
			return posList;
		}

		public function getInstListArray():Array {
			return instList;
		}

		public function get _nodes():Sprite {
			return nodes;
		}
		public function get _posContainer():Sprite {
			return positionContainer;
		}
		public function get _instContainer():Sprite {
			return instContainer;
		}

		public function get _nodesWidth():int {
			return nodeCreator._width;

		}
	}
}