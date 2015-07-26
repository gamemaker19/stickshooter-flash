package entities.Stickmen 
{
	import net.flashpunk.Entity;
	import entities.Infantry;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Spritemap;
	
	public class Stickman extends Infantry 
	{		
		public function Stickman()
		{
			super();
			
			idle_sprite = Sprites.player_idle;
			walk_sprite = Sprites.player_walk;
			run_sprite = Sprites.player_run;
			jump_sprite = Sprites.player_jump;
			fall_sprite = Sprites.player_fall;
			crouch_sprite = Sprites.player_crouch;
			
			const_hitbox = true;
			const_hitbox_x = 0;
			const_hitbox_y = 0;
			const_hitbox_w = 20;
			const_hitbox_h = 90;
		}
		
		override public function update():void
		{
			super.update();
		}
		
	}

}