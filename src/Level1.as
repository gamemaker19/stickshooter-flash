package
{
	import Global;
	import entities.Collider;
	import LevelAdder;
	import entities.Stickmen.*;
	import entities.Wall;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.World;
	import net.flashpunk.utils.Draw;
	
	public class Level1 extends World
	{
		public function Level1() 
		{
			LevelAdder.add(this, LevelAdder.ROOM3);
			LevelAdder.set_waypoints();
			
			/*
			add(new Agent());
			
			var w:Wall = new Wall();
			w.x = 0; w.y = 300; w.xscale = 10;
			add(w);
			
			w2 = new Wall();
			w2.x = 200; w2.y = 100; w2.xscale = 1; w2.yscale = 10;
			add(w2);
			*/
		}
		
		override public function update():void
		{
			super.update();
		}
	}

}