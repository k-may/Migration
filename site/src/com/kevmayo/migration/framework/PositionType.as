package com.kevmayo.migration.framework
{
	public class PositionType{
		
		public static var Curator:PositionType = new PositionType("curator");
		public static var Director:PositionType = new PositionType("director");
		private var _name:String;
		
		public function PositionType(name:String){
			_name = name;
		}
	}
}