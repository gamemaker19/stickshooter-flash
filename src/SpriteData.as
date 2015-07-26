package 
{
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
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
			
			var framesArr:Array = new Array();
			for (var i:int = 0; i < frames; i++)
			{
				framesArr.push(i);
			}
			
			sprite.add("1", framesArr, 30, true);
			
			return sprite;
		}
		
	}

}