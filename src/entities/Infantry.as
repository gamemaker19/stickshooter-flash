package entities 
{
	import SpriteData;
	import Sprites;
	import UnitState;
	import Util;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Mask;
	import net.flashpunk.masks.Grid;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.Entity;
	public class Infantry extends Unit
	{
		//Pseudo-states
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
		public var headwear:Headwear;
		public var armor:Armor;
		
		private var _head_x:Number;
		private var _head_y:Number;
		private var _arm_x:Number;
		private var _arm_y:Number;
		private var _foot_x:Number;
		private var _foot_y:Number;
		public var body_angle:Number;
		
		public function get head_x():Number { return centerX + dir*_head_x; }
		public function get head_y():Number { return centerY + _head_y; }
		public function get arm_x():Number { return centerX + dir*_arm_x; }
		public function get arm_y():Number { return centerY + _arm_y; }
		public function get foot_x():Number { return centerX + dir*_foot_x; }
		public function get foot_y():Number { return centerY + _foot_y; }
	
		//Weapons
		public var weapons:Vector.<Weapon>;
		public var weapon_index:int = 0;
		public function get weapon():Weapon { return weapons[weapon_index]; }
		public var fire_weapon:Boolean = false;	
		public var reload_time:Number = 0;
		public var auto_reload_time:Number = 0;
		public var max_auto_reload_time:Number = 0.75;
		public var no_ammo_time:Number = 0;
		public var max_no_ammo_time:Number = 0;
		
		public function Infantry() 
		{
			super();
			weapons = new Vector.<Weapon>();
			set_default_hitbox();
		}
		
		protected function set_dead_hitbox():void
		{
			
		}
		
		protected function set_default_hitbox():void
		{
			
		}
		
		override protected function get_move_x():Number
		{
			return move_x;
		}
		
		override protected function get_move_y():Number
		{
			return move_y;
		}
		
		public function should_draw_weapon():Boolean
		{
			return (
			state != UnitState.HURT && 
			!is_down && 
			state != UnitState.PUNCH && 
			weapon != null && 
			state != UnitState.POINT &&
			state != UnitState.THROW && 
			state != UnitState.DODGE && 
			state != UnitState.WALL_JUMP &&
			state != UnitState.GET_UP &&
			state != UnitState.HANDS_UP &&
			(state != UnitState.CLIMB || weapon.cooldown_time > 0)
			);
		}
		
		public function should_draw_arms():Boolean
		{
			return ( 
			!is_down &&
			state != UnitState.HURT &&
			state != UnitState.WALL_JUMP &&
			state != UnitState.DODGE &&
			state != UnitState.CLIMB &&
			state != UnitState.GET_UP &&
			(
				weapon == null ||
				state == UnitState.HANDS_UP ||
				state == UnitState.POINT ||
				state == UnitState.RELOAD ||
				state == UnitState.PUNCH ||
				state == UnitState.THROW
			)
			);
		}
		
		public function set_areas():void
		{
			if(is_grounded) {
				if(is_crawling) {
					_head_x = 37;
					_head_y = 34;
					_arm_x = 25;
					_arm_y = 40;
					body_angle = -90;
					_foot_x = -44;
					_foot_y = 44;
				}
				else if(is_crouching) {
					_head_x = 11;
					_head_y = -5;
					_arm_x = 7;
					_arm_y = 3;
					body_angle = -20;
					_foot_x = 0;
					_foot_y = 42;
				}
				else {
					_head_x = 0;
					_head_y = -38;
					_arm_x = 0;
					_arm_y = -29;
					body_angle = 0;
					_foot_x = 0;
					_foot_y = 35;
				}
			}
			else {

				if(is_jumping) {
					_head_x = 0;
					_head_y = -32;
					_arm_x = 0;
					_arm_y = -24 + 2;
					_foot_x = 0;
					_foot_y = 35;
					body_angle = 0;
				}
				else {
					_head_x = -2;
					_head_y = -30;
					_arm_x = -2;
					_arm_y = -22;
					_foot_x = 0;
					_foot_y = 35;
					body_angle = 0;
				}
			}
		}
		
		public override function added():void
		{
			super.added();
			
			arms = FP.world.create(Arms) as Arms;
			arms.parent = this;
			children.push(arms);
			
			/*
			headwear = new Headwear(Headwear.BODYGUARD_GOLD);
			headwear.parent = this;
			FP.world.add(headwear);
			children.push(headwear);
			
			armor = new Armor();
			armor.parent = this;
			FP.world.add(armor);
			children.push(armor);
			*/
			
			var wep:Weapon = FP.world.create(Pistol) as Weapon;
			wep.parent = this;
			
			weapons.push(wep);
			children.push(wep);
		}
		
		public function can_jump():Boolean
		{
			return true;
		}
		
		override public function render():void 
		{
			super.render();
			Draw.line(_tx1, _ty1, _tx2, _ty2);
			Draw.line(_tx1, _ty1, _tx3, _ty3);
			
		}
		
		override public function update():void
		{
			super.update();
		}
		
		public function handle_states():void
		{
			//If dead, do nothing else
			if(is_down) {

			    if(state == UnitState.DEAD) {
			        is_solid_collider = false;
			    }
				
			    move_x = 0;
				
			    //alert(image_number);

			    set_sprite(Sprites.player_dead, 0.8);
				
				/*
			    if(gib_kill) {
			        if(!gib_once) {
			            gib_once = true;
			            create_gibs();
			        }
			        if(instance_exists(head_gib)) {
			            x = head_gib.x;
			            y = head_gib.y;
			        }
			        vel_x = 0;
			        vel_y = 0;
			        move_vel_x = 0;
			        move_vel_y = 0;
			        visible = false;
			    }
			    else if(killed_by_explosive && !killed_by_explosive_ground_once) {
			        
			        if(!is_grounded) {
			            sprite_index = spr_player_flying;
			        }
			        else {
			            killed_by_explosive_ground_once = true;
			            sprite_index = spr_player_dead;
			            image_index = image_number - 1;
			        }
			        
			    }
				*/

			    if(current_sprite == Sprites.player_dead && image_index >= image_number - 1) {
			        //printn("Stopping animation...")
			        image_speed = 0;
			        set_dead_hitbox();
			        /*
					if(state == UnitState.KO) {
			            
						part_emitter_region(stun_particle_system,stun_particle_emitter,get_head_x(),get_head_x(),get_head_y()-5,get_head_y()-5,0,0);
			            part_emitter_stream(stun_particle_system,stun_particle_emitter,stun_particle,-2);

			            ko_time += FP.elapsed;
			            if(ko_time >= max_ko_time) {
			                ko_time = 0;
			                sprite_index = spr_player_dead;
			                image_index = image_number - 1;
			                state = GET_UP;
			                y-=15;
			                part_emitter_clear(stun_particle_system,stun_particle_emitter);
			            }

			        }
			        else {
			            part_emitter_destroy(stun_particle_system,stun_particle_emitter);
			        }
					*/

			    }

			    if(state == UnitState.DEAD) {
			        //Remove all weapons
			        for(var i:int=0;i<weapons.length;i++) {
			            weapons[i].angle = 0;
			            weapons[i].xscale = 1;
			            weapons[i].yscale = 1;
			            weapons[i].dir = dir;
			            weapons[i].vel_x = dir * 9;
			            weapons[i].parent = null;
			        }
					weapons = null;
			    }

			}
			else if(state == UnitState.HURT) {
			    move_x = 0;
			    image_speed = 0.8;
				set_sprite(Sprites.player_hurt, image_speed);
			    if(image_index >= image_number - 1) {
			        state = UnitState.IDLE;
			        image_index = 0;
			    }
			}
			else if (state == UnitState.ZOOM) {
				/*
			    //zoom = 1: zooming in
			    if(zoom == 1) {

			        obj_scope.visible = true;
			        obj_cursor.is_visible = false;
			        look_angle = point_direction_normal(ox, loy, new_xview, new_yview);

			        //If we're not at our destination yet, keep moving the scope to its destination (which is where we aimed)
			        if(point_distance(trans_xview,trans_yview,new_xview,new_yview) >= 1) {
			            trans_xview += (new_xview - trans_xview) * 0.5;
			            trans_yview += (new_yview - trans_yview) * 0.5;
			            obj_scope.x = trans_xview;
			            obj_scope.y = trans_yview;
			        }
			        else {
			            zoom = 2;
			        }
			    }
			    //zoom = 2: zoomed in
			    else if(zoom == 2) {

			        //Zoomed out while zoomed in
			        if(trigger_zoom) {

			            zoom = 3;

			            var xpos = obj_scope.x - old_xview;
			            var ypos = obj_scope.y - old_yview;

			            var dir_to_p = point_direction(ox,loy,obj_scope.x,obj_scope.y);
			            var loop = 0;
			            var border = 5;
			            while(xpos < border || xpos > view_wview[0] - border || ypos < border || ypos > view_hview[0] - border) {

			                xpos -= cos(degtorad(dir_to_p));
			                ypos += sin(degtorad(dir_to_p));

			                loop++;
			                if(loop > 10000) { alert("Infinite loop!"); break; }

			            }
			            
			            trans_xview = obj_scope.x;
			            trans_yview = obj_scope.y;
			            new_xview = old_xview + xpos;
			            new_yview = old_yview + ypos;
			        }
			        //Zoomed in
			        else {

			            obj_scope.visible = true;
			            cursor_sprite = null;
			            look_angle = point_direction(ox, loy, obj_scope.x, obj_scope.y);
			            if(obj_scope.x >= x) dir = 1;
			            else dir = -1;

			            var mx,my;

			            mx=window_mouse_get_x()-window_get_width()/2;
			            my=window_mouse_get_y()-window_get_height()/2;

			            window_mouse_set(window_get_width()/2,window_get_height()/2);

			            //For some reason, we need to wait one frame before moving the scope
			            if(zoom_bool > 0) {

			                obj_scope.x += mx;
			                obj_scope.y += my;

			                //If we go past the maximum range, stop it
			                var ang = point_direction(ox,loy,obj_scope.x,obj_scope.y);
			                var loop = 0;
			                while(point_distance(ox,loy,obj_scope.x,obj_scope.y) > weapon.zoom_distance) {
			                    obj_scope.x -= cos(degtorad(ang));
			                    obj_scope.y += sin(degtorad(ang));
			                    loop++; if(loop > 10000) { alert("Infinite loop!"); break; }
			                }

			                //If we go past the room boundaries, stop it
			                if(obj_scope.x > room_width) obj_scope.x = room_width;
			                if(obj_scope.x < 0) obj_scope.x = 0;
			                if(obj_scope.y > room_height) obj_scope.y = room_height;
			                if(obj_scope.y < 0) obj_scope.y = 0;

			            }
			            else {
			                zoom_bool++;
			            }

			            if(obj_scope.x > room_width) obj_scope.x-= mx;
			            if(obj_scope.x < 0) obj_scope.x-= mx;
			            if(obj_scope.y > room_height) obj_scope.y-= my;
			            if(obj_scope.y < 0) obj_scope.y-= my;
			        }
			    }
			    //3: zooming out
			    else if(zoom == 3) {

			        obj_scope.visible = true;
			        obj_cursor.is_visible = false;
			        look_angle = point_direction_normal(ox, loy, new_xview, new_yview);

			        var zoom_back_ang = point_direction(new_xview,new_yview,trans_xview,trans_yview);
			        
			        var before_x_sign = sign(new_xview - trans_xview);
			        trans_xview += before_x_sign * 200 * cos(degtorad(zoom_back_ang));
			        if(before_x_sign != sign(new_xview - trans_xview)) trans_xview = new_xview;

			        var before_y_sign = sign(new_yview - trans_yview);
			        trans_yview += 200 * sin(degtorad(zoom_back_ang));
			        if(before_y_sign != sign(new_yview - trans_yview)) trans_yview = new_yview;

			        obj_scope.x = trans_xview;
			        obj_scope.y = trans_yview;

			        if(trans_xview == new_xview && trans_yview == new_yview) {
			            window_mouse_set(new_xview - old_xview, new_yview - old_yview);
			            zoom = 0;
			            state = IDLE;
			        }
			    }
				*/
			}
			else if (state == UnitState.WALL_JUMP) {
				/*
			    sprite_index = spr_player_wall_jump;
			    if(image_index >= image_number - 1) {
			        image_index = 0;
			        state = IDLE;
			        is_jumping = true;
			        if(x > wall_jump_wall.x) {
			            move_acc_x = 1;
			            vel_x = 5;
			        }
			        else {
			            move_acc_x = -1;
			            vel_x = -5;
			        }
			        vel_y = -jump_speed;
			        can_boost_jump = true;
			        is_grounded = false;
			    }
				*/
			}
			else if(state == UnitState.CLIMB) {
				/*
			    vel_y = 0;
			    
			    if(trigger_left || trigger_right || is_grounded) {
			        state = IDLE;
			    }
			    else if(!place_meeting(x,y,obj_ladder)) {
			        state = IDLE;
			    }
			    else if(weapon == null || weapon.cooldown_time == 0) {
			        if(trigger_up) {
			            move_y = -5;
			        }
			        else if(trigger_down) {
			            move_y = 5;
			        }
			    }

			    sprite_index = spr_player_ladder;
			    if(move_y == 0) {
			        image_index = 0;
			    }
			    if(weapon.cooldown_time > 0) {
			        sprite_index = spr_player_ladder_shoot;
			    }
				*/
			}
			else if (state == UnitState.DODGE) {
				/*
			    if(is_grounded) {
			        //printn("dodge")
			        sprite_index = spr_player_dodge;
			    }
			    else {
			        sprite_index = spr_player_air_dodge;
			    }
			    if((max_dodge_time / FP.elapsed) != 0) {
			        image_speed = image_number / (max_dodge_time / FP.elapsed);
			        debug(0,image_speed);
			    }
				*/
			}
			else if(state == UnitState.IDLE || state == UnitState.RELOAD) {
				
			    //RELOAD SECTION ONLY
			    if(state == UnitState.RELOAD) {
			        if(reload_time == 0) {
			            //if(is_obj(weapon,obj_shotgun)) { reload_sound = audio_play_sound_on(sound_emitter,snd_shotgun_reload,false,10); }
			        }
			        reload_time += FP.elapsed;
			        if(reload_time >= weapon.reload_time) {

			            var old_ammo:int = weapon.ammo;

			            //Temporarily give enemies infinite ammo so that they can reload completely
			            /*
						if(is_a(obj_enemy)) {
			                weapon.ammo = weapon.max_ammo;
			            }
						*/

			            reload_time = 0;

						/*
			            if(weapon.name == "Shotgun") {
			                if(weapon.clip < weapon.clip_size && weapon.ammo > 0) {
			                    weapon.clip++;
			                    if(weapon.clip >= weapon.clip_size) {
			                        state = IDLE;
			                    }
			                    //Enemies have inifnite ammo
			                    if(!is_a(obj_enemy)) {
			                        weapon.ammo--;
			                    }
			                }
			                else {
			                    state = IDLE;
			                }
			            }
			            else {
						*/
			                state = UnitState.IDLE;
			                while(weapon.clip < weapon.clip_size && weapon.ammo > 0) {
			                    weapon.clip++;
			                    //Enemies have inifnite ammo
			                    //if(!is_a(obj_enemy)) {
			                        weapon.ammo--;
			                    //}
			                }
			            //}

			            //Make their ammo back to old ammo
			            //if(is_a(obj_enemy)) {
			                weapon.ammo = old_ammo;
			            //}
			        }
			    }

			    //RELOAD AND IDLE
			    if(state == UnitState.RELOAD || state == UnitState.IDLE) {
					
					/*
			        if(trigger_grenade && grenades > 0 && grenade_cooldown == 0) {
			            state = THROW;
			            arms.image_index = 0;
			            grenade_thrown = false;
			            grenade_thrown_once = false;
			            return 0;
			        }

			        //Near a ladder: pressing up or down will climb it
			        if(trigger_up || trigger_down) {
			            var ladder = instance_place(x,y,obj_ladder);
			            if(ladder != null) {
			                state = CLIMB;
			                move_x = 0;
			                x = ladder.x;
			                return 0;
			            }
			        }

			        if(trigger_punch) {
			            punch_once = false;
			            state = PUNCH;
			            return 0;
			        }

			        //If stickman, check for wall slide
			        if(is_a(obj_player) && !is_grounded) {

			            var wall_left = instance_place(x-5,y,obj_wall);
			            var wall_right = instance_place(x+5,y,obj_wall);
			            
			            if(wall_left != null && wall_left != wall_jump_wall && !wall_left.is_platform && dir == -1 && recent_trigger_left > 0 && !is_obj(wall_left,obj_wall_diag)) {
			                if(trigger_right) {
			                    state = WALL_JUMP;
			                    image_index = 0;
			                    wall_jump_wall = wall_left;
			                    return 0;
			                }         
			            }
			            else if(wall_right != null && wall_right != wall_jump_wall && !wall_right.is_platform && dir == 1 && recent_trigger_right > 0 && !is_obj(wall_right,obj_wall_diag)) {
			                if(trigger_left) {
			                    state = WALL_JUMP;
			                    image_index = 0;
			                    wall_jump_wall = wall_right;
			                    return 0;
			                }   
			            }
			        }

			        if(trigger_dodge && dodge_cooldown_time == 0) {
			            state = DODGE;
			            dodge_time = FP.elapsed;
			            return 0;
			        }
					*/
			    }

			    //IDLE ONLY
			    if(state == UnitState.IDLE) {
					
			        if(ctl.trigger_reload && weapon != null && weapon.ammo > 0 && weapon.clip < weapon.clip_size && weapon.cooldown_time == 0) {
			            state = UnitState.RELOAD;
			            //if(!is_obj(weapon,obj_shotgun)) { reload_sound = audio_play_sound_on(sound_emitter,snd_reload,false,10); }
			            return;
			        }

			        if(state != UnitState.RELOAD && weapon != null && weapon.clip <= 0 && weapon.ammo > 0) {
			            auto_reload_time += FP.elapsed;
			            if(auto_reload_time > max_auto_reload_time) {
			                auto_reload_time = 0;
			                state = UnitState.RELOAD;
			                //if(!is_obj(weapon,obj_shotgun)) { reload_sound = audio_play_sound_on(sound_emitter,snd_reload,false,10); }
			                return;
			            }
			        }

			        if(is_human && is_grounded) {
						/*
			            zoom_bool = 0;
			            obj_scope.visible = false;
			            obj_cursor.is_visible = true;

			            //Press z: initiate the zoom
			            if(trigger_zoom && weapon != null && weapon.can_zoom) {
			                
			                state = ZOOM;
			                zoom = 1;

			                //Set the old camera position as a reference point
			                old_xview = view_xview[0];
			                old_yview = view_yview[0];

			                //Set "trans view" to start at the muzzle position
			                trans_xview = ox;
			                trans_yview = loy;

			                //Correct trans view
			                if(trans_xview < 0) trans_xview = 0;
			                if(trans_xview > room_width) trans_xview = room_width;
			                if(trans_yview < 0) trans_yview = 0;
			                if(trans_yview > room_height) trans_yview = room_height;

			                //Set the new position to be where the mouse is
			                new_xview = get_mouse_x();
			                new_yview = get_mouse_y();

			                //Correct new view
			                if(new_xview < 0) new_xview = 0;
			                if(new_xview > room_width) new_xview = room_width;
			                if(new_yview < 0) new_yview = 0;
			                if(new_yview > room_height) new_yview = room_height;

			                //Set scope's starting position to be trans view
			                obj_scope.x = trans_xview;
			                obj_scope.y = trans_yview;

			                return 0;
							
			            }
						*/
			        }
			    }

			}
			else if(state == UnitState.THROW) {
				/*
			    if(!grenade_thrown && (trigger_attack || trigger_punch)) {
			        state = IDLE;
			        arms.image_index = 0;
			        image_index = 0;
			        return 0;
			    }

			    else if(!grenade_thrown && (mouse_check_button_released(mb_middle) || is_a(obj_enemy))) {
			        grenade_thrown = true;
			    }

			    if(grenade_thrown && !grenade_thrown_once && arms.image_index >= 6.35) {
			        grenade_cooldown += FP.elapsed;
			        grenade_thrown_once = true;
			        image_speed = 1;
			        grenades--;
			        var grenade = instance_create(ox - (dir * obj_global.grenade_offset_x),oy,obj_grenade);
			        var mag;
			        if(is_a(obj_player)) {
			            mag = point_distance(ox,oy,get_mouse_x(),get_mouse_y()) * 50/640;
			        }
			        else {
			            if(last_target != null) mag = point_distance(ox,oy,last_target.x,last_target.y) * 50/640;            
			            else mag = 1;
			        }
			        var ang;
			        if(is_a(obj_player)) {
			            ang = point_direction(ox,oy,get_mouse_x(),get_mouse_y());
			        }
			        else {
			            if(last_target != null) ang = point_direction(ox,oy,last_target.x,last_target.y);
			            else ang = look_angle;
			        }
			        
			        grenade.is_thrown = true;
			        grenade.owner = id;
			        grenade.vel_x = mag * cos(degtorad(ang));
			        grenade.vel_y = -mag * 1.5 * sin(degtorad(ang));       
			    }
				*/
			}
			else if (state == UnitState.POINT) {
				
			    move_x = 0;
			    set_sprite(Sprites.player_idle);
			    alert_others_time += FP.elapsed;
			    if(alert_others_time >= max_alert_others_time) {
			        alert_others_time = 0;
			        state = UnitState.IDLE;
			    }
				
			}
			else if(state == UnitState.GET_UP) {
			    set_sprite(Sprites.player_dead, -1);
			    is_floating = true;
			    if(image_index == 0) {
			        is_solid_collider = true;
			        set_default_hitbox(); //mask_index = mask_player;
			        is_floating = false;
			        state = UnitState.IDLE;
			        image_speed = 1;
			    }
			}

			if (is_grounded) {
				
				if(is_crouching) {
					set_sprite(crouch_sprite, 0.45);
				}
				else {
					if (move_x == 0) {
						set_sprite(idle_sprite);
					}
					else if(is_running) {
						set_sprite(run_sprite, 0.5);
					}
					else {
						set_sprite(walk_sprite, 0.5);
					}
				}

				if (move_x == 0) {
					image_index = 0;
					image_speed = 0;
				}

			}
			else {

				if(is_jumping) {
					set_sprite(jump_sprite);
				}
				else {
					set_sprite(fall_sprite);
				}
			}
		}
		
		override public function pre():void
		{
			move_x = 0;
			move_y = 0;
			
			if (is_human)
			{
				if(x < FP.world.mouseX) dir = 1;
				else dir = -1;
				
				//if(weapon_switch_time == 0) {
				look_angle = FP.angle(arm_x, arm_y, FP.world.mouseX, FP.world.mouseY);
				//weapon_switch_save_angle = look_angle;
				//weapon_switch_dir = dir;
				//}
				
				look_angle = Util.angle_normal(look_angle);

				if(look_angle > 90 && look_angle < 270) {
					if(dir == 1) { look_angle = Util.angle_normal(180 - look_angle); }
				}
				else {
					if(dir == -1) { look_angle = Util.angle_normal(180 - look_angle); }
				}
			}
				
			prev_jumping = is_jumping;
			prev_crouch = is_crouching;
			
			if (is_grounded) {
				is_jumping = false;
			}
			
			set_areas();
			
			super.pre();
		}
		
		override public function step():void
		{
			set_motion();
			handle_weapons();
			handle_states();
			
			super.step();
		}
		
		public function handle_weapons():void
		{
			/*WEAPON FIRE SECTION*/

			if(ctl.trigger_attack && weapon != null &&
				(state == UnitState.IDLE || state == UnitState.ZOOM || 
					(state == UnitState.CLIMB && 
						(is_obj(weapon,Pistol)) //|| weapon.name == "Revolver" || weapon.name == "Submachine Gun")
					) ||
					(state == UnitState.RELOAD && weapon.clip > 0)
				)
			   ) {
				
				/*
				if(is_obj(weapon,obj_bow) && weapon.cooldown_time == 0) {
					if(!weapon.is_cancel_pull) {
						weapon.bow_pull_time += FP.elapsed;
						if(weapon.bow_pull_time >= weapon.max_bow_pull_time) { 
							weapon.bow_pull_time = weapon.max_bow_pull_time; 
						}
						if(mouse_check_button_pressed(mb_right)) {
							weapon.is_cancel_pull = true;
						}
					}
				}
				else {*/
					fire_weapon = true;
					reload_time = 0;
					if(state == UnitState.RELOAD && weapon.clip > 0) {
						state = UnitState.IDLE;
					}
				//}
			}
			
			/*
			if(is_obj(weapon,obj_minigun)) {
				if(trigger_attack || trigger_alt_attack) {
					weapon.rev_time += FP.elapsed;
					if(weapon.rev_time > weapon.max_rev_time) {
						weapon.rev_time = weapon.max_rev_time;
					}
				}
				else {
					weapon.rev_time -= FP.elapsed;
					if(weapon.rev_time < 0) weapon.rev_time = 0;
				}
			}

			if(is_obj(weapon,obj_bow) && weapon.is_cancel_pull) {
				weapon.bow_pull_time -= FP.elapsed;
				if(weapon.bow_pull_time <= 0) {
					weapon.bow_pull_time = 0;
					weapon.is_cancel_pull = false;
				}
			}
			else if(is_obj(weapon,obj_bow) && !trigger_attack && weapon.bow_pull_time > 0) {
				fire_weapon = true;
			}
			*/
			
			if (ctl.trigger_attack && weapon != null)
			{
				fire_weapon = true;
				reload_time = 0;
				if(state == UnitState.RELOAD && weapon.clip > 0) {
					state = UnitState.IDLE;
				}
			}
			
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
		
		public override function update_ai():void
		{
			super.update_ai();
			
			if(is_down) { return; }

			if(target != null) {

				look_at_target(target as Infantry);
				
				/*
				var throw_grenade = (irandom_range(0,300) == 0);
				if(enemy_type < 0) throw_grenade = 0;
				if(throw_grenade && enemy_type > 0 && target != null) {
					ctl.trigger_grenade = true;
				}
				else {
				*/
					var do_shot:Boolean = (Util.irandom_range(0,10*vigor) == 0);

					if(weapon.is_burst) {
						if(shoot_time > 0) {
							do_shot = true;
							shoot_time += FP.elapsed;
							if(shoot_time >= max_shoot_time) {
								shoot_time = 0;
							}
						}
						else if(do_shot) {
							shoot_time = FP.elapsed;
						}
					}

					//Close enough to melee: do it
					if(Math.abs(y - target.y) < 20 && Math.abs(x - target.x) < 35) {
						if(do_shot) {
							ctl.trigger_punch = true;
						}
					}
					else {
						if(do_shot && weapon != null && weapon.clip > 0) {
							ctl.trigger_attack = true;
						}
					}
				//}
			}
			
			//Get the waypoint we are touching
			cur_waypoint = collide("Waypoint",x,y) as Waypoint;
			if(cur_waypoint != null) {
				waypoint = cur_waypoint;
			}
			if(target == null) {

				target = get_target(sight_range);

				//Got target? Alert others nearby who don't have a target
				if(target != null) {
					/*
					var nearby_enemies = get_nearby_enemies(x,y,alliance,1000);
					for(var i=0;i<ds_list_size(nearby_enemies);i++) {
						var enemy = ds_list_find_value(nearby_enemies,i);
						if(enemy.target == null) {
							with(enemy) {
								look_at_target(other.target);
							}
						}
					}
					ds_list_destroy(nearby_enemies);
					*/

					is_alerted = true;

					if(!squad.in_combat)
					{
						squad.in_combat = true;
						state = UnitState.POINT;	
					}

					last_target = target;
				}

			}
			else {

				if(target.is_down) {
					target = null;
				}

				else {
					
					if(!can_see_target(target as Infantry))
					{
						target = null;
					}

				}

			}

			if(cur_waypoint == null && idle_behavior == IB_PATROL) idle_behavior = IB_STILL;

			ctl.trigger_right = false;
			ctl.trigger_left = false;
			ctl.trigger_action = false;
			ctl.trigger_reload = false;
			ctl.trigger_punch = false;
			ctl.trigger_grenade = false;
			ctl.trigger_crouch = false;
			ctl.trigger_zoom = false;
			ctl.trigger_crawl = false;
			ctl.trigger_jump_hold = false;
			ctl.trigger_jump = false;
			ctl.trigger_run = false;
			ctl.trigger_dodge = false;
			ctl.trigger_attack = false;
			ctl.trigger_alt_attack = false;
			ctl.trigger_fallthrough = false;

			//Datapath
			if(is_alerted && ai_state == AIS_PATROL) {
				ai_state = AIS_STAY_AT_WAYPOINT;
			}

			/*
			if(alliance == PLAYER) {
				if(distance_to_object(obj_player) > 300 || is_following_player) {
					ai_state = AIS_MOVE_TO_POSITION;
					is_following_player = true;
				}
				if(distance_to_object(obj_player) < 150) {
					is_following_player = false;
				}
				if(!is_following_player) {
					if(jump_point == null) {
						ai_state = AIS_STAY_AT_WAYPOINT;
					}
				}
			}
			*/

			//With a target, shoot at it

			if(target != null) {

				look_at_target(target as Infantry);

				/*
				var throw_grenade = (irandom_range(0,300) == 0);
				if(enemy_type < 0) throw_grenade = 0;
				if(throw_grenade && enemy_type > 0 && target != null) {
					ctl.trigger_grenade = true;
				}
				else {
				*/
					do_shot = (Util.irandom_range(0,10*vigor) == 0);

					if(weapon.is_burst) {
						if(shoot_time > 0) {
							do_shot = true;
							shoot_time += FP.elapsed;
							if(shoot_time >= max_shoot_time) {
								shoot_time = 0;
							}
						}
						else if(do_shot) {
							shoot_time = FP.elapsed;
						}
					}

					//Close enough to melee: do it
					if(Math.abs(y - target.y) < 20 && Math.abs(x - target.x) < 35) {
						if(do_shot) {
							ctl.trigger_punch = true;
						}
					}
					else {
						if(do_shot && weapon != null && weapon.clip > 0) {
							ctl.trigger_attack = true;
						}
					}
				//}
			}

			if(!is_alerted) {
				/*
				if(squad.has_disturbance) {
					is_alerted = true;
					surprise_time = FP.elapsed;
					ai_change_dir();   
				}
				else {
					var enemy = instance_place(x-(obj_stickman.vel_x+obj_stickman.move_x),y-(obj_stickman.vel_y),obj_stickman);
					//If player is making contact with enemy, be alerted and turn around
					if(enemy != null && enemy.alliance != alliance) {
						with(squad) { set_disturbance(enemy.x,enemy.y); }
						is_alerted = true;
						surprise_time = FP.elapsed;
						ai_change_dir();
					}
				}
				*/
			}
			else {

				ctl.trigger_run = true;

				/*
				if(target != null && squad != null && !squad.seen_first_target) {
					squad.seen_first_target = true;
					state = POINT;
				}
				*/

			}

			//Control
			if(ai_state == AIS_PATROL) {
				do_patrol();
				do_random_look();
			}
			else if(ai_state == AIS_ARRIVE_CONFUSED) {
				if(confuse_time >= max_confuse_time - FP.elapsed * 2) {
					ai_state = AIS_STAY_AT_WAYPOINT;
				}
				do_random_look();
			}
			else if(ai_state == AIS_MOVE_TO_POSITION) {

				/*
				if(!is_following_player) {
					//dest_x = squad.last_known_x;
					//dest_y = squad.last_known_y;
				}
				else {
					dest_x = obj_player.x;
					dest_y = obj_player.y;
				}
				*/

				/*
				//If on ladder
				if(ladder != null) {

					//alert("on ladder")

					jump_point = null;
					drop_point = null;

					ladder = instance_place(x,y,obj_ladder);

					if(ladder_dir == -1) { 
						ctl.trigger_up = true; 
					}
					else if(ladder_dir == 1) { 
						ctl.trigger_down = true; 
					}

					//alert("clibming ladder");

					return 0;

				}
				*/

				//If alerted and we have the target and are at a waypoint: switch to stay at waypoint phase
				if(!is_following_player && target != null && cur_waypoint != null) {
					ai_state = AIS_STAY_AT_WAYPOINT;
				}

				/*
				if(jump_point != null && jump_point.is_ladder_jp) {
					ctl.trigger_up = true;
					ladder = instance_place(x,y,obj_ladder);    
					if(ladder != null) {
						x = ladder.x;
						vel_x = 0;
						ai_jump_vel_x = 0;
						ai_jump_vel_y = 0;
						jump_point = null;
						y--;
						ladder_dir = -1;
						return 0;
					}
				}
				*/
				
				dest_waypoint = collide("Waypoint",dest_x,dest_y) as Waypoint;
				if(dest_waypoint == null) {
					dest_waypoint = get_closest_waypoint(dest_x,dest_y);
				}

				//If we are on the destination waypoint, just move to the target
				if(waypoint == dest_waypoint) {
					if(x < dest_x) { ctl.trigger_right = true; }
					else if(x > dest_x) { ctl.trigger_left = true; }
					if(Math.abs(x-dest_x) < 5) {
						ctl.trigger_left = false;
						ctl.trigger_right = false;
						x = dest_x;

						//At this point, be confused, and ready to switch to stay-at-waypoint mode
						
						if(!is_following_player && is_investigator) {
							confuse_time = FP.elapsed;
							ai_state = AIS_ARRIVE_CONFUSED;
							is_investigator = false;
							squad.clear_disturbance();
						}

					}
				}

				//Otherwise, find the closest nearest waypoint
				else if(waypoint != null) {
					move_to_best_neighbor();
				}

				if(ctl.trigger_right && dir == -1) ai_change_dir();
				if(ctl.trigger_left && dir == 1) ai_change_dir();

				if(!is_grounded) {
					ctl.trigger_left = false;
					ctl.trigger_right = false;
				}

				//If we're running into a wall, stop tracking down
				if(is_grounded) {
					
					var do_stop:Boolean = false;
					if(ctl.trigger_left && collide("WallCol", x-walk_speed,y) != null) {
						ctl.trigger_left = false;
						do_stop = true;
					}
					if(ctl.trigger_right && collide("WallCol",x+walk_speed,y) != null) {
						ctl.trigger_right = false;
						do_stop = true;
					}

					/*
					if(do_stop) {
						confuse_time = FP.elapsed;
						ai_state = AIS_ARRIVE_CONFUSED;
						is_investigator = false;
						squad.has_disturbance = false;
					}
					*/
				}			     

			}
			else if(ai_state == AIS_STAY_AT_WAYPOINT) {

				//No target: alert-patrol at the current waypoint
				if(target == null && alert_behavior != AB_STILL) {
					do_alert_patrol();
					do_random_look();
				}
				//Target: do the movement thing
				else {
					if(alert_behavior != AB_STILL) {
						do_combat_movement();
					}
					do_random_movement();
				}

			}

			//All overrides happen at this point

			//If distance to a grenade is close

			/*
			var nearby_grenade = collision_circle(x,y,200,obj_grenade,false,true);

			if(nearby_grenade != null) {

				//How "dodgy" enemies will be with grenades. 4 seems to be too high
				var grenade_dodginess = 8;  

				var move_out = (irandom_range(1,vigor*grenade_dodginess) == 1);
				var jump_out = (irandom_range(1,vigor*grenade_dodginess*3) == 1);

				if(enemy_type == THUG_MINOR || enemy_type == THUG_MAJOR) {
					move_out = 0;
					jump_out = 0;
				}

				if(move_out) {
					ctl.trigger_left = false;
					ctl.trigger_right = false;
					ctl.trigger_crouch = false;
					if(x > nearby_grenade.x) ctl.trigger_right = true;
					else if(x <= nearby_grenade.x) ctl.trigger_left = true;
				}
				if(jump_out) {
					ctl.trigger_jump = true;
					ctl.trigger_jump_hold = true;
				}
			}
			*/

			//Message
			//if(is_alerted && msg_ctl.trigger_pt != null && !msg_ctl.trigger_pt.done && msg_ctl.trigger_pt.activate_on_talker_alert) {
			//    obj_global.event_msg_ctl.trigger_pt = msg_ctl.trigger_pt;
			//}
		}
		
		
		public function ai_change_dir():void
		{
			dir *= -1;
			look_angle = Util.angle_normal(180 - look_angle);
		}
	
		public var _tx1:Number = 0;
		public var _ty1:Number = 0;
		public var _tx2:Number = 0;
		public var _ty2:Number = 0;
		public var _tx3:Number = 0;
		public var _ty3:Number = 0;
		
		//Attempt to get a target
		public function get_target(asight_range:int):Unit
		{
			//argument0 = sight range
			var tx1:Number = head_x;
			var ty1:Number = head_y;
			var tx2:Number = head_x+Util.dcos(look_angle-20)*600;
			var ty2:Number = head_y-Util.dsin(look_angle-20)*600;
			var tx3:Number = head_x+Util.dcos(look_angle+20)*600;
			var ty3:Number = head_y-Util.dsin(look_angle+20)*600;
	
			_tx1 = tx1;
			_tx2 = tx2;
			_tx3 = tx3;
			_ty1 = ty1;
			_ty2 = ty2;
			_ty3 = ty3;
			
			var potential_hits:Array = new Array();
			
			for each(var unit:Unit in Global.units)
			{
				var iunit:Infantry = unit as Infantry;
				if (
					(Util.point_in_triangle(iunit.head_x, iunit.head_y, tx1, ty1, tx2, ty2, tx3, ty3) || 
					Util.point_in_triangle(iunit.arm_x, iunit.arm_y, tx1, ty1, tx2, ty2, tx3, ty3) ||
					Util.point_in_triangle(iunit.foot_x,iunit.foot_y,tx1,ty1,tx2,ty2,tx3,ty3)) &&
					unit.alliance != alliance && !unit.is_down)
				{
					potential_hits.push(unit);
				}
				if(unit.alliance == alliance || is_down) {
					collidable = false;
				}
			}

			var hit_check:Unit = null;

			for each(unit in potential_hits) {

				if(can_see_target(unit as Infantry))
				{
					hit_check = unit;
					break;
				}

			}

			Global.solidify_units();
			
			return hit_check as Unit;
		}
		
		//If we can see the target or not.
		public function can_see_target(unit:Infantry):Boolean
		{
			var facing:Boolean = false;
			if(!(unit != null && (dir == 1 && unit.x >= x) || (dir == -1 && unit.x <= x))) { return false; }
			
			//Need to try raycast to see if can see
			var ang_head:Number = FP.angle(head_x,head_y,unit.head_x,unit.head_y);
			var ang_body:Number = FP.angle(head_x,head_y,unit.arm_x,unit.arm_y);
			var ang_foot:Number = FP.angle(head_x,head_y,unit.foot_x,unit.foot_y);
			
			collidable = false;
			
			var hit_head:Entity = Util.raycast("WallCol",head_x,head_y,ang_head,sight_range);
			var hit_check:Entity = hit_head;
			
			if(hit_check !== unit) {
				var hit_body:Entity = Util.raycast("WallCol", head_x, head_y, ang_body, sight_range);
				hit_check = hit_body;
			}
			if(hit_check !== unit) {
				var hit_foot:Entity = Util.raycast("WallCol",head_x,head_y,ang_foot,sight_range);
				hit_check = hit_foot;
			}
			if(hit_check !== unit) {
				hit_check = null;
			}
			
			collidable = true;
			
			if (hit_check != null) {
				return true;
			}
			
			return false;
		}
		
		//Look at the target passed in.
		public function look_at_target(target:Infantry):void
		{
			//Turn to look at the target
			if(target.x < x) dir = -1;
			else dir = 1;

			//Aim at target
			look_angle = Util.point_angle_normal(arm_x,arm_y,target.arm_x,target.arm_y);
		}
		
		//Gets the closest waypoint to the given x and y position
		public function get_closest_waypoint(x:int, y:int):Waypoint
		{
			var best_min:Number = Constants.MAX_DISTANCE;
			var best_waypoint:Waypoint = null;
			for each(var waypoint:Waypoint in Global.waypoints)
			{
				var dist_to_left:Number = FP.distance(waypoint.left_x, waypoint.y, x, y);
				var dist_to_mid:Number = FP.distance(waypoint.x, waypoint.y, x, y);
				var dist_to_right:Number = FP.distance(waypoint.right_x, waypoint.y, x, y);

				var min:Number = Math.min(dist_to_left,dist_to_mid,dist_to_right);

				if(min < best_min) 
				{
					best_min = min;
					best_waypoint = waypoint;
				}
			}
			return best_waypoint;
		}

		public function move_to_best_neighbor():void
		{
			var best_neighbor:Waypoint = waypoint.dest_to_neighbor[dest_waypoint] as Waypoint;

			//No best neighbor: complain
			if(best_neighbor == null) {
			  //alert("No best neighbor. Current waypoint is isolated.");
			}
			else {
			  //print(best_neighbor.name)
			}

			var jp:JumpPoint = waypoint.neighbor_to_jp[best_neighbor] as JumpPoint;
			var dp:DropPoint = waypoint.neighbor_to_dp[best_neighbor] as DropPoint;

			//If best neighbor is connected by a drop point and it's below: move to drop point and drop on it
			if(dp != null && best_neighbor.y > waypoint.y) {

				if(x < dp.x) { ctl.trigger_right = true; }
				else if(x > dp.x) { ctl.trigger_left = true; }

				/*
				//If it's a ladder drop point
				if(dp.is_ladder_dp) {
				  ctl.trigger_down = true;
				  ladder = instance_place(x,y,obj_ladder);    
				  if(ladder != null) {
					  ladder_dir = 1;
					  return 0;
				  }
				}
				*/

				if(is_grounded && dp == collide("DropPoint",x,y)) {
				  ctl.trigger_fallthrough = true;
				  is_grounded = false;
				}

			}
			//If best neighbor is connected by a jump point, move to the jump point
			else if(jp != null) {

				if(x < jp.jump_start_x) { ctl.trigger_right = true; }
				else if(x > jp.jump_start_x) { ctl.trigger_left = true; }

				//If at this point we reach the jump point, have the ai jump
				if(is_grounded && jp == collide("JumpPoint",x,y) && Math.abs(x - jp.jump_start_x) < 15) {
				  
					x = jp.jump_start_x;

					//If it's a ladder jump point
					/*
					if(jp.is_ladder_jp) {
					  ctl.trigger_up = true;
					  ladder = instance_place(x,y,obj_ladder);    
					  if(ladder != null) {
						  //alert("jumping up to ladder")
						  y--;
						  ladder_dir = -1;
						  return 0;
					  }
					}
					*/

					if(jp.dir != dir) {
					  ai_change_dir();
					}

					//var jxy = get_jump_vels(jp);
					//ai_jump_vel_x = jxy[0];
					//vel_y = jxy[1];
					is_jumping = true;
					can_boost_jump = false;
					is_grounded = false;
					jump_point = jp;
					ctl.trigger_left = false;
					ctl.trigger_right = false;

				}

			}
			//Otherwise just move to the waypoint normally
			else {
				if(waypoint != null && best_neighbor != null) {
					if(waypoint.x < best_neighbor.x) { ctl.trigger_right = true; }
					else if(waypoint.x > best_neighbor.x) { ctl.trigger_left = true; }
				}
			}
		}
		//}

		public function do_patrol():void
		{
			if(ai_turn_time > 0) {
			    ai_turn_time += FP.elapsed;
			    if(ai_turn_time > max_ai_turn_time) {
			        ai_turn_time = 0;
			        ai_change_dir();
			    }
			}
			else if(idle_behavior == IB_PATROL) {
			    if(x > cur_waypoint.right_x) {
			        x = cur_waypoint.right_x;
			        ai_turn_time = FP.elapsed;
			    }
			    else if(x < cur_waypoint.left_x) {
			        x = cur_waypoint.left_x;
			        ai_turn_time = FP.elapsed;
			    }
			    else if(thing_in_way(75)) {
			        ai_turn_time = FP.elapsed;
			    }
			    else if(dir == 1) {
			        ctl.trigger_right = true;
			    }
			    else {
			        ctl.trigger_left = true;
			    }
			}
			else if(idle_behavior == IB_TURN) {
			    ai_turn_time = FP.elapsed;
			}
		}

		public function do_alert_patrol():void
		{
			if(ai_alert_action == ALERT_ACTION_TURN) {
			    
			    if(ai_alert_dir_change_num >= ai_max_alert_dir_change_num) {
			        
			        var pause_num:int = Util.irandom_range(1,1 + 30*vigor);
			        if(pause_num == 2) { 

			            if(squad.has_disturbance && is_investigator) {
			                ai_state = AIS_MOVE_TO_POSITION;
			                look_angle = 0;
			                if(dir == -1) look_angle = 180;
			                return;
			            }

			            if(cur_waypoint == null) {
			                ai_alert_dir_change_num = 0;
			                return;
			            }

			            ai_alert_action = ALERT_ACTION_MOVE;
			            ai_move_dist = 0;
			            ai_alert_dir_change_num = 0;

			            //Pick a random direction to move in
			            var times:Number = 0;
			            do {
			                //Pick a random move distance as long as it does not go over the cur_waypoints 
			                times++; if(times > 100) { times = 0; trace("Infinite loop! Debug..."); break; }
			                ai_max_move_dist = Util.random_range(-cur_waypoint.width,cur_waypoint.width);
			            }
			            while(!(x + ai_max_move_dist >= cur_waypoint.left_x && x + ai_max_move_dist <= cur_waypoint.right_x));

			            if(ai_max_move_dist < 0) ai_move_dir = -1;
			            else ai_move_dir = 1;
			            ai_max_move_dist = Math.abs(ai_max_move_dist);

			            dir = Util.sign(ai_move_dir);
			            if(dir == 1) look_angle = 0;
			            else look_angle = 180;
			        }

			    }
			    else {
			        change_dir_time += FP.elapsed;
			        if(change_dir_time >= max_change_dir_time*vigor) {
			            change_dir_time = 0;
			            ai_alert_dir_change_num++;
			            ai_change_dir();
			        }
			    }
			}
			else if(ai_alert_action == ALERT_ACTION_MOVE) {

			    if(thing_in_way(15)) {
			        ai_move_dir *= -1;
			    }

			    var stop:Boolean = false;

			    if(cur_waypoint == null) {
			        stop = true;
			    }
			    else if(x > cur_waypoint.right_x) {
			        x = cur_waypoint.right_x;
			        stop = true;
			    }
			    else if(x < cur_waypoint.left_x) {
			        x = cur_waypoint.left_x;
			        stop = true;
			    }
			    
			    if(!stop && ai_move_dist < ai_max_move_dist) {
			        if(ai_move_dir == -1) ctl.trigger_left = true;
			        else if(ai_move_dir == 1) ctl.trigger_right = true;
			        ai_move_dist += Math.abs(x - ai_last_x);
			        ai_last_x = x;
			    }
			    else {
			        //Pick a random number of times to turn
			        ai_alert_action = ALERT_ACTION_TURN;
			        ai_alert_dir_change_num = 0;
			        ai_max_alert_dir_change_num = Util.random_range(0,4);

			    }
			}
		}

		public function do_combat_movement():void
		{
			if(thing_in_way(15,ai_move_dir)) {
			    ai_move_dir *= -1;
			}

			var stop:Boolean = false;

			if(cur_waypoint == null) {
			    stop = true;
			}
			else if(x > cur_waypoint.right_x) {
			    x = cur_waypoint.right_x;
			    stop = true;
			}
			else if(x < cur_waypoint.left_x) {
			    x = cur_waypoint.left_x;
			    stop = true;
			}

			if(!stop && ai_move_dist < ai_max_move_dist) {
			    if(ai_move_dir == -1) ctl.trigger_left = true;
			    else if(ai_move_dir == 1) ctl.trigger_right = true;
			    ai_move_dist += Math.abs(x - ai_last_x);
			    ai_last_x = x;
			}
			else {
			    
			    var pause_num:int = Util.irandom_range(1,1 + 100*vigor);
			    if(cur_waypoint != null && pause_num == 2) { 
			        
			        ai_move_dir = 0;
			        ai_move_dist = 0;
			        
			        //Pick a random direction to move in
			        var times:Number = 0;
			        do {
			            //Pick a random move distance as long as it does not go over the cur_waypoints 
			            times++; if(times > 100) { times = 0; trace("Infinite loop at do_combat_movement! Debug..."); break; }
			            ai_max_move_dist = Util.random_range(-cur_waypoint.width,cur_waypoint.width);
			        }
			        while(!(x + ai_max_move_dist >= cur_waypoint.left_x && x + ai_max_move_dist <= cur_waypoint.right_x));

			        if(ai_max_move_dist < 0) ai_move_dir = -1;
			        else ai_move_dir = 1;
			        ai_max_move_dist = Math.abs(ai_max_move_dist);
			    }

			}
		}

		public function do_random_look():void
		{
			if(target != null) {
			    return;
			}

			var look_angle_1:Number = -45;
			var look_angle_2:Number = 0;
			var look_angle_3:Number = 45;

			//Randomly choose a look angle of the three

			if(cur_look_angle == dest_look_angle) {
			    var rand:int = Util.irandom_range(0,120);
			    if(rand == 0) dest_look_angle = look_angle_1;
			    if(rand == 1) dest_look_angle = look_angle_2;
			    if(rand == 2) dest_look_angle = look_angle_3;
			}

			if(cur_look_angle != dest_look_angle) {

			    var rate:Number = FP.elapsed * 120;
			    if(is_alerted) rate *= 2;
			    if(cur_look_angle < dest_look_angle) {
			        cur_look_angle += rate;
			    }
			    else {
			        cur_look_angle -= rate;
			    }
			    if(Math.abs(cur_look_angle-dest_look_angle) <= rate * 2) {
			        cur_look_angle = dest_look_angle;
			    }

			}

			if(dir == 1) {
			    look_angle = Util.angle_normal(cur_look_angle);
			}
			else {
			    look_angle = Util.angle_normal(180 - cur_look_angle);
			}
		}

		public function do_random_movement():void
		{
			if(ai_random_action_time > 0) {

			    if(ai_random_action == DUCK) {
			        ctl.trigger_crouch = true;
			    }
			    else if(ai_random_action == JUMP) {
			        ctl.trigger_jump_hold = true;
			    }

			    ai_random_action_time += FP.elapsed;
			    if(ai_random_action_time >= ai_max_random_action_time) {
			        ai_random_action_time = 0;
			    }
			}
			else if(ai_random_action_time == 0) {

			    var rand:int = Util.irandom_range(0,100*vigor);

			    if(rand == DUCK) ai_random_action = DUCK;
			    else if(rand == JUMP) {
			        ctl.trigger_jump = true;
			        ai_random_action = JUMP;
			    }
			        
			    if(rand == DUCK || rand == JUMP) {
			        ai_max_random_action_time = Util.random_range(0.5,2.0);
			        ai_random_action_time = FP.elapsed;
			    }
			    else {
			        ai_random_action_time = 0;
			    }

			}
		}
		
		public function thing_in_way(dist:Number, adir:Number = 0):Boolean
		{
			var move_dir:int = dir;

			if(adir != 0) {
				move_dir = adir;
			}
			
			var hits:Array = new Array();
			collideInto("WallCol", x, y, hits);
			for each(var hit:Object in hits)
			{
				var col:Collider = hits as Collider;
				if (col != null && !col.is_solid_collider)
				{
					continue;
				}
				else
				{
					return true;
				}
			}

			return false;
		}
	}

}

