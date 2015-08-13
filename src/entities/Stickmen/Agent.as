package entities.Stickmen 
{
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	public class Agent extends Stickman
	{
		public function Agent() 
		{
			super();
		}
		
		override public function update():void
		{
			super.update();
			FP.camera.x = x + halfWidth - FP.screen.width/2;
			FP.camera.y = y + halfHeight - FP.screen.height / 2;
		}
	}

}