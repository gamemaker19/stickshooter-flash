package entities 
{
	import flash.accessibility.AccessibilityImplementation;
	import net.flashpunk.Entity;
	
	/*
	 * Generally speaking, a unit is a class that represents an entity that can fight, take damage, move, etc.
	 * Think of it as a unit in RTS terms.
	 * 
	 * Projectiles and weapons won't be units. Unless:
	 * 	-You want to play as a projectile (i.e. controllable rocket)
	 *  -You have a sentient weapon that can move and fire on its own accord
	 */
	public class Unit extends Collider
	{
		public var alliance:int;
		public var look_angle:Number;
		public var hp:Number;
		
		public var move_x;
		public var move_y;
		
		public var ctl:Controller;
		//public var ai:AI;
		
		public var state:UnitState;
		
		public function Unit() 
		{
			
		}
		
		override public function update()
		{
			ctl.update();	//Controls must be the first thing obtained if human player
			pre();
			step();
			post();
		}
		
		//Change direction to look angle
		public function normalize_look_angle():void
		{
			look_angle = angle_normal(look_angle);

			if(look_angle > 90 && look_angle < 270) {
				if(dir == 1) { look_angle = angle_normal(180 - look_angle); }
			}
			else {
				if(dir == -1) { look_angle = angle_normal(180 - look_angle); }
			}
		}
		
	}

}