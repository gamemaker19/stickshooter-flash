package 
{
	public class ChildData 
	{
		public var parent:Base;
		public var host:Base;
		
		public var offset_x:Number;
		public var offset_y:Number;
		
		public function ChildData() 
		{
			
		}
		
		public function update_position():void
		{
			host.x = parent.x + offset_x;
			host.y = parent.y + offset_y;
		}
	}

}