package 
{
	import entities.Stickmen.Agent;
	import entities.Wall;
	import net.flashpunk.World;
	import net.flashpunk.FP;
	public class LevelAdder 
	{
		[Embed(source = "levels/room3.xml", mimeType = "application/octet-stream")] public static const ROOM3:Class;
		
		public static function Add(world:World, level:Class):void
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