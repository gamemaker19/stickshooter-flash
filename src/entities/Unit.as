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
		public var alliance:int = 0;
		public var look_angle:Number = 0;
		public var hp:Number = 200;
		
		public var move_x:Number = 0;
		public var move_y:Number = 0;
		
		public var ctl:Controller;
		//public var ai:AI;
		
		public var state:UnitState;
		
		public function Unit() 
		{
			ctl = new Controller();
		}
		
		override public function update():void
		{
			ctl.update();	//Controls must be the first thing obtained if human player
			super.update();
		}
		
		//Change direction to look angle
		public function normalize_look_angle():void
		{
			look_angle = Util.angle_normal(look_angle);

			if(look_angle > 90 && look_angle < 270) {
				if(dir == 1) { look_angle = Util.angle_normal(180 - look_angle); }
			}
			else {
				if(dir == -1) { look_angle = Util.angle_normal(180 - look_angle); }
			}
		}
		
	}

}