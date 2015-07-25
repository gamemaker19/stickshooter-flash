package entities.Stickmen 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	
	public class Stickman extends Infantry 
	{		
		//BEGIN AUTO GEN SPRITES
		[Embed(source = 'sprites/player/spr_player_idle/spr_player_idle.png')]
		private const SPR_IDLE:Class;
		public var spr_idle:Spritemap;
		
		private function set_sprites()
		{
			var width:int;
			var height:int;
		}
		
		//END AUTO GEN SPRITES
		
		public function Stickman() 
		{
			super();
		}
		
	}

}