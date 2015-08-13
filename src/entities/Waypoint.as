package entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	
	/**
	 * ...
	 * @author 
	 */
	public class Waypoint extends Base 
	{
		public var neighbors:Array = [];
		public var neighbor_to_jp:Dictionary = new Dictionary();	//Maps a neighbor to its connecting jump point
		public var neighbor_to_dp:Dictionary = new Dictionary();	//Maps a neighbor to its connecting jump point
		public var dest_to_neighbor:Dictionary = new Dictionary();	//Maps a destination to best neighbor

		public function Waypoint() 
		{
			super();
			type = "Waypoint";
		}
		
	}

}