package 
{
	import entities.Unit;
	import flash.geom.Point;
	public class Squad
	{
		public var units:Vector.<Unit>;
		public var investigators:Vector.<Unit>;
		public var disturbance:Point;		//A disturbance is a "mysterious" source that squad members will investigate
		
		//If a squad is in combat, disturbances will be ignored. This variable will be set to false if enough time has elapsed
		//since a squad member has last had a target
		public var in_combat:Boolean;			

		public function get has_disturbance():Boolean
		{
			return disturbance != null && !in_combat;
		}

		public function clear_disturbance():void
		{
			disturbance = null;
		}

		public function set_disturbance(x:int, y:int):void
		{
			if(!has_disturbance)
			{
				disturbance = new Point(x,y);
			}
		}

	}
}