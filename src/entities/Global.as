package entities
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;

	public class Global extends Entity
	{
		//[Embed(source = 'sprites/arm/spr_arm_bow/spr_arm_bow_0.png')] private const PLAYER_IMG:Class;
		//[Embed(source = 'sprites/arm/spr_arm_bow/spr_arm_bow_1.png')] private const PLAYER_IMG2:Class;
		public function Global()
		{
			//graphic = new Image(PLAYER_IMG2);
		}
		override public function update():void
		{
			/*
			if (Input.check(Key.LEFT)) { x -= 5; graphic = new Image(PLAYER_IMG); }
			if (Input.check(Key.RIGHT)) { x += 5; }
			if (Input.check(Key.UP)) { y -= 5; }
			if (Input.check(Key.DOWN)) { y += 5; }
			*/
			
		}
	}
}
