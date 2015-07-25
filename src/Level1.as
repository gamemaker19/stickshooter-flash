package 
{
	import entities.Global;
	import entities.Collider;
	import net.flashpunk.World;
	public class Level1 extends World
	{
		public function Level1() 
		{
			add(new Global());
			add(new Collider());
		}
	}

}