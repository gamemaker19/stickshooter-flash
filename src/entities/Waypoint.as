package entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import flash.utils.Dictionary;
	import net.flashpunk.graphics.Image;
	
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

		public var left_x:Number = 0;
		public var right_x:Number = 0;
		public var xs_set:Boolean = false;
		
		public function Waypoint() 
		{
			super();
			type = "Waypoint";
			current_sprite = Sprites.waypoint_pair;
		}
		
		public override function update():void
		{
			if (graphic != null && !xs_set)
			{
				xs_set = true;
				left_x = x - (graphic as Image).scaledWidth/2;
				right_x = x + (graphic as Image).scaledWidth / 2;
			}
		}
		
	}

}