package
{
	import entities.Global;
	import entities.Collider;
	import entities.Stickmen.*;
	import entities.Wall;
	import net.flashpunk.World;
	
	public class Level1 extends World
	{
		public function Level1() 
		{
			add(new Global());
			add(new Agent());
			var w:Wall = new Wall();
			w.x = 0;
			w.y = 200;
			add(w);
		}
	}

}