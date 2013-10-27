package com.kevmayo.migration.view
{

	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;

	public class Trajectory extends Sprite
	{
		/*var trajectory:Sprite;
		var dir:int;
		var contX,contY:int;
		var cX1,cY1,cX2,cY2:int;
		var color:uint;
		var contM:int = 1;
		*/
		
		private var _startPoint:Point;
		private var _endPoint:Point;
		private var _color:uint;
		
		public function Trajectory(startPoint:Point, endPoint:Point, color:uint){
			_startPoint = startPoint;
			_endPoint = endPoint;
			_color = color;
			
			render();
		}
		
		/**
		 * Function handles the animation
		 * 
		 * @param value is a value between 0 and 1
		 * 
		 */		
		public function update(value:Number):void{
			
		}
		
		
		public function render() {
			this.graphics.clear();
			this.graphics.lineStyle(1,_color);
			this.graphics.moveTo(_startPoint.x,_startPoint.y);
			trace("render : " + _endPoint.x + " / " + _startPoint.x);
			this.graphics.curveTo((_endPoint.x - _startPoint.x)*0.9, 200, _endPoint.x, _endPoint.y);
		}
	
/*
	public function Trajectory(_contX:int, _contY:int, _cX1:int, _cY1:int, _cX2:int,_cY2:int, _color:uint) {
		this.contX=_contX;
		this.contY=_contY;
		this.cX1=_cX1;
		this.cY1=_cY1;
		this.cX2=_cX2;
		this.cY2=_cY2;
		this.color=_color;

		trajectory = new Sprite();
		this.name="trajectory";
		addChild(trajectory);
		render();

	}

	public function render() {
		trajectory.graphics.clear();
		trajectory.graphics.lineStyle(1,color);
		trajectory.graphics.moveTo(cX1,cY1);
		trajectory.graphics.curveTo(contX, contY*contM + 40, cX2, cY2);
	}

	public function set _contM(_val) {
		//contY=contY*_val;
		contM = _val;
		render();
	}

	public function get _contM():int{
		return contM;
	}
*/

	}
}
