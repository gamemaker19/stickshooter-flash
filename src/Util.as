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
		
		public static function is_above_platform(entity:Entity, wall:Wall):Boolean
		{
			//Climbing/fallthru stickmen go thru platforms
			
			/*
			 * TODO FIX THIS
			if(is_a(obj_stickman)) {
				if(state == CLIMB || trigger_fallthrough) {
					return false;
				}
			}
			*/

			if(wall.is_diagonal) {
				return above_diag(entity,wall);
			}
			else {
				return entity.y+(Math.abs(entity.height)/2)-1 <= wall.y; 
			}
		}
		
		public static function above_diag(entity:Entity, diag_wall:Wall):Boolean
		{
			var cx:Number = entity.x;
			var cy:Number = entity.y + Math.abs(entity.height)/2;

			var dx:Number = diag_wall.x;
			var dy:Number = diag_wall.y;

			var dwidth:Number = diag_wall.thickness;
			var dir:int;
			var hypotenuse:Number = diag_wall.length;

			var dangle:Number = diag_wall.angle;
			if(dangle < 90) {
				dir = -1;
			}
			else {
				dir = 1;
				dangle = 180 - dangle;
			}

			var yslope:Number = hypotenuse * Math.sin(dangle * FP.RAD);
			var xslope:Number = hypotenuse * Math.cos(dangle * FP.RAD);

			var slope:Number = dir * (yslope / xslope);
			var b:Number = dy - slope*dx;

			//y = mx + b

			if(cy < slope*cx + b) {
				return true;
			}

			return false;
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
		
	}

}