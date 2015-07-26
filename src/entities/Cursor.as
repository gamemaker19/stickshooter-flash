package entities 
{
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.FP;
	public class Cursor extends Base
	{
		public function Cursor() 
		{
			
		}
		
		public override function update():void
		{
			super.update();
			set_sprite(Sprites.cursor);
			x = FP.world.mouseX;
			y = FP.world.mouseY;
		}
		
	}

}