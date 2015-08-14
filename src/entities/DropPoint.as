package entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	
	public class DropPoint extends WaypointLink 
	{
		public var is_ladder_dp:Boolean;
		public function DropPoint() 
		{
			super();
			current_sprite = Sprites.drop_point;
			type = "DropPoint";
		}
		
	}

}