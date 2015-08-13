package 
{
	import entities.Projectile;
	import SpriteData;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Draw;
	import entities.Wall;
	import entities.Infantry;
	import entities.Bullet;
	import entities.Decal;
	import net.flashpunk.FP;
	
	public class Base extends Entity
	{
		//var sprite:SpriteData;
		
		public var children:Vector.<IChild>;
		public var parent:Base;
		public var current_sprite:SpriteData;
		
		public function Base()
		{
			super();
			children = new Vector.<IChild>();
		}
		
		public override function update():void
		{
			super.update();
			show_sprite();
		}
		
		public function set_sprite(value:SpriteData, rate:Number = 1):void
		{
			current_sprite = value;
			image_speed = rate;
		}
		
		public function show_sprite():void
		{
			if (current_sprite == null) return;
			
			if (!(current_sprite in graphic_dict))
			{
				graphic_dict[current_sprite] = current_sprite.generate_sprite();
			}
			if(graphic != graphic_dict[current_sprite]) { graphic = graphic_dict[current_sprite]; }
			
			var sm:Spritemap = (graphic as Spritemap);
				
			var img:Image = graphic as Image;
			
			img.scaleX = xscale;
			img.scaleY = yscale;
			img.angle = angle;
			
			setOrigin(current_sprite.xorigin * xscale, current_sprite.yorigin * yscale);
			
			if (!const_hitbox)
			{
				setHitbox(
					(current_sprite.bbox_right - current_sprite.bbox_left) * Math.abs(xscale), 
					(current_sprite.bbox_bottom - current_sprite.bbox_top) * Math.abs(yscale), 
					(current_sprite.bbox_left + current_sprite.xorigin) * Math.abs(xscale),
					(current_sprite.bbox_top + current_sprite.yorigin) * Math.abs(yscale)
				);
			}
			else
			{
				setHitbox(
					const_hitbox_w * Math.abs(xscale),
					const_hitbox_h * Math.abs(yscale),
					const_hitbox_x * Math.abs(xscale),
					const_hitbox_y * Math.abs(yscale)
				);
			}
			
			//sm.rate = rate;
			sm.play("1", false, 0);
		}
		
		override public function render():void 
		{
			super.render();
			//Draw.hitbox(this,true);
		}
		
		
		public function is_above_platform(wall:Wall):Boolean
		{
			//Climbing/fallthru stickmen go thru platforms
			
			/*
			 * TODO FIX THIS
			if(is_a(obj_stickman)) {
				if(state == CLIMB || trigger_fallthrough) {
					return false;
				}
			}
			*/

			if(wall.is_diagonal) {
				return above_diag(wall);
			}
			else {
				return y+(Math.abs(height)/2)-1 <= wall.y; 
			}
		}
		
		public function above_diag(diag_wall:Wall):Boolean
		{
			var cx:Number = x;
			var cy:Number = y + Math.abs(height)/2;

			var dx:Number = diag_wall.x;
			var dy:Number = diag_wall.y;

			var dwidth:Number = diag_wall.thickness;
			var dir:int;
			var hypotenuse:Number = diag_wall.length;

			var dangle:Number = diag_wall.angle;
			if(dangle < 90) {
				dir = -1;
			}
			else {
				dir = 1;
				dangle = 180 - dangle;
			}

			var yslope:Number = hypotenuse * Math.sin(dangle * FP.RAD);
			var xslope:Number = hypotenuse * Math.cos(dangle * FP.RAD);

			var slope:Number = dir * (yslope / xslope);
			var b:Number = dy - slope*dx;

			//y = mx + b

			if(cy < slope*cx + b) {
				return true;
			}

			return false;
		}
		
		
		public function change_sprite():void
		{
			
		}
		
		/*
		public function on_hit(proj:Projectile, x:int, y:int):void
		{
			FP.world.remove(proj);
			Decal.CreateBlood(x, y);
		}
		*/
		
	}

}