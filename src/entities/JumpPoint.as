package entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	
	/**
	 * ...
	 * @author 
	 */
	public class JumpPoint extends WaypointLink 
	{
		public var is_ladder_jp:Boolean;
		public var jp_dir:int;
		public var jump_start_x:Number;
		public var jump_dest_x:Number;
		public var jump_dest_y:Number;
		
		public function JumpPoint() 
		{
			super();
			type = "JumpPoint";
			current_sprite = Sprites.jump_point;
		}
		
	}

}