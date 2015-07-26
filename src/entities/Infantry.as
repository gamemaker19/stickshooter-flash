package entities 
{
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Mask;
	import net.flashpunk.masks.Grid;
	import net.flashpunk.FP;
	public class Infantry extends Unit
	{
		//Pseudo-states
		public var is_down:Boolean = false;    //Set to true if KO'd or dead
		public var is_jumping:Boolean = false;
		public var prev_jumping:Boolean = false;
		public var is_crouching:Boolean = false;
		public var prev_crouch:Boolean = false;
		public var is_crawling:Boolean = false;
		public var is_burning:Boolean = false;
		public var is_wall_sliding:Boolean = false;
		public var is_running:Boolean = false;
		
		//Jumping
		public var jump_boost_frames:int = 0;
		public var max_jump_boost_frames:int = 7;
		public var can_boost_jump:Boolean = false;
		public var jump_speed:Number = 20;
		public var jump_boost:Number = 2;
		
		public var run_speed:Number = 12;
		public var walk_speed:Number = 6;
		public var crouch_speed:Number = 2;
		
		public var idle_sprite:SpriteData;
		public var walk_sprite:SpriteData;
		public var run_sprite:SpriteData;
		public var jump_sprite:SpriteData;
		public var fall_sprite:SpriteData;
		public var crouch_sprite:SpriteData;
		
		public var arms:Arms;
		
		public function get head_x():Number { return x; }
		public function get head_y():Number { return y - 35; }
		public function get arm_x():Number { return x; }
		public function get arm_y():Number { return y - 27; }
		public function get foot_x():Number { return x; }
		public function get foot_y():Number { return y + 35; }

		/*
		public var weapons:Vector.<Weapon>;
		public int weapon_index;
		
		public function get weapon():Weapon { return weapons[weapon_index]; }
		*/
		
		public function Infantry() 
		{
			arms = new Arms();
			FP.world.add(arms);
			children.push(arms);
		}
		
		public function can_jump():Boolean
		{
			return true;
		}
		
		override public function update():void
		{
			super.update();
		}
		
		override public function change_sprite():void
		{
			if (is_grounded) {
				
				if(is_crouching) {
					set_sprite(crouch_sprite, 0.45);
					arms.to_crouch();
				}
				else {
					if (move_x == 0) {
						set_sprite(idle_sprite);
						arms.to_idle();
					}
					else if(is_running) {
						set_sprite(run_sprite, 0.5);
						arms.to_run();
					}
					else {
						set_sprite(walk_sprite, 0.5);
						arms.to_walk();
					}
				}

				if(move_x == 0) {
					(graphic as Spritemap).frame = 0;
					(graphic as Spritemap).rate = 0;
					(arms.graphic as Spritemap).frame = 0;
					(arms.graphic as Spritemap).rate = 0;
				}

			}
			else {

				if(is_jumping) {
					set_sprite(jump_sprite);
					arms.to_jump();
				}
				else {
					set_sprite(fall_sprite);
					arms.to_fall();
				}
			}
		}
		
		override public function pre():void
		{
			move_x = 0;
			move_y = 0;
			
			prev_jumping = is_jumping;
			prev_crouch = is_crouching;
			
			if (is_grounded) {
				is_jumping = false;
			}
			
			super.pre();
		}
		
		override public function step():void
		{
			set_motion();
			change_sprite();
			super.step();
		}
		
		override protected function get_move_x():Number
		{
			return move_x;
		}
		
		override protected function get_move_y():Number
		{
			return move_y;
		}
		
		private function set_motion():void
		{
			//Movement section
			move_x = -(ctl.trigger_left ? 1 : 0) + (ctl.trigger_right ? 1 : 0);
			is_running = ctl.trigger_run;
			is_crouching = ctl.trigger_crouch;
			
			if (is_running) {
				move_x *= run_speed;
			}
			else if (is_crouching) {
				move_x *= crouch_speed;
			}
			else {
				move_x *= walk_speed;
			}
			
			if (ctl.trigger_jump) {
				if (can_jump() && is_grounded) {
					vel_y = -jump_speed;
					is_jumping = true;
					can_boost_jump = false;
					is_grounded = false;
				}
			}
			
			if(ctl.trigger_jump_hold) {
				if(is_jumping) {
					if(!prev_jumping) {
						can_boost_jump = true;
					}
					if(can_boost_jump) {
						vel_y -= jump_boost;
						jump_boost_frames++;
						if(jump_boost_frames > max_jump_boost_frames) {
							can_boost_jump = false;
							jump_boost_frames = 0;
						}
					}
				}
			}
			else {
				if(can_boost_jump) {
					can_boost_jump = false;
				}
			}
			
			if(vel_y > 0 && is_jumping) {
				is_jumping = false;
				jump_boost_frames = 0;
			}
		}
		
		
	}

}

