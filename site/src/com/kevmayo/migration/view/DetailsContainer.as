package com.kevmayo.migration.view
{
	import com.kevmayo.migration.framework.IDetailsContainer;
	import com.kevmayo.migration.framework.InstitutionEntry;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.geom.Point;

	public class DetailsContainer extends Sprite implements IDetailsContainer
	{
		private var _width:int;
		private var _height:int;
		private var _bar:Shape;
		private var _barWidth:Number;
		private var _latitudeField:TextField;
		private var _latitudeFormat:TextFormat;
		private var _font:Font=new ArialReg();

		private var _entry:InstitutionEntry;
		
		public function DetailsContainer()
		{
			_bar=new Shape();
			
			_latitudeField = new TextField();
			_latitudeField.embedFonts = true;
			_latitudeField.selectable = false;
			
			_latitudeFormat = new TextFormat(_font.fontName, 18, 0x33eedd, false);
			_latitudeField.defaultTextFormat = _latitudeFormat;
		}

		public function clear():void
		{
			_bar.graphics.clear();
			removeChild(_bar);
			
			removeChild(_latitudeField);
			_latitudeField.text = "";
		}

		public function showInstitution(entry:InstitutionEntry, position:Point):void
		{
			_entry = entry;
			
			addChild(_bar);
			_bar.graphics.beginFill(0x333);
			_bar.graphics.drawRect(0, 0, _barWidth, _height);
			_bar.graphics.endFill();
			
			addChild(_latitudeField);
			_latitudeField.rotation = 90;
			_latitudeField.text = entry.latitude.toFixed(2);
			_latitudeField.setTextFormat(_latitudeFormat);
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
		}

	}
}
