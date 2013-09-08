package com.kevmayo.migration{

	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.Event;

	public class TrajectoryController extends Sprite {

		var dir:int;

		public function TrajectoryController(cArray:Array, dirArray:Array, color:uint , type:String, spacing:int = 15) {
this.name = "trajectory";

			if (type=="linear") {
				for (var i:int = 0; i < cArray.length; i ++) {
					/*trajectory = new Sprite();
					this.name="trajectory";
					addChild(trajectory);
					trajectory.graphics.lineStyle(1,color);
					trajectory.graphics.moveTo(cArray[i].x1 + spacing/2,0);*/
					//trace("trajectory ==> "+ i+" :  " + dirArray[i]);

					var linDir = (cArray[i].x2 - cArray[i].x1)/Math.abs(cArray[i].x2-cArray[i].x1);
					var contX=cArray[i].x2-Math.pow(i,2)*linDir;
					//trajectory.graphics.curveTo(contX, dirArray[i]*(100*i+40), cArray[i].x2+ spacing/2, 0);
					var trajectory:Trajectory = new Trajectory(contX, dirArray[i]*(i+1), cArray[i].x1 + spacing/2,0,cArray[i].x2+ spacing/2, 0, color);
					addChild(trajectory);
					if (dirArray[i]==1) {
						trajectory.y=spacing;
					}
					trace("TrajectoryController: traj = " + dirArray);
					trajectory.addEventListener(Event.ENTER_FRAME, animateTrajectory);
				}

			} else if (type =="eccentric") {
				dir=dirArray[0];
				for (var i:int = 0; i < cArray.length; i ++) {
					/*trajectory = new Sprite();
					this.name="trajectory";
					addChild(trajectory);
					trajectory.graphics.lineStyle(1,color);
					trajectory.graphics.moveTo(cArray[i].x1 + spacing/2,0);*/
					//trace("trajectory ==> "+ i+" :  " + dirArray[i]);
					/*if (dir==1) {
					trajectory.y=spacing;
					}*/
					var linDir = (cArray[0].x2 - cArray[0].x1)/Math.abs(cArray[0].x2-cArray[0].x1);
					var contX=cArray[0].x2-Math.pow(4,2)*linDir;
					//trajectory.graphics.curveTo(contX, dir*(44), cArray[0].x2+ spacing/2, 0);
					var trajectory:Trajectory=new Trajectory(contX,dir*4,cArray[i].x1 + spacing/2,0,cArray[0].x2+spacing/2,0,color);
					addChild(trajectory);
					if (dirArray[i]==1) {
						trajectory.y=spacing;
					}
					trace("traj = " + dirArray);
					trajectory.addEventListener(Event.ENTER_FRAME, animateTrajectory);
				}
			}
		}

		private function animateTrajectory(e:Event) {
			e.target._contM+=15;
			if (e.target._contM>85) {
				e.target.removeEventListener(Event.ENTER_FRAME, animateTrajectory);
			}
		}


	}
}