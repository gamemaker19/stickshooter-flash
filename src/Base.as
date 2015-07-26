package 
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Draw;
	import entities.Wall;
	public class Base extends Entity
	{
		//var sprite:SpriteData;
		
		public var children:Vector.<IChild>;
		
		public function Base()
		{
			super();
			children = new Vector.<IChild>();
		}
		
		public function set_sprite(value:SpriteData, rate:Number = 1):void
		{
			if (!(value in graphic_dict))
			{
				graphic_dict[value] = value.generate_sprite();
			}
			if(graphic != graphic_dict[value]) { graphic = graphic_dict[value]; }
			
			var sm:Spritemap = (graphic as Spritemap);
				
			var img:Image = graphic as Image;
			
			img.scaleX = xscale;
			img.scaleY = yscale;
			img.angle = angle;
			img.originX = value.xorigin;
			img.originY = value.yorigin;
			
			setOrigin(value.xorigin * xscale, value.yorigin * yscale);
			if (dir == -1) { img.scaleX = -Math.abs(img.scaleX); }
			else { img.scaleX = Math.abs(img.scaleX); }
			
			if (!const_hitbox)
			{
				setHitbox(
					(value.bbox_right - value.bbox_left) * xscale, 
					(value.bbox_bottom - value.bbox_top) * yscale, 
					(value.bbox_left + value.xorigin) * xscale,
					(value.bbox_top + value.yorigin) * yscale
				);
			}
			else
			{
				setHitbox(
					const_hitbox_w * xscale,
					const_hitbox_h * yscale,
					const_hitbox_x * xscale,
					const_hitbox_y * yscale
				);
			}
			
			sm.rate = rate;
			sm.play("1", false, 0);
		}
		
		override public function render():void 
		{
			super.render();
			//Draw.hitbox(this,true);
		}
		
		public function is_above_platform(wall:Wall):Boolean
		{
			return false;
		}
		
		public function change_sprite():void
		{
			
		}
		
	}

}