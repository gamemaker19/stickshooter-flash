package entities 
{
	import IChild;
	import Base;
	import Sprites;
	public class Headwear extends Base implements IChild
	{
		public static var BODYGUARD_GRAY:int = 0;
		public static var BODYGUARD_GOLD:int = 5;
		public static var DARKAGENT:int = 1;
		public static var ELITE:int = 2;
		public static var POLICE:int = 3;
		public static var BOSS:int = 4;
		
		public var htype:int = 0;
		
		public function Headwear(atype:int) 
		{
			super();
			htype = atype;
		}
		
		public override function update():void
		{
			switch(htype)
			{
				case BODYGUARD_GRAY:
					set_sprite(Sprites.bodyguard_helmet_gray);
					break;
				case BODYGUARD_GOLD:
					set_sprite(Sprites.bodyguard_helmet_gold);
					break;
				case DARKAGENT:
					set_sprite(Sprites.agent_head);
					break;
				case ELITE:
					set_sprite(Sprites.elite_head);
					break;
				case POLICE:
					set_sprite(Sprites.police_head);
					break;
				case BOSS:
					set_sprite(Sprites.boss_head);
					break;
			}
		}
		
		public function update_position(host:Base):void
		{
			var ihost:Infantry = host as Infantry;
			x = ihost.head_x;
			y = ihost.head_y;
			dir = ihost.dir;
		}
		
	}

}