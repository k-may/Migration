package com.kevmayo.migration.view
{
	import com.kevmayo.migration.Migration;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class TextButton extends Sprite
	{
		protected var _text:String;
		protected var _field:TextField;
		private var _active:Boolean = false;
		private var _activeFormat:TextFormat;
		private var _format:TextFormat;

		public function TextButton(text:String)
		{
			super();
			
			_text=text;
			
			_activeFormat = new TextFormat(new ArialReg().fontName, 13, Migration.BUTTON_COLOR);
			_format = new TextFormat(new ArialReg().fontName, 13, Migration.LINE_COLOR);
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		protected function onAddedToStage(event:Event):void
		{
			// TODO Auto-generated method stub
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			_field=new TextField();
			_field.autoSize=TextFieldAutoSize.LEFT;
			_field.text=_text;
			_field.selectable = false;
			_field.setTextFormat(_format);
			addChild(_field);
			_field.mouseEnabled = false;

			var g:Graphics=this.graphics;
			g.beginFill(0xffffff, 0);
			g.drawRect(0, 0, _field.width, _field.height);
			
			this.buttonMode = true;
		}
		
		public function set active(value:Boolean){
			_active = value;
			
			if(_active)
				_field.setTextFormat(_activeFormat);
			else
				_field.setTextFormat(_format);
		}
	}
}
