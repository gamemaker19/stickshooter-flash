package entities 
{
	import Sprites;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	public class Bullet extends Projectile 
	{
		public function Bullet() 
		{
			super();
			current_sprite = Sprites.bullet;
		}
		
		
		
	}

}