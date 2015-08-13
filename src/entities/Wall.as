package entities 
{
	import Base;
	import Sprites;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	
	public class Wall extends Base
	{
		public var is_diagonal:Boolean;
		public var is_platform:Boolean;
		
		public function get thickness():Number
		{
			return yscale;
		}
		
		public function get length():Number
		{
			return xscale;
		}
		
		public var bounciness:Number = 0;	//0 is none, 1 is objects bounce their height, 2 is objects bounce double their height, etc.
		public var friction:Number = 0; 	//1 is none, 0 is objects stop immediately
		
		public function Wall() 
		{
			//visible = false;
			type = "WallCol";
		}
		
		override public function update():void
		{
			super.update();
			set_sprite(Sprites.wall_visible);
		}
		
	}

}