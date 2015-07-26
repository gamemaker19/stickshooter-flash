package
{
	import Global;
	import entities.Collider;
	import entities.Stickmen.*;
	import entities.Wall;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.World;
	
	public class Level1 extends World
	{
		private var w2:Wall;
		
		public function Level1() 
		{
			add(new Global());
			add(new Agent());
			
			var w:Wall = new Wall();
			w.x = 0; w.y = 300; w.xscale = 10;
			add(w);
			
			w2 = new Wall();
			w2.x = 200; w2.y = 100; w2.xscale = 1; w2.yscale = 10;
			add(w2);
		}
		
		override public function update():void
		{
			super.update();
		}
	}

}