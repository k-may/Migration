package com.kevmayo.migration.view
{
	import com.kevmayo.migration.Migration;
	import com.kevmayo.migration.framework.CityEntry;
	import com.kevmayo.migration.framework.NavigationNode;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getTimer;

	public class NavigationContainer extends Sprite
	{

		private var _nodeFields:Vector.<TextField>;
		private var _nodes:Vector.<NavigationNode>;
		private var _points:Vector.<Sprite>;
		private var _startLong:int;
		private var _endLong:int;
		private var _padding:int=50;
		private var _lineColor:uint=0xcccccc;
		private var _buttonColor:uint=0x808080;
		private var _width:int;
		private var _height:int;

		private var _textScrollWidth = 4000;
		
		private var _scrollButton:Sprite;
		private var _invalidated:Boolean=false;

		public function NavigationContainer()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		public function setLocations(entries:Vector.<CityEntry>):void
		{
			_nodeFields = new Vector.<TextField>();
			_nodes=new Vector.<NavigationNode>();
			var node:NavigationNode;
			var pos:Number;
			var longitude:Number;
			var textField:TextField;
			
			for each (var entry:CityEntry in entries)
			{
				longitude=entry.longitude;
				var start:Number=Migration.Start_Long
				var end:Number=Migration.End_Long;
				pos=1 - (longitude - start) / (end - start);
				node=new NavigationNode(entry, pos);
				node.textPos = _textScrollWidth * node.ratio;
				
				textField = new TextField();
				textField.text = node.entry.name.toUpperCase();
				textField.autoSize = TextFieldAutoSize.LEFT;
				textField.embedFonts = true;
				addChild(textField);
				textField.setTextFormat(new TextFormat(new ArialReg().fontName, 16, _lineColor));
				
				textField.x = node.textPos - textField.textWidth;
				
				node.field = textField;
				node.point=new Sprite();
				addChild(node.point);


				_nodes.push(node);

			}
		}

		public override function set width(value:Number):void
		{
			_width=int(value);
			_invalidated=true;
		}

		protected function onAddedToStage(event:Event):void
		{
			// TODO Auto-generated method stub
			this._height=Migration.NAV_HEIGHT;

			if (_scrollButton == null)
			{
				_scrollButton=new Sprite();
				drawButton(_scrollButton.graphics, 7);
				addChild(_scrollButton);
				_scrollButton.y=_padding;
			}
			_invalidated=true;
		}

		public function update()
		{
			if (_invalidated)
			{
				_invalidated=false;

				var g:Graphics=this.graphics;
				g.clear();
				g.lineStyle(1, _lineColor);
				g.drawRect(0, 0, _width, _height);

				//draw line
				g.moveTo(_padding, _padding);
				g.lineTo(_padding + getLineWidth(), _padding);

				if (_points != null)
					clearPoints();

				var point:Sprite;
				for each (var node:NavigationNode in _nodes)
				{
					point = node.point;
					drawPoint(point.graphics, 5);
					node.nodePos = node.ratio * getLineWidth();
					node.textPos = node.ratio * _textScrollWidth;
					point.x=node.ratio * getLineWidth() + _padding;
					point.y=_padding;
				}

			}
		}

		private function drawButton(g:Graphics, radius:int)
		{
			g.clear();
			g.lineStyle(3, _buttonColor);
			g.moveTo(0, -radius);
			g.lineTo(radius, 0);
			g.lineTo(0, radius);
			g.lineTo(-radius, 0);
			g.lineTo(0, -radius);
			g.endFill();
		}

		private function drawPoint(g:Graphics, radius:int)
		{
			g.clear();
			g.beginFill(_lineColor);
			g.moveTo(0, -radius);
			g.lineTo(radius, 0);
			g.lineTo(0, radius);
			g.lineTo(-radius, 0);
			g.lineTo(0, -radius);
			g.endFill();

		}

		private function clearPoints()
		{
			for each (var point:Sprite in _points)
			{
				removeChild(point);
			}
			_points=new Vector.<Sprite>();
		}

		private function getLineWidth()
		{
			return _width - _padding * 2;
		}

		public function setPos(ratio:Number)
		{
			_scrollButton.x=getLineWidth() * ratio;
			
			//var _textPos:Number = _textScrollWidth*ratio;
			
			var _textPos:Number = _width/2 - _textScrollWidth*ratio;
			
			var textField:TextField;
			
			for each(var node:NavigationNode in _nodes){
				textField = node.field;
				textField.x = _textPos + node.textPos;
				
				if(textField.x > _padding && textField.x + textField.width < _padding + getLineWidth())
					textField.visible = true;
				else
					textField.visible = false;
			}
		}
	}
}
