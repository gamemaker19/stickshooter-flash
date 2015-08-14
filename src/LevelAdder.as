package 
{
	import entities.Stickmen.Agent;
	import entities.Wall;
	import net.flashpunk.World;
	import net.flashpunk.FP;
	import net.flashpunk.Entity;
	import entities.*;
	import flash.utils.Dictionary;
	public class LevelAdder 
	{
		[Embed(source = "levels/room3.xml", mimeType = "application/octet-stream")] public static const ROOM3:Class;
		
		public static function set_waypoints(world:World):void
		{
			var waypointList:Array = Util.get_entities(Waypoint);
			var waypointLinkList:Array = Util.get_entities(WaypointLink);

			for each (var waypointLink:WaypointLink in waypointLinkList)
			{
				var waypoint1:Waypoint = null;
				var waypoint2:Waypoint = null;

				var neighbor_waypoints:Array = new Array();
				waypointLink.collideInto("Waypoint",waypointLink.x,waypointLink.y,neighbor_waypoints);

				if(neighbor_waypoints.length != 2)
				{
					if(waypointLink.collide("WaypointLink",waypointLink.x,waypointLink.y) == null && !Util.is_obj(waypointLink, JumpPoint))
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
			            waypoint1.neighbor_to_jp[waypoint2] = waypointLink;
			            //alert(waypoint1.name + " has jump leading to " + waypoint2.name);
			        }
			        else {
			            waypoint2.neighbor_to_jp[waypoint1] = waypointLink;
			            //alert(waypoint2.name + " has jump leading to " + waypoint1.name);
			        }
			    }
			}

			waypoint2 = null;
			
			//Set up neighbors
			for each(var waypoint:Waypoint in Global.waypoints)
			{
			    for each(waypoint2 in Global.waypoints)
			    {
			        //The best neighbor to self is self
			        if(waypoint == waypoint2) {
			            waypoint.dest_to_neighbor[waypoint] = waypoint;
			            continue;
			        }

			        var dest_waypoint:Waypoint = waypoint2;
			        var best_neighbor:Waypoint = null;

			        //Check neighbors. BFS thru all of them. If they can reach the destination waypoint via such a BFS, make them the best neighbor.

			        for each(var neighbor:Waypoint in waypoint.neighbors) {

			            if(neighbor == dest_waypoint) {
			                best_neighbor = neighbor;
			                break;
			            }

			            var can_bfs:Boolean = false;
			            var visited:Dictionary = new Dictionary();  //Map visited nodes to "true"
			            
			            visited[neighbor] = true;
			            visited[waypoint] = true;

			            var visited_queue:Array = new Array();
			            visited_queue.add(neighbor);
			            
			            while(visited_queue.length > 0) {

			                var cur_node:Waypoint = visited_queue[0];
			                visited_queue.delete_first();
			                visited[cur_node] = true;
			                if(cur_node == dest_waypoint) {
			                    can_bfs = true;
			                    best_neighbor = neighbor;
			                    break;
			                }

			                for each(var neighbor2:Waypoint in cur_node.neighbors) {
			                    
			                	if(visited[neighbor2] === undefined)
			                	{
			                		visited_queue.add(neighbor2);
			                	}

			                }

			            }

			            if(can_bfs) {
			                break;
			            }

			        }

			        waypoint.dest_to_neighbor[dest_waypoint] = best_neighbor;

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
				
				var entity:Entity = get_obj(type) as Entity;
				if (entity == null) continue;
				
				switch(type)
				{
					case "wall":
						{
							var is_platform:Boolean = (object.@is_platform == "true" ? true: false);
							(entity as Wall).is_platform = is_platform;
							break;
						}
					case "drop_point":
						{
							var val:Boolean = (object.@is_ladder_dp == "true" ? true: false);
							(entity as DropPoint).is_ladder_dp = val;
							break;
						}
					case "jump_point":
						{
							val = (object.@is_ladder_jp == "true" ? true: false);
							(entity as JumpPoint).is_ladder_jp = val;
							break;
						}
					default: break;
				}

				entity.x = x;
				entity.y = y;
				entity.xscale = scaleX;
				entity.yscale = scaleY;
				entity.color = color;
				entity.angle = rotation;
				world.add(entity);

			}
			
		}
	
		public static function get_obj(key:String):Object
		{
			if (key == "player") return new Agent();
			if (key == "wall") return new Wall();
			if (key == "waypoint") return new Waypoint();
			if (key == "waypoint_link") return new WaypointLink();
			if (key == "drop_point") return new DropPoint();
			if (key == "jump_point") return new JumpPoint();
			return null;
		}
		
	}

}