package entities 
{
	import Base;
	import SpriteData;
	import Sprites;
	import Util;
	import net.flashpunk.graphics.Emitter;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Draw;
	public class Decal extends Base
	{
		public static var REGULAR:int = 0;
		public static var ONE_SHOT:int = 1;
		public static var PARTICLE:int = 2;
		
		private var is_one_shot:Boolean = false;
		private var decalType:int = 0;
		private var emitter:Emitter;
		private var particle:String;
		
		public function Decal(ax:int, ay:int, atype:int = 0, sprite:SpriteData = null, aparticle:String = "") 
		{
			super();
			x = ax;
			y = ay;
			decalType = atype;
			current_sprite = sprite;
			if (decalType == PARTICLE)
			{
				particle = aparticle;
				set_particle_type();
			}
		}
		
		public static function CreateBlood(ax:int, ay:int):void
		{
			var spriteData:SpriteData;
			var rand:int = Util.irandom_range(1, 10);
			if (rand == 1) spriteData = Sprites.blood_p2;
			else if (rand == 2) spriteData = Sprites.blood_p3;
			else if (rand == 3) spriteData = Sprites.blood_p4;
			else if (rand == 4) spriteData = Sprites.blood_p5;
			else if (rand == 5) spriteData = Sprites.blood_p6;
			else if (rand == 6) spriteData = Sprites.blood_p7;
			else if (rand == 7) spriteData = Sprites.blood_p8;
			else if (rand == 8) spriteData = Sprites.blood_p9;
			else if (rand == 9) spriteData = Sprites.blood_p10;
			else if (rand == 10) spriteData = Sprites.blood_p1;
			
			var blood:Decal = new Decal(ax, ay, ONE_SHOT, spriteData);
			FP.world.add(blood);
		}
		
		public static function CreateSparks(ax:int, ay:int):void
		{
			var spriteData:SpriteData;
			var rand:int = Util.irandom_range(1, 9);
			if (rand == 1) spriteData = Sprites.spark_p1;
			else if (rand == 2) spriteData = Sprites.spark_p2;
			else if (rand == 3) spriteData = Sprites.spark_p3;
			else if (rand == 4) spriteData = Sprites.spark_p4;
			else if (rand == 5) spriteData = Sprites.spark_p5;
			else if (rand == 6) spriteData = Sprites.spark_p6;
			else if (rand == 7) spriteData = Sprites.spark_p7;
			else if (rand == 8) spriteData = Sprites.spark_p8;
			else if (rand == 9) spriteData = Sprites.spark_p9;
			
			var sparks:Decal = new Decal(ax, ay, ONE_SHOT, spriteData);
			FP.world.add(sparks);
		}
		
		private function set_particle_type():void
		{
		}
		
		public override function update():void
		{
			super.update();
			
			if (decalType == ONE_SHOT)
			{
				if((graphic as Spritemap).frame == (graphic as Spritemap).frameCount-1)
					FP.world.remove(this);
			}
			/*
			else if (decalType == PARTICLE)
			{
				if (!once)
				{
					once = true;
					emitter.emit(particle, 0, 0);
				}
			}
			*/
		}
		
		public override function render():void
		{
			super.render();
			//Draw.circle(x, y, 10, 0x00FF00);
		}
		
	}

}