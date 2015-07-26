package
{
	import net.flashpunk.Engine;
	import net.flashpunk.FP;

	public class Main extends Engine
	{
		public function Main()
		{
			super(800, 600, 60, false);
			Sprites.set_sprites();
			FP.world = new Level1;
		}
		
		override public function init():void
		{
			trace("FlashPunk has started successfully!");
			
		}
	}
}
