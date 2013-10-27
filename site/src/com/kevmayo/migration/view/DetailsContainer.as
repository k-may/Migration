package com.kevmayo.migration.view
{
	import com.kevmayo.migration.Migration;
	import com.kevmayo.migration.framework.IDetailsContainer;
	import com.kevmayo.migration.framework.InstitutionEntry;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class DetailsContainer extends Sprite implements IDetailsContainer
	{
		private var _width:int;
		private var _height:int;
		private var _bar:Shape;
		private var _barWidth:Number=10;
		private var _latitudeField:TextField;
		private var _latitudeFormat:TextFormat;
		private var _instField:TextField;
		private var _instFormat:TextFormat;
		private var _dateField:TextField;
		private var _dateFormat:TextFormat;
		private var _font:Font=new ArialReg();
		

		private var _invalidated:Boolean=false;

		private var _entry:InstitutionEntry;

		public function DetailsContainer()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);		}
		
		protected function onAddedToStage(event:Event):void
		{

			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			_bar=new Shape();
			
			_dateField = new TextField();
			_dateField.autoSize = TextFieldAutoSize.LEFT;
			_dateField.embedFonts = true;
			
			_dateFormat = new TextFormat(_font.fontName, 14, Migration.TITLE_COLOR, false, true);
			
			_instField = new TextField();
			_instField.selectable = false;
			_instField.autoSize = TextFieldAutoSize.LEFT;
			_instField.embedFonts = true;
			
			_instFormat = new TextFormat(_font.fontName, 18, Migration.TITLE_COLOR, true);
			
			_latitudeField=new TextField();
			_latitudeField.embedFonts=true;
			_latitudeField.selectable=false;
			_latitudeField.autoSize=TextFieldAutoSize.LEFT;
			_latitudeFormat=new TextFormat(_font.fontName, 26, Migration.LINE_COLOR, true);
			_latitudeField.defaultTextFormat=_latitudeFormat;

			
		}
		
		public function clear():void
		{
			if (this.contains(_bar))
				removeChild(_bar);

			if (this.contains(_latitudeField))
				removeChild(_latitudeField);
			
			if(this.contains(_instField))
				removeChild(_instField);
		}

		public function showInstitution(entry:InstitutionEntry, position:Point):void
		{
			_entry=entry;

			addChild(_bar);
			_bar.x=position.x;
			
			var startText:String = _entry.startDate.split("-")[0];
			var endText:String = _entry.endDate.split("-")[0];
			endText = endText == "0000" ? "present": endText;
			var dateText:String = startText + " - " + endText;
			_dateField.text = dateText;
			_dateField.setTextFormat(_dateFormat);
			_dateField.x = position.x + 5;
			_dateField.y = _height - _dateField.height - 3;
			addChild(_dateField);

			addChild(_instField);
			_instField.text = entry.name;
			_instField.setTextFormat(_instFormat);
			_instField.x = position.x + 5;
			_instField.y = _height - _instField.height - 20;
			
			addChild(_latitudeField);
			_latitudeField.rotation=90;
			_latitudeField.text=entry.latitude.toFixed(2);
			_latitudeField.setTextFormat(_latitudeFormat);
			_latitudeField.x=position.x;
			var latWidth:int = _latitudeField.width;
			//trace("latidth : "  + latWidth + " / " + _latitudeField.height);
			_latitudeField.y=_height - _latitudeField.height;
		}

		public function update()
		{
			if (_invalidated)
			{
				_invalidated=false;

				_bar.graphics.clear();
				_bar.graphics.beginFill(Migration.LINE_COLOR);
				_bar.graphics.drawRect(0, 0, 1, _height);
				_bar.graphics.endFill();

			}
		}

		override public function get height():Number
		{
			// TODO Auto Generated method stub
			return _height;
		}

		override public function set height(value:Number):void
		{
			// TODO Auto Generated method stub
			_height=value;
			_invalidated=true;
		}

		override public function get width():Number
		{
			// TODO Auto Generated method stub
			return _width;
		}

		override public function set width(value:Number):void
		{
			// TODO Auto Generated method stub
			_width=value;
			_invalidated=true;
		}

	}
}
