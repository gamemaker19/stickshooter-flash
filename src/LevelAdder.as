package 
{
	import entities.Stickmen.Agent;
	import entities.Wall;
	import net.flashpunk.World;
	import net.flashpunk.FP;
	public class LevelAdder 
	{
		[Embed(source = "levels/room3.xml", mimeType = "application/octet-stream")] public static const ROOM3:Class;
		
		public static function set_waypoints(world:World)
		{
			var waypointList:Array = Util.get_entities(Waypoint);
			var waypointLinkList:Array = Util.get_entities(WaypointLink);

			for each (var waypointLink:WaypointLink in waypointLinkList)
			{
				var waypoint1:Waypoint = null;
				var waypoint2:Waypoint = null;

				var neighbor_waypoints:Array = new Array();
				collides("Waypoint",x,y,neighbor_waypoints);

				if(neighbor_waypoints.length != 2)
				{
					if(collide("WaypointLink",x,y) == null && !Util.is_obj(waypointLink, JumpPoint))
					{
						throw new Error("Error: there's a waypoint link not linking exactly two neighbors");
					}
					continue;
				}

				waypoint1 = neighbor_waypoints[0]
		    waypoint2 = neighbor_waypoints[1];

		    waypoint1.neighbors.add(waypoint2);
		    waypoint2.neighbors.add(waypoint1);

		    if(Util.is_obj(waypointLink,JumpPoint)) {
		        if(waypoint1.y > waypoint2.y) {
		            waypoint1.neighbor_to_jp[waypoint2] = id;
		            //alert(waypoint1.name + " has jump leading to " + waypoint2.name);
		        }
		        else {
		            waypoint2.neighbor_to_jp[waypoint1] = id);
		            //alert(waypoint2.name + " has jump leading to " + waypoint1.name);
		        }
		    }

			}
		}  

		public static function add(world:World, level:Class):void
		{
			var myXML:XML = FP.getXML(level);
			
			for each(var object:XML in myXML.objects.object)
			{
				var type:String = object.@type;
				var x:int = int(object.@x);
				var y:int = int(object.@y);
				var scaleX:Number = Number(object.@scaleX);
				var scaleY:Number = Number(object.@scaleY);
				var color:Number = Number(object.@color);
				var rotation:Number = Number(object.@rotation);
				
				switch(type)
				{
					case "player":
						{
							var agent:Agent = new Agent();
							agent.x = x;
							agent.y = y;
							agent.xscale = scaleX;
							agent.yscale = scaleY;
							agent.color = color;
							agent.angle = rotation;
							world.add(agent);
							break;
						}
					case "wall":
						{
							var is_platform:Boolean = (object.@is_platform == "true" ? true: false);
							var wall:Wall = new Wall();
							wall.x = x;
							wall.y = y;
							wall.xscale = scaleX;
							wall.yscale = scaleY;
							wall.color = color;
							wall.angle = rotation;
							wall.is_platform = is_platform;
							world.add(wall);
							break;
						}
					default: break;
				}
			}
			
		}
		
	}

}