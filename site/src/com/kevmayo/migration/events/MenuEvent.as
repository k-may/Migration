package com.kevmayo.migration.events{

	import flash.events.*;

	public class MenuEvent extends Event {
		static public const EXPAND_MAIN_MENU="expandMainMenu";
		static public const COLLAPSE_MAIN_MENU="collapseMainMenu";
		static public const EXPAND_SUB_MENU="expandSubMenu";
		static public const COLLAPSE_SUB_MENU="collapseSubMenu";
		static public const EXPAND_SORT_MENU="expandSortMenu";
		static public const COLLAPSE_SORT_MENU="collapseSortMenu";
		static public const OVER_NAME="overName";
		static public const OUT_NAME="outName";
		static public const CLICK_NAME="clickName";
		static public const SORT_LIST="sortList";
		public var dir:int;
		public var id:int;
		public var listType:String;

		public function MenuEvent(type:String, id:int = -1, bubbles:Boolean = false, listType:String = "position") {
			super(type, bubbles);
			this.dir=dir;
			this.id=id;
			this.listType=listType;

		}
	}
}