package entities 
{
	import net.flashpunk.utils.Draw;
	import net.flashpunk.FP;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	public class Projectile extends Collider 
	{
		public var damage:Number = 0;
		public var image_angle:Number = dir;
		public var is_fast:Boolean = true; //Turn on for fast projectiles to make sure that they don't clip through walls when they move
		public var is_hitscan:Boolean = false;
		public var owner:Unit = null;
		public var weapon:Weapon = null;
		public var init_vel_x:Number = 0;
		public var init_vel_y:Number = 0;
		public var aim_bonus:Boolean = false;

		public function Projectile() 
		{
			super();
			collidable = false;
			type = "projectile";
		}
		
		public override function post():void
		{
			vel_x = (Math.cos(angle*FP.RAD) * weapon.bullet_speed) + init_vel_x;
			vel_y = (Math.sin(angle*FP.RAD) * weapon.bullet_speed) + init_vel_y;

			if(is_hitscan) {
				vel_x *= 100000;
				vel_y *= 100000;    
			}
			
			/*
			if(is_a(obj_arrow)) {
				vel_x *= arrow_speed_modifier;
				vel_y *= arrow_speed_modifier;
				if(vel_y < obj_global.max_fall_speed) {
					init_vel_y += obj_global.grav;
				}
				if(!stopped) {
					image_angle = radtodeg(arctan2(-vel_y,vel_x));
				}
				else {
					vel_x = 0;
					vel_y = 0;
				}
			}
			else {
			*/
			//}
			
			if (check_collision())
			{
				Decal.CreateSparks(x, y);
				FP.world.remove(this);
				return;
			}
			
			x += vel_x;
			y += vel_y;

			super.post();
		}
		
		public function check_collision():Boolean
		{
			var point:Point = new Point();
			owner.collidable = false;
			var hit:Entity = FP.world.collideLine("WallCol", x, y, x + vel_x, y + vel_y, 1, point);
			owner.collidable = true;
			if (hit != null)
			{
				//trace(hit.getClass())
				x = point.x;
				y = point.y;
				
				//var baseHit:Base = hit as Base;
				//baseHit.on_hit(this, x, y);
				return true;
			}
			return false;
		}
		
	}

}