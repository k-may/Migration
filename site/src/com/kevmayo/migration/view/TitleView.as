package com.kevmayo.migration.view
{
	import com.kevmayo.migration.Migration;
	import com.kevmayo.migration.framework.ITitleView;

	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.engine.TextBlock;

	public class TitleView extends Sprite implements ITitleView
	{
		private var _field:TextField;
		private var _width:int;
		private var _height:int;
		private var _invalidated:Boolean=false;
		private var _text:String;

		public function TitleView()
		{
			super();
		}

		public function update()
		{
			if (_invalidated)
			{
				_invalidated=false;

				if (_field == null)
				{
					_field=new TextField();
					addChild(_field);
				}

				_field.embedFonts=true;
				_field.text=_text;
				_field.wordWrap=true;
				_field.autoSize=TextFieldAutoSize.LEFT;
				_field.setTextFormat(new TextFormat(new ArialReg().fontName, 18, Migration.TITLE_COLOR));
				_field.width=_width;

					//_field.height = _height;
			}
		}

		public override function get height():Number
		{
			return _height;
		}

		public override function set height(value:Number):void
		{
			_height=value;
			_invalidated=true;
		}

		public override function get width():Number
		{
			return _width;
		}

		public override function set width(value:Number):void
		{
			_width=value;
			_invalidated=true;
		}

		public function setText(text:String):void
		{
			_text=text;
			_invalidated=true;
		}
	}
}
