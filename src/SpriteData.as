package 
{
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Draw;
	public class SpriteData 
	{
		public var sprite:Spritemap;
		
		public var xorigin:int;
		public var yorigin:int;
		public var bbox_left:int;
		public var bbox_right:int;
		public var bbox_top:int;
		public var bbox_bottom:int;
		public var width:int;
		public var height:int;
		public var frames:int;
		public var xml:Class;
		public var spr:Class;
		
		public function SpriteData(xmlConst:Class, sprClass:Class) 
		{
			xml = xmlConst;
			spr = sprClass;
			
			var myXML:XML = FP.getXML(xmlConst);
			
			xorigin = myXML.xorigin.toString();
			yorigin = myXML.yorigin.toString();
			bbox_left = myXML.bbox_left.toString();
			bbox_right = myXML.bbox_right.toString();
			bbox_top = myXML.bbox_top.toString();
			bbox_bottom = myXML.bbox_bottom.toString();
			width = myXML.width.toString();
			height = myXML.height.toString();
			frames = myXML.num_frames.toString();
		}
		
		public function generate_sprite():Spritemap
		{
			var sprite:Spritemap = new Spritemap(spr, width, height);
			sprite.originX = xorigin;
			sprite.originY = yorigin;
			
			var framesArr:Array = new Array();
			for (var i:int = 0; i < frames; i++)
			{
				framesArr.push(i);
			}
			
			sprite.add("1", framesArr, 30, true);
			
			return sprite;
		}
		
		//Draws the spritedata
		public function draw(x:Number, y:Number, xscale:Number, yscale:Number, angle:Number, color:uint, alpha:Number, frame:int = 0):void
		{
			var sprite:Spritemap = generate_sprite();
			sprite.x = x;
			sprite.y = y;
			sprite.scaleX = xscale;
			sprite.scaleY = yscale;
			sprite.angle = angle;
			sprite.color = color;
			sprite.alpha = alpha;
			sprite.frame = frame;
			
			Draw.graphic(sprite);
		}
		
	}

}