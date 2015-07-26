package entities 
{
	import IChild;
	import net.flashpunk.Entity;
	import net.flashpunk.utils.Draw;
	public class Arms extends Base implements IChild
	{
		public function Arms() 
		{
		}
		
		override public function update():void
		{
			super.update();
		}
		
		public function to_crouch():void
		{
			set_sprite(Sprites.arm_crouch);
		}
		
		public function to_idle():void
		{
			set_sprite(Sprites.arm_walk);
		}
		
		public function to_walk():void
		{
			set_sprite(Sprites.arm_walk);
		}
		
		public function to_run():void
		{
			set_sprite(Sprites.arm_run);
		}
		
		public function to_jump():void
		{
			set_sprite(Sprites.arm_jump);
		}
		
		public function to_fall():void
		{
			set_sprite(Sprites.arm_fall);
		}
		
		public function update_position(host:Base):void
		{
			var ihost:Infantry = host as Infantry;
			x = ihost.arm_x;
			y = ihost.arm_y;
		}
		
	}

}