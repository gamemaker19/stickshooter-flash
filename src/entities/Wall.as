package entities 
{
	import net.flashpunk.Entity;
	
	public class Wall extends Entity
	{
		public var is_diagonal:Boolean;
		public var is_platform:Boolean;
		
		public var thickness:Number;
		public var length:Number;
		public var angle:Number;
		
		public var bounciness:Number;	//0 is none, 1 is objects bounce their height, 2 is objects bounce double their height, etc.
		public var friction:Number; 	//1 is none, 0 is objects stop immediately
		
		public function Wall() 
		{
			
		}
		
	}

}