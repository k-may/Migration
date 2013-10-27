package com.kevmayo.migration.view
{
	import com.kevmayo.migration.Migration;
	import com.kevmayo.migration.Model;
	import com.kevmayo.migration.framework.CityEntry;
	import com.kevmayo.migration.framework.InstitutionEntry;
	import com.kevmayo.migration.framework.NavigationNode;
	import com.kevmayo.migration.framework.Node;
	
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
		private var _textPaddingTop:int=10;
		private var _width:int;
		private var _height:int;
		private var _currentRatio:Number;

		private var _textScrollWidth=40000;

		private var _overFormat:TextFormat;
		private var _outFormat:TextFormat;

		private var _scrollButton:Sprite;
		private var _invalidated:Boolean=false;

		private var _model:Model;
		private var _nodeContainer:NodeContainer;

		public function NavigationContainer(model:Model, nodeCont:NodeContainer)
		{
			super();
			_model=model;
			_nodeContainer = nodeCont;
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		public function setLocations(entries:Vector.<CityEntry>):void
		{
			_nodeFields=new Vector.<TextField>();
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
				pos=getNodePosForLongitude(longitude); //1 - (longitude - start) / (end - start);
				
				trace("city : " + entry.name + " / " + pos);
				node=new NavigationNode(entry, pos);

				textField=new TextField();
				textField.text=node.entry.name.toUpperCase();
				textField.autoSize=TextFieldAutoSize.LEFT;
				textField.embedFonts=true;
				addChild(textField);
				textField.y=_textPaddingTop;

				node.field=textField;
				node.point=new Sprite();
				addChild(node.point);


				_nodes.push(node);

			}
		}
		
		private function getNodePosForLongitude(value:Number):Number{
			var pos:Number = _model.getLocalEntryForLongitude(value);
			return pos;
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
				Node.DrawDiamond(_scrollButton.graphics, 7, Migration.BUTTON_COLOR, 3); //drawButton(_scrollButton.graphics, 7);
				addChild(_scrollButton);
				_scrollButton.y=_padding;
			}
			_invalidated=true;

			_outFormat=new TextFormat(new ArialReg().fontName, 16, Migration.LINE_COLOR);
			_overFormat=new TextFormat(new ArialReg().fontName, 16, Migration.BUTTON_COLOR);
		}

		public function update()
		{
			if (_invalidated)
			{
				_invalidated=false;

				var g:Graphics=this.graphics;
				g.clear();
				g.lineStyle(1, Migration.LINE_COLOR);
				//g.drawRect(0, 0, _width, _height);

				//draw line
				g.moveTo(_padding, _padding);
				g.lineTo(_padding + getLineWidth(), _padding);

				if (_points != null)
					clearPoints();

				var point:Sprite;
				for each (var node:NavigationNode in _nodes)
				{
					point=node.point;
					Node.DrawDiamond(point.graphics, 5, Migration.LINE_COLOR); //drawPoint(point.graphics, 5);
					node.nodePos=node.ratio * getLineWidth();
					node.textPos=node.ratio * _textScrollWidth;
					point.x=node.ratio * getLineWidth() + _padding;
					point.y=_padding;
				}

				setPos(_currentRatio);
			}
		}

		private function clearPoints()
		{
			for each (var point:Sprite in _points)
				removeChild(point);

			_points=new Vector.<Sprite>();
		}

		private function getLineWidth()
		{
			return _width - _padding * 2;
		}

		public function setPos(ratio:Number)
		{
			_currentRatio=ratio;

			_scrollButton.x=getLineWidth() * ratio + _padding;

			var textScrollPosition=_textScrollWidth * ratio;
			var textScrollOffset:Number=_width / 2 - _textScrollWidth * ratio;

			var textField:TextField;

			for each (var node:NavigationNode in _nodes)
			{
				textField=node.field;
				textField.x=textScrollOffset + node.textPos - textField.width / 2;

				if (textField.x > _padding && textField.x + textField.width < _padding + getLineWidth())
				{
					textField.visible=true;

					if (node.ratio < ratio + 0.02 && node.ratio > ratio - 0.02)
					{
						textField.setTextFormat(_overFormat);
						Node.DrawDiamond(node.point.graphics, 5, Migration.BUTTON_COLOR); //drawPoint(point.graphics, 5);node.point.
					}
					else
					{
						textField.setTextFormat(_outFormat);
						Node.DrawDiamond(node.point.graphics, 5, Migration.LINE_COLOR);
					}

				}
				else
				{
					textField.visible=false;
					textField.setTextFormat(_outFormat);
					Node.DrawDiamond(node.point.graphics, 5, Migration.LINE_COLOR);
				}
			}
		}
	}
}
