package
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import entities.*; 

	public class Global
	{
		public static var debug_toogle:Boolean = false;
		
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
		
		private static var _squad:Squad = null;
		static public function get squad():Squad 
		{
			if (_squad == null) _squad = new Squad();
			return _squad;
		}
	}
}
