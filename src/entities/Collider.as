package entities 
{
	import Base;
	import Constants;
	import IChild;
	import Util;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	
	public class Collider extends Base
	{
		public var vel_x:Number = 0;
		public var vel_y:Number = 0;
		
		public var is_grounded:Boolean = false;
		public var grounded_obj:Object;
		public var is_solid:Boolean = true;
		public var is_solid_collider:Boolean = true;
		public var is_floating:Boolean = false;
		
		public var num_bounces:int = 0;
		
		public var bounciness:Number = 0;	//0 is none, 1 is objects bounce their height, 2 is objects bounce double their height, etc.
		public var friction:Number = 0; 	//1 is none, 0 is objects stop immediately
		
		public function Collider()
		{
			type = "WallCol";
		}
		
		private function get_next_x(net_vel_x:Number):Number
		{
			if (net_vel_x > 0)
			{
				return Math.ceil(x + Util.sign(net_vel_x));
			}
			else
			{
				return Math.floor(x + Util.sign(net_vel_x));
			}
		}
		
		private function get_dest_x(net_vel_x:Number):Number
		{
			if (net_vel_x > 0)
			{
				return Math.ceil(x + net_vel_x);
			}
			else
			{
				return Math.floor(x + net_vel_x);
			}
		}
		
		private function get_next_y(net_vel_y:Number):Number
		{
			if (net_vel_y > 0)
			{
				return Math.ceil(y + Util.sign(net_vel_y));
			}
			else
			{
				return Math.floor(y + Util.sign(net_vel_y));
			}
		}
		
		private function get_dest_y(net_vel_y:Number):Number
		{
			if (net_vel_y > 0)
			{
				return Math.ceil(y + net_vel_y);
			}
			else
			{
				return Math.floor(y + net_vel_y);
			}
		}
		
		protected function get_move_x():Number
		{
			return 0;
		}
		
		protected function get_move_y():Number
		{
			return 0;
		}
		
		private function can_fall():Boolean
		{
			return true;
		}
		
		public function pre():void
		{
			is_grounded = false;
			grounded_obj = null;
			
			if(collidable && vel_y >= 0) {
				
				var ehit:Entity = this.world.collideLine("WallCol", left, bottom, right, bottom);
				
				if (is_obj(ehit,Wall))
				{
					var wall:Wall = ehit as Wall;
					
					if (wall.is_platform || is_above_platform(wall))
					{
						if (!(wall.is_diagonal && Util.is_angle_steep(wall.angle)))
						{
							is_grounded = true;
							grounded_obj = wall;
						}
					}
				}
				else if (is_obj(ehit, Collider))
				{
					var col:Collider = ehit as Collider;
					if (is_solid_collider && is_solid && col.is_solid && col.is_solid_collider)
					{
						is_grounded = true;
						grounded_obj = col;
					}
				}
				
			}
		}
		
		public function step():void
		{
			
		}
		
		public function post():void
		{
			if (collidable)
			{
				check_collision();
			}
			
			//Go thru all colliders, update their positions
			for each(var child:IChild in children)
			{
				child.update_position(this);
			}
			
		}
		
		override public function update():void
		{
			super.update();
			pre();
			step();
			post();
		}
		
		private function check_collision():void
		{
			var times:int = 0;
			var net_vel_x:Number = vel_x + get_move_x();
			var net_vel_y:Number = vel_y + get_move_y();
				
			if (vel_y < Constants.MAX_FALL_SPEED && can_fall())
			{
				vel_y += Constants.GRAVITY;
			}
			
			var orig_net_vel_x:Number = net_vel_x;
			var orig_net_vel_y:Number = net_vel_y;
			
			if(Math.abs(net_vel_x) > 0) {

				var hit_xs:Array = new Array();
				collideInto("WallCol", get_dest_x(net_vel_x), y, hit_xs);
				
				for each(var hit_x:Object in hit_xs)
				{
					if(net_vel_x == 0) continue;

					if(is_obj(hit_x,Wall)) {

						var wall_x:Wall = hit_x as Wall;

						var either_not_a_platform_or_a_steep_diagonal_platform:Boolean = 
							!wall_x.is_platform || wall_x.is_diagonal && Util.is_angle_steep(wall_x.angle);

						//non-diagonal platforms don't have x collision
						if(either_not_a_platform_or_a_steep_diagonal_platform)
						{
							var should_do:Boolean = false;
							if(!wall_x.is_diagonal) {
								should_do = true;
							}
							else {

								if(wall_x.is_platform) {
									if(is_above_platform(wall_x)) {
										should_do = true;
									}
								}
								else {
									should_do = true;
								}

							}

							//Diagonal platforms won't cause x to be pushed unless if not above
							if(should_do)
							{
								times = 0;
								
								while (collide("WallCol", get_next_x(net_vel_x), y) == null)
								{
									x += Util.sign(net_vel_x);
									times++; if(times > Math.abs(net_vel_x)*2) { break; }
									if(times > 100) { Util.alert("INFINITE LOOP AT COLLIDER_STEP NEAR LINE 170"); break; }
								}
								
								net_vel_x = Util.get_bounciness(net_vel_x, this, wall_x);
								vel_x = net_vel_x;
								num_bounces++;

							}

						}

					}
					else if(is_solid_collider && is_obj(hit_x,Collider) && hit_x.is_solid_collider) {
						
						var col_x:Collider = hit_x as Collider;

						if(is_obj(col_x,Unit) && is_a(Unit) && (this as Unit).alliance == (col_x as Unit).alliance) {

						}
						else if (net_vel_x != 0) {
							
							times = 0;
							
							while (collide("Collider", get_next_x(net_vel_x), y) == null)
							{
								x += Util.sign(net_vel_x);
								times++; if(times > Math.abs(net_vel_x)*2) { break; }
								if(times > 100) { Util.alert("INFINITE LOOP AT COLLIDER_STEP AT LINE 215"); break; }
							}
							
							net_vel_x = Util.get_bounciness_cols(net_vel_x, this, col_x);
							vel_x = net_vel_x;
							num_bounces++;
						}
					}

				}

				x += net_vel_x;

			}
			
			if(Math.abs(net_vel_y) > 0 || Math.abs(orig_net_vel_x) > 0) {
				
				var hit_ys:Array = new Array();
				collideInto("WallCol", x, get_dest_y(net_vel_y), hit_ys);
				
				for each(var hit_y:Object in hit_ys) {
					
					if(is_obj(hit_y,Wall)) {
						
						var wall_y:Wall = hit_y as Wall;

						if (net_vel_y > 0 && wall_y.is_platform)
						{
							var b:int = 0;
						}
						
						//For non-platforms, or if above a platform,
						if(!wall_y.is_platform || is_above_platform(wall_y))
						{
							times = 0;

							//If diagonal, only enact if above
							if(wall_y.is_diagonal && Util.is_angle_steep(wall_y.angle) && is_above_platform(wall_y)) {
								var ratio:Number = Math.abs(Math.tan(wall_y.angle));
								if(Util.is_angle_down(wall_y.angle)) {
									x+=net_vel_y*(1/ratio);
								}
								else {
									x-=net_vel_y*(1/ratio);
								}
							}
							else {
								
								while (collide("WallCol", x, get_next_y(net_vel_y)) == null)
								{
									times++; 
									if(times > Math.abs(net_vel_y)) { break; }
									if(times > 100) { Util.alert("INFINITE LOOP AT COLLIDER_STEP NEAR LINE 248"); break; }
									y += Util.sign(net_vel_y);
								}
								
								vel_y = Util.get_bounciness(vel_y, this, wall_y);
								net_vel_y = vel_y;

								vel_x *= Util.get_friction(this, wall_y);
								num_bounces++;
							}

						}
					}
					else if(is_obj(hit_y,Collider) && is_solid_collider && hit_y.is_solid_collider) {
						
						var col_y:Collider = hit_y as Collider;

						//Soft collide with allies
						if(is_a(Unit) && is_obj(col_y,Unit) && (this as Unit).alliance == (col_y as Unit).alliance) {
							
						}
						else {
							
							times = 0;
							
							while (collide("WallCol", x, get_next_y(net_vel_y)) == null)
							{
								times++; 
								if(times > Math.abs(net_vel_y)) { break; }
								if(times > 100) { Util.alert("INFINITE LOOP AT COLLIDER_STEP NEAR LINE 248"); break; }
								y += Util.sign(net_vel_y);
							}
							
							vel_y = Util.get_bounciness_cols(vel_y, this, col_y);
							net_vel_y = vel_y;
							num_bounces++;
							vel_x *= Util.get_friction_cols(this, col_y);
							break;
						}

					}   

				}

				y += net_vel_y;

			}
			
			
			//This section frees objects stuck in walls. It's commented out due to performance concerns.
			/*
			if(is_solid && is_solid_collider) {

				//Disable player's weapon/armor/helmet if they have one
					
				if(is_a(obj_stickman)) {
					move_attachments_away();
				}

				var prelim_check = place_meeting(x,y,obj_wall_col);

				if(prelim_check) {
					
					var walls = instance_place_all(x,y,obj_wall_col);

					if(ds_list_size(walls) > 0) {

						var max_left = 100000000;
						var max_right = -1;
						var max_top = 100000000;
						var max_bottom = -1;

						var left_wall = noone;
						var right_wall = noone;
						var top_wall = noone;
						var bottom_wall = noone;

						var any = false;

						for(var i=0;i<ds_list_size(walls);i++) {
							
							var wall = ds_list_find_value(walls,i);

							if(is_obj(wall,obj_collider) && !wall.is_solid_collider) continue;
							if(is_obj(wall,obj_wall) && wall.is_platform) continue;
							if(is_obj(wall,obj_wall_diag)) continue;

							//Soft collide with allies
							if(is_obj(wall,obj_stickman) && is_a(obj_stickman) && alliance == wall.alliance)
							{
								var push_dir;
								if(wall.x > x) {
									push_dir = -1;
								}
								else {
									push_dir = 1;
								}
								x += push_dir;
								continue;
							}

							any = true;

							var left = abs(wall.bbox_left - x);
							var right = abs(wall.bbox_right - x);
							var top = abs(wall.bbox_top - y);
							var bottom = abs(wall.bbox_bottom - y);

							if(left < max_left) {
								max_left = left;
								left_wall = wall;
							}
							if(right > max_right) {
								max_right = right;
								right_wall = wall;
							}
							if(top < max_top) {
								max_top = top;
								top_wall = wall;
							}
							if(bottom > max_bottom) {
								max_bottom = bottom;
								bottom_wall = wall;
							}

						}

						if(any) {

							//alert("STUCK")
							//alert("max_left: " + string(max_left));
							//alert("max_right: " + string(max_right));
							//alert("max_top: " + string(max_top));
							//alert("max_bottom: " + string(max_bottom));

							var min_dist = min(max_left,max_right,max_top,max_bottom);

							if(min_dist == max_left) {
								//alert("FREE LEFT")
								var bbox_width = bbox_right - bbox_left;
								set_bbox_left(left_wall.bbox_left - bbox_width - 1);
							}
							else if(min_dist == max_right) {
								//alert("FREE RIGHT")
								var bbox_width = bbox_right - bbox_left;
								set_bbox_left(right_wall.bbox_right + 1);
							}
							else if(min_dist == max_top) {
								//alert("FREE TOP")
								var bbox_height = bbox_bottom - bbox_top;
								set_bbox_top(top_wall.bbox_top - bbox_height - 1);
							}
							else if(min_dist == max_bottom) {
								//alert("FREE BOT")
								var bbox_height = bbox_bottom - bbox_top;
								set_bbox_top(bottom_wall.bbox_bottom + 1);
							}

						}

					}

					ds_list_destroy(walls);

				}

				if(is_a(obj_stickman)) {
					move_attachments_back();
				}

			}
			*/
		}
	}

}