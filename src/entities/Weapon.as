package entities 
{
	import Base;
	import SpriteData;
	import Sprites;
	import IChild;
	import Util;
	import net.flashpunk.FP
	public class Weapon extends Collider implements IChild
	{
		/*
		public var click_sound:Number = noone; 	//Plays when no ammo
		public var fire_sound_index:Number = noone;
		public var fire_sound:Number = noone; 
		*/
		
		public var depth:int = -10; 
		public var weight:int = 1; //A weight of 0 means you can't move or jump at all. 
		public var owner_vel_x:Number = 0;
		public var owner_vel_y:Number = 0; 
		public var weapon_name:String = "<Weapon Name Here>"
		public var reload_time:Number = 1; 
		public var muzzle_flash_sprite:SpriteData = Sprites.muzzle_flash; 
		public var muzzle_angle:Number = 10;
		public var muzzle_dist:Number = 10; 
		public var offset_x:Number = 0;
		public var offset_y:Number = 0; 
		public var cooldown_time:Number = 0;
		public var max_cooldown_time:Number = 0.5;
		public var use_recoil:Boolean = true;
		public var recoil_mag:Number = 5;
		public var recoil_time:Number = 0.15; 
		public var accuracy:Number = 1;   //0 = most accurate, 90 = least accurate 
		public var clip:Number = 10;
		public var clip_size:Number = 10; 
		public var ammo:Number = 30;  	//Ammo does NOT include the current clip
		public var max_ammo:Number = 30; 
		public var is_hitscan:Boolean = false;
		public var is_automatic:Boolean = false;
		public var is_burst:Boolean = false;
		public var headshot_modifier:Number = 1;    //Headshot damage modifier (multiplies damage). 1 means can't headshot 
		public var muzzle_flash_frames:Number = 0; 
		public var damage:Number = 5;
		public var is_single_shot:Boolean = true;  //used for drawing different bullets 
		public var bullet_speed:Number = 200; 
		public var num_bullets:Number = 1; 
		public var projectile:Class;
		public var can_zoom:Boolean = false;
		public var zoom:Number = 0;
		public var zoom_distance:Number = 0; 
		public var y_origin_offset:Number = 0;    //Some weapons, such as the minigun and flamethrower, have the sight line lower than the default stickman's arm_y value 
		public var x_mod:Number = 0;
		public var y_mod:Number = 0;
		
		public function get owner():Infantry
		{
			return (parent as Infantry);
		}
		
		public function Weapon() 
		{
			super();
			is_solid_collider = false;
		}
		
		public function get muzzle_x():Number
		{
			if(owner == null) {
				return NaN;
			}
			var x_off:Number = 30 * Math.cos(angle * FP.RAD);
			var m_off_x:Number = Math.cos((owner.look_angle+(muzzle_angle*owner.dir)) * FP.RAD) * muzzle_dist;
			return x+x_off+m_off_x;
		}

		public function get muzzle_y():Number
		{
			if(owner == null) {
				return NaN;
			}
			var y_off:Number = 30*Math.sin(angle * FP.RAD);
			var m_off_y:Number = Math.sin((owner.look_angle+(muzzle_angle*owner.dir)) * FP.RAD) * muzzle_dist;
			return y+y_off+m_off_y;
		}
		
		public override function update():void
		{
			super.update();
		}
		
		public override function step():void
		{
			if (owner == null)
			{
				collidable = true;
				return;
			}
			
			collidable = false;
			
			x = owner.arm_x + offset_x;
			y = owner.arm_y + offset_y;

			xscale = 1;
			yscale = owner.dir;

			var ox:int = owner.arm_x;
			var oy:int = owner.arm_y + y_origin_offset;

			angle = owner.look_angle;

			x_mod = 30*Math.cos(angle * FP.RAD);
			y_mod = 30*Math.sin(angle * FP.RAD);

			x = owner.arm_x + offset_x;
			y = owner.arm_y + offset_y;
			
			if(cooldown_time > 0) {
				cooldown_time += FP.elapsed;
				if(cooldown_time > max_cooldown_time) {
					cooldown_time = 0;
					//if(is_a(obj_shotgun)) {
					//	stop_weapon_sound(pump_sound);
					//	pump_sound = noone;
					//}
				}
				//if(is_a(obj_shotgun) && cooldown_time > 0.5 && pump_sound == noone) {
				//	pump_sound = play_sound(snd_shotgun_pump,x,y);
				//}
			}
			
			if (owner.fire_weapon)
			{
				owner.fire_weapon = false;
			
				if (cooldown_time != 0) { return; }
			
				if(clip <= 0) { 
					//stop_weapon_sound(); 
					if (ammo <= 0 && owner.no_ammo_time == 0) { owner.no_ammo_time += FP.elapsed; }
					
					/*
					if (!mouse_check_button_pressed(0)) && ((click_sound == noone || !audio_is_playing(click_sound)) ) {
						first_time_click = true;
						click_sound = play_sound(snd_no_ammo,x,y); 
					}
					*/
					return; 
				}

				if(cooldown_time == 0) {
					//alert_enemies(owner.alliance, owner.x, owner.y, 2000);
				}

				muzzle_flash_frames = 1;
				//if(!is_obj(owner,obj_player) || !owner.bottomless_clip) clip -= 1;
				clip -= 1;
				cooldown_time += FP.elapsed;

				/*
				if(is_a(obj_flamethrower)) {
					if(fire_sound == noone) {
						fire_sound = play_sound(fire_sound_index,x,y);
					}
				}
				else {
					if(fire_sound_index != noone) {
						play_sound(fire_sound_index,x,y);
					}
				}
				*/

				for(var i:int=0;i<num_bullets;i++) {
					var bullet:Projectile = FP.world.create(projectile) as Projectile;
					bullet.x = muzzle_x;
					bullet.y = muzzle_y;
					bullet.owner = owner;
					bullet.weapon = this;
					bullet.is_hitscan = is_hitscan;
					bullet.damage = damage;
					
					/*
					if(is_obj(bullet,obj_rocket)) { 
						start_y = bullet.y;
					}
					if(is_obj(bullet,obj_rocket) && is_obj(owner,obj_player) && !owner.trigger_alt_attack) {
						bullet.explode_on_platform = true;
					}
					if(is_obj(owner,obj_player) && obj_cursor.target_aquired) {
						bullet.aim_bonus = true;
					}
					else if(is_obj(owner,obj_enemy)) {
						bullet.aim_bonus = (irandom_range(0,1 + owner.vigor*5) == 1);
					}
					
					if(is_a(obj_flamethrower)) {
						bullet.init_vel_x = owner_vel_x;
						bullet.init_vel_y = -owner_vel_y;
					}

					if(is_a(obj_bow)) {
						bullet.arrow_speed_modifier = bow_pull_time / max_bow_pull_time;
						bullet.damage *= (0.5 + (bow_pull_time / max_bow_pull_time));
						bow_pull_time = 0;
					}
					*/
					
					var accuracy_offset:Number = Util.random_range(-accuracy,accuracy);
					var enemy_offset:Number = 0;
					
					/*
					if(is_obj(owner,obj_enemy)) {
						enemy_offset = Util.random_range(-10*owner.vigor,10*owner.vigor);
					}
					*/

					bullet.angle = owner.look_angle + accuracy_offset + enemy_offset;

				}
				
				/*
				//Before doing the raycast, make all allies not solid so they can shoot thru
				with(obj_stickman) {
					if(alliance == other.owner.alliance) {
						is_solid = false;
					}
				}
				var prospective_hit_arr = raycast_def(muzzle_pos[0],muzzle_pos[1],owner.look_angle,RAYCAST_MAX);
				with(obj_stickman) {
					is_solid = true;
				}

				var pe = prospective_hit_arr[0];

				if(is_obj(pe,obj_enemy) && pe.enemy_type >= 4 && pe.is_controllable) {

					var r = 100;

					if(pe.enemy_type == 4) r = irandom_range(0,1);
					else if(pe.enemy_type == 5) r = 0;
					else if(pe.enemy_type == 6) r = irandom_range(0,1);
					
					if(r == 0) {
						pe.state = pe.DODGE;
						pe.dodge_time = dtime();
					}

				}
				*/

			}
			else {
				/*
				stop_weapon_sound();

				if(is_a(obj_minigun)) {
				}
				else if(is_a(obj_flamethrower)) {
					//part_emitter_clear(fire_particle_system,fire_particle_emitter);
				}
				*/
			}
			
		}
		
		public function update_position(host:Base):void
		{
			var ihost:Infantry = host as Infantry;
			x = ihost.arm_x;
			y = ihost.arm_y;
			dir = ihost.dir;
		}
		
		public override function render():void
		{
			if (owner == null)
			{
				super.render();
			}
			else if (owner.should_draw_weapon())
			{
				current_sprite.draw(x + x_mod, y + y_mod, xscale * owner.dir, yscale, angle, color, alpha);
			}
			
			if(muzzle_flash_frames > 0 && muzzle_flash_sprite != null) {
				muzzle_flash_sprite.draw(muzzle_x, muzzle_y, xscale * 0.5, yscale * 0.5, angle, color, alpha, muzzle_flash_frames);
				muzzle_flash_frames++;
				if(muzzle_flash_frames >= muzzle_flash_sprite.frames) {
					muzzle_flash_frames = 0;
				}
			}
			
		}
		
	}

}