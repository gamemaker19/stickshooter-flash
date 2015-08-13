package entities 
{
	import IChild;
	import Base;
	import Sprites;
	public class Armor extends Base implements IChild
	{
		public function Armor() 
		{
			super();
		}
		
		public override function update():void
		{
			set_sprite(Sprites.bodyguard_armor);
		}
		
		public function update_position(host:Base):void
		{
			var ihost:Infantry = host as Infantry;
			x = ihost.arm_x;
			y = ihost.arm_y;
			angle = (ihost.dir == 1 ? ihost.body_angle : 180 - ihost.body_angle);
			yscale = ihost.dir;
		}
		
	}

}