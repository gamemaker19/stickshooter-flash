package entities.Stickmen 
{
	import net.flashpunk.Entity;
	import entities.Infantry;
	import net.flashpunk.graphics.Spritemap;
	
	public class Stickman extends Infantry 
	{		
		public function Stickman() 
		{
			super();
		}
		override public function update():void
		{
			if(graphic == null) graphic = Sprites.player_idle;
			super.update();
		}
	}

}