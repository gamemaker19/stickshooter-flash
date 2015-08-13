package 
{
	import entities.Wall;
	import flash.display.BitmapEncodingColorSpace;
	import net.flashpunk.Entity;
	import flash.utils.*;
	import mx.controls.Alert;
	import net.flashpunk.FP;
	import entities.Collider;
	
	public class Util 
	{
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