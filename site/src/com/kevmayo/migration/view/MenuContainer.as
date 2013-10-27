package com.kevmayo.migration.view
{
	import com.kevmayo.migration.Migration;
	import com.kevmayo.migration.Model;
	import com.kevmayo.migration.events.EntrySelectedEvent;
	import com.kevmayo.migration.events.EventTypes;
	import com.kevmayo.migration.events.MenuButtonClickEvent;
	import com.kevmayo.migration.framework.IMenuContainer;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class MenuContainer extends Sprite implements IMenuContainer
	{
		private var _height:int;
		private var _width:Number;
		private var _model:Model;
		private var _invalidated:Boolean=false;

		private var _itemsHeight:int;

		private var _scrollWidth:int=25;
		private var _itemPaddingLeft=169;
		private var _itemPaddingTop=82;

		private var _padding:int=50;
		private var _openButton:MenuButton;

		private var _mask:Shape;
		private var _posBtn:TextButton;
		private var _instBtn:TextButton;


		private var _itemsCont:Sprite;
		private var _itemsMask:Shape;

		private var _textCont:Sprite;

		private var _state:String;

		private var _scrollView:ScrollView;
		private var _scrollRatio:Number;
		private var _downRatio:Number;
		private var _mouseDown:Boolean;
		private var _dragging:Boolean;
		private var _downPos:int;

		public function MenuContainer(model:Model)
		{
			super();
			_model=model;

			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		protected function onAddedToStage(event:Event):void
		{
			// TODO Auto-generated method stub
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			_openButton=new MenuButton();
			_openButton.addEventListener(MouseEvent.CLICK, function(e)
			{
				dispatchEvent(new MenuButtonClickEvent());
			});
			addChild(_openButton);
			_openButton.x=_padding;
			_openButton.y=Migration.MENU_PADDING_TOP;

			_textCont=new Sprite();
			addChild(_textCont);

			_posBtn=new TextButton("POSITIONS");
			_posBtn.addEventListener(MouseEvent.CLICK, function()
			{
				setState("positions");
			});
			_textCont.addChild(_posBtn);
			_posBtn.x=70;
			_posBtn.y=100;

			_instBtn=new TextButton("INSTITUTIONS");
			_instBtn.addEventListener(MouseEvent.CLICK, function()
			{
				setState("institutions");
			});
			_textCont.addChild(_instBtn);
			_instBtn.x=70;
			_instBtn.y=130;

			_mask=new Shape();
			this.addChild(_mask);
			_textCont.mask=_mask;
			//this.mask = _mask;

			_itemsCont=new Sprite();
			_textCont.addChild(_itemsCont);

			_itemsMask=new Shape();
			addChild(_itemsMask);
			_itemsCont.mask=_itemsMask;

			_scrollView=new ScrollView(setRatio);
			_textCont.addChild(_scrollView);

			_itemsCont.addEventListener(MouseEvent.CLICK, onEntryClicked);

			_itemsCont.addEventListener(MouseEvent.MOUSE_DOWN, onMouseHandler);
			_itemsCont.addEventListener(MouseEvent.MOUSE_MOVE, onMouseHandler);
			_itemsCont.addEventListener(MouseEvent.MOUSE_UP, onMouseHandler);
			_itemsCont.addEventListener(MouseEvent.ROLL_OUT, onMouseHandler);

		}

		protected function onMouseHandler(event:MouseEvent):void
		{
			switch (event.type)
			{
				case MouseEvent.MOUSE_DOWN:
					_mouseDown=true;
					_downPos=event.stageY;
					_downRatio = _scrollRatio;
				case MouseEvent.MOUSE_MOVE:
					if (_mouseDown)
					{
						var distance:Number=_downPos - event.stageY;

						_dragging=_dragging || Math.abs(distance) > 10;

						if (_dragging)
						{
							var ratio:Number=_downRatio + (distance / _itemsHeight);
							setRatio(ratio, true);
						}
					}
					break;
				case MouseEvent.ROLL_OUT:
				case MouseEvent.MOUSE_UP:
					if (_mouseDown)
					{
						_dragging=false;
						_mouseDown=false;
					}
					break;

			}
		}

		public function setRatio(value:Number, isInternal:Boolean = false):void
		{
			_scrollRatio = Math.min(Math.max(value, 0), 1);
			if(isInternal)
				_scrollView.setRatio(value);
			else{
				//trace("set scroll : " + value);
				_scrollRatio=value;
				_itemsCont.y=_scrollRatio * (getItemsMaskHeight() - _itemsHeight);
				
			}
		}

		protected function onEntryClicked(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			if (event.target is EntryButton)
				dispatchEvent(new EntrySelectedEvent((event.target as EntryButton).name)());
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

		public override function get height():Number
		{
			return _height;
		}

		public override function set height(value:Number):void
		{
			_height=value;
			_invalidated=true;
		}

		public function update():void
		{
			if (_invalidated)
			{
				var g:Graphics=this.graphics;
				g.clear();
				g.lineStyle(1, Migration.LINE_COLOR);

				_invalidated=false;

				g.drawRect(Migration.MENU_PADDING_HOR, Migration.MENU_PADDING_TOP, _width - Migration.MENU_PADDING_HOR * 2, _height - Migration.MENU_PADDING_TOP);

				g=_mask.graphics;
				g.clear();
				g.beginFill(0xffffff);
				g.drawRect(Migration.MENU_PADDING_HOR, Migration.MENU_PADDING_TOP, _width - Migration.MENU_PADDING_HOR * 2, _height - Migration.MENU_PADDING_TOP);
				g.endFill();

				var paddingLeft=Migration.MENU_PADDING_HOR;
				var maskWidth = getItemsMaskWidth();
				g=_itemsMask.graphics;
				g.clear();
				g.beginFill(0xffffff);
				g.drawRect(_itemPaddingLeft, _itemPaddingTop, maskWidth, getItemsMaskHeight());
				g.endFill();

				_scrollView.x=_width - Migration.MENU_PADDING_HOR - _scrollWidth;
				_scrollView.y=Migration.MENU_PADDING_TOP;
				_scrollView.width=_scrollWidth;
				_scrollView.height=_height - Migration.MENU_PADDING_TOP;
				_scrollView.update();
				
				/*
				g = this.graphics;
				g.lineStyle(3, 0xff0000);
				g.drawRect(_itemPaddingLeft, _itemPaddingTop, maskWidth, getItemsMaskHeight());
				g.endFill();
				*/
				
				g = _itemsCont.graphics;
				g.clear();
				g.beginFill(0x00000000, 0);
				g.drawRect(_itemPaddingLeft,0,getItemsMaskWidth(), _itemsHeight);
				g.endFill();
			}
		}
		
		private function getItemsMaskWidth():int{
			return _width - _itemPaddingLeft - Migration.MENU_PADDING_HOR - 35;
		}

		private function getItemsMaskHeight():int
		{
			return _height - _itemPaddingTop - 10;
		}

		public function get isOpen():Boolean
		{
			return _openButton.isOpen();
		}

		public function set isOpen(value:Boolean):void
		{
			if (value)
				_openButton.open();
			else
				_openButton.close();
		}


		public function setState(state:String):void
		{
			if (_state == state)
				return;

			var t:Array;
			_state=state;
			if (state == "positions")
			{
				_posBtn.active=true;
				_instBtn.active=false;
				t=_model.getPositionNames();
			}
			else if (state == "institutions")
			{
				_posBtn.active=false;
				_instBtn.active=true;
				t=_model.getInstitutionNames();
			}

			while (_itemsCont.numChildren > 0)
			{
				_itemsCont.removeChildAt(0);
			}

			var field:TextButton;
			var x:int=_itemPaddingLeft;
			var y:int=_itemPaddingTop;
			for each (var text:Object in t)
			{
				field=new EntryButton(text.text, text.color); //TextButton(text);
				field.x=x;
				field.y=y;
				y+=16;
				_itemsCont.addChild(field);
			}

			_itemsHeight=y;

		}

		public function get state():String
		{
			return _state;
		}

		public function setActive(name:String):void
		{
			var btn:EntryButton;
			for (var i=0; i < _itemsCont.numChildren; i++)
			{
				btn=_itemsCont.getChildAt(i) as EntryButton;
				if (btn.name == name)
				{
					btn.active=true;
				}
				else
					btn.active=false;
			}

		}
	}
}
