package SWFLoader{

	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.text.*;

	public class SWFLoader extends Sprite {

		private var nodeArray:Array = new Array();
		private var ratio:int;
		private var myTimer:Timer;
		private var pDO:DisplayObject;
		private var num:int=0;
		private var container:Sprite = new Sprite();
		private var nodeSize=10;
		var topTitle:TextField = new TextField();
		private var myFont:Font = new ArialReg();

		public function SWFLoader() {
			myTimer=new Timer(400,5);
			myTimer.addEventListener(TimerEvent.TIMER, timerHandler);
			myTimer.addEventListener(TimerEvent.TIMER_COMPLETE, completeHandler);
						addChild(container);
						container.graphics.beginFill(0xffffff);
			container.graphics.drawRect(0,0,stage.stageWidth, stage.stageHeight);
			//addChild(bG);
					
			var tFormat:TextFormat=new TextFormat(myFont.fontName,18,0X7E7F81);
			
			topTitle.embedFonts=true;
			topTitle.defaultTextFormat=tFormat;
			topTitle.setTextFormat(tFormat);
			topTitle.selectable=false;
			topTitle.autoSize="left";
			topTitle.text = "Loading";
			topTitle.x=stage.stageWidth/2 - topTitle.width/2;
			topTitle.y=stage.stageHeight/2 + 40;
			container.addChild(topTitle);
			trace("topTitle = " + topTitle.stage)
			
			createNodes();
			myTimer.start();
			
		}

		private function createNodes() {
			for (var i = 0; i < 5; i ++) {
				var node=new Node(nodeSize,0xffffff,0x7E7F81);
				nodeArray[i]=node;
				container.addChild(nodeArray[i]);
				nodeArray[i].x = stage.stageWidth/2- (5*nodeSize)/2 + i*nodeSize;
				nodeArray[i].y=305;
			}
		}

		private function startLoad() {
			var mLoader:Loader = new Loader();
			var mRequest:URLRequest=new URLRequest("untitled.swf");
			mLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler);
			mLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			mLoader.load(mRequest);
		}

		private function timerHandler(e:TimerEvent):void {
			if(num == 0){
				startLoad();
			}
			nodeArray[num].fillNode("over");
			num++;
		}
		private function completeHandler(e:TimerEvent):void {
			trace("stop timer");
			removeChild(container);
			//addEventListener(Event.ENTER_FRAME, fadeOut);
			
			
		}
		
		private function fadeOut(e:Event){
			container.alpha *= 0.9;
			if(container.alpha  < 0.1){
				removeChild(container);
				removeEventListener(Event.ENTER_FRAME, fadeOut);
			}
		}

		function onCompleteHandler(loadEvent:Event) {
			pDO=loadEvent.currentTarget.content;
			addChild(pDO);
			this.setChildIndex(pDO, 0);
			//addChild(loadEvent.currentTarget.content);
			trace("LOAD COMPLETE");
		}

		function onProgressHandler(mProgress:ProgressEvent) {
			var percent:Number=mProgress.bytesLoaded/mProgress.bytesTotal;
			trace("percent loaded = " + percent);
		}

		/*private function onLoadingProgress(evt:ProgressEvent):void {//display load progress
		var percentage:Number=evt.bytesLoaded/evt.bytesTotal*ratio;
		var total_percentage:Number=Math.floor(partial+percentage);
		reader.text=total_percentage.toString()+" %";
		countDown.update(total_percentage);
		}*/

	}
}