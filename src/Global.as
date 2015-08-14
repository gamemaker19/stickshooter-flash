package
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import entities.*; 

	public class Global
	{
		private static var _units:Array = null;
		public static function get units():Array
		{
			if(_units == null) { _units = Util.get_entities(Unit); }
			return _units;
		}

		private static var _waypoints:Array = null;
		public static function get waypoints():Array
		{
			if(_waypoints == null) { _waypoints = Util.get_entities(Waypoint); }
			return _waypoints;
		}

		public static function solidify_units():void
		{
			for each(var unit:Unit in units)
			{
				unit.collidable = true;
			}
		}
	}
}
