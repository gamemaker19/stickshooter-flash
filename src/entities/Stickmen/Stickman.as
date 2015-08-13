package entities.Stickmen 
{
	import entities.Arms;
	import Sprites;
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
		}
		override public function update():void
		{
			super.update();
		}
		override protected function set_dead_hitbox():void
		{
			change_hitbox(0, 70, 103, 14);
		}
		override protected function set_default_hitbox():void
		{
			change_hitbox(10, 45, 20, 90);
		}
	}

}