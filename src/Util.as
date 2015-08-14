package 
{
	import entities.Wall;
	import flash.display.BitmapEncodingColorSpace;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import flash.utils.*;
	import mx.controls.Alert;
	import net.flashpunk.FP;
	import entities.Collider;
	
	public class Util 
	{
		public static function point_in_triangle(x:Number,y:Number, x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number):Boolean
		{
			return isInsideTriangle(new Point(x1, y1), new Point(x2, y2), new Point(x3, y3), new Point(x, y));
		}
		
		private static function isInsideTriangle(A:Point,B:Point,C:Point,P:Point):Boolean {
			var planeAB:Number = (A.x-P.x)*(B.y-P.y)-(B.x-P.x)*(A.y-P.y);
			var planeBC:Number = (B.x-P.x)*(C.y-P.y)-(C.x - P.x)*(B.y-P.y);
			var planeCA:Number = (C.x-P.x)*(A.y-P.y)-(A.x - P.x)*(C.y-P.y);
			return sgn(planeAB)==sgn(planeBC) && sgn(planeBC)==sgn(planeCA);
		}
		
		private static function sgn(n:Number):int {
			return Math.abs(n)/n;
		}
		
		public static function raycast(type:String, x:Number, y:Number, angle:Number, distance:Number):Entity
		{
			var x2:Number = x + (dcos(angle)*distance);
			var y2:Number = y + (dsin(angle)*distance);

			return FP.world.collideLine(type,x,y,x2,y2,1);
		}

		public static function point_angle_normal(x1:Number,y1:Number,x2:Number,y2:Number):Number
		{
			return Util.angle_normal(FP.angle(x1,y1,x2,y2));
		}

		public static function dsin(degrees:Number):Number
		{
			return Math.sin(degrees * -FP.RAD);
		}

		public static function dcos(degrees:Number):Number
		{
			return Math.cos(degrees * -FP.RAD);
		}

		public static function get_entities(cls:Class):Array
		{
			var retList:Array = [];
			FP.world.getClass(cls, retList);
			return retList;
		}

		public static function is_obj(obj:Object, type:Class):Boolean
		{
			if (obj == null) return false;
			return obj is Class(getDefinitionByName(getQualifiedClassName(obj)));
		}
		
		public static function is_angle_steep(angle:Number):Boolean
		{
			if(angle < 0) angle += 360;
			return (angle >= 50 && angle <= 130) || (angle >= 230 && angle <= 310);
		}
		
		public static function get_bounciness(net_vel_x:Number, collider:Collider, wall:Wall):Number
		{
			if(Math.abs(net_vel_x) < 10) {
				return 0;
			}

			var bc:Number = collider.bounciness + wall.bounciness;

			if(bc < 0) bc = 0;

			return -bc * net_vel_x;
		}
		
		public static function get_bounciness_cols(net_vel_x:Number, collider:Collider, collider2:Collider):Number
		{
			if(Math.abs(net_vel_x) < 10) {
				return 0;
			}

			var bc:Number = collider.bounciness + collider2.bounciness;

			if(bc < 0) bc = 0;

			return -bc * net_vel_x;
		}
		
		public static function get_friction(collider:Collider, wall:Wall):Number
		{
			var fc:Number = collider.friction + wall.friction;

			if(fc < 0) fc = 0;
			if(fc > 1) fc = 1;

			return fc;
		}
		
		public static function get_friction_cols(collider:Collider, collider2:Collider):Number
		{
			var fc:Number = collider.friction + collider2.friction;

			if(fc < 0) fc = 0;
			if(fc > 1) fc = 1;

			return fc;
		}
		
		public static function sign(number:Number):int
		{
			if (number < 0) return -1;
			else if (number > 0) return 1;
			else return 0;
		}
		
		public static function alert(msg:String):void
		{
			trace(msg);
		}
		
		public static function is_angle_down(angle:Number):Boolean
		{
			//returns true if angle is such that an incline would be going down from left to right, i.e.
			/*
			\
			 \
			  \
			*/

			if(angle < 0) angle += 360;
			return (angle > 90 && angle < 180) || (angle > 270 && angle < 360);
		}
		
		public static function angle_normal(angle:Number):Number
		{
			while(angle < 0) {
				angle += 360;
			}
			angle = angle % 360;

			return angle;
		}
		
		public static function random_range(lowInclusive:Number, highExclusive:Number):Number
		{
			var a:Number = lowInclusive + (highExclusive - lowInclusive) * FP.random;
			return a;
		}
		
		public static function irandom_range_high_exlusive(lowInclusive:int, highExclusive:int):int
		{
			var b:int = random_range(lowInclusive, highExclusive);
			return int(b);
		}
		
		public static function irandom_range(lowInclusive:int, highInclusive:int):int
		{
			var c:int = irandom_range_high_exlusive(lowInclusive, highInclusive+1);
			return c;
		}
		
	}

}